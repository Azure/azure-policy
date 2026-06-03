# 01 - Overview

**External Evaluation** (sometimes called "Invoke" colloquially) allows enforcement policies to incorporate the results of an invocation of an external endpoint into the policy evaluation context, allowing infinite extensibility of enforcement scenarios. Currently this feature only supports the invocation of **Azure Resource Graph (ARG)** queries and using them in the policy conditions, with additional endpoints coming in the future.

## Common patterns

- **Prerequisite checks.** Deny resource operations if some prerequisites (which are expressed by the status of other resources fetched from ARG) are not met.
- **Existence checks.** Deny resource operations based on the existence of a resource.
- **Reference checks.** Deny resource operations based on how it's being used/referenced by other resources.

## How it works

### Semantics

"Normal" enforcement policies look only at the body of the ARM request the user is sending. **External Evaluation policies** incorporate additional context fetched from invoking an external endpoint (currently, an **Azure Resource Graph (ARG)** query) in the form of a token attached to the ARM request, allowing the policy to make more complex enforcement decisions.

The semantics of the enforcement rule for these policies is "Deny unless the request attaches a token **proving** that an external endpoint has been invoked and returned an acceptable result". For example, "Deny the association of an NSG to a subnet unless you ran a query that confirms the NSG is not already being used for any other subnets".

### In Practice

- The policy definition has a new `externalEvaluationEnforcementSettings` defining which endpoint to invoke.
- The results of the endpoint invocation will be encoded into the claims of a special policy token.
- The `if` condition can use a new `claims()` template function to access the results of the endpoint invocation. e.g. `{ "value": "[claims().isSafe]", "equals": true }`.
- All expressions in the `if` conditions that are not referencing claims are used to determine the applicability of the policy.
	- For example, a policy with the condition `if type == vm && tags.env == prod && claims().isSafe == true` is interpreted as "all VMs with `tags[env]` set to `prod` must present a policy token".

### Token Acquisition

Before performing a resource operation protected by an external evaluation policy, the user (or the client they're using) must acquire a policy token that attests that all relevant external endpoints have been invoked and to their results.

This is done with a single call to a new subscription-level `acquirePolicyToken` API call [API Docs](https://learn.microsoft.com/en-us/rest/api/policy-authorization/policy-tokens/acquire?view=rest-policy-authorization-2025-11-01&tabs=HTTP). The semantics of this API is "I want to perform operation X, give me a policy token that fulfils all external evaluation prerequisites". The token API takes care of finding the relevant policies, invoking their endpoints, and signing their results into a single token.

The user (or the client tool) will then attach the token to the ARM resource operation in the `x-ms-policy-external-evaluations` header.

### Compliance

External Evaluation policies make their enforcement decision from data that only exists when (and is only relevant to) a specific resource operation is attempted, so there is no resource-state signal to scan on a schedule. As a result, the standard compliance surface will simply mark all applicable resources as compliant; the real enforcement signal is the per-operation token acquisition result.

## Known limits

### Client tool support

The feature heavily relies on the ability of client tools to "understand" the new concept of a policy token and either acquire it for the user, or provide the user with a knob to acquire it themselves.

Supported tools:
- Azure Portal — automatically intercepts request failures due to a missing token, acquires the token, and retries the request.
- Azure Template Deployments — automatically intercept request failures for resources within the template due to a missing token, acquire the token, and retry the request.
- Azure CLI — global `--acquire-policy-token` flag was added to all commands starting from version 2.85.0.

Known client issues:
- Tag updates via `Microsoft.Resources/tags` are not evaluated.
	- When tags are updated via the [tags-as-a-resource API](https://learn.microsoft.com/en-us/rest/api/resources/tags/update-at-scope?view=rest-resources-2021-04-01), which is used by major clients like Azure Portal, the token acquisition will be performed against the tag "resource" instead of the underlying resource actually containing the tags. This essentially means that external evaluation policies that target resource tags (e.g. `../examples/02-deny-immutable-tag-on-nsg/policy-definition.json`) are incompatible with this API and the tag update operations will always be blocked.
	- *Fix status:* Policy team is working to make the tags API invoke-policy-aware

### Platform limits

- To acquire a policy token, the user must be at least reader at the subscription level as well as have permissions to perform the operation the token is acquired for.
- Only the `deny`, `audit`, `denyAction` and `auditAction` effects are supported.
- Endpoint invocation is typically using the policy assignment's MSI, which could lead to throttling if the endpoint has throttling limits by app id.
	- In the case of ARG queries, the endpoint provides an option to use the caller's identity to query ARG, which should mitigate the issue.

### ARG Endpoint limits, gotchas and quirks

- Queries are being executed at the subscription level. No cross-subscription queries at this stage.
- The ARG query must return 0 or 1 rows.
	- The single row value column is translated to a claim accessible by the `if` conditions. e.g. the ARG query `resources | take 1 | project id` will return a single resource id, which the `if` condition can access with the `[claims().id]` expression.
	- When 0 rows are returned, the claim for each column will be assigned a null value.
- The ARG endpoint can only return a single column (aka claim). For scenarios where the policy needs multiple pieces of information, they should be consolidated in the ARG query into a single column.
- Boolean claims arrive as `0`/`1` integers, not `true`/`false`
	- KQL booleans projected from ARG (`project isFoo = <bool expression>`) are serialized into the policy claim as the integers `1` (true) or `0` (false), not as JSON booleans.
	- *Workaround:* when expecting a boolean response from the ARG query, wrap the claim expression with `bool(...)` in the rule expression — `[bool(coalesce(claims().isFoo, false()))]` — to coerce the integer back to a real boolean. See `02-policy-artifacts-shape.md` under `policyRule.if` for the full pattern.
