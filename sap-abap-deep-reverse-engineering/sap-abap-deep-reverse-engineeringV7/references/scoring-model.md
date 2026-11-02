# Deterministic scoring model

## Rule
Scores indicate evidence coverage or prioritization only. Never use document length, selected profile, inferred items, or discovered-but-unread objects as verified credit.

## Coverage credits
- `ANALYZED_FULL` or `VERIFIED`: 1.0
- `ANALYZED_PARTIAL` or `PARTIAL`: 0.5
- `DISCOVERED`, `QUEUED`, `UNRESOLVED`, `INACCESSIBLE`, `UNSUPPORTED`: 0.0
- `EXCLUDED_LOW_RELEVANCE`: excluded only with reason and scope approval

Dimension score:
`100 * sum(item credit) / count(in-scope registry items)`

Weighted score:
`sum(dimension score * weight) / sum(weights of scorable dimensions)`

## Reverse-engineering static weights
- Source/component: 25
- Critical path/dependency: 20
- Capability/process: 15
- Entity/data/write path: 15
- Configuration: 10
- Inbound/impact: 5
- Static authorization/security inspection: 5
- Document integrity: 5

Runtime coverage is reported separately and never implied by the static score.

## Confidence caps
- Live source/version unverified: maximum `Medium`
- Any unresolved critical write/mutation path: maximum `Medium`
- More than 25% of critical registry items unresolved/partial: maximum `Low`
- Generated documentation without source: source confidence maximum `Low`
- Integrity validation failed: final status is draft; no confidence band may exceed `Low`

## Bands
- 90-100 Very High
- 75-89 High
- 55-74 Medium
- 30-54 Low
- 0-29 Very Low

## Required calculation display
`Dimension | Full | Partial | Unresolved | Excluded | Denominator | Raw score | Weight | Weighted contribution | Evidence`

Then show `raw weighted score`, `normalization`, `caps applied`, `final score`, and `final band`. Recalculate during final validation.

## V7.2 multi-axis reporting
Report three separate views:
- `Breadth coverage`: proportion of relevant capabilities, processes, objects, entities, configurations, and integrations inspected.
- `Critical-path depth`: completeness of entry-to-output, transformations, writes/LUW, errors, dynamic behavior, and impact for P0/P1 paths.
- `Evidence quality`: quality mix of live source/reference, source export, generated documentation, text hits, inference, and runtime evidence.

Do not collapse `Not Scorable` inbound completeness into zero. Coverage is descriptive, not a target.

## Finding priority
For runtime handoffs score 0-5: business severity, likelihood, static confidence, data/security exposure, test feasibility; subtract execution risk 0-5. Show each component and total. Manual overrides require rationale.
