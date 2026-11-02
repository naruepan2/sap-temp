# Architecture pattern detection

## Goal
Describe structural patterns and their operational consequences without forcing every design into a named pattern.

## Patterns
MVC, layered/service, factory, strategy, facade, adapter, repository/DAO, builder, singleton/shared buffer, callback/event handler, BAdI/enhancement, RAP managed/unmanaged, OData provider, report-submit wrapper, batch/input-file pipeline.

## Detection requirements
A pattern is `Confirmed` only when required roles and relationships are observed. Otherwise use `Candidate` or `Partial`.

## Record
`Pattern ID | Pattern | Status | Roles/components | Evidence | Intended benefit | Actual implementation | Deviation | Risk | Recommendation`

## Examples of review questions
- Are controller, model, and view responsibilities separated?
- Is strategy selection dynamic/configuration-driven?
- Does a repository centralize persistence or do writes bypass it?
- Does shared mutable buffering require locking?
- Are enhancement implementations and filters active and resolvable?

Pattern names are explanatory aids, not quality scores. Do not call a design defective merely because it differs from textbook form.
