# Logon gate - mandatory before any SAP call

Session has system (user gave connectionId/destination, or chat shows connected system): reuse it, never re-ask. Verify toolchain in use - one working does not prove the other:
- ABAP FS: `abapfs_get_connected_systems` + one light SAFE_READ (e.g. `abapfs_get_object_info`).
- ADT MCP: `mcp_adt_mcp_serve_abap_destination_list` + one light SAFE_READ (e.g. `abap_repository_search_object`).

Verified live: ABAP FS `gc_s4d110, luf_dev_900`; ADT MCP `GSD_120_Z0012353_EN, GSD_110_Z0012353_EN` (2026-11-01). No system in chat: ask once for connectionId/destination and wait. Never infer from SID/counts/tool output or bypass denials. No other SAP tool until resolved and verified. On failure stop and report.
