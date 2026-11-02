# Functional Specification Templates

Place each project-specific Markdown template in its own subfolder under this directory.

```text
templates/SMILE/functional-specification-template.md
templates/SMILE/template.yaml
```

The agent asks for the project template only when the output mode is Functional Specification or Both, as part of its single batched intake. If no project is specified, or the requested template is absent or invalid, it uses `default/functional-specification-template.md` and records the fallback reason.

Rules:
- Never edit a template during analysis; the agent writes a new output file.
- Do not rename sections of a project template to match the default. If a project template omits the reverse-engineering governance sections, the agent appends them as a labeled appendix (see `references/template-selection.md`).
- Keep `template.yaml` `version` as the template's own version, independent of the skill version.
- Do not replace the `default` folder unless intentionally updating the bundled fallback.
