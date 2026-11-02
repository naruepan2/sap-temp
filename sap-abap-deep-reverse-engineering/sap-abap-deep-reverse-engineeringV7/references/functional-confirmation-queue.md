# Functional confirmation queue

## Purpose
Consolidate questions that need a functional consultant, process owner, security owner, or business user decision.

## Schema
`Question ID | Priority | Capability | Process | Topic | Observed behavior | Confirmation question | Why needed | Suggested owner | Blocking stage | Related rule/finding | Status`

## Priorities
`Blocking`, `Required before correction`, `Required before testing`, `Required before sign-off`, `Documentation only`.

## Status
`Open`, `Answered`, `Deferred`, `Out of scope`.

If any blocking question remains open, a functional specification cannot be `FINAL`; set `DRAFT_PENDING_FUNCTIONAL_CONFIRMATION`. Technical static completion may still be reported separately.
