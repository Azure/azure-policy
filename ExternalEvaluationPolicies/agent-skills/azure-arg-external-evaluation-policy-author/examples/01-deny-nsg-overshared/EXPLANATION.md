# Explanation — Example 01: deny NSG over-sharing

## 1. What this policy does

When someone tries to attach an NSG to a subnet (PUT on `Microsoft.Network/virtualNetworks/subnets`), the policy asks ARG: "is this NSG already attached to any other subnet in this subscription?" If yes, the request is denied.

The query pivots on the NSG (not the subnet): it loads the NSG by id, expands `properties.subnets`, drops the subnet being modified, counts what's left, and projects the count as `otherSubnetsCount`.

What is and isn't denied:
- Attaching an NSG that's already on ≥ 1 other subnet → denied (`otherSubnetsCount > 0`).
- Attaching an NSG that's on no other subnet → allowed (`otherSubnetsCount == 0`).
- A subnet PATCH that doesn't set `networkSecurityGroup.id` → short-circuits on the `notEquals: ""` filter and never hits ARG.
- Attaching across subscriptions → not evaluated. External Evaluation is single-subscription scoped.

## 2. Test queries used during co-design

The KQL below was materialized and run via `az graph query -q "<query>" --subscriptions <sub>` while authoring the policy.

### Iteration 1 — list subnets currently attached to a given NSG

```kusto
resources
| where type =~ "microsoft.network/networksecuritygroups"
| where id == "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/networkSecurityGroups/nsgA"
| mv-expand subnet = properties["subnets"]
| project subnetId = subnet["id"]
```

Confirms NSG rows in ARG carry the subnet associations as a `properties.subnets` array, and that `mv-expand` over it produces one row per attached subnet with `subnet["id"]` as the subnet's resource id.

### Iteration 2 — exclude the subnet being modified, count

```kusto
resources
| where type =~ "microsoft.network/networksecuritygroups"
| where id == "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/networkSecurityGroups/nsgA"
| mv-expand subnet = properties["subnets"]
| where isnotnull(subnet["id"])
| where subnet["id"] !~ "/subscriptions/<sub>/resourceGroups/<rg>/providers/Microsoft.Network/virtualNetworks/<vnet>/subnets/subnetB"
| summarize otherSubnetsCount = count()
```

Input: NSG A attached to subnetA. Simulate the PUT that would attach it to subnetB. Expected: 1 row with `otherSubnetsCount = 1`. Matched.

### Iteration 3 — 0-row sanity check (fresh NSG)

Same query with a freshly-created NSG (NSG B) attached to nothing. Expected: 1 row with `otherSubnetsCount = 0`. `mv-expand` over an empty array produces 0 rows, but `summarize count()` without `by` always emits exactly one row, so the count is `0` rather than missing. Matched. The policy rule's `{ "value": "[claims().otherSubnetsCount]", "greater": 0 }` evaluates to false → request allowed.

### From plain KQL to policy form

The two literal id values become `field(...)` calls; the whole string is wrapped in `[format(...)]`:

```kusto
[format(
  'resources
   | where type =~ "microsoft.network/networksecuritygroups"
   | where id == "{0}"
   | mv-expand subnet = properties["subnets"]
   | where isnotnull(subnet["id"])
   | where subnet["id"] !~ "{1}"
   | summarize otherSubnetsCount = count()',
  field('Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id'),
  field('id'))]
```

`field('…/networkSecurityGroup.id')` resolves against `operation.content.properties.networkSecurityGroup.id` at token-acquisition time — that's the NSG id being attached. `field('id')` is the subnet's own id, excluded so the count counts *other* subnets only.

## 3. How to test

Open `test-flow.http` in VS Code with the REST Client extension, edit the variables at the top, and send the requests top to bottom. The flow walks: resource group → vnet with 2 subnets (A, B) → NSG A → attach NSG A to subnetA → NSG B → policy definition → policy assignment → unauth PUT NSG A → subnetB (deny) → acquire-token for that op (denied, no token) → unauth PUT NSG B → subnetB (deny) → acquire-token for NSG B → subnetB (allowed, token returned) → retry NSG B → subnetB with the token (succeeds). Interleaved `GET` requests after each `PUT` let you eyeball the resource before moving on.

No role-assignment step: the definition sets `queryWithUserIdentity: true`, so the assignment's MSI isn't used at ARG-call time. The caller's bearer (`{{tok}}`) needs Reader on the resources the query reads.

The policy assignment body is embedded inline in `test-flow.http` rather than living in its own JSON file — the REST Client extension doesn't expand `@`-variables inside files included via `< ./file.json`, so an external assignment file would PUT a request with literal `{{policyName}}` strings.

The acquirePolicyToken body must mirror the guarded ARM PUT byte-for-byte, or the token won't bind. The token comes back with a `PoP ` prefix; pass it through verbatim including the prefix.
