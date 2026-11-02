---
name: sap-abap-reverse-engineering
description: Production-ready, evidence-driven and strictly read-only SAP reverse engineering. Extracts business capabilities, processes, entities, configuration, architecture, impact, coverage confidence, knowledge graphs, runtime handoffs, and graph-oriented CDS lineage from SAP ABAP and related artifacts.
---

# SAP ABAP Reverse Engineering

## Boundaries
Read `references/safety-policy.md` before any SAP tool call. SAP is read-only; business execution is prohibited. Local documentation/export creation is allowed.

## Logon gate (mandatory, before any SAP call)
Apply `references/logon-gate.md`. Session has system: reuse it, never re-ask; verify the toolchain you will use (ABAP FS via `abapfs_get_connected_systems` + light `SAFE_READ`; ADT MCP via `mcp_adt_mcp_serve_abap_destination_list` + light `SAFE_READ`). No system in chat: ask once for `connectionId`/destination and wait. Never infer system or bypass denials. No other SAP tool until resolved and verified.

## Inputs
Root object/type, investigation objective, output language, and local output path. Resolve source version, source preference, intended document type, and scope options when available. System/client comes from Logon gate only.

## Workflow
1. **Preflight**: Logon gate + identity/tools/source/completeness/output.
2. **Profile**: `profile-selection.md`; if none, depth 2/25 assess, recommend, explain 4, wait.
3. **Discover**: structural (entry/components/modes/integrations/forms); capabilities/processes (`capability-discovery.md`); entities/lifecycle (`entity-discovery.md`); config (`configuration-discovery.md`).
4. **CDS discover**: when the root is CDS or a critical path is CDS-heavy, apply `references/cds-discovery-strategy.md` before deep reading. Build the canonical node/edge registry, deduplicate occurrences, preserve UNION/SELECT branch context, rank retrieval, resolve table functions/AMDP and DCL, then run critical-gap closure.
5. **Map**: tech (`analysis-playbooks.md`, `architecture-patterns.md`, evidence model); impact (`impact-radius.md`); coverage (`coverage-confidence.md`, no inflated scores).
6. **Deliver**: handoffs (`runtime-handoff.md` + `abapfs-runtime-handoff.md`); graph (`knowledge-graph.md`); comms (audience/diagram/report-template); validate (`completion-checklist.md`), save/reopen.

## Scope and governance
Intent (`document-intent.md`) + plan (`analysis-plan.md`), one tweak, freeze (`scope-governance.md`). Priority (`analysis-priority.md`); sufficiency gate (`evidence-sufficiency.md`); queue (`functional-confirmation-queue.md`); applicability (`deliverable-applicability.md`); redaction (`data-handling-and-redaction.md`); size (`report-size-policy.md`). Report breadth/depth/quality separately; never game score.

## Baseline and controls
Metadata (`analysis-metadata-model.md`) + fingerprint (`source-baseline-and-fingerprint.md`) at preflight; layout (`output-artifact-layout.md`) main vs sidecars; validate reopened files (`final-serialization-validation.md`).

## Core state
Keep `frontier/visited/nodes/edges/unresolved/evidence/findings/capabilities/processes/entities/configurations/handoffs/coverage/ledger/report_state`. Never re-analyze a visited canonical key. For CDS, also keep `occurrence_count/unique_paths/branch_context/retrieval_status/source_hash/relation_type/evidence_source/confidence/implementation_link`.

## CDS discovery invariants
- Raw dependency rows are occurrences, not unique objects.
- Canonical identity prefers CDS entity name; SQL name is alias/fallback. Normalize case/escapes, retain originals.
- Structural tokens (SELECT/UNION/UNION ALL) are branch nodes, not repository objects.
- Preserve unique directed edges even when a child source is read once.
- Separate downstream lineage, bounded upstream impact, and contextual candidates.
- Table functions need definition + AMDP analysis; unresolved lowers critical-path coverage.
- DCL status is independent from source-read status.
- Budgets stop tool use, never justify completeness.
- Complete only when no unresolved high-priority node remains and critical-path/table-function gates pass, or limitations are explicit.

## Integrity and scoring
Registry (`coverage-registry.md`) + `scoring-model.md` before scoring; `document-integrity-validation.md` + `artifact-export.md` + `artifact-schema-validation.md` + `finding-confidence-model.md` + `completion-state-policy.md` before delivery. No undocumented denominators; no unvalidated Mermaid/YAML/JSON/coverage/handoff/graph claims. For CDS reports, publish at minimum: raw occurrences, unique nodes/edges, max depth, fully/partially/unresolved nodes, skipped nodes, critical-path coverage, table-function/DCL resolution, duplicated-path reduction, stop reason. Never use raw occurrences as coverage denominator.

## Completion status
Use exactly one: `DEEP_COMPLETE`, `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`, `STATIC_DEEP_PARTIAL`, `STRUCTURAL_ANALYSIS_ONLY`, or `REPORT_VALIDATION_FAILED`. A selected Deep profile does not imply Deep completion.
