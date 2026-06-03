# 03 — REST contracts

Reference for the wire shapes the `.http` flow uses. The flow itself lives in `templates/test-flow.template.http` and `examples/01-deny-nsg-overshared/test-flow.http`; this file only documents the parts of the contract that matter when reading responses or debugging.

---

## R0 — API versions

| Operation | API version |
|---|---|
| Policy definition / assignment CRUD | `2025-03-01` |
| `acquirePolicyToken` | `2025-11-01` |

---

## R1 — Reading the `acquirePolicyToken` response

Top-level:

- `result`: `"Succeeded"` means the call ran end-to-end; per-endpoint outcomes live under `results[*]`. `"Failed"` means token acquisition itself failed (e.g. ARG returned an error, query was rejected, gating denied the call) — inspect `message` and per-result `message`; don't retry the ARM op.
- `token`: present when at least one token was minted. Always prefixed with `"PoP "` (literal three characters + space). Pass verbatim, including the prefix.
- `tokenId`, `expiration`: identifier and lifetime. The token contents are opaque.
- `changeReference`: change-safety reference; not used for ARG-backed policies.

Per-result (`results[*]`):

- `policyInfo`: which definition/assignment produced this entry.
- `result`: per-endpoint invocation result. `"Failed"` means the endpoint (e.g. ARG) errored — no token component for this result.
- `claims`: the exact key/value pairs your KQL projected. The first place to look when a boolean comes back as `null`, the column name is misspelled, or the projection doesn't match `queryProjectedClaims`.

Also under each result:

- `requestDetails`: echo of the operation the token binds to, including a `contentHash` the retry is checked against.
- `results[*].endpointKind`: `"AzureResourceGraph"` for the ARG endpoint.
- `results[*].policyAction`: the engine's verdict. Values: `Allow`, `Audit`, `Deny`, `Error`.
  - all `Allow` or `Audit` → `token` is returned; retry the ARM op with it.
  - any `Deny` → no token; the policy will block. Don't retry.
  - `Error` → see `results[*].policyEvaluationDetails.reason`.
- `results[*].policyEvaluationDetails.evaluatedExpressions`: the rule expressions the engine evaluated and how each resolved.
- `results[*].additionalInfo` (ARG endpoints): contains `requestBody.query` — the materialized KQL ARG actually saw, after `field(...)` and `parameters(...)` substitution. Diff this against your authored query to catch escaping bugs.

---

## R2 — Retrying the guarded ARM op

The retry attaches the token via header:

- **Header name**: `x-ms-policy-external-evaluations` — lowercase, dashes. Typos behave exactly like "no header" and re-trigger the missing-token path.
- **Header value**: the `token` field from the acquire-token response, **verbatim including the `PoP ` prefix** (note the space).
- **Body**: must match `operation.content` from the acquire-token request byte-for-byte. The token is bound to the request body via the `contentHash` echoed in `requestDetails`; mismatched bodies won't bind.

---

## R3 — The 403 you'll see on the first attempt

PUT the resource the first time, before acquiring a token, and ARM returns `403 RequestDisallowedByPolicy`. The interesting payload sits under `error.additionalInfo[*].info.evaluationDetails.missingPolicyTokenDetails`:

- `shouldDeny`: whether the policy would deny without a token (driven by `missingTokenAction` on the definition).
- `endpointKind`: `"AzureResourceGraph"` for ARG-backed policies.
- `endpointDetails`: endpoint-specific metadata. For ARG, the materialized query and the subscription it will run against.
- `endpointResultLifespan`: ISO-8601 duration the resulting token will be valid for.
- `isChangeReferenceRequired`: change-safety flag; not used for ARG-backed policies.

Programmatic clients consume this block directly to drive the retry. The `.http` flow walks past the 403 deliberately so authors see it at least once.
