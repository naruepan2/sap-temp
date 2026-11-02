/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 10.02.2026
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
@EndUserText.label: 'Valuation Rule Cashflow'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ValuationRuleCF_0
  as select from ZI_REContractData         as REContract

    inner join   ZI_REValuationRule        as REValuationRule        on REValuationRule.InternalRealEstateNumber = REContract.InternalRealEstateNumber

    inner join   ZI_REValuationProcessStep as REValuationProcessStep on  REValuationProcessStep.InternalRealEstateNumber = REValuationRule.InternalRealEstateNumber
                                                                     and REValuationProcessStep.REValuationRuleUUID      = REValuationRule.REValuationRuleUUID
{
  key REContract.CompanyCode,

  key REContract.RealEstateContract,

      REContract.InternalRealEstateNumber,

      max(
        concat(
          REValuationProcessStep.REConsiderationStartDate,
          concat(
            REValuationProcessStep.CreationDate,
            concat(
              REValuationProcessStep.CreationTime,
              concat(
                bintohex( REValuationRule.REValuationRuleUUID ),
                bintohex( REValuationProcessStep.REValuationProcessUUID )
              )
            )
          )
        )
      )                                                                          as ValuationObject,

      max( substring( bintohex( REValuationRule.REValuationRuleUUID ), 1, 32 ) ) as MaxREValuationRuleUUID
}

where
  REValuationRule.REValuationRule like 'ZROU%'

group by
  REContract.CompanyCode,
  REContract.RealEstateContract,
  REContract.InternalRealEstateNumber
