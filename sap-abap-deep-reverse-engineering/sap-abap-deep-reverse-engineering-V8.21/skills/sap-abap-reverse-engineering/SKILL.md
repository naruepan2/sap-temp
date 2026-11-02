---
name: sap-abap-reverse-engineering
description: Production-oriented, evidence-driven, read-only SAP ABAP reverse engineering with graph-based CDS discovery and Word-ready Markdown Functional Specification generation.
---

# SAP ABAP Reverse Engineering

## Purpose
Reconstruct an SAP solution from repository evidence and produce a complete, traceable Functional Specification in Markdown, supported by technical evidence and runtime-test handoff artifacts when applicable.

## Required references
Read and apply, in order:
1. `references/safety-and-preflight.md`
2. `references/output-mode-selection.md`
3. `references/evidence-and-completion.md`
4. `references/cds-discovery-strategy.md` for CDS roots or CDS-heavy paths
5. `references/template-selection.md` only for `FUNCTIONAL_SPEC` or `BOTH`
6. `references/functional-specification-authoring.md` only when a Functional Specification is required
7. the project template selected from `templates/`, or `templates/default/functional-specification-template.md` as fallback

## Inputs
Required before deep analysis:
- SAP system/destination and client when required
- root object/type or business entry point
- investigation objective
- output language
- output mode: `CHAT_SUMMARY`, `FUNCTIONAL_SPEC`, or `BOTH`
- output directory when file generation is selected

Resolve when available:
- source/version preference
- intended artifact: Functional Specification, Technical Specification, Support Handbook, or Impact Assessment
- project/template name, when the user has one
- expected analysis depth and budget
- business process/workstream metadata

## State model
Maintain:
- `scope`: root, boundaries, objective, audiences, exclusions
- `frontier`, `visited`, `nodes`, `edges`, `structural_nodes`
- `evidence_registry`, `retrieval_registry`, `source_fingerprints`
- `field_lineage`, `business_rules`, `validations`, `configurations`
- `authorizations`, `errors`, `ui_output`, `test_scenarios`
- `findings`, `risks`, `unresolved`, `confirmation_queue`
- `coverage`, `completion_status`, `artifact_registry`
- `output_mode_request`, `resolved_output_mode`, `output_mode_source`
- `chat_summary_required`, `functional_spec_required`
- `template_request`, `template_candidates`, `selected_template`, `template_fingerprint`, `template_fallback_reason`

Never re-analyze a visited canonical object unless the source fingerprint changed or a targeted gap requires a bounded reread.

## Workflow

### Phase 0 - Preflight
Apply `safety-and-preflight.md`. Verify identity and toolchain before repository reads. Freeze system/client/root in analysis metadata.


### Phase 0.5 - Output mode selection
Apply `references/output-mode-selection.md` before long-running analysis. Resolve one mode: `CHAT_SUMMARY`, `FUNCTIONAL_SPEC`, or `BOTH`. Output mode and analysis profile are independent.

- `CHAT_SUMMARY`: skip project-template selection and FS generation.
- `FUNCTIONAL_SPEC`: select a project template and generate Markdown FS.
- `BOTH`: generate Chat Summary and Markdown FS from the same frozen analysis state.

Do not repeat repository discovery or deep analysis when generating both outputs.

### Phase 0.6 - Conditional project template selection
Apply `references/template-selection.md` only for `FUNCTIONAL_SPEC` or `BOTH`. For `CHAT_SUMMARY`, skip this phase. Ask for the project template unless already specified. Resolve the template deterministically from `templates/`; use the bundled default only when no project is specified or the requested template cannot be found. Persist the selection, match method, fingerprint, and fallback reason in analysis state.

### Phase 1 - Bounded assessment
Explore only enough to determine object type, likely architecture, dependency breadth, and recommended profile. If the user has not selected depth, assess with a small budget, recommend a profile, explain trade-offs, and wait.

### Phase 2 - Scope freeze
Record:
- root and related entry points
- intended FS/report audience
- downstream lineage boundary
- bounded upstream impact boundary
- package/system boundary
- depth/node/token budget
- explicit exclusions

Do not expand scope silently.

### Phase 3 - Discovery
Discover entry points, components, dependency relations, UI/service exposure, configuration, authorization, integrations, forms/jobs, and runtime boundaries.

For CDS:
- run graph-first structural discovery;
- canonicalize and deduplicate nodes before source reads;
- preserve unique edges and UNION branch context;
- resolve table functions to AMDP;
- treat DCL independently from source-read status;
- separate downstream lineage, upstream impact, and contextual candidates.

### Phase 4 - Deep reconstruction
Prioritize:
1. root/consumption/interface objects
2. custom Z/Y logic on critical paths
3. calculations, CASE, UNION, aggregation, currency/unit handling
4. validations and exception branches
5. configuration-driven behavior
6. table functions, AMDP, query providers, exits/BAdIs/classes
7. authorization and service exposure
8. base tables and low-risk wrappers

Reconstruct:
- business objective and actors
- trigger/input/output
- process flow and decision branches
- data sources and join keys
- field-level lineage and transformations
- required/optional/conditional status only when evidenced
- filters, value helps, sort/group/aggregation behavior
- configuration and fallback logic
- authorization controls
- error handling and messages
- operational constraints and performance risks
- runtime scenarios needing execution

### Phase 5 - Evidence closure
Trace every critical output and business rule back to source evidence. Mark each statement `FACT`, `DERIVED`, `INFERRED`, or `UNVERIFIED`. Add unsupported business metadata to the confirmation queue instead of inventing it.

### Phase 6 - Selected output generation

For `CHAT_SUMMARY`, return a structured summary covering scope, completion status, executive summary, business behavior, architecture, findings, risks, evidence states, coverage, unresolved items, runtime backlog, and next steps. Do not create an FS file.

For `FUNCTIONAL_SPEC`, generate the selected-template FS and return a short completion note in Chat.

For `BOTH`, create both outputs from the same scope, registries, evidence, findings, coverage, and completion status.

#### Functional Specification generation
Apply `functional-specification-authoring.md` and instantiate the resolved project template. If no valid project template is resolved, instantiate `templates/default/functional-specification-template.md`.

Primary output:
`<OBJECT>_Functional_Specification.md`

Optional sidecars, only when useful:
- `<OBJECT>_Technical_Appendix.md`
- `<OBJECT>_CDS_Inventory.md`
- `<OBJECT>_Dependency_Graph.md`
- `<OBJECT>_Evidence_Register.md`
- `<OBJECT>_Runtime_Test_Handoff.md`
- `<OBJECT>_Confirmation_Queue.md`

The primary FS must remain understandable without opening sidecars. Use links to avoid duplicating large inventories.

### Phase 7 - Validation
Validate only the selected outputs. Chat Summary must agree with the evidence and completion status. For `BOTH`, ensure Chat and FS use the same findings and coverage.
Validate the exact saved files:
- selected-template identity, fingerprint, and fallback reason
- headings and section order
- valid Markdown tables and Mermaid blocks
- no broken internal links
- no accidental blank mandatory cells
- no invented approvals or business metadata
- field rows reconcile across overview, detailed logic, and output/filter tables
- all `TBD` and `UNVERIFIED` items appear in the confirmation queue
- coverage denominators come from unique canonical registries, never raw occurrences
- generated files reopen successfully

Allow one repair pass. If validation still fails, return `REPORT_VALIDATION_FAILED` and preserve the draft.

## Functional Specification minimum content
The FS should contain, where applicable:
1. Document Control
2. General Information
3. Program Overview
4. Application Name and Description
5. Detailed Program Logic
6. Input Parameters
7. User Actions
8. Validation
9. Output / Filter Bar
10. Customized Tables and Configuration
11. Authorizations
12. Error Handling
13. Testing Procedure
14. Dependencies and Architecture
15. Risks, Assumptions, and Limitations
16. Evidence and Coverage Summary
17. Confirmation Queue

Sections not applicable must say `N/A - <evidence-based reason>` rather than being silently removed.

## Completion metrics
Report separately:
- object/source coverage
- unique edge coverage
- critical-path coverage
- critical field-lineage coverage
- configuration coverage
- authorization coverage
- table-function/AMDP coverage
- runtime verification coverage
- unresolved high-priority items

A selected deep profile does not imply deep completion.
