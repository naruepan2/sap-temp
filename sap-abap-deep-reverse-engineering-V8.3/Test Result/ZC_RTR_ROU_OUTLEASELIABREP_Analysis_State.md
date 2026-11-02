# Analysis State — ZC_RTR_ROU_OutLeaseLiabRep (checkpoint Phase 5)

```yaml
scope:
  root: ZC_RTR_ROU_OutLeaseLiabRep (DDLS/DF)
  system: GSD_120_Z0012353_EN
  client: 120
  package: Z1_RTR_RE_ROU_OUT_LEASE_LIAB_R  # discovered via TADIR search, not supplied
  objective: Full as-is understanding
  profile: extended
  output_mode: FUNCTIONAL_SPEC
  document_intent: functional_specification
  exclusions:
    - EX-01: standard SAP internals (I_*, VIC*, TIV*, E_REContract) as BOUNDARY_STANDARD
    - EX-02: live data preview blocked (allowDataPreview=false)
    - EX-03: ZI_RTR_ROU_OUTLEASELIABREP_TP missing from TADIR (unresolved)
baseline:
  timestamp: 2026-11-02 23:23:17 UTC
  fingerprint_method: PARTIAL (header TRs GSDK911054+GSDK918255+GSDK922121; 346-line root; active version)
  compatibility: BASELINE_PARTIAL
nodes_unique: 71
edges_unique: 96
max_depth: 11
table_functions_resolved: 2/2 (CONTRACTGENERLAPCP via ZCL_RTR_OLL_CONTRACTGENERLAPCP; CNNoInstallmentTF via ZCL_RTR_CNNOINSTALLMENTTF)
dcl_read: 5/5
union_branches: 3/3 (L/D/AP-CP)
critical_fields_lineaged: 22/22
findings: [F-01, F-02, F-03, F-04, F-05, F-06, F-07, F-08, F-09, F-10]
confirmation_queue: [CQ-01, CQ-02, CQ-03, CQ-04, CQ-05, CQ-06, CQ-07, CQ-08, CQ-09, CQ-10]
runtime_handoffs: [RTC-01, RTC-02, RTC-03, RTC-04, RTC-05 (RTC-05 in FS §14 F-07)]
unresolved_frontier:
  - ZI_RTR_ROU_OUTLEASELIABREP_TP (service-declared, TADIR miss)
  - Config row values + domain values (preview blocked)
  - Role effectiveness + release state (no trace)
completion_status: STATIC_DEEP_COMPLETE_WITH_LIMITATIONS
document_status: DRAFT_PENDING_FUNCTIONAL_CONFIRMATION
artifacts:
  - C:\Users\narue\Desktop\New folder (4)\ZC_RTR_ROU_OUTLEASELIABREP_Functional_Specification.md
validation: REPORT_VALIDATION_PASSED_WITH_WARNINGS (template-driven multiple H1; fences balanced; IDs stable; coverage recomputed; redaction passed)
```
