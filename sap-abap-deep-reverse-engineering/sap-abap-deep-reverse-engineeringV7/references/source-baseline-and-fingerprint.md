# Source baseline and fingerprint

## Purpose
Bind the analysis to a specific SAP source context so a runtime tester or future re-analysis can detect drift.

## Baseline fields
`Connection | System | Client | Root object | Object type | Active/inactive version | Package | Last changed metadata | Transport/request when available | Analysis timestamp | Source fingerprint | Fingerprint method | Tool/source`

## Fingerprint
Prefer a deterministic hash of normalized source and relevant includes/components when tools permit. If hashing is unavailable, record a composite fingerprint from object version, change metadata, include inventory, and analysis timestamp, marked `PARTIAL`.

## Compatibility
- `BASELINE_VERIFIED_FOR_TARGET_SYSTEM`
- `BASELINE_PARTIAL`
- `BASELINE_NOT_VERIFIED_FOR_TARGET_SYSTEM`
- `BASELINE_DRIFT_DETECTED`

Do not expose credentials or sensitive source contents in the fingerprint record. Runtime handoffs must reference the baseline ID.
