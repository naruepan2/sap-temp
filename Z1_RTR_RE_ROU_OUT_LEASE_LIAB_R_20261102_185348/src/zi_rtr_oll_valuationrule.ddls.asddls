/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 18.02.2026
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
@EndUserText.label: 'ZI_RTR_OLL_ValuationRule'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ValuationRule
  as select from ZI_RTR_OLL_ValuationRuleCF_2 as ValuationRuleCF_2
{
  key ValuationRuleCF_2.CompanyCode,

  key ValuationRuleCF_2.RealEstateContract,

      ValuationRuleCF_2.InternalRealEstateNumber,

      ValuationRuleCF_2.REValuationRuleUUID,

      ValuationRuleCF_2.REValuationProcessUUID,

      ValuationRuleCF_2._REValuationProcessStep,
      ValuationRuleCF_2._REValuationRule
}
