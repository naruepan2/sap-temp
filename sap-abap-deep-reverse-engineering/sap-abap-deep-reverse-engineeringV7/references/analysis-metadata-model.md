# Analysis metadata model

## Purpose
Prevent confusion between the method used to create a document and the type of document delivered.

## Required metadata
```yaml
analysis_method: reverse_engineering
document_intent: functional_specification
document_scope: as_is
audience:
  - functional
  - technical
analysis_profile: deep
analysis_status: STATIC_DEEP_COMPLETE_WITH_LIMITATIONS
document_status: DRAFT_PENDING_FUNCTIONAL_CONFIRMATION
```

## Rules
- `analysis_method` explains how knowledge was obtained.
- `document_intent` controls structure and emphasis.
- `document_scope` distinguishes as-is, target-state, change-specific, or mixed scope.
- `analysis_status` describes evidence coverage.
- `document_status` describes readiness for review/sign-off.

Never use `reverse_engineering_report` as both method and intent when the output is explicitly a functional or technical specification.
