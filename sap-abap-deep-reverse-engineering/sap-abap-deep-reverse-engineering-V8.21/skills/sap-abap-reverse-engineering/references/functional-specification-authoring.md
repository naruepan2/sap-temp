# Functional Specification Authoring Rules

## Goal
Transform reverse-engineering evidence into a Word-ready Markdown Functional Specification resembling the project FS structure, without pretending that reverse-engineered facts are approved requirements.

## Source-to-document principle
The repository explains implemented behavior. The Functional Specification template also contains governance and business-owned fields. Therefore:
- implementation facts may be populated from evidence;
- business intent may be derived or inferred only with labels;
- approvals, ownership, priority, workstream, frequency, volume, mandatory/optional intent, and expected results must remain `TBD` unless evidenced;
- comments, tracked changes, struck-through text, and obsolete alternatives in a source document are not treated as active requirements unless the final accepted wording is unambiguous.

## Document modes
Set `Document Origin` to one of:
- `Reverse-engineered as-built specification`
- `Reverse-engineered draft for business confirmation`
- `Baseline specification with reverse-engineered validation`

Default to `Reverse-engineered draft for business confirmation`.

## Formatting
- Use ATX headings (`#`, `##`, `###`).
- Use normal Markdown tables. Keep cells concise; move long logic to numbered subsections and reference them from tables.
- Escape literal pipe characters in code/expressions.
- Use fenced `mermaid` blocks for process, dependency, and decision diagrams.
- Use fenced language blocks for ABAP/CDS/SQL excerpts, but quote only the minimum evidence required.
- Use `<br>` inside table cells only when necessary.
- Use checkboxes only for confirmed selections. Unknown selections remain unchecked and marked TBD.
- Keep technical names exactly as implemented.

## Required reconciliation
The following must reconcile:
- output field count and numbering;
- field names across overview, detailed logic, input/filter, and output-position sections;
- data type/currency/unit semantics;
- configuration identifiers and values;
- authorization status;
- test scenarios and business-rule branches.

## Field logic pattern
For every material field capture:
1. Functional meaning
2. Source object-field
3. Join/filter conditions
4. Transformation/calculation
5. Fallback/priority logic
6. Aggregation/granularity
7. Currency/unit handling
8. Null/blank behavior
9. Evidence state
10. Runtime test needed

## Diagram set
Generate only applicable diagrams:
- context/architecture
- end-to-end process
- critical calculation decision tree
- CDS/data lineage
- integration or service exposure

Diagrams supplement, not replace, textual logic.

## N/A and TBD policy
- `N/A - not implemented in analyzed sources` means evidence shows absence.
- `TBD - requires business confirmation` means the value is business-owned or not proven.
- `UNVERIFIED - <reason>` means evidence could not be obtained.

## Testing procedure
Derive scenario candidates from branches, boundaries, fallback paths, messages, and configuration. Do not claim expected production results unless deterministically proven. Mark tests as `Static-derived`, `Business-confirmation`, or `Runtime-required`.
