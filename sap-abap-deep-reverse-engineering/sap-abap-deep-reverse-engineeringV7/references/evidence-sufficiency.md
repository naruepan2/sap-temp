# Evidence sufficiency gate

## Confirmed static defect
Requires verified source/metadata, a statically demonstrable control/data consequence, consideration of alternative interpretation, resolved evidence IDs, and no dependency on an unapproved business rule.

## Probable static defect
The suspicious condition and likely consequence are verified, but one or more causal or business links remain unresolved.

## Design/data-integrity risk
The risk condition exists, but failure or current impact is not proven. State trigger and conditional impact.

## Security observation
State the inspected scope and the absent/weak control. Do not infer end-to-end authorization without transaction, role, caller, and runtime evidence.

## Gate questions
- Is the condition verified?
- Is expected behavior authoritative?
- Is current impact proven, probable, or only potential?
- Could behavior be intentional?
- Could another control exist outside scope?
- Is runtime or functional confirmation required?

When evidence is insufficient, use `REVIEW_POINT`, `BUSINESS_CONFIRMATION_REQUIRED`, or `UNVERIFIED_CONCERN` instead of defect.
