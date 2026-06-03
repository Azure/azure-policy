---
name: azure-arg-external-evaluation-policy-author
description: Use when the user wants to author, design, or test an Azure Policy that queries Azure Resource Graph (ARG) at request-time — i.e. a policy whose deny/audit decision depends on data from elsewhere in the subscription (sibling/parent resource state, RG-wide invariants, multi-hop relationships, etc.). Formally called Azure Policy External Evaluation; sometimes referred to colloquially as "Invoke". Drives an iterative KQL co-design loop against the user's real subscription via `az graph query`, then emits a policy definition, assignment, `.http` test flow, and an `EXPLANATION.md` companion. Read-only; never provisions anything.
---

# Azure Policy External Evaluation (ARG) authoring

Procedure for authoring and testing an **enforcement Azure Policy that queries Azure Resource Graph (ARG)**, utilizing the new **External Evaluation** features. Follow the workflow below when the user asks for a policy whose decision depends on ARG data.

The output of the procedure is a folder containing: a `policy-definition.json`, a `test-flow.http`, and an `EXPLANATION.md`. The policy assignment body lives inline in the `.http` file (see step 4 below). A secondary goal of this procedure is to help users learn about the new External Evaluation feature.

The procedure never provisions anything in the user's subscription; the only Azure side-effects are read-only ARG queries via `az graph query`.

Knowledge files referenced throughout — read them **as needed**:

- [`knowledge/01-overview.md`](./knowledge/01-overview.md) — what External Evaluation + ARG is and known feature limits
- [`knowledge/02-policy-artifacts-shape.md`](./knowledge/02-policy-artifacts-shape.md) — canonical JSON for definition + assignment, field by field, with locks and leeway
- [`knowledge/03-rest-flow.md`](./knowledge/03-rest-flow.md) — Token API REST contracts, response shapes, the 403 to expect

Also available: [`templates/`](./templates/) (canonical skeletons) and [`examples/`](./examples/) (worked end-to-end scenarios).

---

## Rules

- **Never modify, create, or delete anything in the user's subscription.** ARG queries via `az graph query` are read-only and are the only Azure side-effects you produce.
- **Stay within External Evaluation + ARG's limits.** If the user ask can't be achieved with the existing capabilities, say so plainly, explain why and stop.
   - If the user asks for a policy that doesn't need an ARG call but they want to use it anyway, let them know and continue with creating the policy if they're ok with it.
- **Your generated artifacts should strictly follow the pattern described in the knowledge base**.
- **Work with the user to create and test the ARG query**. Always run the co-design process.
- **Cite a knowledge file or official docs** every time you justify a non-obvious choice (e.g. "queryWithUserIdentity: true — see the shape doc"). No bare hand-waving. Goal is to ensure that you are accountable to the accuracy of your decisions as well as educating the user.

---

## Workflow

### Step 0 - Read the overview doc

[`knowledge/01-overview.md`](./knowledge/01-overview.md)
External Evaluation is new and not yet covered by public documentation. Prior context and official docs will not fill in the gaps — read the overview first.

### Step 1 — Intake & feasibility

Goal is to reach a mutual agreement with the user about what the policy is doing and whether it's feasible to utilize the External Evaluation feature.

1. **Restate the free-text policy intent in one sentence. Reiterate based on user feedback until they approve**:
   - Name which resource operations are targeted: operation type (write/delete, could be implicit), resource type and any other constraints on the resource payload.
   - Loosely describe what the ARG query returns and which returned values will result in denial.
   - Example: "Deny the association of an NSG to a subnet if an ARG query that counts other subnets using the NSG returns a number greater than 3"
2. **Feasibility check.** Walk through these reasons-to-reject:
   - Is the invariant **within one subscription**? Cross-sub / cross-tenant / MG-scoped → reject.
   - The ARG query must return a result that has a single column and 0 or 1 rows. Can the invariant collapse to **one boolean or scalar**?
      - This means that parts of the policy logic will have to be shifted to the ARG query side. e.g. instead of an `allOf: [ claims().a == 1, claims().b == 2]` in the policy condition, the ARG query will have a `| project a == 1 and b == 2` statement.
      - Common ways to return a single result is to have the query filter by a specific resource id, or use `summarize`
      - Try hard - ARG language is more capable than the policy language and it's most likely doable. Only reject if you genuinely cannot.
   - Is the desired effect in `{audit, deny, auditAction, denyAction}`?
   When rejecting, state the reason plainly, point at the relevant knowledge file section, and suggest the closest standard-policy alternative if one exists. Then stop.

### Step 2 — KQL co-design with the user

Goal is to work with the user to compose and test a draft of the query that will be used in the policy.

The main challenge with the new kind of policies is that any meaningful use case will require formatting the ARG query at evaluation time, plugging in details from the evaluated resource or policy parameter values. This means that the policy definition you'll author will likely have ugly `[format()]` expressions that construct the query, with the necessary runtime details plugged in via expressions like `[field()]` and `[parameters()]`, as well as escaping any quotes. This expression is not very human readable and extremely hard to manually convert to and from a runnable ARG query for testing. You are to shield the user from this complexity. Help them author and test a "regular" ARG query against a real environment, being mindful (and helping the user understand) about the parts of the query that will need to be parameterized at runtime vs parts of the query that are meant to perform the desired logic.

1. Get the initial query that captures the intent.
   - Ask the user if they have a working sample query that they want to use as a starting point. The query doesn't have to conform to the added rules and limitations of the policy. It should express the general idea.
   - If they don't have a query, suggest a starting query for them and ask for feedback. Your query should focus on the core logic. Don't add any collapsing logic yet.
   - For example, for the NSG oversharing example (see [`examples/01-deny-nsg-overshared/`](./examples/01-deny-nsg-overshared/)), the starting query can return all pairs of associated subnet-nsgs:
      - `resources | where type =~ "microsoft.network/networksecuritygroups" | mv-expand subnet = properties["subnets"] | project nsgId = id, subnetId = subnet["id"]`
2. Sanity check query run:
   - Ask the user for permission to run the query, as well as against which subscriptions to run it — we want a test subscription where the query will return results.
   - Run the query, analyze the results and present them to the user, raising any potential issues with the query or the quality of the test data set, as well as asking if it makes sense to them.
   - Loop with the user until they have confidence that the query returns the right data to drive the requested policy.
3. Re-write the query in a policy-friendly form:
   - Add additional filters if the initial query is too broad — the policy query needs to only return results that are relevant to the evaluated resource.
   - Try to separate between conditions that will require parameterization and any conditions that act only on the properties of the queried resources.
   - Your filters should use hard coded values that you know will yield results from the test set.
   - Apply the necessary consolidation.
   - Going with the NSG oversharing example above, the revised query will be: `resources | where type =~ "microsoft.network/networksecuritygroups" | where id == '<hard coded NSG Id that will be populated in runtime in the policy>' | mv-expand subnet = properties["subnets"] | where isnotnull(subnet["id"]) | where subnet["id"] !~ '<hard coded subnet Id that will be populated in runtime in the policy>' | summarize otherSubnetsCount = count()`
      - In this revised query, we imagine that the policy will target subnets, and that we'll have 2 dynamic values in the ARG query: which NSG we're about to add to the subnet (so that we can find who else uses it) as well as the id of the evaluated subnet, so that we can exclude it from the count if it's already attached to this NSG. We also consolidate the results by using a `summarize count()` aggregation.
   - Share this query with the user, explain what you did and why, run it and ensure the results make sense. You may need to produce multiple versions of the query with different placeholder values hard-coded into it for different test cases. Iterate with the user until reaching an acceptable result.
   - These queries and details will also be added to EXPLANATION.md

### Step 3 - Design the policy definition

Now that you have a working ARG query, work with the user to create a Policy Definition utilizing the external evaluation feature.
Note that this skill is meant to help utilizing the new external evaluation feature, it's not a generic policy authoring skill. Also remember that the external evaluation feature is not publicly documented yet. This means that:
- You must follow the canonical policy definition shape in `knowledge/02-policy-artifacts-shape.md` to ensure proper use of the new primitives and maximize your chances to create a working policy.
- When it comes to the core evaluation logic, you should rely heavily on the user's input. If the user seems to be well versed in Azure Policy, your role should become helping them plug in the external evaluation endpoint definition and claims usage.

1. Start with crafting the policy rule's `if` condition based on the input you received so far. The condition should capture both the applicability of the policy (e.g. `type == vm && tags[env] == prod`) as well as claims assertions (e.g. `coalesce(claims().otherSubnetsCount, null()) > 0`). Follow the shape described in `knowledge/02-policy-artifacts-shape.md`.
2. Share the `if` condition with the user. Explain in words what the condition is doing. The verbal description of the condition should loosely match the policy intent one-liner you came up with in step 1. Answer any questions the user has about the claims() usage. Remember to anchor your responses with references to your knowledge base. Iterate with the user until reaching an acceptable result.
3. Craft the `then` block. `effect` is always `[parameters('effect')]`. **If the effect family is action-time (`auditAction` / `denyAction`), also include `then.details.actionNames`** — the engine rejects the assignment otherwise. See `knowledge/02-policy-artifacts-shape.md` → `policyRule.then.details` for the exact shape.
4. Craft the `externalEvaluationEnforcementSettings` section based on the canonical definition shape and the query you constructed in the previous stage. Take the query with the hard-coded values and replace it with an ARM template expression that formats the query at runtime, using `field()` / `parameters()` calls for the dynamic values. Escape every quote in the inner KQL.

    Before (literal query, hard-coded NSG and subnet ids):

    ```kusto
    resources
    | where type =~ "microsoft.network/networksecuritygroups"
    | where id == "<NSG id being attached>"
    | mv-expand subnet = properties["subnets"]
    | where isnotnull(subnet["id"])
    | where subnet["id"] !~ "<subnet id being modified>"
    | summarize otherSubnetsCount = count()
    ```

    After (ARM template expression, single-line, all inner quotes escaped):

    ```jsonc
    "query": "[format('resources | where type =~ \"microsoft.network/networksecuritygroups\" | where id == \"{0}\" | mv-expand subnet = properties[\"subnets\"] | where isnotnull(subnet[\"id\"]) | where subnet[\"id\"] !~ \"{1}\" | summarize otherSubnetsCount = count()', field('Microsoft.Network/virtualNetworks/subnets/networkSecurityGroup.id'), field('id'))]"
    ```

5. Share this section with the user. Explain what each part is doing and how you transformed the query and why. Iterate with the user until reaching an acceptable result.

### Step 4 — Emit artifacts

Before writing anything, tell the user — in one short line each — which files you're about to create and what each is for. Then write them.

Create a new folder named after the policy (kebab-case, prefixed with `audit-` / `deny-` / `auditaction-` / `denyaction-`) and write three files:

- `policy-definition.json` — model the canonical shape in `knowledge/02-policy-artifacts-shape.md` and the worked examples under `examples/`. Fill in the effect family from step 1, the target resource type, the claim name, and the `[format(...)]` KQL from step 2. The shape doc is authoritative for every field.
- `test-flow.http` — start from `templates/test-flow.template.http`. Substitute the concrete RP path, API version, location, and request body. Keep the `### Expected:` lines. The policy assignment body is inlined inside this file rather than living in its own JSON — the REST Client extension does not expand `@`-variables inside files included via `< ./file.json`, so an external assignment file would emit a broken request.
  - **Before each `acquirePolicyToken` POST, include a direct ARG query that mirrors what the policy will run for that case.** Build it from the same materialized KQL with the same inputs the policy will substitute (resource id, parameter values). Lets the user — and the agent, on a failing case — distinguish a wrong query from a policy/token/wiring problem in one extra send. See `examples/03-denyaction-actiongroup-in-use/test-flow.http` for the pattern.
- `EXPLANATION.md` — three sections:
  1. **What this policy does** — intent, target operation, bad-state condition, what gets denied vs allowed.
  2. **Test queries used during co-design** — for each iteration of the KQL loop: the materialized query, the inputs, the actual ARG result, the conclusion.
  3. **How to test this** — concrete steps for Portal, Azure CLI, and the `.http` file.

Authoring rules for these files:

- **No real environment values.** Subscription ids, resource group names, tenant ids, and specific resource names from the user's environment must be replaced with placeholders like `<subId>`, `<rgName>`, `<nsgName>` (or a generic-looking default like `nsg-immutable-test`) in *every* file you emit, including KQL examples quoted inside `EXPLANATION.md`. These bundles are shared publicly.
- **Cross-references stay inside the bundle.** When `EXPLANATION.md` links to a knowledge file or another example, use a relative path inside this bundle (e.g. `../../knowledge/01-overview.md`). Do not invent absolute paths under `.copilot/skills/...` or any other deploy-time location — those won't resolve for the reader.

Once the files are written, respond with a short message: list the files you created, point the user at `EXPLANATION.md` for the design walkthrough and at `test-flow.http` for the end-to-end create-and-test flow, and invite follow-ups. Do **not** re-explain what the policy does or restate each design decision — that's what `EXPLANATION.md` is for.

---

## When asked "why X?"

Cite the relevant knowledge file and answer in one or two sentences. If the answer involves a trade-off (`missingTokenAction`, `mode: Indexed` vs `All`, `queryWithUserIdentity`), state the trade, the default, and offer to change it. If you don't have a citation, say so — don't invent one.

---

## When to stop

If you discover mid-flow that the ask hits a limit you missed in step 1 — cross-sub query, request-mutation effect, data not in ARG, an invariant that won't collapse to one claim, or an unsupported endpoint kind — stop and explain. Don't write artifacts you know won't work. Suggest the nearest workable alternative (classic policy, DeployIfNotExists, a pipeline check) if one exists.

Push back, but proceed after re-confirmation, when the user picks an effect from the wrong family for their operation kind (e.g. `denyAction` on a PUT, `deny` on a DELETE). The wrong family silently no-ops at runtime — the test loop appears to succeed and the customer thinks they have protection.

---

## Output style

- Lead with the punchline. Use matter-of-fact and neutral tone. Be concise. Use plain language.
- Show the materialized KQL (literal values substituted) — not the `[format(...)]` wrapper. That's the form that matters for debugging.
- After each emitted artifact, a short `_why:_` callout listing the 3–6 most surprising choices with a pointer to the relevant knowledge file.
- One concrete suggestion, not a list of options.
