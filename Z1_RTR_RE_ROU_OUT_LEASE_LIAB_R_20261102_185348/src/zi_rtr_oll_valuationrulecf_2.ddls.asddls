/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 11.02.2026
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
define view entity ZI_RTR_OLL_ValuationRuleCF_2
  as select from ZI_RTR_OLL_ValuationRuleCF_1 as ValuationRuleCF_1

  association [1..1] to ZI_REValuationRule        as _REValuationRule        on  $projection.InternalRealEstateNumber = _REValuationRule.InternalRealEstateNumber
                                                                             and $projection.REValuationRuleUUID      = _REValuationRule.REValuationRuleUUID

  association [1..1] to ZI_REValuationProcessStep as _REValuationProcessStep on  $projection.InternalRealEstateNumber = _REValuationProcessStep.InternalRealEstateNumber
                                                                             and $projection.REValuationRuleUUID      = _REValuationProcessStep.REValuationRuleUUID
                                                                             and $projection.REValuationProcessUUID   = _REValuationProcessStep.REValuationProcessUUID
{
  key ValuationRuleCF_1.CompanyCode,

  key ValuationRuleCF_1.RealEstateContract,

      ValuationRuleCF_1.InternalRealEstateNumber,

      hextobin( ValuationRuleCF_1.HexREValuationRuleUUID )    as REValuationRuleUUID,

      hextobin( ValuationRuleCF_1.HexREValuationProcessUUID ) as REValuationProcessUUID,

      _REValuationRule,
      _REValuationProcessStep
}
