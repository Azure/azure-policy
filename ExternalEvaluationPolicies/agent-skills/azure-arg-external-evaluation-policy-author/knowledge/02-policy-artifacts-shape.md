# 02 — Policy artifacts shape (definition + assignment)

Authoritative JSON shapes for an External Evaluation + ARG policy **definition** and its **assignment**. Both bodies are required; runtime behavior is a function of how they fit together. Base your policy on these. Don't improvise.

---

## The two artifacts, end to end

NSG over-sharing example (from `examples/01-deny-nsg-overshared/`).

### Definition

Official docs:
- https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-basics
- https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-policy-rule
- https://learn.microsoft.com/en-us/azure/governance/policy/concepts/definition-structure-alias

> Note that official docs don't cover external evaluations as this feature is still in private preview.

```jsonc
{
  "properties": {
    "displayName": "Deny attaching an NSG to subnet if the NSG is already attached to a different subnet",
    "description": "Denies attaching a Network Security Group to a subnet when the same NSG is already attached to a different subnet in the subscription. Triggers on subnet PUT/PATCH operations that set a networkSecurityGroup reference; subnet operations without an NSG reference, and unrelated NSG updates, are unaffected.",
    "policyType": "Custom",
    "mode": "All",
    "parameters": {
      "effect": {
        "type": "String",
        "metadata": { "displayName": "Effect" },
        "allowedValues": [ "audit", "deny", "disabled" ],
        "defaultValue": "audit"
      }
    },
    "policyRule": {
      "if": {
        "allOf": [
          {
            "field": "type",
            "equals": "Microsoft.Network/virtualNetworks/subnets"
          },
          {
            "field": "Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id",
            "notEquals": ""
          },
          {
            "value": "[claims().otherSubnetsCount]",
            "greater": 0
          }
        ]
      },
      "then": {
        "effect": "[parameters('effect')]"
      }
    },
    "externalEvaluationEnforcementSettings": {
      "missingTokenAction": "deny",
      "resultLifespan": "PT1H",
      "roleDefinitionIds": [
        "/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
      ],
      "endpointSettings": {
        "kind": "AzureResourceGraph",
        "details": {
          "query": "[format('resources | where type =~ \"microsoft.network/networksecuritygroups\" | where id == \"{0}\" | mv-expand subnet = properties[\"subnets\"] | where isnotnull(subnet[\"id\"]) | where subnet[\"id\"] !~ \"{1}\" | summarize otherSubnetsCount = count()', field('Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id'), field('id'))]",
          "queryProjectedClaims": [
            "otherSubnetsCount"
          ],
          "queryWithUserIdentity": true
        }
      }
    }
  }
}
```

### Assignment

```jsonc
PUT https://management.azure.com/subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Authorization/policyAssignments/deny-nsg-overshared?api-version=2025-03-01

{
  "properties": {
    "displayName": "Assign — deny NSG over-sharing",
    "policyDefinitionId": "/subscriptions/{sub}/providers/Microsoft.Authorization/policyDefinitions/deny-nsg-overshared",
    "parameters": {
      "effect": { "value": "deny" }
    }
  },
  "name": "deny-nsg-overshared",
  "type": "Microsoft.Authorization/policyassignments",
  "location": "centralus",
  "identity": { "type": "systemassigned" }
}
```

---

## Where `externalEvaluationEnforcementSettings` lives

It is a new property, a **sibling of `policyRule`**, directly under `properties`.

```jsonc
"properties": {
  "policyRule": { … },                          // standard if/then
  "externalEvaluationEnforcementSettings": {    // ← sibling
    "endpointSettings": { … }
  }
}
```

---

## Definition, field by field

Walk top to bottom through the definition above. Each subsection: *what it is*, *what to set*, *leeway*, *see*.

### Envelope: `displayName`, `description`, `policyType`

*What it is.* Human-facing metadata plus the `Custom` policyType marker. No runtime semantics.

*What to set.*
- `policyType: "Custom"` — fixed.
- `displayName` — short label, prefer "<effect> <thing>" (e.g. "Deny NSG over-sharing").
- `description` — one paragraph stating intent. Surfaced in Portal and `Get-AzPolicyDefinition`.

*Leeway.* `displayName`, `description` are author's call. `policyType` is constant.

---

### `mode`

*What it is.* Controls which resource types the policy engine evaluates.

*What to set.* `"All"`.

*Leeway.* `"Indexed"` is permitted only when the policy targets resource types that support tags and location (except the resource group type). Default to `"All"` whenever you target child types (subnets, role assignments, extension resources). When unsure, `"All"`.

---

### `parameters`

*What it is.* The policy definition parameters. The only parameter the definition exposes. Lets the assignment flip between audit and enforce without editing the definition.

*What to set.* Define an `effect` string parameter so that the policy effect can be decided at assignment time. Definition default is the **audit side** of the family; the assignment overrides to the **enforcement side** (see `parameters.effect.value` under Assignment below). Pick the family from the table based on what kind of ARM op the policy guards.

| Guarded op | Effect family | `allowedValues` | Definition default | Assignment override |
|---|---|---|---|---|
| PUT / PATCH on a tracked resource | request-time | `["audit","deny","disabled"]` | `"audit"` | `"deny"` |
| DELETE | action-time | `["auditAction","denyAction","disabled"]` | `"auditAction"` | `"denyAction"` |

*Leeway.* The two families are not interchangeable — `denyAction` on a PUT silently no-ops. Always include `"disabled"` in `allowedValues` so the assignment can kill the policy without deleting the record.

---

### `policyRule.if`

*What it is.* Standard policy condition language, extended with `claims().<name>` reads against the ARG-side claim. The `allOf` is ordered:

1. `field: "type"` filter on the resource type the policy guards.
2. *(optional)* `exists` / `field` short-circuit filter — skips the ARG call when the field of interest isn't present in the request body.
3. The claim check must be aware of the fact that the claim value might be null in the case of no results:
  -  Expressions like `{ "value": "[claims().otherSubnetsCount]", "notEquals": 0 }`, `{ "value": "[claims().otherSubnetsCount]", "greater": 0 }` will fail evaluation if the ARG query returned no results.
  - Defensive patterns:
    - Wrap the expression with `coalesce()`: `[coalesce(claims().otherSubnetsCount, 0)]`.
    - If the condition needs to explicitly check for null value in the claim, use `[equals(claims().value, null())]`.
    - **`true`, `false`, and `null` are ARM template *functions*, not literal keywords** inside `[...]` expressions. Always call them: `true()`, `false()`, `null()`. Using the bare word — e.g. `[coalesce(claims().isFoo, false)]` — silently emits the string `"false"`, not the boolean, and the rule will not behave as intended.
4. When the projected claim is a **boolean**, wrap the read with `bool(...)` to coerce it back from the integer `0`/`1` ARG actually returns over the wire (see `01-overview.md` → Known issues → "Boolean claims arrive as 0/1 integers"). The canonical form combining null-defense, the literal-function trap, and the wire-format coercion is:
    ```jsonc
    {
      "value": "[bool(coalesce(claims().isFoo, false()))]",
      "equals": true
    }
    ```
    Drop the `bool(...)` wrapper once the underlying ARG fix lands.

*What to set.* The NSG example:

```jsonc
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Network/virtualNetworks/subnets"
      },
      {
        "field": "Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id",
        "notEquals": ""
      },
      {
        "value": "[claims().otherSubnetsCount]",
        "greater": 0
      }
    ]
  }
}
```

Notes:
- The claim name on the right of `claims().` **must** match (case-sensitive) the column projected by the KQL (see `endpointSettings.details.query` below) and the single entry in `queryProjectedClaims` (see `queryProjectedClaims` below). Three places, one string.
- When adding checks on resource properties, you'll need to use the correct policy aliases. If you're not sure, ask the user for help or confirm with them the aliases you think should be used.

*Leeway.* Number of applicability filters is author's call — add them whenever an ARG call would be wasted. The claim check's template-language form is highly recommended but not required. It is intended to protect against operators that might not handle `null` values well. For example, `{ "value": "[claims().X]", "equals": true }` will fail the evaluation in the null case (ARG returned 0 rows).

---

### `policyRule.then.effect`

*What it is.* The effect the rule applies when `if` is true.

*What to set.* Always `"[parameters('effect')]"`.

*Leeway.* None. Don't bake the effect into the definition.

---

### `policyRule.then.details` (action-time effects only)

*What it is.* The companion block to `effect` for the `auditAction` / `denyAction` family. Tells the engine which ARM operation(s) on the targeted resource type the rule guards.

*What to set.* Required when the effect family is action-time. Omit for request-time (`audit` / `deny`).

```jsonc
"then": {
  "effect": "[parameters('effect')]",
  "details": {
    "actionNames": [ "delete" ]
  }
}
```

- `actionNames` is the list of ARM action verbs the rule should match. For `auditAction`/`denyAction` today, the supported value is `"delete"` — the action-time family exists to guard DELETE.
- See the [official `auditAction` reference](https://learn.microsoft.com/en-us/azure/governance/policy/concepts/effect-audit-action) for the underlying shape.

*Leeway.* None on action-time effects: the engine rejects the assignment without `details.actionNames`. Don't add this block for request-time effects — it has no meaning there and may fail validation.

---

### `externalEvaluationEnforcementSettings` common fields

*What it is.* The block that makes a policy externally-evaluated. Sibling of `policyRule` (see "Where `externalEvaluationEnforcementSettings` lives" above).

*What to set.*

| Field | Value | Why |
|---|---|---|
| `missingTokenAction` | `"deny"` | Controls what happens when the ARM op arrives without a token header. `audit` value makes the token acquisition stage optional, which is useful for advanced scenarios beyond the scope of this skill. |
| `resultLifespan` | `"PT1H"` | ISO-8601 duration. Arbitrary value that matches the default token expiration time when this property is not specified. |
| `roleDefinitionIds` | `["/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"]` (Reader) | Declared as the role the assignment MSI would need to invoke the endpoint. Required for all external validation policies. |
| `endpointSettings.kind` | `AzureResourceGraph` | This is the only supported endpoint |
| `endpointSettings.details` | An object containing the details of how to invoke the specific endpoint. See `endpointSettings.details.query` below. | NA |

*Leeway.* `resultLifespan` may be shorter than `PT1H`.

---

### `endpointSettings.details.query`

*What it is.* The KQL string the policy service sends to ARG at token-acquisition time to compute the projected claim.

*What to set.* A KQL string wrapped in `[format(...)]` with `field(...)`/`parameters(...)` references for everything that should come from the resource evaluation context. From the NSG example:

```jsonc
"query": "[format('resources | where type =~ \"microsoft.network/networksecuritygroups\" | where id == \"{0}\" | mv-expand subnet = properties[\"subnets\"] | where isnotnull(subnet[\"id\"]) | where subnet[\"id\"] !~ \"{1}\" | summarize otherSubnetsCount = count()', field('Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id'), field('id'))]"
```

Notes:
- `query` is the ARG query **string** — not an object. While it can be a literal query, in reality any meaningful query will require passing fields/parameters from the currently evaluated resource or policy, thus the `[format(...)]` pattern is what most policies will use, where we have a template of the query string that's being dynamically constructed at token acquisition time.
- Pass `field(...)` and or `parameters(...)` expressions to the query `format()`ing expression to parameterize the query with the necessary runtime values. Both resolve **server-side**, before the materialized KQL is sent to ARG.
- In advanced scenarios, you can pass more complex values to the query. For example, if evaluating an NSG and the query needs the number of rules, it can be passed to the query with the expression `length(field(...))`.
- **Dynamic / parameterized field paths.** When the property the query needs to read is itself selected by a policy parameter — e.g. "the value of a tag whose name is `parameters('tagName')`" — combine `field(...)` with `concat(...)`: `field(concat('tags[', parameters('tagName'), ']'))`. This lets a single definition serve many assignments, each pointing at a different field.
- **Defending against an absent field.** A `field(...)` reference to a property the incoming request body does not contain resolves to `null`, which gets emitted into the materialized KQL as the literal string `"null"` and will silently break query semantics (e.g. a `where existingTag != "null"` comparison passes when the tag was actually omitted). Wrap optional fields with `coalesce(..., '')` (or another sentinel that's safe inside your KQL): `coalesce(field(concat('tags[', parameters('tagName'), ']')), '')`. This is what makes "user is deleting the tag" round-trip cleanly as the empty string the KQL can compare against. Combining the two idioms is common: `coalesce(field(concat('tags[', parameters('tagName'), ']')), '')`.
- Query must produce **0 or 1 rows**. Multi-row results are rejected with `ExternalEvaluationAzureResourceGraphTooManyRows`. Typical queries either target a specific resource by its id (which will always return 1 or 0 rows). In more advanced cases, use `summarize` (no `by` clause) or `take 1` statements to ensure a single result is returned at most.
- Carefully escape all the quotes in the ARG query format string.
- Implicitly scoped to **the single subscription** the ARM op is in. The Policy service pins `subscriptions: ["{sub}"]` on the outbound call — you cannot widen the query. Cross-sub / cross-tenant / MG-scoped invariants are not a fit for this feature.

*Leeway.* Query shape is author's call. Project an **affirmative** boolean — `true` means "the world is in the state the policy cares about" — or a scalar that the rule can compare with `greater` / `less` / `equals`.

*Caveats.*
- **ARG eventual consistency.** ARG is the standard product; newly created resources may not appear for seconds to minutes. "Deny if a sibling exists" can produce false negatives during that window; "deny unless a sibling exists" can produce false positives. There is no mitigation in the Policy layer — account for it in the policy's intent and error message.
- **RBAC visibility.** ARG honors the caller's RBAC (or the MSI's, with `queryWithUserIdentity: false`). Resources the identity cannot read are simply absent from the result — indistinguishable from "doesn't exist". Zero rows never means "the resource isn't there"; it means "isn't there or isn't visible to me".

---

### `queryProjectedClaims` and `queryWithUserIdentity`

*What it is.* The contract between ARG result and policy rule. `queryProjectedClaims` names the single column the rule reads via `claims().<name>`. `queryWithUserIdentity` picks whose identity the ARG query uses.

*What to set.*

```jsonc
"queryProjectedClaims": [ "otherSubnetsCount" ],
"queryWithUserIdentity": true
```

Locks:
- `queryProjectedClaims` is an array of **exactly one** string. Collapse multi-fact logic inside KQL with `summarize`, `iif`, `bag_pack`, etc.
- The string must equal the KQL column name (`summarize otherSubnetsCount = …`) and the `claims().otherSubnetsCount` reference in the rule. Case-sensitive.
- `queryWithUserIdentity: true` — use the caller's identity (OBO). Avoids MSI-tier throttling, MSI principal-propagation wait, and the role-assignment step in the test loop.

*Leeway.* `queryWithUserIdentity: false` (MSI mode) is permitted only when the MSI must see resources the caller cannot. Rare. Switching to MSI mode means the assignment's MSI needs the actual role assignment, and the test loop adds principal- and RBAC-propagation waits.

---

## Assignment, field by field

The assignment body shown above.

### `policyDefinitionId`

*What it is.* Full resource id of the definition the assignment is binding.

*What to set.* `"/subscriptions/{sub}/providers/Microsoft.Authorization/policyDefinitions/<defName>"`.

*Leeway.* The assignment's scope (the URL) can be narrower than the definition's home sub — RG-scoped or single-resource-scoped. The definition id itself must match exactly.

---

### `parameters.effect.value`

*What it is.* Override of the `effect` parameter from the definition default.

*What to set.* The **enforcement** side of the family — `"deny"` for request-time, `"denyAction"` for action-time. The definition default is the audit side; the assignment is what turns enforcement on.

*Leeway.* `"audit"` / `"auditAction"` for an audit-only rollout, `"disabled"` to keep the assignment record but skip evaluation. Match `missingTokenAction` in the definition (see `externalEvaluationEnforcementSettings` common fields above) to the assignment-side value.

---

### `identity.type` and `location`

*What it is.* The system-assigned MSI record on the assignment.

*What to set.*

```jsonc
"identity": { "type": "systemassigned" },
"location": "centralus"
```

Locks:
- `identity.type = "systemassigned"` is **mandatory** on External Evaluation assignments, even when `queryWithUserIdentity: true` means the MSI isn't used at ARG-call time. Validation rejects the assignment without it.
- `location` is required whenever there's a system-assigned identity. Any valid region works.

*Leeway.* `location` value is author's call. `identity.type` is locked.

---
