# Output artifact layout

## Purpose
Keep the main document readable while preserving auditable technical detail.

## Recommended outputs by intent
For a functional specification:
```text
<OBJECT>_Functional_Spec.md
<OBJECT>_Technical_Appendix.md          optional
<OBJECT>_Coverage.json                  optional
<OBJECT>_Findings.json                  optional
<OBJECT>_Knowledge_Graph.yaml           optional
<OBJECT>_Runtime_Handoffs.yaml          optional
<OBJECT>_Validation.json                when sidecars are produced
```

## Rules
- The main report contains business context, capabilities, processes, rules, exceptions, key findings, confirmation queue, coverage summary, and limitations.
- Large inventories, evidence ledgers, full field mappings, graph exports, and handoff packages move to appendices/sidecars.
- Create optional sidecars only when requested or materially useful.
- Use relative links and stable IDs across files.
- Do not label an embedded sample as the full export.
