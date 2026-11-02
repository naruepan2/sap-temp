# Functional Specification Authoring Rules

## Goal
Transform reverse-engineering evidence into a Word-ready Markdown Functional Specification that follows the selected project FS structure, without pretending that reverse-engineered facts are approved requirements.

## Source-to-document principle
The repository explains implemented behavior. The template also contains governance and business-owned fields. Therefore:
- implementation facts may be populated from evidence;
- business intent may be derived or inferred only with labels;
- approvals, ownership, priority, workstream, frequency, volume, mandatory/optional intent, and expected results stay `TBD` unless evidenced;
- comments, tracked changes, struck-through text, and obsolete alternatives in a source document are not active requirements unless the final accepted wording is unambiguous.

## Document origin
Set `Document Origin` to one of:
- `Reverse-engineered as-built specification`
- `Reverse-engineered draft for business confirmation`
- `Baseline specification with reverse-engineered validation`

Default: `Reverse-engineered draft for business confirmation`.

## Formatting
- ATX headings (`#`, `##`, `###`); one H1 per document.
- Normal Markdown tables; keep cells concise and move long logic to numbered subsections referenced from tables.
- Escape literal pipe characters in code and expressions.
- Fenced `mermaid` blocks for process, dependency, and decision diagrams (limits in `deliverables-and-layout.md`).
- Fenced language blocks for ABAP/CDS/SQL excerpts; quote only the minimum evidence required.
- `<br>` inside table cells only when necessary.
- Checkboxes only for confirmed selections; unknown selections stay unchecked and marked `TBD`.
- Keep technical names exactly as implemented. Pair business labels with technical names on first use, for example `Company Code (P_BUKRS)`. Expand acronyms on first use.

## Executive summary
Write a one-to-two page Executive Summary that a business reader can use without the rest: what the solution does, who uses it, key rules, key findings, completion status, and what needs confirmation. State the analysis status and document status.

## Required reconciliation
These must reconcile across the document: output field count and numbering; field names across overview, detailed logic, input/filter, and output-position sections; data type, currency, and unit semantics; configuration identifiers and values; authorization status; test scenarios and business-rule branches.

## Field logic pattern
For every material field capture: functional meaning; source object-field; join and filter conditions; transformation or calculation; fallback and priority logic; aggregation and granularity; currency and unit handling; null and blank behavior; evidence state; runtime test needed. Mandatory/optional/conditional status only when proven; otherwise `TBD - requires business confirmation`.

## Diagram set
Generate only applicable diagrams: context/architecture, end-to-end process, critical calculation decision tree, CDS/data lineage, integration or service exposure. Diagrams supplement, not replace, textual logic.

## N/A, TBD, UNVERIFIED policy
- `N/A - not implemented in analyzed sources`: evidence shows absence (state the search scope).
- `N/A - <evidence-based reason>`: the section does not apply.
- `TBD - requires business confirmation`: the value is business-owned or not proven.
- `UNVERIFIED - <reason>`: evidence could not be obtained.

Never silently remove a template section.

## Testing procedure
Derive scenario candidates from branches, boundaries, fallback paths, messages, and configuration. Do not claim expected production results unless deterministically proven. Mark tests `Static-derived`, `Business-confirmation`, or `Runtime-required`.

## Findings in the specification
Place the findings register under section 14 using the record in `findings-and-risk.md`. Every `TBD`, `INFERRED`, and `UNVERIFIED` item that matters appears in the Confirmation Queue or in limitations.

## Sensitive data
Apply the redaction rules in `safety-and-preflight.md` to tables, diagrams, and examples before saving.
