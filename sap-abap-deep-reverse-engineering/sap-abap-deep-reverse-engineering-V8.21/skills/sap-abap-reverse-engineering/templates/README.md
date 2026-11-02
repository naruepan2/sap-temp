# Functional Specification Templates

Place project-specific Markdown templates in a dedicated subfolder under this directory.

Example:

```text
templates/SMILE/functional-specification-template.md
templates/SMILE/template.yaml
```

The agent asks which project template to use. If no project is specified, or the requested template is absent or invalid, the agent uses `default/functional-specification-template.md`.

Do not replace the `default` folder unless intentionally updating the bundled fallback.
