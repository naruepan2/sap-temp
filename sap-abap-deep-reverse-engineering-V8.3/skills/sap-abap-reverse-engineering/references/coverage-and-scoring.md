# Coverage and Scoring

## Principle
Coverage communicates evidence coverage, not correctness. Never award credit for assumptions, document length, selected profile, or discovered-but-unread objects. Coverage is descriptive, not a target. Percentages without a documented registry are prohibited.

## Coverage registry
Create the canonical denominator before computing any percentage.

`Coverage ID | Dimension | Item type | Item name | Critical? | In scope? | State | Credit | Evidence IDs | Exclusion reason | Next action`

Dimensions: `SOURCE`, `DEPENDENCY`, `CAPABILITY`, `ENTITY`, `CONFIGURATION`, `INBOUND`, `AUTHORIZATION`, `DOCUMENT_INTEGRITY`. For CDS add `TABLE_FUNCTION`, `DCL`, `UNION_BRANCH`, `FIELD_LINEAGE` (see `cds-discovery-strategy.md`).

Procedure:
1. Seed from the root inventory and the bounded assessment.
2. Add newly discovered relevant items; never delete difficult items.
3. Mark criticality by business impact, write or side-effect role, security, integration, or control-flow importance.
4. Apply only the credits below.
5. Freeze the registry before final reporting and record its version or timestamp.
6. List excluded items with reasons. Inaccessibility alone is not a valid exclusion.

## Credits
- `ANALYZED_FULL` or `VERIFIED`: 1.0
- `ANALYZED_PARTIAL` or `PARTIAL`: 0.5
- `DISCOVERED`, `QUEUED`, `UNRESOLVED`, `INACCESSIBLE`, `UNSUPPORTED`: 0.0
- `EXCLUDED_LOW_RELEVANCE`: excluded from the denominator only with a reason and scope approval

Dimension coverage = `100 * sum(credit) / count(in-scope registry items)`. Report numerator, denominator, exclusions, and unknown count. If the denominator cannot be estimated, report `Not Scorable`, never 0 or 100.

## Default reporting: by dimension, no composite
Report these separately; do not compress them into one score unless the user asks for the composite below:
unique object/source coverage; unique edge coverage; critical-path coverage; critical field-lineage coverage; configuration coverage; authorization coverage; table-function/AMDP coverage; DCL coverage; UNION-branch coverage; runtime-verification coverage; unresolved high-priority items.

Dashboard: `Dimension | Verified | Total | Unknown | Score | Evidence basis | Limitation | Improvement action`.

Three views to keep apart:
- Breadth coverage: proportion of relevant capabilities, processes, objects, entities, configurations, and integrations inspected.
- Critical-path depth: completeness of entry-to-output, transformations, writes/LUW, errors, dynamic behavior, and impact for P0/P1 paths.
- Evidence quality: mix of live source/reference, source export, generated documentation, text hits, inference, and runtime evidence.

Report runtime coverage separately. A static analysis with runtime 0% can have high static coverage but cannot claim runtime-confirmed defects or root causes.

### Nuances
- Inbound: separate "known inbound paths verified" from "repository-wide inbound search completeness". If live where-used is unavailable, repository-wide completeness is `Not Scorable`.
- Authorization: separate application-source inspection, transaction/role design verification, and runtime authorization validation. Do not collapse them into one misleading 0%.

## Optional composite score (only on request)
Weights (static only; runtime is never included): Source/component 25, Critical path/dependency 20, Capability/process 15, Entity/data/write path 15, Configuration 10, Inbound/impact 5, Static authorization/security inspection 5, Document integrity 5 (sum 100).

Weighted score = `sum(dimension score * weight) / sum(weights of scorable dimensions)`.

Confidence caps:
- Live source/version unverified: at most `Medium`.
- Any unresolved critical write/mutation path: at most `Medium`.
- More than 25% of critical registry items partial or unresolved: at most `Low`.
- Generated documentation without source: source confidence at most `Low`.
- Integrity validation failed: draft only; no band above `Low`.

Bands: 90-100 Very High; 75-89 High; 55-74 Medium; 30-54 Low; 0-29 Very Low.

Show the calculation: `Dimension | Full | Partial | Unresolved | Excluded | Denominator | Raw score | Weight | Weighted contribution | Evidence`, then raw weighted score, normalization, caps applied, final score, final band. Recompute during validation. Never use raw dependency occurrences as a denominator.
