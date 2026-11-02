# Data handling and redaction

## Classes
`Public metadata`, `Internal technical metadata`, `Business-sensitive`, `Personal data`, `Secret/credential`, `Restricted operational data`.

## Rules
- Never expose passwords, tokens, secrets, private keys, or credentials.
- Redact personal identifiers, emails, partner data, sensitive paths/endpoints, and configuration values unless essential and explicitly permitted.
- Use masked or synthetic examples.
- Do not export bulk table contents.
- Record that a sensitive field/value exists without reproducing it.
- Preserve only evidence necessary for the finding.

## Review
Before delivery scan reports, fenced blocks, diagrams, logs, YAML/JSON exports, and examples. Record `DATA_REDACTION_REVIEW_PASSED` or fail validation.
