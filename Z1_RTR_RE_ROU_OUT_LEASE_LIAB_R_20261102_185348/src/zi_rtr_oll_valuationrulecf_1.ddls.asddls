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
define view entity ZI_RTR_OLL_ValuationRuleCF_1
  as select from ZI_RTR_OLL_ValuationRuleCF_0 as ValuationRuleCF_0
{
  key ValuationRuleCF_0.CompanyCode,

  key ValuationRuleCF_0.RealEstateContract,

      ValuationRuleCF_0.InternalRealEstateNumber,

      substring( ValuationRuleCF_0.ValuationObject, 23, 32 ) as HexREValuationRuleUUID,

      substring( ValuationRuleCF_0.ValuationObject, 55, 32 ) as HexREValuationProcessUUID
}
