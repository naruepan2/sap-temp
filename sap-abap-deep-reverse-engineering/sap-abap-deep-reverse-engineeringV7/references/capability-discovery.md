# Business capability and process discovery

## Goal
Translate technical modes and objects into business capabilities that functional readers can understand, without inventing process ownership or requirements.

## Discovery method
1. Identify user entry points, mode labels, messages, forms, outputs, transactions, and business nouns.
2. Cluster related actions into a candidate process.
3. Cluster processes that deliver one business outcome into a candidate capability.
4. Search source metadata, texts, documentation, and configuration for names and ownership.
5. Classify each attribute as `Approved`, `Observed`, `Inferred`, or `Unverified`.
6. Ask for functional confirmation when capability names, owners, upstream/downstream processes, or intended outcomes are inferred.

## Capability catalog template
`Capability ID | Name | Purpose | Business outcome | Process area | Owner | Upstream | Downstream | Processes | Technical objects | Findings/risks | Evidence | Confidence`

## Process catalog template
`Process ID | Capability ID | Trigger | Actor | Preconditions | Inputs | Main steps | Decisions | Outputs | Exceptions | Status changes | Side effects | Objects | Evidence`

## Rules
- Do not use radio-button names as final capability names unless they describe a business outcome.
- Separate user-visible process steps from implementation calls.
- One mode may support multiple capabilities; one capability may span multiple programs.
- Every capability must connect to at least one process and one technical object, or be marked `UNMAPPED`.

## Diagrams
Create one business capability map and one end-to-end business flow when evidence exists. Use business labels and provide a text walkthrough.
