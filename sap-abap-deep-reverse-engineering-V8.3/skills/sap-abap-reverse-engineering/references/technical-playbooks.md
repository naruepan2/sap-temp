# Technical Playbooks

Use the section that matches the object type. A pattern or finding is `Confirmed` only when the required roles and relationships are observed; otherwise label it `Candidate` or `Partial`.

## 1. Multi-mode report
Build an option matrix: inputs, dispatch, selection, validation, processing, writes/side effects, output, risks, evidence. Analyze materially different modes separately.

## 2. Transaction and data integrity (LUW)
Map user action through write, BAPI, update task, commit, rollback, refresh, and error paths. Prioritize delete-commit-modify sequences, BAPI commit followed by custom updates, independent commits, missing locks, number ranges, retries, and partial failure. Produce a LUW view when writes, commits, rollback, update task, locks, or postings exist.

## 3. Dynamic and configuration-driven behavior
Resolve or mark dynamic method/function/program/class calls, factories, strategies, BAdIs, enhancements, selection-screen PBO/PAI, customizing-driven ranges and targets. An unresolved dynamic target on a critical path is `UNVERIFIED` and lowers critical-path coverage.

## 4. Class and function module
Identify safe entry points, callers, interfaces, constructor/factory context, update or RFC properties, exceptions, side effects, and existing unit tests.

## 5. CDS, RAP, and OData
CDS roots: follow `cds-discovery-strategy.md`. For a RAP business object, add the behavior layer; each item needs source evidence.

- Behavior definition: implementation type (managed, unmanaged, abstract, projection, interface), `with draft`, strict mode, entities and compositions, aliases, persistent tables.
- Locking, authorization, and ETag: `lock master/dependent`, `authorization master/dependent` (global or instance), `etag master/dependent`.
- Field characteristics: readonly, mandatory, numbering (managed, early, late), readonly after create.
- Standard and custom operations: create/update/delete, create-by-association, actions (instance, static, factory, with result, precheck), functions.
- Determinations (on modify, on save) and validations (on save): read each implementation method; record trigger, affected fields, messages (`reported`/`failed`, message class), and side effects.
- Side effects and feature control: `side effects { ... }`, instance and global feature control.
- Draft handling: draft actions (edit, activate, discard, resume), prepare determination.
- Behavior pool: handler and saver classes, `save_modified`/`save`, `adjust_numbers`, `cleanup`, EML (`READ ENTITIES`, `MODIFY ENTITIES`) usage, commits or direct DML that bypass the RAP transactional contract.
- Projection layer: projection behavior `use` statements, exposed actions, projection field aliases.
- Exposure: service definition (`expose`), service binding type (OData V2/V4, UI or Web API), metadata extensions and UI annotations, published status.
- Authorization: DCL for reads, instance and global authorization methods, authority checks. Role and PFCG design is outside repository evidence unless a tool provides it; mark `UNVERIFIED`.

Trace CDS projections, behavior, authorization, side effects, actions, service exposure, bindings, persistence, and consumers. A BDEF whose behavior pool cannot be read leaves its determinations and validations `UNVERIFIED`.

## 6. Classic report, selection screen, and ALV
Entry point and transaction, selection-screen parameters and select-options with defaults and value helps, events and flow (initialization, at selection-screen, start-of-selection), validation and messages, data selection (nested loops, repeated selects, buffers), ALV (classic or SALV/OO) field catalog, layout, sort/group/subtotal, user commands and handlers, output or print forms, background and variant behavior, `SUBMIT` wrappers. Record each selection-screen field for the Functional Specification input and filter sections.

## 7. Enhancements and extension points
Classic BAdIs, new BAdIs, enhancement spots and sections, implicit enhancements, user exits, customer exits, and form exits. For each: definition, filters, active implementations, implementing class or include, and effect on the flow. Unresolvable or inactive implementations are recorded as such, not assumed active.

## 8. Authorization
Separate: authority checks in source (object, fields, activity, failure behavior), DCL and RAP authorization, service or transaction exposure, and runtime effectiveness. Presence of a check or DCL does not prove effective authorization for a real user.

## 9. Performance and maintainability
Review nested loops, repeated selects, large-table copies, `SUBMIT`/runtime-info usage, `SELECT *`, missing `FOR ALL ENTRIES` guards, dead or duplicated branches, uncleared tables, wrong previous buffers, hardcoding, fan-out and duplicate-row risks in CDS joins, and clean-core concerns. Report performance as a risk with trigger conditions, not as a measured result.

## 10. Clean Core assessment
For custom objects on critical paths, record:
- dependencies by kind: released API or released CDS, classic API, unreleased or internal SAP object, direct access to SAP-standard tables, modification;
- API release state and release contract only when the toolchain returns it; otherwise `UNVERIFIED`. Naming prefixes are hints, never proof;
- extensibility style in use (on-stack developer extensibility, key-user, classic, side-by-side) when evidenced;
- upgrade-stability observations, each with an evidence state;
- a recommendation labeled `INFERRED` unless a released successor is verified.

Do not assign a clean-core level from naming or package alone.

## 11. Architecture pattern detection
Candidates: MVC, layered/service, factory, strategy, facade, adapter, repository/DAO, builder, singleton/shared buffer, callback/event handler, BAdI/enhancement, RAP managed/unmanaged, OData provider, report-submit wrapper, batch/input-file pipeline.

Record: `Pattern ID | Pattern | Status (Confirmed/Candidate/Partial) | Roles/components | Evidence | Intended benefit | Actual implementation | Deviation | Risk | Recommendation`.

Review questions: Are controller, model, and view responsibilities separated? Is strategy selection dynamic or configuration-driven? Does a repository centralize persistence, or do writes bypass it? Does shared mutable buffering require locking? Are enhancement implementations and filters active and resolvable? Pattern names are explanatory aids, not quality scores; do not call a design defective merely because it differs from the textbook form.
