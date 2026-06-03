# Explanation — Deny changing or removing an immutable tag on an NSG

## 1. What this policy does

When someone issues a PUT/PATCH against an `Microsoft.Network/networkSecurityGroups` resource, the policy asks ARG: "does this NSG already exist with the named tag set, AND is the incoming request changing or clearing that tag?" If yes, the request is denied.

The query loads the NSG by id, reads the current value of the parameterized tag, and projects a single boolean `isImmutableViolation` computed as `existingTag is not empty AND existingTag != incomingTag`. The `incomingTag` value is plugged into the query at token-acquisition time from the request body via a dynamic `field()` lookup; an absent tag in the body is coalesced to `""`, which is what makes "delete the tag" register as a violation.

What is and isn't denied:

- New NSG (no row in ARG yet) → ARG returns 0 rows → claim is null → `bool(coalesce(claim, false()))` → `false` → policy allows.
- Existing NSG that doesn't yet have the tag → `isnotempty(existingTag) == false` → `isImmutableViolation = false` → allowed. Adding the tag is fine.
- Existing NSG with the tag, request keeps the same value → `existingTag == incomingTag` → `false` → allowed.
- Existing NSG with the tag, request changes the value → `true` → **denied**.
- Existing NSG with the tag, request omits the tag → `incomingTag` coalesces to `""`, `existingTag != ""` → `true` → **denied**.
- Tag updates via `Microsoft.Resources/tags` (the tags-as-a-resource API used by `az tag update` and currently by the Portal's tag editor) → not evaluated. See `knowledge/01-overview.md` under "Known issues" for details and tracking.
- Cross-subscription anything → not evaluated. External Evaluation is single-subscription scoped.

### Known caveat: ARG eventual consistency

ARG is the standard product and refreshes asynchronously. If a user sets the tag and immediately attempts to change it within the lag window (typically seconds, occasionally longer), ARG may not yet show the original tag — `existingTag` will be empty, the policy will see "no immutability to protect", and the change will be allowed. There is no in-policy mitigation. Same caveat applies in reverse for newly-created NSGs: the policy never blocks the first PUT that sets the tag (correctly), but a near-immediate second PUT changing it could slip through.

## 2. Test queries used during co-design

All queries below were materialized and run via `az graph query -q "<query>"` against a sample NSG that carries `immutableIdentifier = "123"`.

### Q0 — Sanity: confirm the NSG and read its current tag value

```kusto
resources
| where type =~ "microsoft.network/networksecuritygroups"
| where id =~ "/subscriptions/<subId>/resourceGroups/<rgName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>"
| project id, tags
```

Result: 1 row, `tags.immutableIdentifier == "123"`. Confirms tag-name spelling and that ARG carries NSG tags under `tags.<name>`.

### Q1 — Existing tag, incoming SAME value (must allow)

```kusto
resources
| where type =~ "microsoft.network/networksecuritygroups"
| where id =~ "/subscriptions/<subId>/resourceGroups/<rgName>/providers/Microsoft.Network/networkSecurityGroups/<nsgName>"
| extend existingTag = tostring(tags["immutableIdentifier"])
| project isImmutableViolation = isnotempty(existingTag) and existingTag != "123"
```

Result: `isImmutableViolation = 0` (false). ✅

### Q2 — Existing tag, incoming DIFFERENT value (must deny)

Same as Q1 with `"123"` → `"456"`. Result: `isImmutableViolation = 1` (true). ✅

### Q3 — Existing tag, incoming MISSING/EMPTY (must deny — covers the "delete the tag" case)

Same as Q1 with `"123"` → `""`. Result: `isImmutableViolation = 1` (true). ✅ This is why the `[format(...)]` expression in the policy uses `coalesce(field('tags[...]'), '')` for the incoming value — an absent tag in the request body becomes `""` and trips this exact branch.

### Q4 — NSG not in ARG yet (simulates new-resource creation, must allow)

Same query with a non-existent NSG id. Result: `0 rows`. The projected claim is therefore null, and the policy's `[bool(coalesce(claims().isImmutableViolation, false()))]` evaluates to `false` so the rule does not fire. ✅

### From plain KQL to policy form

Three runtime values become substitutions; the whole string is wrapped in `[format(...)]`:

```kusto
[format(
  'resources
   | where type =~ "microsoft.network/networksecuritygroups"
   | where id =~ "{0}"
   | extend existingTag = tostring(tags["{1}"])
   | project isImmutableViolation = isnotempty(existingTag) and existingTag != "{2}"',
  field('id'),
  parameters('tagName'),
  coalesce(field(concat('tags[', parameters('tagName'), ']')), ''))]
```

- `{0}` ← `field('id')` — the NSG's resource id from the incoming PUT/PATCH. Filters ARG to a single row, satisfying the endpoint's 0-or-1-row requirement.
- `{1}` ← `parameters('tagName')` — the tag name from the policy parameter. Lets one definition serve as the template for many assignments, each enforcing a different tag.
- `{2}` ← `coalesce(field(concat('tags[', parameters('tagName'), ']')), '')` — the incoming tag value from the request body, defaulted to `""` when the tag is absent. Empty string is the sentinel that turns "the user is trying to remove this tag" into a violation in the `existingTag != ""` clause.

## 3. How to test

Three options:

### Option A — VS Code REST Client (the `.http` file)

Open `test-flow.http` in VS Code with the REST Client extension, edit the variables at the top (`@tok`, `@subId`, `@rgName`), and send the requests top to bottom. The flow walks:

1. Resource group → policy definition → policy assignment.
2. **Case A**: create an NSG without the tag. First PUT without a token → 403. Acquire token (Allow, null claim) → retry PUT → 200.
3. **Case B**: PUT the same NSG adding the tag for the first time. Token → Allow (`isImmutableViolation = false`) → PUT → 200.
4. **Case C**: same-value re-PUT. Token → Allow.
5. **Case D**: PUT with a different tag value. Token → **Deny**, no token returned.
6. **Case E**: PUT omitting the tag. Token → **Deny**.
7. **Case F**: direct PUT (no token) attempting the change → 403.

Cases B and C require waiting for ARG eventual consistency after the prior PUT.

No role-assignment step is needed: the definition sets `queryWithUserIdentity: true`, so the assignment's MSI is not used at ARG-call time. The caller's bearer (`{{tok}}`) needs Reader on the NSG, which any caller authorized to PUT it already has.

### Option B — Azure CLI

```bash
# Setup
az policy definition create --name deny-immutable-tag-on-nsg --rules @policy-definition.json --mode All --subscription <subId>
az policy assignment create --name deny-immutable-tag-on-nsg \
  --policy deny-immutable-tag-on-nsg \
  --scope /subscriptions/<subId>/resourceGroups/<rg> \
  --params '{"effect":{"value":"deny"},"tagName":{"value":"immutableIdentifier"}}' \
  --location eastus --mi-system-assigned

# Create NSG without the tag — needs --acquire-policy-token because missingTokenAction=deny.
az network nsg create -g <rg> -n nsg-immutable-test --acquire-policy-token

# Add the tag — allowed.
az network nsg update -g <rg> -n nsg-immutable-test --set tags.immutableIdentifier=123 --acquire-policy-token

# Wait a few seconds for ARG consistency, then attempt to change — should fail.
az network nsg update -g <rg> -n nsg-immutable-test --set tags.immutableIdentifier=456 --acquire-policy-token
```

The last command should fail with `RequestDisallowedByPolicy`. `--acquire-policy-token` is the global flag added in Azure CLI 2.85.0 (see `../../knowledge/01-overview.md`).

### Option C — Azure Portal

Portal intercepts missing-token failures, calls `acquirePolicyToken`, and retries automatically. Open the NSG, edit the tag, save. If the change is allowed it goes through transparently; if denied you'll see a 403 surfaced as a tooltip referencing the policy assignment.
