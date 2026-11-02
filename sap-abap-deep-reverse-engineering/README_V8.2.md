# SAP ABAP Deep Reverse Engineering V8

> **Current release:** V8.2 - Output Mode Selection
>
> Evidence-driven, strictly read-only SAP reverse engineering with selectable Chat Summary, Functional Specification, or combined delivery.
Ready-to-use GitHub Copilot agent and skill package.

## Installation
1. Copy `agents/sap-abap-reverse-engineer.agent.md` to the repository agent location, commonly `.github/agents/`.
2. Copy `skills/sap-abap-reverse-engineering/` to the skill location used by the Copilot environment.
3. Keep the internal `references/` and `templates/` paths unchanged. Project templates must remain under `templates/<PROJECT>/`.


## V8.2 - Output Mode Selection

V8.2 separates **analysis depth** from **delivery format**. Before long-running analysis, the Agent resolves one output mode unless the user's request already makes the choice explicit.

### Available output modes

#### 1. `CHAT_SUMMARY`

Use when the user needs an evidence-backed explanation, findings, risks, dependency review, or architecture assessment directly in Chat.

- Produces a concise, structured Chat response.
- Includes completion status, evidence states, coverage, limitations, unresolved items, runtime backlog, and next steps.
- Skips project-template selection.
- Does not create a Functional Specification file.

#### 2. `FUNCTIONAL_SPEC`

Use when the user needs formal documentation, an as-built specification, project handover material, or Word-ready Markdown.

- Runs project-template selection.
- Generates `<OBJECT>_Functional_Specification.md`.
- Generates technical sidecars only when applicable.
- Returns a short completion note and file links in Chat.

#### 3. `BOTH`

Use when the user needs immediate understanding and a formal document.

- Produces a concise Chat Summary.
- Runs project-template selection.
- Generates the Markdown Functional Specification.
- Reuses the same frozen scope, canonical graph, evidence registry, findings, coverage, and completion status.
- Does not repeat repository discovery or deep analysis solely to create the second output.

### Selection question

When the requested delivery format remains ambiguous, the Agent asks:

```text
How should the reverse-engineering results be delivered?

1. Chat Summary
2. Functional Specification
3. Both
```

The Agent may resolve the mode without asking when the request is explicit:

- Summary, explanation, analysis, findings, or architecture assessment -> `CHAT_SUMMARY`
- Functional Specification, documentation, Markdown file, Word-ready output, or project template -> `FUNCTIONAL_SPEC`
- Summary plus document, or an explicit request for both -> `BOTH`

### Analysis profile versus output mode

These controls are independent:

- **Analysis profile** controls depth, breadth, and processing budget.
- **Output mode** controls how findings are delivered.

Examples:

- Deep analysis + Chat Summary
- Standard analysis + Functional Specification
- Deep analysis + Both

Selecting Chat Summary does not reduce the analytical depth automatically. Selecting Functional Specification does not imply that static or runtime evidence is complete.

### Late conversion

If a user requests a Functional Specification after a Chat Summary has already been completed, the workflow:

1. verifies the frozen scope and source fingerprints;
2. runs project-template selection;
3. reuses the valid analysis state;
4. retrieves only document-specific missing evidence;
5. generates and validates the Functional Specification;
6. reruns full analysis only when the previous baseline is stale or inconsistent.

## Project template selection
Before analysis/document generation, the agent asks which project template should be used. Add each project template under `skills/sap-abap-reverse-engineering/templates/<PROJECT>/`. If no project is specified or no valid match exists, the bundled default template is used.

## Primary change
After analysis, the workflow now generates a Word-ready Markdown Functional Specification modeled on the supplied project FS structure, while preserving evidence labels, gaps, coverage, CDS discovery metrics, and runtime-test handoff.

## Expected primary output
`<OBJECT>_Functional_Specification.md`

## Important behavior
The package does not invent business-owned metadata, approvals, sign-off, mandatory/optional flags, or expected test results. Unknown values are marked for confirmation.

## Package Structure

```text
sap-abap-deep-reverse-engineering-v8.2/
├── README.md
├── RELEASE_NOTES_V8.2.md
├── agents/
│   └── sap-abap-reverse-engineer.agent.md
└── skills/
    └── sap-abap-reverse-engineering/
        ├── SKILL.md
        ├── references/
        │   ├── safety-and-preflight.md
        │   ├── output-mode-selection.md
        │   ├── evidence-and-completion.md
        │   ├── cds-discovery-strategy.md
        │   ├── template-selection.md
        │   └── functional-specification-authoring.md
        └── templates/
            ├── README.md
            └── default/
                ├── functional-specification-template.md
                └── template.yaml
```

## Quick Start

1. Install the Agent and Skill while preserving the directory structure.
2. Provide the SAP system or destination, client when required, root object, and investigation objective.
3. Select the output mode: Chat Summary, Functional Specification, or Both.
4. Select an analysis profile, or allow the Agent to run a bounded assessment and recommend one.
5. For Functional Specification or Both, select a project template or use `default`.
6. Review the frozen scope before deep analysis starts.
7. Review completion status, coverage, unresolved items, runtime backlog, and generated artifacts.

### Example request

```text
Reverse engineer ZC_RTR_ROU_OUTLEASELIABREP in system S4D, client 100.
Use Deep Evidence-Based analysis.
Output mode: Both.
Project template: SMILE.
Generate the results in English under ./reverse-engineering-output.
```

## Core Capabilities Preserved in V8.2

- Strict read-only SAP safety
- Mandatory system, client, and root-object preflight
- Bounded assessment and explicit scope freeze
- Graph-first CDS discovery
- Canonical object and edge deduplication
- CDS table-function to AMDP resolution
- DCL and authorization analysis
- Field-level lineage
- FACT, DERIVED, INFERRED, and UNVERIFIED evidence states
- Coverage reporting based on unique canonical registries
- Runtime-testing handoff
- Project-specific template selection with default fallback
- Artifact validation and controlled completion statuses

## Completion Statuses

The workflow uses exactly one completion status:

- `DEEP_COMPLETE`
- `STATIC_DEEP_COMPLETE_WITH_LIMITATIONS`
- `STATIC_DEEP_PARTIAL`
- `STRUCTURAL_ANALYSIS_ONLY`
- `REPORT_VALIDATION_FAILED`

A Deep profile does not automatically imply `DEEP_COMPLETE`, and a Chat-only result does not imply shallow analysis.
