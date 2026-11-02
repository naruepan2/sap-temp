# Findings, Confirmation Queue, and Impact

## Finding classes
`CONFIRMED_STATIC_DEFECT`, `PROBABLE_STATIC_DEFECT`, `DESIGN_RISK`, `DATA_INTEGRITY`, `SECURITY_OBSERVATION`, `PERFORMANCE`, `INCOMPLETE_IMPLEMENTATION`, `BUSINESS_RULE_CONFIRMATION`, `DOCUMENTATION_GAP`, `UNVERIFIED_CONCERN`.

Severity: `Critical | High | Medium | Low | Informational`.

## Evidence sufficiency gate
- **Confirmed static defect** needs verified source or metadata, a statically demonstrable control/data consequence, consideration of alternative interpretations, resolved evidence IDs, and no dependency on an unapproved business rule.
- **Probable static defect**: the suspicious condition and likely consequence are verified, but a causal or business link remains unresolved.
- **Design or data-integrity risk**: the risk condition exists, but failure or current impact is not proven. State the trigger and conditional impact.
- **Security observation**: state the inspected scope and the absent or weak control. Do not infer end-to-end authorization without transaction, role, caller, and runtime evidence.

Gate questions: Is the condition verified? Is the expected behavior authoritative? Is current impact proven, probable, or only potential? Could the behavior be intentional? Could another control exist outside scope? Is runtime or functional confirmation required?

When evidence is insufficient use `REVIEW_POINT`, `BUSINESS_CONFIRMATION_REQUIRED`, or `UNVERIFIED_CONCERN`, never "defect".

## Three confidence dimensions
- Defect existence confidence: does the evidence prove the defect or risk condition exists?
- Current impact confidence: is user-visible or production impact proven now?
- Potential impact confidence: what could happen if the path, configuration, or data condition is exercised?

Values: `Confirmed`, `Probable`, `Possible`, `Unverified`, `NotApplicable`.

Rules: a confirmed unreachable branch does not prove current impact; a missing source-level authority check is a security observation until end-to-end controls are assessed; a partial-commit pattern is a data-integrity risk until failure behavior is reproduced or logically proven.

## Finding record
`Finding ID | Type | Severity | Defect existence | Current impact | Potential impact | Runtime confirmation required | Functional confirmation required | Capability | Process | Entity/config | Object/location | Evidence | Why this matters | Human action`

Every material finding carries a business explanation (expected versus actual behavior, user impact, sanitized example) and a technical explanation (object, call path, location, fields or formula, evidence, confidence, human correction target).

## Functional confirmation queue
Consolidates questions for a functional consultant, process owner, security owner, or business user.

`Question ID | Priority | Capability | Process | Topic | Observed behavior | Confirmation question | Why needed | Suggested owner | Blocking stage | Related rule/finding | Status`

Priorities: `Blocking`, `Required before correction`, `Required before testing`, `Required before sign-off`, `Documentation only`. Status: `Open`, `Answered`, `Deferred`, `Out of scope`.

If any `Blocking` question is open, the document cannot be final: `document_status` is `DRAFT_PENDING_FUNCTIONAL_CONFIRMATION`. Static completion may still be reported separately. Every `TBD`, `INFERRED`, and `UNVERIFIED` item that matters must appear here or in limitations.

## Impact radius
Trace a finding, object, field, configuration, or rule across capabilities, processes, entities, objects, interfaces, users, and operations.

Method:
1. Start from the finding, object, field, configuration, or rule.
2. Traverse verified outbound dependencies and inbound consumers.
3. Add capability, process, entity, and configuration links.
4. Separate direct, indirect, dynamic, configuration-driven, and unverified impact.
5. Assess data population, historical data, batch jobs, interfaces, forms, reports, variants, authorizations, and operating procedures.
6. Stop at profile boundaries and mark unresolved frontier nodes.

Matrix: `Impact ID | Finding/change | Capability | Process | Object/component | Entity/table | Integration/job/form | User role | Impact type | Directness | Severity | Evidence | Required validation`.

Impact types: functional behavior, data integrity, interface contract, authorization, performance, scheduling, reporting, audit/compliance, configuration, support/operations, regression.

Never treat text-search hits as confirmed consumers. Label each consumer `LIVE_REFERENCE`, `SOURCE_REFERENCE`, `TEXT_HIT`, `CONFIG_REFERENCE`, or `UNVERIFIED_NAME_MATCH`.
