# Project Template Selection

## Applicability
Use this reference only for `FUNCTIONAL_SPEC` or `BOTH`. Do not select a project template for `CHAT_SUMMARY`.

## Purpose
Select a project-specific Functional Specification template before document generation while guaranteeing a safe bundled fallback.

## User interaction gate
Ask for the template inside the single batched intake (`intake-and-modes.md`), item "Project template name, or `default`". Do not ask a separate follow-up question, and do not ask at all when the current conversation already contains an unambiguous project or template name. Resolve the template before Phase 6, normally during Phase 2.

## Search scope
Search only inside the skill's `templates/` directory, recursively. Do not search arbitrary workstation folders. Supported authoring templates are Markdown files (`.md`). A project may also include `template.yaml` metadata.

Recommended layout:

```text
templates/
  default/
    functional-specification-template.md
  SMILE/
    functional-specification-template.md
    template.yaml
  PROJECT_X/
    project-x-fs.md
    template.yaml
```

## Candidate discovery
A Markdown file is a template candidate when:
- it is under `templates/`;
- it is not a README or generated output;
- its metadata or file content identifies it as a Functional Specification template;
- it is readable and passes basic structural validation.

## Match order
Resolve the user's project/template request in this order:
1. Exact `project_id` or `template_id` from `template.yaml`.
2. Exact project folder name.
3. Exact template filename without extension.
4. Exact configured alias from `template.yaml`.
5. Normalized name match: case-insensitive; spaces, hyphens, and underscores treated equivalently.

Never use fuzzy similarity alone to auto-select a template.

## Selection outcomes

### One valid match
Use the template. Record:
- requested project/template;
- resolved template path;
- match method;
- template version, if declared;
- SHA-256 fingerprint;
- selection timestamp.

### Multiple valid matches
Show only the candidate project/template names, versions, and relative paths. Ask the user to choose. Do not continue document generation until resolved.

### No project specified
Use `templates/default/functional-specification-template.md`. Record `fallback_reason: project_not_specified`.

### Requested project not found
Report that the requested template was not found, list the searched relative template locations, then use the default template. Record `fallback_reason: requested_template_not_found` and add a note to Document Control and the Confirmation Queue.

### Requested template invalid
If the file is unreadable, malformed, empty, or lacks minimum recognizable FS sections, use the default. Record `fallback_reason: requested_template_invalid` and the validation error.

## Optional metadata
Example `template.yaml`:

```yaml
project_id: SMILE
template_id: SMILE_FS_REPORT
version: "1.0"   # template version, independent of the skill version
aliases:
  - smile report
  - smile functional specification
template_file: functional-specification-template.md
required_sections:
  - Document Control
  - General Information
  - Program Overview
  - Detailed Program Logic
```

## Minimum validation
Before selection, verify:
- file is readable and non-empty;
- Markdown fences are balanced;
- at least Document Control, Program Overview, and Detailed Program Logic or equivalent sections exist;
- placeholders are recognizable and do not reference missing partial files;
- template path remains inside `templates/` after path resolution.

## Template preservation
Never edit or overwrite the selected template. Generate a new output Markdown file in the approved output directory. Preserve the template's section order and project-specific labels. Add evidence, coverage, limitations, and confirmation sections only according to the augmentation rules below.

## Augmentation rules
When a project template omits reverse-engineering governance, add a clearly labeled appendix containing:
- analysis baseline and source fingerprint;
- FACT / DERIVED / INFERRED / UNVERIFIED definitions;
- evidence and coverage summary;
- unresolved items and confirmation queue;
- CDS discovery metrics when applicable;
- runtime verification limitations.

Do not rename existing project sections merely to match the bundled default.

## Required output metadata
Every generated FS must include:

```yaml
template_selection:
  requested: <value or null>
  selected: <relative template path>
  match_method: <metadata|folder|filename|alias|normalized|default>
  template_version: <value or unknown>
  template_fingerprint: <sha256>
  fallback_reason: <none|project_not_specified|requested_template_not_found|requested_template_invalid>
```
