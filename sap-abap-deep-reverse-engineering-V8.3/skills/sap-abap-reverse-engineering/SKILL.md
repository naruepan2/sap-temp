---
name: sap-abap-reverse-engineering
description: Use when asked to reverse engineer, explain, document, review, or assess the impact of an existing SAP ABAP, CDS, RAP, or classic report/class/function solution, or to produce an as-built Functional Specification from repository evidence. Strictly read-only, evidence-driven, with graph-first CDS discovery, evidence states, coverage reporting, runtime-test handoff, and selectable Chat Summary / Functional Specification / Both delivery.
---

# SAP ABAP Reverse Engineering

## Purpose
Reconstruct an SAP solution from repository evidence and deliver traceable knowledge: what it does, why, how it is built, what it depends on, where the risks are, and what is still unverified. Delivery is a Chat Summary, a Word-ready Markdown Functional Specification, or both, from one shared analysis state.

## Three independent controls
| Control | Decides | Values |
|---|---|---|
| Analysis profile | depth and budget | Quick, Standard, Deep, Extended |
| Output mode | delivery format | `CHAT_SUMMARY`, `FUNCTIONAL_SPEC`, `BOTH` |
| Document intent | content emphasis | functional specification (default), technical specification, support handbook, impact assessment, migration specification, test design, knowledge base |

Chat-only does not mean shallow. A Deep profile does not mean deep completion. Details: `references/intake-and-modes.md`.

## Reference loading map
Load on demand; do not read every file up front.

| Reference | Load when |
|---|---|
| `safety-and-preflight.md` | always, before any SAP call |
| `intake-and-modes.md` | always, Phase 0 |
| `scope-and-planning.md` | Phases 1-2 (profile, plan, priority, freeze, baseline) |
| `evidence-and-completion.md` | always, before Phase 3 |
| `cds-discovery-strategy.md` | root is CDS or a critical path is CDS-heavy |
| `discovery-playbooks.md` | capability/process, entity, or configuration discovery is needed |
| `technical-playbooks.md` | by object type: LUW, dynamic calls, class/function, CDS/RAP/OData, classic report/ALV, enhancements, authorization, performance, Clean Core, patterns |
| `findings-and-risk.md` | findings, risks, confirmation questions, or impact analysis are produced |
| `coverage-and-scoring.md` | Phase 5 and whenever coverage is reported |
| `runtime-handoff.md` | any finding or `UNVERIFIED` item needs runtime confirmation |
| `template-selection.md` | `FUNCTIONAL_SPEC` or `BOTH` only |
| `functional-specification-authoring.md` | a Functional Specification is required |
| `deliverables-and-layout.md` | Phase 6, any output |
| `validation.md` | Phase 7 |
| `machine-readable-exports.md` | only when the user opts in to YAML/JSON exports |

Templates: the selected project template under `templates/`, else `templates/default/functional-specification-template.md`.

## Inputs
Required before deep analysis: SAP system/destination (+ client when required), root object or entry point, objective, output language, output mode. Required when files are produced: output folder. Required for `FUNCTIONAL_SPEC`/`BOTH`: project template name or `default`. Resolve all missing items in one batched intake message.

Optional: source/version preference, document intent, profile, business process metadata.

## State model
Maintain: `scope`, `analysis_plan`, `baseline`, `frontier`, `visited`, `nodes`, `edges`, `structural_nodes`, `evidence_registry`, `retrieval_registry`, `source_fingerprints`, `field_lineage`, `business_rules`, `validations`, `configurations`, `authorizations`, `errors`, `ui_output`, `capabilities`, `processes`, `entities`, `test_scenarios`, `findings`, `risks`, `unresolved`, `confirmation_queue`, `runtime_handoffs`, `coverage_registry`, `completion_status`, `artifact_registry`, `output_selection`, `template_selection`.

Never re-analyze a visited canonical object unless its source fingerprint changed or a targeted gap requires a bounded reread.

## Workflow

### Phase 0 - Intake and preflight
Apply `safety-and-preflight.md` and `intake-and-modes.md`. One batched intake message. Verify the toolchain with one light `SAFE_READ`. Freeze system, client, and root.

### Phase 1 - Bounded assessment
If the profile is not selected, assess at depth 2 / about 25 nodes, recommend a profile with evidence, explain all four options, and wait. If selected, proceed to Phase 2 after a minimal structural look.

### Phase 2 - Plan, scope freeze, baseline
Record the analysis plan, allow one scope adjustment, freeze scope, record exclusions, capture the source baseline and fingerprint (`scope-and-planning.md`). Resolve the project template now when the mode requires it (`template-selection.md`).

### Phase 3 - Discovery
Discover entry points, components, dependency relations, UI/service exposure, configuration, authorization, integrations, forms/jobs, and runtime boundaries. CDS: graph-first per `cds-discovery-strategy.md`. Business capabilities, entities, configuration: `discovery-playbooks.md`.

### Phase 4 - Deep reconstruction
Allocate budget to P0/P1 first (`scope-and-planning.md`). Use the matching section of `technical-playbooks.md`. Reconstruct objective and actors, trigger/input/output, process flow and decision branches, data sources and join keys, field-level lineage, validations, configuration and fallback logic, authorization, errors and messages, operational and performance risks, and runtime scenarios.

### Phase 5 - Evidence closure, findings, coverage
Trace every critical output and rule to evidence and label each claim. Classify findings with the evidence-sufficiency gate. Build the confirmation queue and runtime handoffs. Compute coverage from the registry. Write a checkpoint when the output folder is known (see `validation.md`, Checkpoint).

### Phase 6 - Output generation
Chat Summary and/or Functional Specification per `deliverables-and-layout.md` and `functional-specification-authoring.md`. `BOTH` reuses the same registries, findings, coverage, and status; never rerun analysis to produce the second format.

### Phase 7 - Validation
Apply `validation.md` to the selected outputs only, on the exact saved files. One repair pass; otherwise `REPORT_VALIDATION_FAILED` with the draft preserved.

### Phase 8 - Completion report
State completion status, stop reason, coverage by dimension, unresolved items, confirmation queue summary, runtime backlog, and exact file paths.

## Hard rules
- SAP is read-only; classify each operation `SAFE_READ`, `PROHIBITED_WRITE`, or `UNKNOWN`; invoke only `SAFE_READ`.
- Raw dependency rows are occurrences, not unique objects; coverage denominators are unique canonical registries.
- SELECT / UNION / UNION ALL are structural nodes, not repository objects.
- A CDS table function is unresolved until its AMDP implementation is analyzed or explicitly blocked.
- DCL status is independent of source-read status.
- Technical naming alone never proves business meaning.
- Source behavior is `Observed`, not an approved requirement.
- Budgets stop tool use; they never justify completeness.
- Never invent business-owned metadata; use `TBD - requires confirmation` and queue it.
- Never expand scope or profile silently.

## Completion status
Exactly one: `DEEP_COMPLETE`, `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`, `STATIC_DEEP_PARTIAL`, `STRUCTURAL_ANALYSIS_ONLY`, `REPORT_VALIDATION_FAILED`. Decision order and definitions: `evidence-and-completion.md`.
