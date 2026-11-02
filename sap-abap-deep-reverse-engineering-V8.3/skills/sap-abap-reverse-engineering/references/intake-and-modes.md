# Intake and Modes

## Three independent controls
- **Analysis profile** controls depth, breadth, and budget (`scope-and-planning.md`).
- **Output mode** controls delivery format: `CHAT_SUMMARY`, `FUNCTIONAL_SPEC`, `BOTH`.
- **Document intent** controls content emphasis.

Examples: Deep + Chat Summary; Standard + Functional Specification; Deep + Both. Choosing Chat Summary does not reduce analytical depth. Choosing Functional Specification does not imply complete static or runtime evidence.

## Single batched intake
Ask once, in one message, only for items that are missing. Never ask for something the message or session already answers.

```text
Before I start, please confirm anything not already clear:
1. SAP system/destination (and client if required) and the root object
2. Investigation objective
3. Output language, and output folder if files are needed
4. Output mode: 1 Chat Summary / 2 Functional Specification / 3 Both
5. Project template name, or `default` (Functional Specification or Both only)
6. Analysis profile: Quick / Standard / Deep / Extended, or "recommend" for a bounded assessment
```

Rules:
- System, client (when required), and root object must be resolved before any SAP call. Wait for the answer.
- Output mode may be resolved from explicit wording (below). Do not silently choose when intent is ambiguous; ask in the same batched message.
- Ask for the project template only when the mode is `FUNCTIONAL_SPEC` or `BOTH`, and not if the conversation already names one.
- If the profile is not chosen, run the bounded assessment after the safe read and recommend a profile.
- Default output language is the language the user writes in. SAP technical names stay unchanged.

## Output modes

### CHAT_SUMMARY
For explanation, analysis, findings, risks, dependency review, or architecture assessment in Chat. Produces a structured, evidence-backed Chat response (structure in `deliverables-and-layout.md`). Skips project-template selection. Creates no Functional Specification file.

### FUNCTIONAL_SPEC
For formal documentation, as-built specification, project handover, or Word-ready Markdown. Runs project-template selection and generates `<OBJECT>_Functional_Specification.md`. Sidecars only when applicable. Returns a short completion note in Chat.

### BOTH
For immediate understanding plus a formal document. Produces a concise Chat Summary and the Functional Specification from the same frozen scope, canonical graph, evidence registry, field lineage, findings, coverage, and completion status. Never rerun repository discovery or deep analysis solely to create the second format.

### Explicit intent mapping
- summary, explain, analyze, review, findings, architecture assessment -> `CHAT_SUMMARY`
- Functional Specification, documentation, Markdown file, Word-ready output, project template -> `FUNCTIONAL_SPEC`
- summary plus document, or "both" -> `BOTH`

### Late conversion
If the user requests a Functional Specification after a Chat Summary:
1. verify the saved scope and source fingerprints (from the checkpoint, or from conversation state if still in context);
2. run project-template selection;
3. reuse valid analysis state;
4. retrieve only document-specific missing evidence;
5. generate and validate the Functional Specification;
6. rerun full analysis only when the baseline is stale, inconsistent, or no valid state is available.

If no checkpoint file and no usable conversation state exist, say so, re-verify fingerprints of critical sources, and reread only what is needed rather than silently trusting memory.

## Document intent
Supported: `functional_specification`, `technical_specification`, `support_handbook`, `impact_assessment`, `migration_specification`, `test_design`, `knowledge_base`, `reverse_engineering_report`.

Default: `functional_specification` for `FUNCTIONAL_SPEC`/`BOTH`; for `CHAT_SUMMARY` use `reverse_engineering_report` with functional and technical reader paths.

Emphasis:
- Functional specification: actors, capabilities, processes, inputs/outputs, rules, exceptions, lifecycle, confirmations, acceptance scenarios.
- Technical specification: architecture, objects, call paths, data model, algorithms, persistence, LUW, locks, authorization, dependencies, performance.
- Support handbook: operations, configuration, messages, troubleshooting, jobs/interfaces, escalation.
- Impact assessment: change radius, direct/indirect consumers, configuration, regression and release risk.
- Migration specification: replacement or conversion scope, data movement, clean-core gaps.
- Test design: confirmed rules, inputs, expected outcomes, cases, observations, safe stops, evidence.

Only the Functional Specification has a bundled template. For other file intents, use the emphasis above with the skeleton in `deliverables-and-layout.md`, and state that no project template applies. Do not build one oversized document that implements every intent.

## Analysis metadata model
Keep method, intent, scope, status, and readiness as separate fields.

```yaml
analysis_method: reverse_engineering
document_intent: functional_specification
document_scope: as_is            # as_is | target_state | change_specific | mixed
audience: [functional, technical]
analysis_profile: deep
output_mode: BOTH
analysis_status: STATIC_DEEP_COMPLETE_WITH_LIMITATIONS
document_status: DRAFT_PENDING_FUNCTIONAL_CONFIRMATION
```

- `analysis_method` explains how knowledge was obtained; `document_intent` controls structure; `document_scope` separates as-is from target-state or change-specific; `analysis_status` describes evidence coverage; `document_status` describes readiness for review and sign-off.
- Never use `reverse_engineering_report` as both method and intent when the output is explicitly a functional or technical specification.
- If any `Blocking` confirmation question is open, `document_status` cannot be final; use `DRAFT_PENDING_FUNCTIONAL_CONFIRMATION`. Static analysis status is reported separately.

## State
```yaml
output_selection:
  requested: <user wording or null>
  resolved: <CHAT_SUMMARY|FUNCTIONAL_SPEC|BOTH>
  source: <explicit|user_selected|inferred_from_explicit_deliverable>
  chat_summary_required: <true|false>
  functional_spec_required: <true|false>
```
