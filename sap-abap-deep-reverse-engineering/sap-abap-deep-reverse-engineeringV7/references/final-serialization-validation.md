# Final serialization validation

## Non-negotiable rule
Validation operates on the exact files reopened from disk after final write, not on the in-memory report model.

## Sequence
1. Save all intended outputs.
2. Reopen each exact file.
3. Validate UTF-8, headings, fences, tables, relative links, and escaped artifacts.
4. Extract and count Mermaid fences; detect Mermaid keywords outside fences.
5. Parse every YAML/JSON artifact claimed as machine-readable.
6. Validate stable IDs, graph endpoints, evidence references, and artifact links.
7. Recompute coverage and priority scores from serialized values.
8. Compare summary findings with the canonical finding register.
9. Compare claimed artifact counts with files actually present.
10. Assign validation and completion status only after these checks.

## Failure rules
Any arithmetic mismatch, invalid machine-readable file, dangling critical reference, missing claimed artifact, unfenced Mermaid, or completion contradiction causes `REPORT_VALIDATION_FAILED` after one repair pass.

## Required validation record
`File | Size | Hash | Checks performed | Passed | Warnings | Failed | Repair | Final status`
