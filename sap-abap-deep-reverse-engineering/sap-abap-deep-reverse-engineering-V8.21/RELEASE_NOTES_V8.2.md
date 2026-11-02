# Release Notes V8.2 - Output Mode Selection

## Added
- `CHAT_SUMMARY`, `FUNCTIONAL_SPEC`, and `BOTH` output modes
- Output Mode Selection Gate
- Shared analysis-state reuse across output formats
- Late conversion from Chat Summary to Functional Specification
- `references/output-mode-selection.md`

## Changed
- Project-template selection is conditional and skipped for Chat-only analysis.
- Analysis profile and output mode are independent.
- Functional Specification generation runs only when selected.

## Preserved
- Strict read-only safety and mandatory preflight
- Scope freeze and bounded assessment
- Graph-first CDS discovery and canonical deduplication
- Table-function-to-AMDP resolution
- Evidence classification and field lineage
- Runtime-testing handoff, coverage, validation, and completion statuses
