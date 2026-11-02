# Scope and Planning

## Profiles (maximum budgets, not targets)
| Profile | Depth | Nodes | Use for |
|---|---|---|---|
| Quick | 3 | 75 | focused component or known routine; fastest; can miss deeper paths |
| Standard | 5 | 150 | normal custom application or bounded flows; balanced |
| Deep | 10 | 300 | multi-layer, dynamic, transaction, integration, and impact analysis |
| Extended | 20 | 500 | exceptional breadth, or unresolved critical paths after Deep; highest cost |

If the user did not select a profile:
1. Assess only at depth 2 / about 25 nodes.
2. Show root and type, components, modes, direct custom dependencies, dynamic/configuration paths, writes/integrations, and missing references.
3. Recommend one profile with evidence.
4. Explain all four options.
5. Wait for the user.

Never escalate silently. At a boundary, report consumption, critical unresolved paths, the expected benefit of expansion, and the options to stop or expand. Stop early when the requested questions, critical paths, side effects, evidence, and synthesis are sufficient. Budgets are safety limits, not completeness claims.

## Analysis plan
Record before full traversal:
`Objective | Root object | System/client | Source/version | Selected profile | Output mode | Document intent | Critical tracks | Planned exclusions | Tool limitations | Expected deliverables | Estimated depth/nodes | Open decisions`

Procedure:
1. Use the assessment and the selected profile.
2. Identify P0/P1 paths (below).
3. List planned capability, process, entity, configuration, inbound, and impact work.
4. State unavailable capabilities such as live where-used or runtime execution.
5. Present the plan and allow one user scope adjustment.
6. Freeze scope and start the coverage registry.

A plan is not a promise that unavailable evidence will be found.

## Priority allocation
- `P0` critical path: writes/commits, financial or material postings, locks and number ranges, authorization-sensitive actions, dynamic dispatch, interface contracts, critical configuration, rollback and error behavior.
- `P1` business-important: validation, status transitions, user-editable data, operational output, important exception handling.
- `P2` supporting: formatting, noncritical reporting, generic wrappers.
- `P3` low-value boundary: standard framework internals, low-use helpers.

Spend profile budget on P0/P1 before P2/P3. Coverage is descriptive, not an optimization target; never traverse low-value objects merely to raise a percentage.

## Scope record
Define included capabilities, processes, artifacts, systems, clients, source versions, dependency boundaries, the standard-SAP boundary policy, downstream lineage boundary, bounded upstream impact boundary, and requested outputs.

### Exclusion record
`Exclusion ID | Item | Reason | User approved? | Criticality | Potential impact | Revisit condition | Evidence`

### Never exclude automatically
Critical write/commit paths; dynamic targets controlling behavior; posting configuration; sensitive authorization paths; public API consumers; critical error/rollback paths; number ranges and locks; business-critical interfaces.

### Freeze and change control
After one plan adjustment, freeze scope. New critical discoveries may trigger a scope-change proposal showing cost, benefit, unresolved risk, and target profile. Out-of-scope consumers go to impact candidates. Do not expand silently.

## Source baseline and fingerprint
Bind the analysis to a specific source context so a tester or a later re-analysis can detect drift.

Baseline fields: `Connection | System | Client | Root object | Object type | Active/inactive version | Package | Last changed metadata | Transport/request when available | Analysis timestamp | Source fingerprint | Fingerprint method | Tool/source`.

Fingerprint: prefer a deterministic hash of normalized source and relevant includes/components when tools permit. If hashing is unavailable, record a composite of object version, change metadata, include inventory, and analysis timestamp, marked `PARTIAL`.

Compatibility: `BASELINE_VERIFIED_FOR_TARGET_SYSTEM`, `BASELINE_PARTIAL`, `BASELINE_NOT_VERIFIED_FOR_TARGET_SYSTEM`, `BASELINE_DRIFT_DETECTED`.

Do not expose credentials or sensitive source contents in the fingerprint record. Runtime handoffs reference the baseline ID.
