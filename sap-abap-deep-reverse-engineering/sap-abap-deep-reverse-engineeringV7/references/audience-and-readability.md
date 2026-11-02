# Audience and readability

Use progressive disclosure: business meaning first, technical evidence second, large inventories in appendices.

Expand acronyms on first use. Pair business labels with technical names, for example `Company Code (P_BUKRS)`. Translate status codes only when evidence exists. Add `Why this matters` to every material finding.

Separate rules as `Approved`, `Observed`, `Inferred`, or `Unverified`.

## Intent-sensitive writing
Adjust emphasis to the recorded document intent. Functional specifications lead with process/rules/acceptance; technical specifications lead with architecture/data/LUW; support handbooks lead with operation/configuration/troubleshooting; impact assessments lead with change radius and regression.

Every material finding needs:
- Business explanation: expected, actual, user impact, sanitized example
- Technical explanation: object, call path, location, fields/formula, evidence, confidence, human correction target

Include a glossary and technical-object map. Review the report once as a functional reader and once as a developer; revise if either cannot continue without missing context.
