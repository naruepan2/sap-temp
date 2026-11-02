# Business entity discovery

## Goal
Explain what persistent and transient data means to the business, how it is identified, created, changed, consumed, and governed.

## Candidate sources
Transparent tables, CDS entities, structures, table types, RAP entities, BAPI/interface structures, ALV output tables, text tables, domain fixed values, status constants, document keys, and configuration tables.

## Entity workflow
1. Discover data objects and classify as master, transaction, history, configuration, worklist, output, interface, or technical.
2. Infer a business name from labels, DDIC texts, relationships, messages, and usage; mark inference explicitly.
3. Identify keys, foreign/reference fields, dates, quantities, currencies, units, statuses, audit fields, and retention clues.
4. Map create/read/update/delete consumers and transaction boundaries.
5. Reconstruct lifecycle/status transitions and invariants.
6. Record sensitive fields, personal data, authorization relevance, and unresolved semantics.

## Catalog template
`Entity ID | Business name | Physical object | Type | Purpose | Keys | Parent/child | Created by | Updated by | Read by | Status lifecycle | Retention | Sensitivity | Evidence | Confidence`

## Field mapping template
`Entity | Business field | Technical field | Type/domain | Meaning | Source | Transformation | Output/consumer | Rule status | Evidence`

## Rules
Never equate a table name with business meaning without evidence. Distinguish current-state, history, staging, and log entities. Flag update paths that bypass locking, validation, or coherent LUW boundaries.
