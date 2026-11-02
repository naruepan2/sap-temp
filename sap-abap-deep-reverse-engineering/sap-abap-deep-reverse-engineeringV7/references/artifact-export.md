# Artifact export

## Optional output set
- `<OBJECT>_functional_spec.md`
- `<OBJECT>_knowledge_graph.yaml`
- `<OBJECT>_runtime_handoffs.yaml`
- `<OBJECT>_coverage.json`
- `<OBJECT>_findings.json`
- `<OBJECT>_validation.json`

Ask once whether machine-readable exports are required. The Markdown report remains mandatory unless the user requests otherwise.

## Export rules
- Use stable IDs identical to the report.
- Export full data in separate files; label report snippets as samples.
- UTF-8, no secrets, credentials, unrestricted personal data, or unnecessary business values.
- Include schema version, generated timestamp, source context, profile, evidence status, and validation status.
- Use relative links from the Markdown report.
- Never call an illustrative snippet a validated export.

## Minimum manifests
Every export contains `schema_version`, `object`, `system_context`, `source_version`, `profile`, `generated_at`, and `validation_status`.
