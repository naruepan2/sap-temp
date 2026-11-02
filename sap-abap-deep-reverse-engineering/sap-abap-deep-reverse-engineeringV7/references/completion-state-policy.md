# V7.1 completion-state policy

## States
- `DEEP_COMPLETE`: all in-scope critical static categories complete, integrity valid, no critical unresolved path.
- `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`: root application and critical reachable static paths complete; explicitly bounded gaps remain in runtime, inbound, configuration values, authorization, form/layout, or inaccessible metadata.
- `STATIC_DEEP_PARTIAL`: one or more in-scope critical static paths remain unresolved.
- `STRUCTURAL_ANALYSIS_ONLY`: inventory/architecture only; functional/data/impact depth insufficient.
- `REPORT_VALIDATION_FAILED`: document or artifact integrity failed after repair.

## Decision order
1. If integrity validation fails -> `REPORT_VALIDATION_FAILED`.
2. If critical static paths unresolved -> `STATIC_DEEP_PARTIAL`.
3. If critical static paths complete but bounded external/runtime gaps remain -> `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`.
4. Use `DEEP_COMPLETE` only when all declared in-scope critical categories satisfy completion thresholds.

## Stop reason
State what was completed, why stopping is justified, actual depth/nodes, and each excluded/unresolved category. Never claim all paths covered when low-scoring critical categories remain.
