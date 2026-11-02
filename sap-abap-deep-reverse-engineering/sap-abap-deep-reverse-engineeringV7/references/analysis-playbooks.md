# Analysis playbooks

## Multi-mode report
Build an option matrix: inputs, dispatch, selection, validation, processing, writes/side effects, output, risks, evidence. Analyze materially different modes separately.

## Transaction and data integrity
Map user action through write, BAPI, update task, commit, rollback, refresh, and error paths. Prioritize delete-commit-modify, BAPI commit followed by custom updates, independent commits, missing locks, number ranges, retries, and partial failure.

## Dynamic/configuration behavior
Resolve or mark dynamic method/function/program/class calls, factories, strategies, BAdIs, enhancements, selection-screen PBO/PAI, customizing-driven ranges and targets.

## Class/function
Identify safe entry points, callers, interfaces, constructor/factory context, update/RFC properties, exceptions, side effects, and existing tests.

## CDS/RAP/OData
Trace CDS projections, behavior, authorization, side effects, actions, service exposure, bindings, persistence, and consumers.

## Performance and maintainability
Review nested loops, repeated selects, large-table copies, submit/runtime-info, dead or duplicated branches, uncleared tables, wrong previous buffers, hardcoding, and clean-core concerns.
