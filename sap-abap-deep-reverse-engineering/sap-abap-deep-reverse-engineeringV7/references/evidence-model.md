# Evidence model

## Source trust
`VERIFIED_LIVE`, `VERIFIED_SOURCE_EXPORT`, `DOCUMENTED_CLAIM`, `DERIVED`, `UNVERIFIED`.

## Node states
`DISCOVERED`, `QUEUED`, `ANALYZED_FULL`, `ANALYZED_PARTIAL`, `BOUNDARY_STANDARD`, `UNSUPPORTED`, `INACCESSIBLE`, `EXCLUDED_LOW_RELEVANCE`.

Count only `ANALYZED_FULL` as fully analyzed. Report partial/boundary/queued separately.

## Edge labels
`INCLUDES`, `CALLS`, `DYNAMIC_CALL`, `INSTANTIATES`, `READS`, `WRITES`, `DELETES`, `MODIFIES`, `COMMITS`, `ROLLS_BACK`, `LOCKS`, `SUBMITS`, `IMPLEMENTS`, `ENHANCED_BY`, `CONFIGURED_BY`, `AUTHORIZED_BY`, `CONSUMES`, `EXPOSES`, `PRINTS`, `SENDS`, `RECEIVES`.

Every material claim and technical edge needs an evidence ID. No result proves only that the performed search found no result.

## Finding classes
`CONFIRMED_STATIC_DEFECT`, `PROBABLE_STATIC_DEFECT`, `DESIGN_RISK`, `DATA_INTEGRITY`, `SECURITY_OBSERVATION`, `PERFORMANCE`, `INCOMPLETE_IMPLEMENTATION`, `BUSINESS_RULE_CONFIRMATION`, `DOCUMENTATION_GAP`, `UNVERIFIED_CONCERN`.

Use severity `Critical|High|Medium|Low|Informational` and confidence `Confirmed|Probable|Possible|Unverified`.
