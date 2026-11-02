# SAP ABAP Deep Reverse Engineering Agent + Skill

## 1. Overview

The **SAP ABAP Deep Reverse Engineering Agent + Skill** package provides evidence-driven, strictly read-only analysis of existing SAP solutions. It is designed to do more than read source code or produce a dependency inventory. Its purpose is to reconstruct business, functional, and technical knowledge from SAP repository evidence and convert that knowledge into traceable, review-ready documentation.

The package is intended to answer the following questions:

- What does the solution do?
- Why does the solution exist?
- Which business process does the solution support?
- Which users, applications, jobs, or services invoke it?
- How is the solution implemented?
- Which programs, classes, CDS views, tables, services, configurations, authorizations, and integrations does it depend on?
- How is each critical input, output, or calculated field derived?
- Which findings are confirmed by evidence?
- Which conclusions are derived or inferred?
- Which areas remain unverified and require business confirmation or runtime testing?
- How can the analysis be transformed into a project-specific Functional Specification?

The core objective is to transform complex SAP repository content into **business-readable, functional, technical, and evidence-backed knowledge** that can be independently reviewed and traced back to its source.

---

## 2. Agent and Skill Responsibilities

### 2.1 Agent

The Agent controls the conversation and the high-level workflow. Its responsibilities include:

- collecting and validating required inputs;
- resolving the SAP system, client, and root object;
- enforcing read-only safety;
- verifying the selected SAP toolchain;
- requesting or recommending an analysis profile;
- selecting a project Functional Specification template;
- freezing the agreed scope before deep analysis;
- invoking the Skill and relevant reference files;
- preventing silent scope expansion;
- enforcing completion and validation gates;
- reporting results, limitations, completion status, and generated files.

The Agent should remain concise. Detailed analytical behavior belongs in the Skill and its reference files.

### 2.2 Skill

The Skill is the source of truth for the reverse-engineering process. Its responsibilities include:

- repository discovery;
- dependency and architecture analysis;
- business-process reconstruction;
- functional-logic reconstruction;
- field-level lineage;
- graph-oriented CDS discovery;
- configuration discovery;
- authorization analysis;
- runtime-boundary identification;
- evidence classification;
- coverage calculation;
- Functional Specification generation;
- artifact validation.

In summary, the **Agent orchestrates the work**, while the **Skill defines how the work is performed**.

---

## 3. Mandatory Preflight

Before calling any SAP tool, the Agent must resolve and verify:

1. SAP system, destination, or connection ID
2. SAP client when required by the selected tool or evidence
3. Root object or business entry point
4. Object type, when known
5. Investigation objective
6. Source or version preference
7. Output language
8. Output directory
9. Analysis profile
10. Project template

If the system, client, or root object is missing and cannot be obtained safely from the active session, the Agent must ask once and wait.

The Agent must not infer the target system from:

- object names;
- system IDs embedded in source code;
- connection counts;
- unrelated tool output;
- previous projects;
- prior conversations that were not explicitly carried into the current scope.

If the active session already identifies the system unambiguously, the Agent should reuse it and must not ask again.

The actual toolchain must be verified using a lightweight read-only call. A working connection through one connector does not prove that another connector is available.

---

## 4. Read-only Safety

The reverse-engineering workflow is **strictly read-only**.

### Permitted activities

- Read source code
- Read repository metadata
- Inspect package content
- Perform dependency searches
- Perform where-used searches
- Read CDS sources, DCLs, and metadata extensions
- Read service definitions and service bindings
- Read ABAP classes and AMDP implementations
- Read configuration definitions through safe operations
- Create documentation files in the local workspace

### Prohibited activities

- Create or modify SAP repository objects
- Activate objects
- Create transports
- Write business or configuration data
- Execute business transactions
- Post documents
- Schedule jobs
- Change configuration
- Invoke operations with unknown side effects
- Claim runtime execution without actual runtime evidence

If the user changes the objective to creating or changing a package, program, class, function module, CDS object, service, or other repository object, the Agent must stop the reverse-engineering workflow and hand the request to a separate development workflow with an explicit write/change gate.

Sensitive production information must not be copied into generated documentation. Credentials, bank details, personal data, supplier account values, and confidential transactional samples must be masked or omitted.

---

## 5. Analysis Profiles and Scope Control

Before deep analysis, the Agent performs a bounded structural assessment to estimate:

- object type;
- architecture style;
- dependency breadth;
- major components;
- likely complexity;
- presence of CDS, RAP, AMDP, query providers, enhancements, forms, services, or background processing;
- the most appropriate analysis profile.

Recommended profiles are:

- **Quick Structural**: inventory and high-level architecture
- **Standard Functional**: business behavior and functional flow
- **Extended Functional and Technical**: deeper logic, dependencies, and field lineage
- **Deep Evidence-Based**: full evidence, coverage, gap closure, documentation, and runtime handoff

If the user has not chosen a profile, the Agent should perform a small assessment, for example depth 2 and approximately 25 nodes, recommend a profile, explain the trade-offs, and wait before starting long-running analysis.

After profile selection, the workflow freezes:

- root object;
- related entry points;
- business objective;
- intended audiences;
- downstream lineage boundary;
- bounded upstream impact boundary;
- package and system boundaries;
- depth, node, token, or tool-call budgets;
- output artifacts;
- explicit exclusions.

These budgets are safety limits. Reaching a limit does not prove that the analysis is complete.

---

## 6. Repository and Dependency Discovery

The discovery process may include:

- executable programs and includes;
- classes and interfaces;
- function modules;
- CDS views and CDS view entities;
- CDS projections and custom entities;
- CDS table functions;
- AMDP classes and methods;
- database tables;
- RAP business objects;
- behavior definitions and implementations;
- service definitions and bindings;
- OData services;
- query providers;
- enhancements, BAdIs, exits, and enhancement spots;
- forms and print objects;
- application jobs and background programs;
- authorization objects and DCLs;
- configuration tables and configuration APIs;
- external interfaces;
- UI applications and navigation targets.

The workflow maintains state through registries such as:

- frontier;
- visited objects;
- canonical nodes;
- unique edges;
- structural nodes;
- retrieval registry;
- evidence registry;
- source fingerprints;
- findings;
- unresolved items;
- confirmation queue;
- coverage metrics;
- artifact registry.

A visited canonical object should not be read repeatedly unless its source fingerprint changed or a targeted evidence gap requires a bounded reread.

---

## 7. Graph-first CDS Discovery

A CDS dependency export may contain thousands of occurrences while representing only a few hundred unique repository objects. The workflow therefore treats CDS dependencies as a **directed graph**, not as a simple traversal tree.

The workflow distinguishes:

- raw dependency occurrences;
- unique repository objects;
- unique directed edges;
- structural nodes;
- branch context;
- source-retrieval status;
- evidence status.

An object that appears in many paths is read once, while all parent relationships, dependency edges, occurrence counts, and branch contexts remain recorded.

### 7.1 Canonical object identity

Canonical identity is resolved in this order:

1. Object type plus CDS entity name
2. Object type plus repository object name
3. Object type plus SQL name as fallback

Normalization rules include:

- case-insensitive comparison;
- whitespace normalization;
- escaped underscore normalization;
- retention of original entity name, SQL name, and database object as aliases;
- no merging of different object types merely because their names are similar.

Recommended canonical key:

```text
<SYSTEM>|<OBJECT_TYPE>|<NORMALIZED_OBJECT_NAME>
```

### 7.2 Structural nodes

The following are structural elements rather than repository objects:

- `SELECT`
- `UNION`
- `UNION ALL`
- subqueries
- branch markers

They must not be counted as CDS objects, retrieved as source objects, or reported as missing repository objects. They are retained to explain branch structure.

### 7.3 CDS discovery passes

#### Pass 1: Structural discovery

Collect object identity, object type, relation type, depth, parameters, access-control indicators, and retrieval failures without inferring business meaning.

#### Pass 2: Normalize and deduplicate

Create canonical nodes and unique edges while preserving occurrence counts, parent-child relationships, paths, branch contexts, cycles, and shared foundations.

#### Pass 3: Prioritized retrieval

Recommended priority order:

1. Root and consumption CDS
2. Interface and core-calculation CDS
3. Custom Z/Y objects
4. CASE, UNION, aggregation, and currency-conversion layers
5. Objects contributing to critical fields
6. CDS table functions
7. DCL and authorization-relevant objects
8. Query providers and custom entities
9. Service exposure
10. Base tables and low-risk wrappers

#### Pass 4: Critical-gap closure

Confirm that:

- every critical output has a source path;
- important calculations have evidence;
- all critical UNION branches are represented;
- table functions are traced to AMDP;
- authorization and configuration dependencies are covered;
- service exposure is understood;
- unresolved high-priority gaps are documented.

---

## 8. CDS Table Functions and AMDP

Reading the CDS table-function definition alone is insufficient.

For every critical table function, the workflow should:

1. Read the CDS table-function definition.
2. Inspect parameters and return structure.
3. Resolve the implementing class and method.
4. Read the AMDP SQLScript implementation.
5. Discover additional dependencies referenced in SQLScript.
6. Capture client handling.
7. Capture parameter mapping.
8. Capture filters and aggregation.
9. Capture fallback and priority logic.
10. Add implementation dependencies to the graph.

If the implementation cannot be read, the table function must remain `UNVERIFIED`, with the blocker and coverage impact recorded.

---

## 9. Dependency Scope Directions

The workflow separates three kinds of scope.

### Downstream lineage

Answers where data and logic originate:

- source CDS views;
- base tables;
- configuration;
- calculation chains;
- field lineage.

### Bounded upstream impact

Answers what may be affected by a change:

- consumers;
- reports;
- services;
- applications;
- shared foundations.

### Contextual candidates

Objects found through package searches, naming, annotations, repository searches, or similarity remain candidates until confirmed by source or repository evidence.

Candidate relationships must not be mixed with confirmed dependencies.

---

## 10. Evidence Model

Every material finding uses one of four evidence states.

### `FACT`

Directly observed in source code, repository metadata, configuration evidence, or verified tool output.

### `DERIVED`

A deterministic conclusion calculated from confirmed facts. The formula, reasoning, or source chain should be shown.

### `INFERRED`

A likely interpretation that is not explicitly proven, such as business purpose, actor, or design intent. The basis must be stated and confirmation requested.

### `UNVERIFIED`

Evidence is unavailable, blocked, truncated, runtime-dependent, outside scope, or otherwise unproven.

Important evidence records should contain:

- evidence ID;
- object name and type;
- source version or fingerprint;
- source location or relationship;
- retrieval method;
- supported claim;
- evidence state;
- confidence;
- limitation.

Technical naming alone must not be treated as confirmed business meaning.

---

## 11. Functional Reconstruction

The result covers three perspectives.

### 11.1 Business perspective

- Business objective
- Actors and users
- Trigger
- Inputs and outputs
- End-to-end process
- Decision points
- Exception paths
- Business value
- Operational constraints

### 11.2 Functional perspective

- Processing sequence
- Input parameters
- Filters and defaults
- Value helps
- User actions
- Validations
- Messages
- Output fields
- Sorting, grouping, and aggregation
- Currency and unit semantics
- Date and time semantics
- Fallback and priority rules
- Configuration-controlled behavior
- Authorization behavior

### 11.3 Technical perspective

- Entry points
- Architecture layers
- Dependency graph
- Join conditions
- Associations and compositions
- CASE and UNION logic
- Calculations
- Database access
- Service exposure
- Extension points
- Performance risks
- Duplicate and fan-out risks
- Runtime boundaries

---

## 12. Field-level Lineage

Every critical field should capture:

1. Field name
2. Functional meaning
3. Source object-field
4. Alternative source or fallback
5. Join conditions
6. Filter conditions
7. Transformation
8. Calculation formula
9. CASE or priority logic
10. Aggregation and granularity
11. Currency or unit reference
12. Date/time behavior
13. Null or blank behavior
14. Data type and length
15. Mandatory, optional, or conditional status when proven
16. Evidence state
17. Evidence IDs
18. Runtime-test requirement

Mandatory, optional, or conditional status must not be inferred from field naming alone. When not proven, use:

```text
TBD - requires business confirmation
```

---

## 13. Configuration, Authorization, and Error Handling

### 13.1 Configuration

Capture:

- configuration object;
- key or identifier;
- value or range;
- purpose;
- default or fallback;
- consuming object;
- evidence state;
- unresolved values.

### 13.2 Authorization

Analyze separately:

- DCL;
- authorization object;
- authorization field;
- role or aspect mapping;
- enforcement point;
- service or application exposure;
- runtime-verification requirement.

The presence of a DCL or annotation does not prove effective runtime authorization for a real user.

### 13.3 Error handling

Search for:

- explicit messages;
- exception classes;
- failed validations;
- empty-result behavior;
- duplicate behavior;
- missing-configuration behavior;
- authorization failures;
- fallback behavior;
- logging and trace behavior;
- recovery or retry behavior.

---

## 14. Runtime-testing Handoff

The primary workflow is static analysis. Runtime-dependent behavior must be separated from source-confirmed behavior.

Typical runtime-verification topics include:

- actual output values;
- authorization outcomes;
- runtime configuration values;
- performance;
- data-dependent branches;
- currency-conversion results;
- reconciliations;
- service filtering and paging;
- dumps and exceptions;
- background-job behavior.

Test scenarios are classified as:

- `Static-derived`
- `Business-confirmation`
- `Runtime-required`

The Agent must never claim that a test passed unless runtime evidence was actually collected.

---

## 15. Project Template Selection

Before long-running analysis or Functional Specification generation, the Agent asks which project template should be used unless the current conversation already provides an unambiguous project or template name.

Recommended template structure:

```text
templates/
  default/
    functional-specification-template.md
    template.yaml
  <PROJECT>/
    functional-specification-template.md
    template.yaml
```

### Match order

1. `project_id` in `template.yaml`
2. `template_id`
3. Exact project-folder name
4. Exact template filename
5. Configured alias
6. Normalized name

Normalized matching may ignore letter case and treat spaces, hyphens, and underscores as equivalent. Fuzzy similarity alone must not trigger automatic selection.

### Selection outcomes

#### One valid match

Use the template and record the request, selected path, match method, version, and SHA-256 fingerprint.

#### Multiple valid matches

Show a concise candidate list and ask the user to choose. Do not guess.

#### No project specified

Use the bundled default and record:

```yaml
fallback_reason: project_not_specified
```

#### Requested project not found

Use the bundled default and record:

```yaml
fallback_reason: requested_template_not_found
```

#### Requested template invalid

Use the bundled default and record:

```yaml
fallback_reason: requested_template_invalid
```

The selected template must never be modified or overwritten. The workflow always creates a new output document.

---

## 16. Functional Specification Output

The primary output is:

```text
<OBJECT>_Functional_Specification.md
```

The document must use the selected project template and remain understandable without opening technical sidecars.

Minimum content, where applicable:

1. Document Control
2. General Information
3. Program Overview
4. Application Name and Description
5. Detailed Program Logic
6. Input Parameters
7. User Actions
8. Validation
9. Output and Filter Bar
10. Customized Tables and Configuration
11. Authorizations
12. Error Handling
13. Testing Procedure
14. Dependencies and Architecture
15. Risks, Assumptions, and Limitations
16. Evidence and Coverage Summary
17. Confirmation Queue

When a section is not applicable, retain it and state:

```text
N/A - <evidence-based reason>
```

The default document origin is:

```text
Reverse-engineered draft for business confirmation
```

Other supported modes are:

- Reverse-engineered as-built specification
- Baseline specification with reverse-engineered validation

---

## 17. Information That Must Not Be Invented

Without supporting evidence, the Agent must not fabricate:

- project owner;
- approver;
- sign-off;
- workstream;
- priority;
- frequency;
- transaction volume;
- business mandatory/optional status;
- catalog ID;
- authorization role;
- configuration value;
- expected production result;
- runtime test result.

Use:

```text
TBD - requires confirmation
```

and add the item to the Confirmation Queue.

---

## 18. Optional Sidecar Artifacts

For complex solutions, the workflow may generate:

```text
<OBJECT>_Technical_Appendix.md
<OBJECT>_CDS_Inventory.md
<OBJECT>_Dependency_Graph.md
<OBJECT>_Evidence_Register.md
<OBJECT>_Runtime_Test_Handoff.md
<OBJECT>_Confirmation_Queue.md
```

The main Functional Specification remains self-contained. Large technical inventories and evidence lists should be placed in sidecars and linked from the primary document.

---

## 19. Artifact Validation

Before delivery, the workflow saves and reopens the exact generated files, then validates:

- Markdown headings;
- selected-template section order;
- Markdown tables;
- Mermaid syntax;
- internal links;
- template identity, version, and fingerprint;
- field count and numbering;
- field names and data types;
- input/filter/output consistency;
- configuration identifiers;
- authorization status;
- evidence references;
- coverage calculations;
- Confirmation Queue completeness;
- sensitive-data handling;
- generated-file paths.

Material `TBD`, `INFERRED`, and `UNVERIFIED` items must appear in the Confirmation Queue or limitations section.

One repair pass is permitted. If validation still fails, preserve the draft and use:

```text
REPORT_VALIDATION_FAILED
```

---

## 20. Coverage Model

Coverage is reported by dimension rather than compressed into a single score:

- unique object/source coverage;
- unique edge coverage;
- critical-path coverage;
- critical field-lineage coverage;
- configuration coverage;
- authorization coverage;
- table-function/AMDP coverage;
- DCL coverage;
- UNION-branch coverage;
- runtime-verification coverage;
- unresolved high-priority items.

CDS analysis additionally reports:

- raw dependency occurrences;
- unique canonical objects;
- unique directed edges;
- maximum observed depth;
- fully read objects;
- partially read objects;
- listed-only objects;
- unresolved objects;
- intentionally skipped objects;
- duplicated-path reduction;
- stop reason.

Raw dependency occurrence count must never be used as the denominator for object coverage.

---

## 21. Completion Status

Exactly one completion status is used.

### `DEEP_COMPLETE`

Critical static evidence and required runtime evidence are complete within the frozen scope.

### `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`

Critical static analysis is complete, but runtime verification or business confirmation remains.

### `STATIC_DEEP_PARTIAL`

Significant deep analysis is available, but one or more critical static gaps remain.

### `STRUCTURAL_ANALYSIS_ONLY`

Inventory and architecture are available, but detailed logic reconstruction is insufficient.

### `REPORT_VALIDATION_FAILED`

Analysis may exist, but generated artifacts did not pass final validation.

Selecting a Deep profile does not automatically justify `DEEP_COMPLETE`.

---

## 22. Package Architecture

```text
sap-abap-deep-reverse-engineering/
├── README.md
├── agents/
│   └── sap-abap-reverse-engineer.agent.md
└── skills/
    └── sap-abap-reverse-engineering/
        ├── SKILL.md
        ├── references/
        │   ├── safety-and-preflight.md
        │   ├── evidence-and-completion.md
        │   ├── cds-discovery-strategy.md
        │   ├── template-selection.md
        │   └── functional-specification-authoring.md
        └── templates/
            ├── README.md
            ├── default/
            │   ├── functional-specification-template.md
            │   └── template.yaml
            └── <PROJECT>/
                ├── functional-specification-template.md
                └── template.yaml
```

---

## 23. End-to-end Workflow

```text
Preflight
    ↓
Read-only Tool Verification
    ↓
Project Template Selection
    ↓
Bounded Assessment
    ↓
Analysis Profile Selection
    ↓
Scope Freeze
    ↓
Repository and Graph Discovery
    ↓
Priority-based Source Retrieval
    ↓
Business and Functional Reconstruction
    ↓
Field-level Lineage
    ↓
Evidence and Gap Closure
    ↓
Functional Specification Generation
    ↓
Runtime-testing Handoff
    ↓
Artifact Validation
    ↓
Completion Status
```

---

## 24. Design Principles

The package is built around the following principles:

- **Production-safe:** SAP access remains read-only.
- **System-aware:** system and client are never guessed.
- **Graph-first:** complex dependencies are modeled as canonical nodes and unique edges.
- **Deduplicated:** repeated CDS occurrences do not cause repeated source reads.
- **Implementation-complete:** critical table functions are traced to AMDP.
- **Evidence-driven:** facts are separated from derivations, inferences, and unknowns.
- **Business-honest:** source code is not presented as approved business intent.
- **Template-aware:** project-specific Functional Specification structures are supported.
- **Fallback-safe:** a validated default template is always available.
- **Runtime-aware:** runtime verification is handed off rather than fabricated.
- **Coverage-transparent:** completeness is measured using unique evidence and critical paths.
- **Artifact-validated:** files are reopened and checked before completion is claimed.

---

## 25. Final Summary

This Agent + Skill package is not merely an AI source-code reader. It is an **evidence-based SAP knowledge reconstruction system**.

Its purpose is to transform a complex SAP repository into a reliable as-built understanding that:

- is traceable to technical evidence;
- can be read by business and functional teams;
- remains useful to developers, testers, security teams, and support teams;
- distinguishes confirmed implementation from interpretation;
- identifies static and runtime limitations;
- generates a project-aligned Functional Specification;
- avoids claims that exceed the available evidence.

The intended outcome is a reusable, production-oriented reverse-engineering workflow that can support analysis, documentation, testing, impact assessment, maintenance, support, and future modernization work.
