# Release Notes V8.3 - Consolidated Package

V8.3 merges the V7 reference set (39 reference files plus agent and skill) with the V8.2/V8.21 output-mode design, removes contradictions found in V8.21, and adds the capabilities that neither version had. Details and reasoning: `docs/IMPROVEMENT_ANALYSIS.md`.

## Fixed
- Agent preflight listed template selection as mandatory for every run, contradicting the rule that `CHAT_SUMMARY` skips it. Preflight now asks for the template only for Functional Specification or Both.
- Agent mission and front-matter description promised a Functional Specification in all cases. They now describe the three output modes.
- Template selection timing was inconsistent (early in the skill phases, late in the agent workflow, "before analysis" in the README). It is now resolved in the batched intake and in Phase 2.
- Late conversion depended on "saved scope and fingerprints" with no persistence rule. Added a checkpoint file and a no-checkpoint fallback.
- Profiles were referenced but not defined in V8.21. Quick/Standard/Deep/Extended budgets and the bounded assessment are restored.
- The V8.21 validation list omitted the redaction review. It is now a validation step.
- V7 had two conflicting weight tables (runtime 5 versus document integrity 5). One table is kept and runtime is reported separately.
- V7 `logon-gate.md` hardcoded connection IDs and a verification date. Removed; the connected-system list always comes from the live session.
- Four V7 references were never loaded by the V7 skill (`audience-and-readability`, `diagram-guidelines`, `evidence-model`, `report-template`). Their content is merged and reachable.
- Stale versioning: `template.yaml` said 8.1, the README said V8, and a separate root README described V8 without output modes. One README and one version now.
- The agent duplicated reference content. It is now a thin orchestrator (about 3.8 KB, from 6.3 KB).

## Added
- Single batched intake instead of up to four sequential questions.
- Reference loading map in the skill (progressive disclosure) in place of eager loading.
- Analysis checkpoint (`<OBJECT>_Analysis_State.md`) with fingerprint verification on resume.
- Chat Summary structure and default length.
- `document_intent` as a third independent control, and `analysis_status` separate from `document_status`.
- Restored from V7: finding classes and the evidence-sufficiency gate, three-dimension confidence, confirmation-queue priorities and the blocking rule, impact radius labels, coverage registry and credits, runtime handoff schema and priority model, source baseline, absence-of-evidence rule, node and edge states, completion decision order, diagram rules, redaction classes.
- New technical playbook content: RAP business object checklist, classic report/selection screen/ALV, enhancements, authorization separation, Clean Core assessment.
- Functional Specification template: Executive Summary, Findings Register, Glossary and Technical Object Map, analysis and template metadata appendix, document status.
- Skill description rewritten with trigger wording for better invocation.
- Toolchain table with a row for additional connectors.

## Changed
- Coverage is reported by dimension by default. The weighted composite score is opt-in.
- Knowledge graph and JSON/YAML exports are opt-in (V7 produced them by default).
- References consolidated from 45 files (V7: 39, V8.21: 6, with `cds-discovery-strategy.md` identical in both) to 15.

## Preserved
Strict read-only safety, mandatory preflight and bounded assessment, scope freeze, graph-first CDS discovery and canonical deduplication, table function to AMDP resolution, evidence states, field lineage rules, runtime handoff, project template selection with default fallback, artifact validation, and the five completion statuses.

## Reference mapping
V8.21 files `safety-and-preflight`, `evidence-and-completion`, `cds-discovery-strategy`, `template-selection`, and `functional-specification-authoring` keep their names. `output-mode-selection.md` is now `intake-and-modes.md`.

| V7 reference | V8.3 location |
|---|---|
| `abapfs-runtime-handoff.md` | runtime-handoff.md |
| `analysis-metadata-model.md` | intake-and-modes.md |
| `analysis-plan.md` | scope-and-planning.md |
| `analysis-playbooks.md` | technical-playbooks.md |
| `analysis-priority.md` | scope-and-planning.md |
| `architecture-patterns.md` | technical-playbooks.md (section 11) |
| `artifact-export.md` | machine-readable-exports.md |
| `artifact-schema-validation.md` | machine-readable-exports.md |
| `audience-and-readability.md` | deliverables-and-layout.md; functional-specification-authoring.md |
| `capability-discovery.md` | discovery-playbooks.md (section 1) |
| `cds-discovery-strategy.md` | cds-discovery-strategy.md (unchanged, plus related-references section) |
| `completion-checklist.md` | validation.md |
| `completion-state-policy.md` | evidence-and-completion.md |
| `configuration-discovery.md` | discovery-playbooks.md (section 3) |
| `coverage-confidence.md` | coverage-and-scoring.md |
| `coverage-registry.md` | coverage-and-scoring.md |
| `data-handling-and-redaction.md` | safety-and-preflight.md |
| `deliverable-applicability.md` | deliverables-and-layout.md |
| `diagram-guidelines.md` | deliverables-and-layout.md |
| `document-integrity-validation.md` | validation.md |
| `document-intent.md` | intake-and-modes.md |
| `entity-discovery.md` | discovery-playbooks.md (section 2) |
| `evidence-model.md` | evidence-and-completion.md |
| `evidence-sufficiency.md` | findings-and-risk.md |
| `final-serialization-validation.md` | validation.md |
| `finding-confidence-model.md` | findings-and-risk.md |
| `functional-confirmation-queue.md` | findings-and-risk.md |
| `impact-radius.md` | findings-and-risk.md |
| `knowledge-graph.md` | machine-readable-exports.md |
| `logon-gate.md` | safety-and-preflight.md (hardcoded connection IDs dropped) |
| `output-artifact-layout.md` | deliverables-and-layout.md |
| `profile-selection.md` | scope-and-planning.md |
| `report-size-policy.md` | deliverables-and-layout.md |
| `report-template.md` | superseded by the FS template; required matrices moved to deliverables-and-layout.md |
| `runtime-handoff.md` | runtime-handoff.md |
| `safety-policy.md` | safety-and-preflight.md |
| `scope-governance.md` | scope-and-planning.md |
| `scoring-model.md` | coverage-and-scoring.md |
| `source-baseline-and-fingerprint.md` | scope-and-planning.md |
