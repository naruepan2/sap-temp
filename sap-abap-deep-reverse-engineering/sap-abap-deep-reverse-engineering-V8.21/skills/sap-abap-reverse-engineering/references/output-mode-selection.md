# Output Mode Selection

## Purpose
Choose how reverse-engineering findings will be delivered before long-running analysis begins.

## Modes

### CHAT_SUMMARY
Use for explanation, analysis, findings, risks, or architecture review in Chat.

Required behavior:
- produce a concise, structured, evidence-backed Chat response;
- include completion status, evidence states, coverage, limitations, runtime backlog, and next steps;
- do not search project templates;
- do not create a Functional Specification.

### FUNCTIONAL_SPEC
Use for formal documentation, as-built specification, project handover, or Word-ready Markdown.

Required behavior:
- run project-template selection;
- generate `<OBJECT>_Functional_Specification.md`;
- generate sidecars only when applicable;
- return a short completion note in Chat.

### BOTH
Use when immediate understanding and formal documentation are both required.

Required behavior:
- generate a concise Chat Summary;
- run project-template selection;
- generate the Functional Specification;
- use one shared analysis state for both outputs.

## Selection question
When ambiguous, ask once:

> How should the reverse-engineering results be delivered?
> 1. Chat Summary
> 2. Functional Specification
> 3. Both

## Explicit intent mapping
- summary, explain, analyze, review, findings, architecture assessment -> `CHAT_SUMMARY`
- Functional Specification, documentation, Markdown file, Word-ready output, project template -> `FUNCTIONAL_SPEC`
- summary plus document, or both -> `BOTH`

Do not silently select a mode when intent remains ambiguous.

## Independence from analysis profile
Output mode controls delivery format. Analysis profile controls depth and budget. Deep analysis may produce only a Chat Summary.

## Shared-state rule
`BOTH` must reuse the same frozen scope, canonical graph, evidence registry, field lineage, findings, coverage, and completion status. Never rerun the full analysis solely to generate the second format.

## Late conversion
If a user requests a Functional Specification after `CHAT_SUMMARY`:
1. verify the saved scope and source fingerprints;
2. run project-template selection;
3. reuse valid analysis state;
4. retrieve only document-specific missing evidence;
5. generate and validate the FS;
6. rerun full analysis only when the baseline is stale or inconsistent.

## State
```yaml
output_selection:
  requested: <user wording or null>
  resolved: <CHAT_SUMMARY|FUNCTIONAL_SPEC|BOTH>
  source: <explicit|user_selected|inferred_from_explicit_deliverable>
  chat_summary_required: <true|false>
  functional_spec_required: <true|false>
```
