# Document intent

## Supported intents
- `reverse_engineering_report`
- `functional_specification`
- `technical_specification`
- `support_handbook`
- `impact_assessment`
- `migration_specification`
- `test_design`
- `knowledge_base`

If the user does not specify an intent, use `reverse_engineering_report` with functional and technical reader paths.

## Emphasis
- Functional specification: actors, capabilities, processes, inputs/outputs, rules, exceptions, lifecycle, confirmations, acceptance scenarios.
- Technical specification: architecture, objects, call paths, data model, algorithms, persistence, LUW, locks, authorization, dependencies, performance.
- Support handbook: operations, configuration, messages, troubleshooting, jobs/interfaces, escalation.
- Impact assessment: change, direct/indirect impact, consumers, configuration, regression and release risk.
- Test design: confirmed rules, inputs, expected outcomes, cases, observations, safe stops, evidence.

Record the chosen intent in document control and use the matching report structure. Do not create one oversized document that fully implements every intent.
