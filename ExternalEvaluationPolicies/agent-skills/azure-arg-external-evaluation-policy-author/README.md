# Azure Policy External Evaluation (ARG) authoring assistant

> Note: This skill is meant to be shared with Azure customers. Do not include links to internal docs and other data sources.

This folder contains AI skill for authoring and testing **Azure Policy External Evaluation policies that query Azure Resource Graph (ARG)**. (This feature is sometimes referred to colloquially as "Invoke"; the rest of this bundle uses the formal name.)

The goal of this skill is to help customers registered to the private preview to get familiar and experiment with the new concept of external evaluations.

The skill takes a free-text intent for an enforcement policy that queries ARG, decides feasibility against the known limits and gotchas, iterates on the desired query (via `az graph query`), and helps create the policy definitions, a `.http` file with a test flow, and a detailed explanation of the policy's structure.

> Note: This skill is authored to work within the limits of the external evaluations feature as of May 2026. Some of these limits might change in the future.

## Usage

This bundle is packaged as an [agent skill](https://code.visualstudio.com/docs/copilot/customization/agent-skills) (`SKILL.md` at the root with YAML frontmatter, supporting `knowledge/`, `templates/`, and `examples/` folders alongside).

### GitHub Copilot

Drop the entire folder into one of the skill locations Copilot discovers automatically.

## Prerequisites

- Your tenant is onboarded to the External Evaluation policies private preview.
- `az` CLI logged in (`az login`) with at least Reader on the subscription you'll be testing against. Used by the agent to run `az graph query` during the KQL co-design loop.
- A real subscription with resources relevant to the ARG query.

## Folder layout

```
azure-policy-invoke-arg-author/
├── README.md                                    # this file
├── SKILL.md                                     # skill entry point (frontmatter + system prompt)
├── knowledge/
│   ├── 01-overview.md                           # what it is, when not to use it
│   ├── 02-policy-artifacts-shape.md             # canonical JSON for definition + assignment, field by field
│   └── 03-rest-flow.md                          # acquirePolicyToken contract, the 403 you'll see
├── templates/
│   └── test-flow.template.http
└── examples/
    ├── 01-deny-nsg-overshared/
    ├── 02-deny-immutable-tag-on-nsg/
    └── 03-denyaction-actiongroup-in-use/
```

Each example folder contains a `policy-definition.json`, a `test-flow.http`, and an `EXPLANATION.md` (what the policy does, the test queries run during co-design, how to verify via Portal / CLI / REST).
