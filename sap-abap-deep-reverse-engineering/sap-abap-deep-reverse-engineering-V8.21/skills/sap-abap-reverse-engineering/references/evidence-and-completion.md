# Evidence and Completion

## Claim states
- `FACT`: directly observed in source, metadata, or verified repository output.
- `DERIVED`: deterministic conclusion from one or more facts. Show formula or reasoning.
- `INFERRED`: plausible interpretation not explicitly proven. State why and request confirmation.
- `UNVERIFIED`: unavailable, blocked, truncated, runtime-only, or outside scope.

## Evidence record
For each important claim retain:
- evidence ID
- object and source version/fingerprint
- source location or relation
- extraction method/tool
- claim state and confidence
- limitations

## Coverage rules
Use unique canonical objects and edges as denominators. Raw dependency-tree rows are occurrences only. Report fully read, partially read, listed-only, unresolved, and intentionally skipped separately.

## Completion status
- `DEEP_COMPLETE`: static and required runtime evidence complete for frozen scope.
- `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`: critical static paths complete; runtime or external confirmations remain.
- `STATIC_DEEP_PARTIAL`: meaningful deep analysis, but one or more critical static gaps remain.
- `STRUCTURAL_ANALYSIS_ONLY`: inventory/topology without sufficient source reconstruction.
- `REPORT_VALIDATION_FAILED`: generated artifacts failed final integrity checks.
