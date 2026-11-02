# Coverage and confidence model

## Principle
Scores communicate evidence coverage, not correctness. Never award points for assumptions, document length, selected profile, or discovered-but-unread objects.

## Dimensions and weights
- Source/component coverage: 25%
- Critical-path/dependency coverage: 20%
- Business process/capability coverage: 15%
- Data/entity/write-path coverage: 15%
- Configuration coverage: 10%
- Inbound usage/impact coverage: 5%
- Authorization/security coverage: 5%
- Runtime coverage: 5% (normally 0 for reverse engineering)

## Dimension scoring
For each dimension calculate `verified relevant items / total relevant items * 100`. Use explicit numerator, denominator, exclusions, and unknown count. If the denominator cannot be estimated, report `Not Scorable`, not 0 or 100.

## Overall score
Compute a weighted average using only scorable dimensions, then apply confidence caps:
- Any unresolved critical write path: overall confidence at most `Medium`.
- Live source/version unverified: at most `Medium`.
- More than 25% of critical nodes partial/unresolved: at most `Low`.
- Generated documentation only: at most `Low` for source correctness.

## Bands
- 90-100: Very High
- 75-89: High
- 55-74: Medium
- 30-54: Low
- 0-29: Very Low

## Dashboard template
`Dimension | Verified | Total | Unknown | Score | Evidence basis | Limitation | Improvement action`

Always report runtime coverage separately. A static report with runtime 0% can still have high static coverage but cannot claim runtime-confirmed defects or root causes.
