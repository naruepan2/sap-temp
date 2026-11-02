# Artifact schema validation

## Knowledge graph
Required node fields: `id`, `type`, `name`, `source_status`, `confidence`, `evidence_ids`.
Required edge fields: `from`, `type`, `to`, `directness`, `source_status`, `confidence`, `evidence_ids`.
Validate unique node IDs, existing endpoints, allowed node/edge types, and evidence references.

## Runtime handoff
Required fields: `rtc_id`, `finding_id`, `objective`, `hypothesis`, `business_impact`, `target`, `required_capability`, `user_controlled_inputs`, `observation_points`, `expected_evidence`, `mutation_boundary`, `safe_stop`, `priority_breakdown`, `status`.

## Coverage JSON
Required: registry items, dimension summaries, weights, raw score, caps, final score, final band, unscorable dimensions, and arithmetic validation result.

## Findings JSON
Required: ID, type, severity, defect-existence confidence, current-impact confidence, potential-impact confidence, evidence, affected capability/process/entity/object, runtime requirement, and owner action.

## Validation behavior
Use a local parser when available. On parse or schema failure, repair once. If still invalid, set `REPORT_VALIDATION_FAILED`; do not publish the artifact as machine-readable.
