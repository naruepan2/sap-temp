# Profile selection

Profiles are maximum budgets, not targets.

- **Quick**: depth 3, nodes 75. Focused component or known routine; fastest; can miss deeper paths.
- **Standard**: depth 5, nodes 150. Normal custom application or bounded flows; balanced coverage.
- **Deep**: depth 10, nodes 300. Multi-layer, dynamic, transaction, integration, and impact analysis.
- **Extended**: depth 20, nodes 500. Exceptional breadth or unresolved critical paths after Deep; highest cost.

If the user did not select a profile:
1. Assess only depth 2 / 25 nodes.
2. Show root/type, components, modes, direct custom dependencies, dynamic/configuration paths, writes/integrations, and missing references.
3. Recommend one profile with evidence.
4. Explain all four choices.
5. Wait for the user.

Never escalate silently. At a boundary, report consumption, critical unresolved paths, expected benefit of expansion, and options to stop or expand.

Stop early when requested questions, critical paths, side effects, evidence, and synthesis are sufficient.
