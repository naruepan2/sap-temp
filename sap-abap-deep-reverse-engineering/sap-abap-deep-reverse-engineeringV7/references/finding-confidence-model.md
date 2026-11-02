# Finding confidence and impact model

## Separate confidence dimensions
- `Defect existence confidence`: does the source/evidence prove the defect or risk condition exists?
- `Current impact confidence`: is user-visible or production impact proven now?
- `Potential impact confidence`: what impact could occur if the path/configuration/data condition is exercised?

Values: `Confirmed`, `Probable`, `Possible`, `Unverified`, `NotApplicable`.

## Required fields
`Finding ID | Type | Severity | Defect existence | Current impact | Potential impact | Runtime confirmation required | Functional confirmation required | Capability | Process | Entity/config | Object/location | Evidence | Why this matters | Human action`

## Rules
- A confirmed unreachable branch does not automatically prove current business impact.
- A missing source-level authority check is a security observation until end-to-end controls are assessed.
- A partial-commit pattern is a data-integrity risk until failure behavior is reproduced or logically proven.
- Source behavior is `Observed`, not an approved business requirement.
