# Safety policy

## SAP
Only observational operations with known side-effect-free behavior are allowed: repository/source/metadata read, version read, definition/reference navigation, where-used, dependency/impact query, and non-persisting diagnostics.

Classify each capability as `SAFE_READ`, `PROHIBITED_WRITE`, or `UNKNOWN`. Invoke only `SAFE_READ`. Never probe whether a write would be blocked.

Prohibited actions include create/change/delete/rename/format/refactor/activate/transport/publish/configure/upload, table or customizing updates, job/service/user/role changes, runtime execution, and persisted traces.

## Local workspace
Creating/updating the requested Markdown and local folders is allowed. If the path is unknown, ask once before long analysis. If writing is unavailable, return the complete Markdown and state that no file was created.
