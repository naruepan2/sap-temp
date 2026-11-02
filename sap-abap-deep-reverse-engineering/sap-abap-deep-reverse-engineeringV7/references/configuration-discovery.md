# Configuration discovery

## Goal
Identify values outside source code that change behavior, and show their business purpose, resolution path, consumers, defaults, and risk.

## Mechanisms to inspect
Custom configuration classes/tables, TVARVC, SET/GET parameters, constants/customizing, BRFplus, feature switches, BAdI filters, variant values, number ranges, logical destinations, service bindings, output determination, workflow/job variants, authorization-dependent behavior, hardcoded organizational values, and environment variables.

## Workflow
1. Discover configuration reads and resolution APIs.
2. Capture key/category, call location, fallback/default, expected type, and consumers.
3. Read configured values only when permitted and necessary; redact sensitive values.
4. Separate configured value from source fallback and from inferred meaning.
5. Assess missing/invalid/duplicate/client-dependent/environment-dependent behavior.
6. Map each key to capabilities, processes, entities, findings, and tests.

## Inventory template
`CFG ID | Mechanism | Key/filter | Business purpose | Source object | Resolution path | Current value status | Default/fallback | Consumers | Change owner | Impact | Evidence | Confidence`

## Confidence
- `Verified`: key and value/resolution observed.
- `Partial`: key and consumer observed, value unavailable.
- `Inferred`: behavior suggests configuration but key/value not verified.
- `Unknown`: unresolved dynamic or external configuration.

Never expose credentials, secrets, endpoints with tokens, or personal data.
