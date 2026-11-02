# Document integrity validation

## Purpose
Prevent delivery of a report that is analytically useful but internally inconsistent, mathematically incorrect, syntactically invalid, or falsely machine-readable.

## Saved-file authority
The serialized file is the source of truth for validation. In-memory counts or intended formatting cannot justify a pass when the reopened file differs.

## Required validation sequence
1. **Markdown structure**: one H1, ordered H2/H3, closed fences, valid relative links, no escaped-artifact noise.
2. **Stable IDs**: detect duplicates; resolve every Capability, Process, Entity, Configuration, Finding, Risk, Evidence, Test, Graph, and Coverage ID.
3. **Evidence links**: every material finding, technical graph edge, score, impact claim, and runtime handoff must reference defined evidence or carry an explicit uncertainty marker.
4. **Mermaid**: every diagram must be inside a `mermaid` fence, indexed, within size limits, and followed by a text walkthrough. No diagram keyword may remain outside a fence.
5. **YAML/JSON**: parse every block claimed to be machine-readable; validate required fields, IDs, edge endpoints, and allowed enumerations.
6. **Coverage arithmetic**: recompute every dimension, weight, normalized score, confidence cap, and final band from the coverage registry.
7. **Profile consistency**: compare configured profile, actual depth/nodes, stop reason, unresolved frontier, and completion status.
8. **Cross-artifact consistency**: report summaries, finding register, handoff export, coverage export, and knowledge graph must agree.
9. **Audience checks**: functional and technical reader reviews must both pass.

## V7.2 governance checks
Validate that document intent matches report structure; all conditional deliverables have applicability decisions; scope exclusions are recorded; findings pass evidence sufficiency; blocking confirmation questions prevent FINAL status; redaction review passed; and large artifacts are linked rather than falsely embedded as complete exports.

## Validation status
- `REPORT_VALIDATION_PASSED`
- `REPORT_VALIDATION_PASSED_WITH_WARNINGS`
- `REPORT_VALIDATION_FAILED`

Any parse error, arithmetic mismatch, duplicate stable ID, dangling graph edge, unresolved critical cross-reference, or completion-status contradiction causes `REPORT_VALIDATION_FAILED`.

## Repair policy
Make one repair pass, then rerun all checks. Do not silently remove failed content. If validation still fails, deliver the report only as draft, list errors, and do not claim completion.

## Validation summary table
`Check | Items tested | Passed | Warnings | Failed | Repair performed | Final status | Evidence/log`

## Required booleans
`MARKDOWN_STRUCTURE_VALID`, `ALL_REFERENCED_IDS_RESOLVED`, `MERMAID_VALID`, `MACHINE_READABLE_EXPORTS_PARSE`, `COVERAGE_ARITHMETIC_VALID`, `PROFILE_STATUS_CONSISTENT`, `CROSS_ARTIFACT_CONSISTENT`, `FUNCTIONAL_READER_REVIEW_PASS`, `TECHNICAL_READER_REVIEW_PASS`.
