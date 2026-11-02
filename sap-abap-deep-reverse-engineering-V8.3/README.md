# SAP ABAP Deep Reverse Engineering V8.3

Evidence-driven, strictly read-only reverse engineering of existing SAP ABAP, CDS, RAP, and classic report/class solutions. Ready-to-use GitHub Copilot agent and skill package. V8.3 consolidates the V7 reference set and the V8.2/V8.21 output-mode design into one package.

## Installation
1. Copy `agents/sap-abap-reverse-engineer.agent.md` to the repository agent location, commonly `.github/agents/`.
2. Copy `skills/sap-abap-reverse-engineering/` to the skill location used by your Copilot environment.
3. Keep the internal `references/` and `templates/` paths unchanged. Project templates live under `templates/<PROJECT>/`.

`docs/` is for people only (analysis and release information); do not copy it into the agent or skill location.

## Three independent controls
| Control | Decides | Values |
|---|---|---|
| Analysis profile | depth and budget | Quick (3/75), Standard (5/150), Deep (10/300), Extended (20/500) |
| Output mode | delivery format | `CHAT_SUMMARY`, `FUNCTIONAL_SPEC`, `BOTH` |
| Document intent | content emphasis | functional specification (default), technical specification, support handbook, impact assessment, migration specification, test design, knowledge base |

Chat-only does not mean shallow, and a Deep profile does not mean `DEEP_COMPLETE`.

## Quick start
Provide the system or destination (and client when required), the root object, and the objective. The agent asks for anything else missing in **one** batched message (output mode, project template for Functional Specification/Both, profile, output folder, language), verifies the toolchain with one light read, runs a bounded assessment if you did not pick a profile, then freezes scope before deep analysis.

Example request:
```text
Reverse engineer ZC_RTR_ROU_OUTLEASELIABREP in system S4D, client 100.
Use Deep analysis. Output mode: Both. Project template: SMILE.
Generate the results in English under ./reverse-engineering-output.
```

## Output modes
- `CHAT_SUMMARY`: evidence-backed summary in Chat; no template lookup; no Functional Specification file.
- `FUNCTIONAL_SPEC`: project-template selection and `<OBJECT>_Functional_Specification.md`; short completion note in Chat.
- `BOTH`: concise Chat Summary plus the Functional Specification from the same analysis state, with no repeated discovery.

A Functional Specification can be requested after a Chat Summary (late conversion). It reuses valid state; when an `<OBJECT>_Analysis_State.md` checkpoint exists it is verified against current source fingerprints first.

## Package structure
```text
sap-abap-deep-reverse-engineering-V8.3/
├── README.md
├── RELEASE_NOTES_V8.3.md
├── docs/
│   └── IMPROVEMENT_ANALYSIS.md
├── agents/
│   └── sap-abap-reverse-engineer.agent.md
└── skills/
    └── sap-abap-reverse-engineering/
        ├── SKILL.md
        ├── references/            (15 files, loaded on demand)
        └── templates/
            ├── README.md
            └── default/
                ├── functional-specification-template.md
                └── template.yaml
```

## References (loaded on demand)
| File | Covers |
|---|---|
| `safety-and-preflight.md` | read-only classes, identity gate, toolchain verification, redaction |
| `intake-and-modes.md` | batched intake, output modes, late conversion, document intent, metadata model |
| `scope-and-planning.md` | profiles, plan, P0-P3 priority, scope freeze, exclusions, baseline and fingerprint |
| `evidence-and-completion.md` | claim states, node/edge states, absence rule, completion statuses and decision order |
| `cds-discovery-strategy.md` | graph-first CDS discovery, canonical identity, table functions to AMDP |
| `discovery-playbooks.md` | capability/process, entity, configuration discovery |
| `technical-playbooks.md` | LUW, dynamic calls, class/function, CDS/RAP/OData, classic report/ALV, enhancements, authorization, performance, Clean Core, patterns |
| `findings-and-risk.md` | finding classes, sufficiency gate, confirmation queue, impact radius |
| `coverage-and-scoring.md` | coverage registry, credits, per-dimension reporting, optional composite score |
| `runtime-handoff.md` | runtime test packages, priority model, ABAP FS / SAP UI testing handoff |
| `template-selection.md` | project template resolution and fallback |
| `functional-specification-authoring.md` | rules for writing the Functional Specification |
| `deliverables-and-layout.md` | Chat Summary structure, sidecars, size policy, applicability, diagrams, readability |
| `validation.md` | validation sequence, completion checklist, checkpoint |
| `machine-readable-exports.md` | opt-in YAML/JSON exports and schemas |

## Behavior that is never relaxed
- SAP is read-only; only `SAFE_READ` operations run. No write probing.
- System, client, and root object are never guessed.
- No invented sign-off, owners, priority, frequency, volume, mandatory flags, configuration values, or expected results; use `TBD - requires confirmation` and queue it.
- Technical naming alone never proves business meaning.
- Budgets stop tool use; they never justify completeness.
- Credentials, personal data, and confidential samples never reach outputs.

## Completion statuses
Exactly one of `DEEP_COMPLETE`, `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`, `STATIC_DEEP_PARTIAL`, `STRUCTURAL_ANALYSIS_ONLY`, `REPORT_VALIDATION_FAILED`. `analysis_status` (evidence coverage) is reported separately from `document_status` (readiness for review).
