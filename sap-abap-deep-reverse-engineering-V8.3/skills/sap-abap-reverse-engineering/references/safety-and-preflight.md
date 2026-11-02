# Safety and Preflight

## SAP safety
Only observational operations with known side-effect-free behavior are allowed: repository/source/metadata read, version read, definition and reference navigation, where-used, dependency/impact query, and non-persisting diagnostics.

Classify each tool capability before use:
- `SAFE_READ`: known read-only. Invoke.
- `PROHIBITED_WRITE`: create, change, delete, rename, format, refactor, activate, transport, publish, configure, upload; table or customizing updates; job, service, user, or role changes; runtime execution of business processing; persisted traces. Never invoke.
- `UNKNOWN`: side effects not known. Do not invoke. Never probe whether a write would be blocked.

Stop if an operation may activate, modify, transport, post, schedule, lock, or execute business processing.

## Mandatory identity gate
Before the first repository call, resolve: system/destination/connection, client when applicable, root object and type, objective, output language, and output path when files are produced. Collect missing items in the single batched intake (see `intake-and-modes.md`).

- If the session already identifies the system (user supplied a connection or destination, or chat shows a connected system), reuse it and do not ask again.
- If no system is identified, ask once for the connection ID or destination and wait.
- Never infer a system from object names, SIDs embedded in source, connection counts, unrelated tool output, earlier projects, or prior conversations not carried into the current scope.
- Never bypass a denial.

## Toolchain verification
Verify the toolchain you will actually use with one lightweight `SAFE_READ`. One working connector does not prove another works.

| Toolchain | List connected systems | Light `SAFE_READ` examples |
|---|---|---|
| ABAP FS | `abapfs_get_connected_systems` | `abapfs_get_object_info` |
| ADT MCP | `mcp_adt_mcp_serve_abap_destination_list` | `abap_repository_search_object` |
| Other connector (for example ARC-1) | discover from the tool list | pick one read-only lookup, classify it first |

Do not store verified connection IDs in this skill or its references. The connected-system list comes from the live session each time. On verification failure, stop and report; do not continue with another toolchain unless the user confirms the system.

## New object creation gate
Reverse engineering never creates or changes SAP repository objects. If the user switches intent to creating a package, program, class, function module, CDS, service, or other object, stop this workflow and hand off to a development workflow with an explicit write/change gate.

## Local workspace
Creating or updating the requested Markdown and local folders is allowed. If the output path is unknown and files are required, ask before long analysis. If writing is unavailable, return the complete Markdown and state that no file was created.

## Data handling and redaction
Classes: public metadata, internal technical metadata, business-sensitive, personal data, secret/credential, restricted operational data.

Rules:
- Never expose passwords, tokens, secrets, private keys, or credentials.
- Redact personal identifiers, emails, partner data, bank or payment account values, sensitive paths/endpoints, and configuration values unless essential and explicitly permitted.
- Use masked or synthetic examples. Do not export bulk table contents.
- Record that a sensitive field or value exists without reproducing it.
- Keep only the evidence necessary for the finding.
- Before delivery, scan reports, fenced blocks, diagrams, logs, YAML/JSON, and examples. Record `DATA_REDACTION_REVIEW_PASSED` or fail validation.
