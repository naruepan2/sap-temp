# Safety and Preflight

## SAP safety
Only execute operations explicitly classified as read-only. Stop if a tool may activate, modify, transport, post, schedule, lock, or execute business processing.

## Mandatory identity gate
Before the first repository call, resolve:
- system/destination/connection
- client if applicable
- root object/type
- objective
- output language and path

If the current session already identifies the system, reuse it and do not ask again. Verify the actual toolchain being used with one lightweight safe read. One working connector does not prove another connector works.

## New object creation gate
Reverse engineering never creates or changes SAP repository objects. If the user switches intent to creating a package, program, class, function module, CDS, service, or other SAP object, stop this workflow and hand off to a development workflow with an explicit write/change gate.

## Sensitive data
Do not place production personal data, credentials, bank details, payment account values, or confidential transactional samples into generated documentation. Use masked examples and record that redaction occurred.
