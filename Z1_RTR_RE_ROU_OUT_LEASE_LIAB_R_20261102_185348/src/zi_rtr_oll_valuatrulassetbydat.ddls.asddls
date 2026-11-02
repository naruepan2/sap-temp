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

define view entity ZI_RTR_OLL_VALUATRULASSETByDat
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_VALUATIONRULASSET_0 as ValuationRuleCF

{
  key CompanyCode,
  key RealEstateContract,
      max( PostingDate ) as PostingDate
}
where
  PostingDate <= $parameters.P_KeyDate
group by
  CompanyCode,
  RealEstateContract
