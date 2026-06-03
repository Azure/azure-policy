# Block delete of an Action Group still referenced by alert rules

## What this policy does

**Intent.** Once an Action Group has any alert rule pointing at it, the policy denies any attempt to delete it. The Action Group must be unreferenced before it can be removed. New Action Groups are created freely; only DELETE is guarded.

**Target operation.** `DELETE` on `Microsoft.Insights/actionGroups` (effect family: `auditAction` / `denyAction`).

**Bad-state condition.** Any of the following resource types in the same subscription has a serialized `properties` blob containing the target Action Group's resource ID:

- `Microsoft.Insights/metricAlerts` (`properties.actions[].actionGroupId`)
- `Microsoft.Insights/scheduledQueryRules` (`properties.actions.actionGroups[]`)
- `Microsoft.Insights/activityLogAlerts` (`properties.actions.actionGroups[].actionGroupId`)

The three alert types each store the reference at a slightly different JSON path. The KQL avoids per-type unpacking by serializing `properties` and substring-matching the action-group resource ID — which is a unique, fully-qualified ARM ID, so false positives are not a practical concern.

**Allowed.** Creating Action Groups; modifying them; deleting an Action Group that no alert rule references; deleting referencing alert rules (the policy only guards `Microsoft.Insights/actionGroups`).

**Denied.** Deleting an Action Group while at least one alert rule still references it.

### Customer value

Deleting an Action Group silently succeeds in Azure today even when alerts reference it. The referencing alert rules keep firing — into a void — and the on-call rotation stops paging. This is a classic SRE incident pattern: someone "cleans up" stale-looking Action Groups during a refactor, and weeks later an outage isn't noticed because the page never went out. This policy is the guardrail for that pattern.

### Scope notes / known gaps

- **Smart Detector Alert Rules** (`microsoft.alertsmanagement/smartdetectoralertrules`) and **Alert Processing Rules** (`microsoft.alertsmanagement/actionrules`) are not scanned. They are niche; extending the query to them is a one-line change to the `in~` list.
- **Cross-subscription references** are not detected — External Evaluation pins the ARG call to the current subscription.
- **ARG eventual consistency** — newly created or deleted alert rules may not appear in ARG for seconds to minutes. A freshly-deleted alert can briefly cause the policy to still deny the Action Group's deletion.

---

## Test queries used during co-design

The KQL was developed and validated against a test subscription `<subId>` and resource group `<rgName>` with three resources created up front:

| Resource | Type | Role in test |
|---|---|---|
| `ag-referenced` | `Microsoft.Insights/actionGroups` | Referenced by `alert-test` |
| `ag-orphan` | `Microsoft.Insights/actionGroups` | Not referenced by anything |
| `alert-test` | `Microsoft.Insights/activityLogAlerts` | References `ag-referenced` |

### Query 1 — confirm the reference shape on activity log alerts

Goal: pick a query strategy. Confirm where the action-group ID lives in the alert's `properties`.

```kusto
resources
| where type =~ "microsoft.insights/activitylogalerts"
| where id =~ "/subscriptions/<subId>/resourceGroups/<rgName>/providers/Microsoft.Insights/activityLogAlerts/alert-test"
| project actions = properties.actions
```

Result:

```json
{ "actions": { "actionGroups": [ { "actionGroupId": "/subscriptions/.../actionGroups/ag-referenced" } ] } }
```

Conclusion: the reference is nested under `properties.actions.actionGroups[].actionGroupId` for activity log alerts. Metric alerts use `properties.actions[].actionGroupId`; scheduled query rules use `properties.actions.actionGroups[]` as a flat string array. To avoid per-type unpacking, the production query serializes the whole `properties` object and substring-matches the action-group's resource ID.

### Query 2 — referenced AG (should be `true`)

```kusto
resources
| where type in~ ("microsoft.insights/metricalerts","microsoft.insights/scheduledqueryrules","microsoft.insights/activitylogalerts")
| where tostring(properties) contains "/subscriptions/<subId>/resourceGroups/<rgName>/providers/Microsoft.Insights/actionGroups/ag-referenced"
| summarize refCount = count()
| project isReferenced = refCount > 0
```

Result: `isReferenced = 1`. ✓

### Query 3 — orphan AG (should be `false`)

Same query, substituting `ag-orphan` for `ag-referenced`.

Result: `isReferenced = 0`. ✓

### Note on the int-vs-bool gotcha

ARG serializes KQL booleans as integer `0`/`1` over the wire to Policy. The policy rule wraps the claim with `bool(...)` to coerce back to a boolean:

```jsonc
{ "value": "[bool(coalesce(claims().isReferenced, false()))]", "equals": true }
```

Without the `bool()` wrap, the condition silently never fires because `1 != true` under the policy engine's strict equality.

---

## How to test this

### Prerequisites

None — the `.http` file creates the resource group, the three test resources, the policy definition, and the assignment from scratch. You just need a bearer token (`armclient token`) and a subscription you can write to.

### Option A — `.http` file (recommended)

1. Install the "REST Client" VS Code extension.
2. Open `test-flow.http`, replace `@tok` with your bearer token and `@subId` with your subscription.
3. Send requests top-to-bottom. The file is self-contained: RG → 3 resources → policy def → assignment → test cases → cleanup.

The flow covers:

- **Case A** — DELETE `ag-orphan` → Allow (no references)
- **Case B** — DELETE `ag-referenced` → Deny (alert-test references it)
- **Case C** — Direct DELETE without token → 403
- **Case D** — Delete `alert-test`, wait for ARG, then DELETE `ag-referenced` → Allow

### Option B — Portal

1. Run Steps 1–6 from `test-flow.http` to create the resources, definition, and assignment.
2. In the Portal, navigate to the test RG → Action Groups → `ag-referenced` → Delete. Expect a policy-denied error.
3. Try the same on `ag-orphan` — expect success.

### Option C — Azure CLI

```powershell
# Requires Azure CLI 2.85.0+ for --acquire-policy-token

# This should fail with a denyAction message.
az monitor action-group delete --name ag-referenced --resource-group <rgName> --acquire-policy-token

# This should succeed.
az monitor action-group delete --name ag-orphan --resource-group <rgName> --acquire-policy-token
```

### Cleanup

```powershell
# Drop assignment + definition (see Step 11 in test-flow.http), then:
az group delete -n <rgName> --yes
```
