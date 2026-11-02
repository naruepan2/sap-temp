# Impact radius analysis

## Goal
Trace a finding or proposed change across business capabilities, processes, entities, objects, interfaces, users, and operations.

## Method
1. Start from the finding, object, field, configuration, or business rule.
2. Traverse verified outbound dependencies and inbound consumers.
3. Add capability/process/entity/configuration links from the catalogs.
4. Separate direct, indirect, dynamic, configuration-driven, and unverified impact.
5. Assess data population, historical data, batch jobs, interfaces, forms, reports, variants, authorizations, and operational procedures.
6. Stop at profile boundaries and mark unresolved frontier nodes.

## Matrix
`Impact ID | Finding/change | Capability | Process | Object/component | Entity/table | Integration/job/form | User role | Impact type | Directness | Severity | Evidence | Required validation`

## Impact types
Functional behavior, data integrity, interface contract, authorization, performance, scheduling, reporting, audit/compliance, configuration, support/operations, and regression.

Never treat text-search hits as confirmed consumers. Label `LIVE_REFERENCE`, `SOURCE_REFERENCE`, `TEXT_HIT`, `CONFIG_REFERENCE`, or `UNVERIFIED_NAME_MATCH`.
