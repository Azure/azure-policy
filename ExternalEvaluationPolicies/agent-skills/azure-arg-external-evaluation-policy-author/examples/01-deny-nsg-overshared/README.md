# Example 01 — Deny NSG over-sharing

## Intent

Deny attaching a Network Security Group to a subnet if that same NSG is already attached to any other subnet in the same subscription.

## Effect family

PUT on `Microsoft.Network/virtualNetworks/subnets` → `deny` (parameterized; assignment sets `effect.value = "deny"`).

## KQL — plain (what to test with `az graph query`)

```kusto
resources
| where type =~ "microsoft.network/networksecuritygroups"
| where id == "<NSG id being attached>"
| mv-expand subnet = properties["subnets"]
| where isnotnull(subnet["id"])
| where subnet["id"] !~ "<subnet id being modified>"
| summarize otherSubnetsCount = count()
```

The query pivots on the NSG: load the NSG by id, expand its `properties.subnets` array, drop the subnet currently being modified, and count what's left. `summarize` without `by` always emits exactly one row, so an NSG attached to nothing still produces `otherSubnetsCount = 0` (not a null/no-row claim).

Expected results:
- NSG already attached to ≥ 1 other subnet → `otherSubnetsCount > 0` → deny.
- NSG attached to no other subnet → `otherSubnetsCount == 0` → allow.

## KQL — policy form

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

`field('Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id')` resolves against the inbound subnet PUT body at token-acquisition time — that's the NSG id being attached. `field('id')` is the resource id of the subnet being modified, excluded so the count reflects *other* subnets only.
