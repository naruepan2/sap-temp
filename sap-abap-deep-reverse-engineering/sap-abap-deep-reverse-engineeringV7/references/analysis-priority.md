# Analysis priority allocation

## Priority classes
- `P0`: critical path
- `P1`: business-important
- `P2`: supporting
- `P3`: low-value boundary

## P0 examples
Writes/commits, financial/material postings, locks/number ranges, authorization-sensitive actions, dynamic dispatch, interface contracts, critical configuration, rollback/error behavior.

## P1 examples
Validation, status transitions, user-editable data, operational output, important exception handling.

## P2/P3 examples
Formatting, noncritical reporting, generic wrappers, standard framework internals, low-use helpers.

Allocate profile budget to P0/P1 before P2/P3. Coverage is descriptive, not an optimization target; never traverse low-value objects merely to raise a percentage.
