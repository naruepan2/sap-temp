/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 15.07.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK922121
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Valuation Cashflow: Interest'

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_VALUATIONRULASSET_1
  with parameters
    P_KeyDate : datum

  as select from ZI_RTR_OLL_VALUATIONRULASSET_0       as ValuationRuleCF

    inner join   ZI_RTR_OLL_VALUATRULASSETByDat(
                   P_KeyDate : $parameters.P_KeyDate) as ValuationRuleByDate on  ValuationRuleCF.CompanyCode        = ValuationRuleByDate.CompanyCode
                                                                             and ValuationRuleCF.RealEstateContract = ValuationRuleByDate.RealEstateContract
                                                                             and ValuationRuleCF.PostingDate        = ValuationRuleByDate.PostingDate

{
  key ValuationRuleCF.CompanyCode,
  key ValuationRuleCF.RealEstateContract,
      max( bintohex( ValuationRuleCF.REValuationRuleRecordUUID ) )     as REValuationRuleRecordUUID,
      max( bintohex( ValuationRuleCF.REValuationProcessRecordUUID ) )  as REValuationProcessRecordUUID,
      max( bintohex( ValuationRuleCF.REValuationCashFlowRecordUUID ) ) as REValuationCashFlowRecordUUID,

      ValuationRuleCF.PostingDate
}
group by
  ValuationRuleCF.CompanyCode,
  ValuationRuleCF.RealEstateContract,
  ValuationRuleCF.PostingDate
