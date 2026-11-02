# SAP ABAP Deep Reverse Engineering V8

Ready-to-use GitHub Copilot agent and skill package.

## Installation
1. Copy `agents/sap-abap-reverse-engineer.agent.md` to the repository agent location, commonly `.github/agents/`.
2. Copy `skills/sap-abap-reverse-engineering/` to the skill location used by the Copilot environment.
3. Keep the internal `references/` and `templates/` paths unchanged. Project templates must remain under `templates/<PROJECT>/`.


## V8.2 - Output Mode Selection

Before long-running analysis, the Agent resolves one delivery mode:

1. **Chat Summary**: evidence-backed summary in Chat; no template search or FS file.
2. **Functional Specification**: project-template selection and Markdown FS generation.
3. **Both**: concise Chat Summary plus Markdown FS from the same analysis state.

Analysis profile and output mode are independent. Project-template selection is now conditional.

## Project template selection
Before analysis/document generation, the agent asks which project template should be used. Add each project template under `skills/sap-abap-reverse-engineering/templates/<PROJECT>/`. If no project is specified or no valid match exists, the bundled default template is used.

## Primary change
After analysis, the workflow now generates a Word-ready Markdown Functional Specification modeled on the supplied project FS structure, while preserving evidence labels, gaps, coverage, CDS discovery metrics, and runtime-test handoff.

## Expected primary output
`<OBJECT>_Functional_Specification.md`

## Important behavior
The package does not invent business-owned metadata, approvals, sign-off, mandatory/optional flags, or expected test results. Unknown values are marked for confirmation.
