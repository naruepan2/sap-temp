# Runtime Handoff

## Purpose
Convert static findings and unresolved hypotheses into safe, reusable test packages. A handoff is a test design, not proof that runtime tools exist. This workflow never executes business processing; runtime execution belongs to a separate runtime-testing workflow unless the user explicitly invokes a permitted runtime toolchain.

## Eligibility
Create a candidate when runtime evidence is needed to confirm user impact, first divergence, dynamic target, configuration behavior, concurrency, authorization, transaction failure, actual output values, performance, currency conversion, paging and filtering, dumps, or background-job behavior.

## Priority model
Score 0-5 for each of: business severity, occurrence likelihood, static confidence, data-integrity or security exposure, test feasibility. Subtract 0-5 for execution risk. Total 0-20:
- 16-20 P1
- 11-15 P2
- 6-10 P3
- 0-5 P4

Show each component and the total. A manual override requires a reason.

## Handoff schema
`RTC ID | Finding ID | Objective | Hypothesis | Business impact | Target/entry | Required capability | User-controlled inputs | Preconditions | Breakpoints/observations | Expected evidence | Alternative evidence | Mutation boundary | Safe stop | Cleanup | Priority | Confidence | Status | Baseline ID`

Status: `READY_FOR_TOOL`, `READY_FOR_HUMAN`, `BLOCKED_CAPABILITY`, `BLOCKED_INPUT`, `BLOCKED_SIDE_EFFECT`, `NOT_REQUIRED`.

If execute or debug capability is unavailable, set `BLOCKED_CAPABILITY` and provide human steps. Never include credentials or sensitive values.

## Classes of test scenario
`Static-derived`, `Business-confirmation`, `Runtime-required`. Never claim a test passed or give an expected production result unless it is deterministically proven or runtime evidence was collected.

## ABAP FS / SAP UI testing handoff
When SAP UI testing is intended, include: objective type, latest baseline and source fingerprint, transaction or program, expected selection-screen fields, user-chosen variant placeholder, effective-input confirmation requirement, initial F8 side-effect class, blocked custom commands, expected result class, ALV acceptance criteria, database proof needs, and a suggested test case ID.

Route preference: `SAP_UI_TESTING`, `BACKEND_DEBUG_ASSISTED`, `MANUAL_GUI`, or `STATIC_ONLY`. Do not assume SAP UI testing tools are generic MCP tools.

## YAML form
Provide one fenced YAML block per candidate using the same fields when machine-readable handoffs are requested (`machine-readable-exports.md`).
