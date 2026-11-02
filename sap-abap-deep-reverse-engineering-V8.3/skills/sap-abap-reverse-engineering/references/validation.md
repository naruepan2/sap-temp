# Validation and Checkpoint

## Authority of the saved file
Validation operates on the exact files reopened from disk after the final write, never on the in-memory model. An in-memory count or intended format cannot justify a pass when the reopened file differs. Validate only the outputs selected by the output mode.

## Sequence
1. Save all intended outputs; reopen each exact file.
2. **Markdown structure**: UTF-8; one H1; ordered headings; closed fences; valid tables; valid relative links; no escaped-artifact noise; selected-template section order preserved.
3. **Template identity**: selected template, match method, version, fingerprint, and fallback reason recorded.
4. **Stable IDs**: no duplicates; every Capability, Process, Entity, Configuration, Finding, Risk, Evidence, Test, Graph, and Coverage ID resolves.
5. **Evidence links**: every material finding, technical edge, coverage figure, impact claim, and runtime handoff references defined evidence or carries an explicit uncertainty marker.
6. **Mermaid**: every diagram is inside a `mermaid` fence, within size limits, followed by a walkthrough; no diagram keyword outside a fence.
7. **Machine-readable blocks**: parse every YAML/JSON block claimed as machine-readable; schema checks in `machine-readable-exports.md`.
8. **Coverage arithmetic**: recompute every dimension from the coverage registry; denominators come from unique canonical registries, never raw occurrences.
9. **Field reconciliation**: field rows reconcile across overview, detailed logic, input/filter, and output tables; data types and semantics agree.
10. **Business-owned metadata**: no invented approvals, owners, workstream, priority, frequency, volume, mandatory flags, catalog IDs, configuration values, or expected results.
11. **Confirmation queue**: all `TBD`, `INFERRED` (that matter), and `UNVERIFIED` items appear in the queue or limitations; a blocking item keeps `document_status` out of final.
12. **Redaction review**: scan tables, fences, diagrams, logs, and examples; record `DATA_REDACTION_REVIEW_PASSED` or fail.
13. **Cross-output consistency**: the Chat Summary, Functional Specification, finding register, handoffs, and coverage agree on findings, coverage, and status (for `BOTH`, they use the same state).
14. **Profile and status consistency**: configured profile, actual depth and nodes, stop reason, unresolved frontier, and completion status agree.
15. **Claimed artifacts exist**: every file or count named in the report is actually present.
16. **Reader reviews**: functional-reader and technical-reader passes both succeed.

## Failure and repair
Any parse error, arithmetic mismatch, duplicate stable ID, dangling reference, unresolved critical cross-reference, missing claimed artifact, unfenced Mermaid, or status contradiction fails validation. Make one repair pass, rerun all checks, and never silently delete failed content. If it still fails, deliver the draft only, list the errors, set `REPORT_VALIDATION_FAILED`, and do not claim completion.

Validation status: `REPORT_VALIDATION_PASSED`, `REPORT_VALIDATION_PASSED_WITH_WARNINGS`, `REPORT_VALIDATION_FAILED`.

## Validation record
`File | Size | Hash | Checks performed | Passed | Warnings | Failed | Repair | Final status`

## Completion checklist (all must hold before claiming completion)
- output mode, profile, and template (when applicable) recorded
- root, source/version, and baseline verified and fingerprint recorded
- critical write, dynamic, security, and integration paths addressed
- node states and actual depth/node consumption reported
- business rules classified; findings carry severity, confidence, evidence, impact, and human action
- runtime handoffs exist where confirmation is needed
- coverage by dimension recomputed from the registry
- redaction review passed
- final files reopened and validated; final status selected; critical unresolved paths listed

## Checkpoint (analysis state persistence)
Late conversion, session continuity, and long analyses need state that survives beyond the chat context.

- When the output folder is known and the profile is Deep or Extended, or the mode is `BOTH`, or the user may request a later conversion, write `<OBJECT>_Analysis_State.md` at the end of Phase 2 and again at Phase 5.
- Contents (compact, no source dumps, no sensitive values): scope and exclusions, baseline and fingerprints, output selection, template selection, node and edge registry summary with canonical keys and states, evidence IDs with claim states, findings, confirmation queue, coverage registry summary, runtime handoff IDs, unresolved frontier, completion status.
- When the output folder is unknown (for example Chat-only), keep state in the conversation and tell the user that a later Functional Specification conversion will re-verify fingerprints and reread only what is needed.
- On resume, compare stored fingerprints with current sources before reusing any state; on drift, mark affected nodes stale and reread them in a bounded way.
