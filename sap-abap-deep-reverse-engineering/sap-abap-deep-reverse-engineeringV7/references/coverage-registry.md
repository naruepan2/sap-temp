# Coverage registry

## Purpose
Create a canonical denominator before calculating coverage. Percentages without a documented registry are prohibited.

## Registry schema
`Coverage ID | Dimension | Item type | Item name | Critical? | In scope? | State | Credit | Evidence IDs | Exclusion reason | Next action`

## Dimensions
`SOURCE`, `DEPENDENCY`, `CAPABILITY`, `ENTITY`, `CONFIGURATION`, `INBOUND`, `AUTHORIZATION`, `DOCUMENT_INTEGRITY`.

## Procedure
1. Seed the registry from the root inventory and preliminary assessment.
2. Add newly discovered relevant items without deleting difficult items.
3. Mark criticality using business impact, write/side-effect role, security, integration, or control-flow importance.
4. Apply only states and credits from `scoring-model.md`.
5. Freeze the registry before final scoring and record its version/hash or timestamp.
6. List excluded items with reason. Exclusion cannot be used merely because an item is inaccessible.

## Inbound nuance
Separate `known inbound paths verified` from `repository-wide inbound search completeness`. If live where-used is unavailable, repository-wide completeness is `Not Scorable`.

## Authorization nuance
Separate application-source inspection, transaction/role design verification, and runtime authorization validation. Do not collapse these into one misleading 0%.
