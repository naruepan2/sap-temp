# Machine-readable Exports (opt-in)

Off by default. Ask once, in the intake, only when the user asks for reusable data or the scope spans several related artifacts. The Markdown outputs remain primary.

## Optional output set
```text
<OBJECT>_Knowledge_Graph.yaml
<OBJECT>_Runtime_Handoffs.yaml
<OBJECT>_Coverage.json
<OBJECT>_Findings.json
<OBJECT>_Validation.json        when any export is produced
```

## Export rules
- Stable IDs identical to the report. Full data in separate files; label report snippets as samples and never call an illustrative snippet a validated export.
- UTF-8. No secrets, credentials, unrestricted personal data, or unnecessary business values.
- Every export includes `schema_version`, `object`, `system_context`, `source_version`, `profile`, `generated_at`, `validation_status`, plus evidence status.
- Relative links from the Markdown report.

## Knowledge graph
Node types: Capability, Process, Actor/Role, Object, Component, Method/Form/Function, Entity, Field, Configuration, Integration, Job, Form, Message, BusinessRule, Finding, Risk, TestCandidate, Evidence, CoverageBoundary.

Edge types: SUPPORTS, CONTAINS, PERFORMS, IMPLEMENTED_BY, CALLS, READS, WRITES, TRANSFORMS, CONFIGURED_BY, EXPOSES, TRIGGERS, PRODUCES, CONSUMES, AFFECTS, EVIDENCED_BY, TESTED_BY, DEPENDS_ON, AUTHORIZED_BY, ENHANCED_BY.

Required node fields: `id`, `type`, `name`, `source_status`, `confidence`, `evidence_ids` (and `description`). Required edge fields: `from`, `type`, `to`, `directness`, `source_status`, `confidence`, `evidence_ids`. An edge without evidence must be `Derived` or `Unverified`. Formats: a Markdown graph index, fenced YAML or JSON for reuse, and focused Mermaid diagrams rather than one full graph.

Validate unique node IDs, existing edge endpoints, allowed node and edge types, evidence references, and orphan nodes.

## Runtime handoff export
Required fields: `rtc_id`, `finding_id`, `objective`, `hypothesis`, `business_impact`, `target`, `required_capability`, `user_controlled_inputs`, `observation_points`, `expected_evidence`, `mutation_boundary`, `safe_stop`, `priority_breakdown`, `status`, `baseline_id`.

## Coverage export
Required: registry items, dimension summaries, (weights, raw score, caps, final score, and band only when the composite score was requested), unscorable dimensions, and the arithmetic validation result.

## Findings export
Required: ID, type, severity, defect-existence confidence, current-impact confidence, potential-impact confidence, evidence, affected capability/process/entity/object, runtime requirement, owner action.

## Validation behavior
Use a local parser when available. On a parse or schema failure, repair once. If still invalid, set `REPORT_VALIDATION_FAILED` and do not publish the artifact as machine-readable.
