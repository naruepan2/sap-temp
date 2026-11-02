# Runtime handoff package

## Purpose
Convert static findings and unresolved hypotheses into safe, reusable test packages. A handoff is a test design, not proof that runtime tools exist.

## Eligibility
Create a candidate when runtime evidence is needed to confirm user impact, first divergence, dynamic target, configuration behavior, concurrency, authorization, or transaction failure.

## Priority model
Score 0-5 for business severity, occurrence likelihood, static confidence, data-integrity/security exposure, and test feasibility. Subtract 0-5 for execution risk. Total 0-20:
- 16-20 P1
- 11-15 P2
- 6-10 P3
- 0-5 P4
Manual override requires a reason.

## Handoff schema
`RTC ID | Finding ID | Objective | Hypothesis | Business impact | Target/entry | Required capability | User-controlled inputs | Preconditions | Breakpoints/observations | Expected evidence | Alternative evidence | Mutation boundary | Safe stop | Cleanup | Priority | Confidence | Status`

## Status
`READY_FOR_TOOL`, `READY_FOR_HUMAN`, `BLOCKED_CAPABILITY`, `BLOCKED_INPUT`, `BLOCKED_SIDE_EFFECT`, `NOT_REQUIRED`.

## YAML export
Provide a machine-readable fenced YAML block per candidate using the same fields. Never include credentials or sensitive values. If execute/debug capability is unavailable, set `BLOCKED_CAPABILITY` and provide human steps.
