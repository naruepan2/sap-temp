# Scope governance

## Scope record
Define included capabilities, processes, artifacts, systems, clients, source versions, dependency boundaries, standard-SAP boundary policy, and requested outputs.

## Exclusion record
`Exclusion ID | Item | Reason | User approved? | Criticality | Potential impact | Revisit condition | Evidence`

## Never exclude automatically
Critical write/commit paths; dynamic targets controlling behavior; posting configuration; sensitive authorization paths; public API consumers; critical error/rollback paths; number ranges/locks; business-critical interfaces.

## Freeze and change control
After one plan adjustment, freeze scope. New critical discoveries may trigger a scope-change proposal showing cost, benefit, unresolved risk, and target profile. Do not expand silently.
