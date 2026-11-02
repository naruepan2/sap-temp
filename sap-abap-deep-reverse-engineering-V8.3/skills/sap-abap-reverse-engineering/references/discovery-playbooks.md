# Discovery Playbooks: Capability, Entity, Configuration

Use these when the document intent or objective needs business meaning, data meaning, or configuration-driven behavior (Functional Specification, support handbook, impact assessment). Skip sections that do not apply and record the applicability decision.

## 1. Business capability and process
Goal: translate technical modes and objects into business capabilities without inventing ownership or requirements.

Method:
1. Identify user entry points, mode labels, messages, forms, outputs, transactions, and business nouns.
2. Cluster related actions into candidate processes; cluster processes that deliver one outcome into a candidate capability.
3. Search source metadata, texts, documentation, and configuration for names and ownership.
4. Classify each attribute `Approved`, `Observed`, `Inferred`, or `Unverified`.
5. Queue a functional confirmation when names, owners, upstream/downstream processes, or intended outcomes are inferred.

Capability catalog: `Capability ID | Name | Purpose | Business outcome | Process area | Owner | Upstream | Downstream | Processes | Technical objects | Findings/risks | Evidence | Confidence`.

Process catalog: `Process ID | Capability ID | Trigger | Actor | Preconditions | Inputs | Main steps | Decisions | Outputs | Exceptions | Status changes | Side effects | Objects | Evidence`.

Rules:
- Do not use radio-button names as capability names unless they describe a business outcome.
- Separate user-visible steps from implementation calls.
- One mode may support several capabilities; one capability may span several programs.
- Every capability connects to at least one process and one technical object, or is marked `UNMAPPED`.
- Produce one business capability map and one end-to-end business flow when evidence exists, with a text walkthrough.

## 2. Business entities
Goal: explain what data means to the business and how it is identified, created, changed, consumed, and governed.

Candidate sources: transparent tables, CDS entities, structures, table types, RAP entities, BAPI/interface structures, ALV output tables, text tables, domain fixed values, status constants, document keys, configuration tables.

Workflow:
1. Classify each data object: master, transaction, history, configuration, worklist, output, interface, technical.
2. Infer a business name from labels, DDIC texts, relationships, messages, and usage; mark it `INFERRED`.
3. Identify keys, foreign/reference fields, dates, quantities, currencies, units, statuses, audit fields, retention clues.
4. Map create/read/update/delete consumers and transaction boundaries.
5. Reconstruct lifecycle and status transitions and invariants.
6. Record sensitive fields, personal data, authorization relevance, unresolved semantics.

Entity catalog: `Entity ID | Business name | Physical object | Type | Purpose | Keys | Parent/child | Created by | Updated by | Read by | Status lifecycle | Retention | Sensitivity | Evidence | Confidence`.

Field mapping: `Entity | Business field | Technical field | Type/domain | Meaning | Source | Transformation | Output/consumer | Rule status | Evidence`.

Rules: never equate a table name with business meaning without evidence; distinguish current-state, history, staging, and log entities; flag update paths that bypass locking, validation, or coherent LUW boundaries.

## 3. Configuration
Goal: identify values outside source code that change behavior, with business purpose, resolution path, consumers, defaults, and risk.

Mechanisms to inspect: custom configuration classes and tables, TVARVC, SET/GET parameters, constants and customizing, BRFplus, feature switches and toggles, BAdI filters, variant values, number ranges, logical destinations and communication arrangements, service bindings, output determination, workflow and job variants, authorization-dependent behavior, hardcoded organizational values, environment variables.

Workflow:
1. Discover configuration reads and resolution APIs.
2. Capture key or category, call location, fallback/default, expected type, consumers.
3. Read configured values only when permitted and necessary; redact sensitive values.
4. Separate configured value from source fallback and from inferred meaning.
5. Assess missing, invalid, duplicate, client-dependent, and environment-dependent behavior.
6. Map each key to capabilities, processes, entities, findings, tests.

Inventory: `CFG ID | Mechanism | Key/filter | Business purpose | Source object | Resolution path | Current value status | Default/fallback | Consumers | Change owner | Impact | Evidence | Confidence`.

Confidence: `Verified` (key and value or resolution observed), `Partial` (key and consumer observed, value unavailable), `Inferred` (behavior suggests configuration, key or value not verified), `Unknown` (unresolved dynamic or external configuration).

Never expose credentials, secrets, endpoints with tokens, or personal data.
