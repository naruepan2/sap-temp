# Reverse-engineering Word-ready report template

## Metadata separation
Record analysis method, document intent, document scope, audience, source baseline ID, analysis status, and document status as distinct fields.

## Document control
Title, object, system/client, source version, authoring method, date, revision history, classification, and intended audiences.

## Part A: Business and functional view
1. One-page executive summary
2. Business context, actors, scope, assumptions, exclusions
3. Capability catalog
4. Process catalog and business flow diagrams
5. Inputs, outputs, messages, statuses, and exceptions
6. Business rules classified Approved/Observed/Inferred/Unverified
7. Entity catalog and lifecycle
8. Configuration catalog
9. Findings, business impact, open questions, owners

## Part B: Technical view
10. Source/profile/coverage context
11. Object inventory and architecture patterns
12. Entry points and technical flows
13. Data lineage, field mappings, persistence, LUW, locking
14. Authorization/security
15. Dynamic behavior, enhancements, integrations, jobs/forms/files
16. Dependency/where-used and impact radius
17. Findings with evidence, severity, confidence, and action
18. Performance/maintainability
19. Runtime handoff packages
20. Coverage/confidence dashboard and unresolved frontier
21. Knowledge-graph index/export
22. Glossary, evidence ledger, analyzed-object appendix

## Required matrices
- Capability-to-process-to-object
- Process-to-entity/configuration/output
- Finding-to-impact-radius
- Business rule-to-implementation-to-evidence-to-test
- Coverage dashboard

Use one H1, numbered headings, portable tables, validated fenced Mermaid, short paragraphs, and sanitized examples. Every diagram needs a text walkthrough.


## V7.2 planning and governance
Record document intent, approved analysis plan, frozen scope, exclusions, deliverable applicability, functional confirmation queue, breadth/depth/evidence-quality dashboard, redaction status, and report-size decisions.

Use the intent-specific emphasis. If blocking functional questions remain, set document status `DRAFT_PENDING_FUNCTIONAL_CONFIRMATION` even when static analysis is complete.

## V7.1 integrity appendix
Include the frozen coverage registry summary, raw calculation breakdown, confidence caps, document-validation summary, machine-readable artifact links/status, and completion-state rationale.
