# Knowledge graph export

## Purpose
Export reusable, evidence-backed relationships connecting business and technical knowledge.

## Node types
Capability, Process, Actor/Role, Object, Component, Method/Form/Function, Entity, Field, Configuration, Integration, Job, Form, Message, BusinessRule, Finding, Risk, TestCandidate, Evidence, CoverageBoundary.

## Edge types
SUPPORTS, CONTAINS, PERFORMS, IMPLEMENTED_BY, CALLS, READS, WRITES, TRANSFORMS, CONFIGURED_BY, EXPOSES, TRIGGERS, PRODUCES, CONSUMES, AFFECTS, EVIDENCED_BY, TESTED_BY, DEPENDS_ON, AUTHORIZED_BY, ENHANCED_BY.

## Canonical schema
Each node: `id`, `type`, `name`, `description`, `source_status`, `confidence`, `evidence_ids`.
Each edge: `from`, `type`, `to`, `directness`, `source_status`, `confidence`, `evidence_ids`.

## Export formats
1. Markdown graph index for readers.
2. Fenced YAML or JSON for reuse.
3. Focused Mermaid diagrams, not a single full graph.

## Rules
Use stable IDs. Never export secrets or unrestricted business data. An edge without evidence must be `Derived` or `Unverified`. Validate referential integrity, duplicate IDs, orphan nodes, and unsupported edge types before completion.
