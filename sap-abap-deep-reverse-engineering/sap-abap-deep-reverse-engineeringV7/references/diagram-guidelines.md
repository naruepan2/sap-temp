# Diagram guidelines

Generate diagrams from canonical nodes/edges and evidence, not prose memory. Use fenced Mermaid plus a numbered text walkthrough.

## Expected diagrams when relevant
- `G-BUS`: plain-language business flow
- `G-TECH`: technical execution flow
- `G-DATA`: data lineage/transformation
- `G-DEP`: focused dependency graph
- `G-DEC`: decision/mode flow
- `G-STATE`: status lifecycle
- `G-INT`: system/integration context
- `G-LUW`: write and transaction boundaries

Every technical edge needs evidence or `Derived/Unverified`. Show coverage boundaries explicitly. Separate business and technical diagrams.

Normally limit one diagram to 20 nodes and 30 edges. Split into overview plus focused subgraphs. Collapse low-value standard internals.

Validate fences, syntax structure, IDs, evidence mapping, labels, size, and agreement with the walkthrough. Render locally if available; otherwise record `MERMAID_STRUCTURAL_VALIDATION_ONLY`.
