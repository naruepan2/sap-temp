# CDS Discovery Strategy

## Purpose
Discover CDS dependencies completely enough for reliable reverse engineering without re-reading the same object for every repeated dependency-tree occurrence. This reference governs CDS discovery only; general reverse-engineering behavior remains unchanged.

## 1. Discovery model
Treat repository discovery as a directed property graph.

### Node classes
- Repository object: CDS view/view entity/projection/custom entity/table function, table, DCL, metadata extension, service definition/binding, ABAP class/method.
- Structural node: SELECT, UNION, UNION ALL, subquery, branch marker. Structural nodes keep context but are excluded from object coverage.
- Candidate node: inferred by naming, package, annotation, or search but not yet source-confirmed.

### Edge classes
FROM, JOIN, ASSOCIATION, COMPOSITION, PROJECTION, UNION_BRANCH, TABLE_FUNCTION_IMPLEMENTATION, AUTHORIZATION, SERVICE_EXPOSURE, WHERE_USED, and INFERRED_RELATED.

## 2. Canonical identity
Use this precedence:
1. Repository type + CDS entity name.
2. Repository type + resolved repository object name.
3. Repository type + SQL name fallback.

Normalize for matching only:
- case-insensitive comparison;
- unescape `\\_` to `_`;
- trim whitespace and quoting;
- retain original SQL name, entity name, and database object as aliases;
- do not merge different object types solely because names match.

Canonical key example:
`<system>|<object_type>|<normalized_entity_or_repository_name>`

## 3. Required registries

### Node registry
Record canonical key, aliases, type, package, first/minimum depth, occurrence count, parent/child counts, branch contexts, source status, source hash/fingerprint, access-control status, evidence IDs, priority, and unresolved reason.

### Edge registry
Record parent key, child key, relation type, branch ID, source location when available, evidence source, confidence, and occurrence count.

### Retrieval registry
Record requested tool, result, timestamp, bytes/lines read, truncation, retry count, and cache key. Read a canonical source once unless its fingerprint changes or a targeted field-lineage gap requires a second bounded read.

## 4. Four-pass workflow

### Pass 1 - Structural discovery
Collect identities, types, relations, depths, parameters, access-control indicators, and failures. Do not infer business meaning yet.

### Pass 2 - Normalize and deduplicate
Create canonical nodes and unique edges. Preserve occurrence counts and all branch/path context. Detect cycles and shared foundations.

### Pass 3 - Prioritized retrieval
Rank nodes using root proximity, custom-object weight, transformation weight, fan-in/fan-out, critical-field contribution, security relevance, table-function status, unresolved penalties, and objective relevance.

Mandatory deep-read candidates:
- root/consumption/interface/core calculation objects;
- custom Z/Y objects on critical paths;
- UNION/CASE/aggregation/currency-conversion layers;
- CDS table functions and implementing AMDP;
- DCL for critical exposed objects;
- query providers/custom entities and service exposure when applicable.

Usually inventory-first candidates:
- base tables without transformation logic;
- repeated standard master/text wrappers;
- low-relevance upstream consumers outside frozen scope.

### Pass 4 - Gap closure
Trace backward from every critical output/measure and forward from every unresolved high-priority node. Close missing source, field lineage, table-function implementation, DCL, branch, and service-exposure gaps. Stop only through the stop conditions below.

## 5. Table-function resolution
For every CDS table function:
1. Read its CDS definition and parameters.
2. Resolve the implementing class and method.
3. Read AMDP SQLScript using SAFE_READ.
4. Add SQLScript-discovered tables/views as evidence-backed graph edges.
5. Capture client handling, parameter mapping, filtering, aggregation, window logic, and fallback behavior.
6. Mark `resolved` only after implementation analysis; otherwise record explicit blocker.

## 6. Direction and scope
- Downstream lineage: exhaustive within configured safety budget and critical paths.
- Upstream where-used: bounded by objective, object type, package/system boundary, depth, and node budget.
- Context candidates: separate from confirmed scope and never counted as confirmed dependencies.

Do not silently enlarge frozen scope. Place out-of-scope consumers in impact candidates.

## 7. Evidence and confidence
Edge evidence levels:
- CONFIRMED_SOURCE: parsed directly from source.
- CONFIRMED_REPOSITORY: returned by repository dependency/where-used metadata.
- CORROBORATED: supported by two independent discovery methods.
- CANDIDATE: naming/package/annotation inference only.
- UNRESOLVED: expected relation cannot be verified.

Business meaning must not be marked confirmed solely from technical naming.

## 8. Coverage denominators
Never divide by raw dependency occurrences. Report separately:
- unique canonical object coverage;
- unique edge coverage;
- critical-path source coverage;
- critical-field lineage coverage;
- table-function implementation coverage;
- DCL/access-control coverage;
- branch coverage;
- unresolved high-priority count.

## 9. Stop conditions
A CDS discovery scope is sufficient only when:
- all critical outputs have an evidence-backed path to source;
- unresolved high-priority nodes = 0, or each has an explicit blocker and impact;
- critical table functions are 100% resolved or explicitly blocked;
- all UNION branches on critical paths are represented;
- configured critical-path threshold is met;
- registry and artifact validation pass;
- the stop reason is recorded.

Depth/node/token budgets may force `STATIC_DEEP_PARTIAL`; they must never be presented as completion.

## 10. Minimum report section
Include:
- root and frozen scope;
- raw occurrences vs unique nodes/edges;
- maximum observed depth;
- source-read status by object type/priority;
- highest fan-in/fan-out shared nodes;
- unresolved and intentionally skipped objects;
- table-function and DCL resolution;
- critical paths and branch coverage;
- discovery stop reason and limitations.
