# Evidence and Completion

## Claim states
- `FACT`: directly observed in source, metadata, configuration evidence, or verified tool output.
- `DERIVED`: deterministic conclusion from one or more facts. Show the formula or source chain.
- `INFERRED`: plausible interpretation not explicitly proven (business purpose, actor, design intent). State why and request confirmation.
- `UNVERIFIED`: unavailable, blocked, truncated, runtime-only, or outside scope.

Observed source behavior is `Observed`, not an approved requirement; an approved business rule needs an authoritative document or owner confirmation. Technical naming alone never proves business meaning.

## Absence rule
No result proves only that the search performed found no result. Record the search scope, method, and limits. Do not state that something "does not exist" or "is not used" unless the search was exhaustive for the claim.

## Source trust
`VERIFIED_LIVE`, `VERIFIED_SOURCE_EXPORT`, `DOCUMENTED_CLAIM`, `DERIVED`, `UNVERIFIED`. Generated documentation without source caps source confidence at Low.

## Evidence record
For each important claim keep: evidence ID, object and source version/fingerprint, source location or relation, extraction method/tool, claim state and confidence, limitations.

## Node states
`DISCOVERED`, `QUEUED`, `ANALYZED_FULL`, `ANALYZED_PARTIAL`, `BOUNDARY_STANDARD`, `UNSUPPORTED`, `INACCESSIBLE`, `EXCLUDED_LOW_RELEVANCE`. Count only `ANALYZED_FULL` as fully analyzed; report partial, boundary, and queued separately.

## Edge labels
`INCLUDES`, `CALLS`, `DYNAMIC_CALL`, `INSTANTIATES`, `READS`, `WRITES`, `DELETES`, `MODIFIES`, `COMMITS`, `ROLLS_BACK`, `LOCKS`, `SUBMITS`, `IMPLEMENTS`, `ENHANCED_BY`, `CONFIGURED_BY`, `AUTHORIZED_BY`, `CONSUMES`, `EXPOSES`, `PRINTS`, `SENDS`, `RECEIVES`. CDS-specific relation classes and evidence levels are in `cds-discovery-strategy.md`.

Every material claim and technical edge needs an evidence ID, or is `DERIVED`/`UNVERIFIED`.

## Coverage
Use unique canonical objects and edges as denominators; raw dependency rows are occurrences only. Rules and registry: `coverage-and-scoring.md`.

## Completion status
- `DEEP_COMPLETE`: static and required runtime evidence complete for the frozen scope; integrity valid; no critical unresolved path.
- `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`: critical static paths complete; runtime or external confirmations remain (runtime, inbound, configuration values, authorization, form/layout, inaccessible metadata).
- `STATIC_DEEP_PARTIAL`: meaningful deep analysis, but one or more critical static gaps remain.
- `STRUCTURAL_ANALYSIS_ONLY`: inventory and topology without sufficient source reconstruction.
- `REPORT_VALIDATION_FAILED`: generated artifacts failed final integrity checks after repair.

### Decision order
1. Integrity validation failed after repair -> `REPORT_VALIDATION_FAILED`.
2. Critical static paths unresolved -> `STATIC_DEEP_PARTIAL`.
3. Critical static paths complete but bounded runtime or external gaps remain -> `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`.
4. `DEEP_COMPLETE` only when all declared in-scope critical categories meet completion thresholds.
5. Only inventory or topology reconstructed -> `STRUCTURAL_ANALYSIS_ONLY`.

### Stop reason
State what was completed, why stopping is justified, actual depth and nodes, and every excluded or unresolved category. Depth, node, and token budgets may force `STATIC_DEEP_PARTIAL`; never present them as completion. A selected Deep profile does not imply `DEEP_COMPLETE`.
