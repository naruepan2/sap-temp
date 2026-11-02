# Deliverables and Layout

## Chat Summary structure (`CHAT_SUMMARY` and the Chat part of `BOTH`)
Default length: about 600 to 900 words. Expand on request or when the evidence demands it, and offer detail rather than dumping it. Order:
1. Scope: system, client, root, profile, baseline timestamp.
2. Completion status and one-line stop reason.
3. Executive summary: what it does, for whom, why.
4. Business behavior and key rules, each with its evidence state.
5. Architecture and key dependencies (short; diagram only when it helps).
6. Findings: top items by severity, with confidence and evidence IDs.
7. Risks and limitations.
8. Coverage by dimension (compact table).
9. Unresolved items and the confirmation queue (blocking items first).
10. Runtime backlog and next steps; offer the Functional Specification when not yet produced.

The Chat Summary must agree with the evidence registry and completion status. For `BOTH`, it uses the same findings and coverage as the file.

## Main document versus sidecars
The main document contains business context, capabilities, processes, rules, exceptions, key findings, the confirmation queue, a coverage summary, and limitations. It must stay understandable without opening sidecars.

Optional sidecars, only when applicable or requested:
```text
<OBJECT>_Functional_Specification.md     primary
<OBJECT>_Technical_Appendix.md
<OBJECT>_CDS_Inventory.md
<OBJECT>_Dependency_Graph.md
<OBJECT>_Evidence_Register.md
<OBJECT>_Runtime_Test_Handoff.md
<OBJECT>_Confirmation_Queue.md
<OBJECT>_Analysis_State.md               checkpoint (see validation.md)
```
Use relative links and stable IDs across files. Do not label an embedded sample as the full export. Machine-readable exports: `machine-readable-exports.md`.

## Progressive disclosure and size
Reader levels: executive summary, functional/business view, technical view, evidence appendices. Move large inventories, the full coverage registry, the evidence ledger, field mappings, graph exports, and handoffs to sidecars and link to them. Keep source excerpts short. Size is governed by relevance, not a page count; do not omit critical evidence just to shorten the document.

## Deliverable applicability
Always: executive summary, scope and limitations, source context, profile and consumption, business and technical overview, findings and evidence, coverage, unresolved items, validation summary.

Conditional (record `Applicable`, `Not Applicable`, `Unavailable`, or `Out of Scope` with a reason; never invent content to fill a template): entity catalog, configuration inventory, state diagram, LUW diagram, integration context, authorization matrix, runtime handoff, knowledge graph, migration section, performance section. In the Functional Specification, a non-applicable section keeps its heading and states `N/A - <reason>`.

## Skeleton for other document intents
For technical specification, support handbook, impact assessment, migration specification, test design, or knowledge base, build the document from: document control, executive summary, scope and baseline, the emphasis sections from `intake-and-modes.md`, findings, confirmation queue, coverage, limitations. State that no project template applies.

## Required matrices (technical appendix)
Capability-to-process-to-object; process-to-entity/configuration/output; finding-to-impact-radius; business rule-to-implementation-to-evidence-to-test; coverage dashboard.

## Diagram guidelines
Generate diagrams from canonical nodes and edges and evidence, not from prose memory. Use fenced Mermaid plus a numbered text walkthrough.

Expected when relevant: `G-BUS` plain-language business flow; `G-TECH` technical execution flow; `G-DATA` data lineage; `G-DEP` focused dependency graph; `G-DEC` decision/mode flow; `G-STATE` status lifecycle; `G-INT` system/integration context; `G-LUW` write and transaction boundaries.

Rules: every technical edge has evidence or is `Derived`/`Unverified`; show coverage boundaries; separate business and technical diagrams; limit one diagram to about 20 nodes and 30 edges and split into an overview plus focused subgraphs; collapse low-value standard internals; validate fences, syntax structure, IDs, labels, size, and agreement with the walkthrough. Render locally if available; otherwise record `MERMAID_STRUCTURAL_VALIDATION_ONLY`.

## Audience and readability
Business meaning first, technical evidence second, large inventories in appendices. Translate status codes only when evidence exists. Add "Why this matters" to every material finding. Include a glossary and a technical-object map. Review the document once as a functional reader and once as a developer; revise if either cannot continue without missing context.
