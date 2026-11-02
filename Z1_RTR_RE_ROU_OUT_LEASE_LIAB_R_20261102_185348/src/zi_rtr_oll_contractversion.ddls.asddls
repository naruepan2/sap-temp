/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 19.02.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK911054
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Version'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ContractVersion
  as select from ZI_REValuationProcessStep as REValuationProcessStep

    join         ZI_REValuationRule        as REValuationRule on  REValuationRule.InternalRealEstateNumber = REValuationProcessStep.InternalRealEstateNumber
                                                              and REValuationRule.REValuationRuleUUID      = REValuationProcessStep.REValuationRuleUUID

{
  key REValuationProcessStep.InternalRealEstateNumber,

      count(
        distinct
          concat(
            REValuationProcessStep.REConsiderationStartDate,
            concat(
              REValuationProcessStep.CreationDate,
              REValuationProcessStep.CreationTime
            )
          )
        ) as Version
}

where
  REValuationRule.REValuationRule like 'ZROU%'

group by
  REValuationProcessStep.InternalRealEstateNumber
