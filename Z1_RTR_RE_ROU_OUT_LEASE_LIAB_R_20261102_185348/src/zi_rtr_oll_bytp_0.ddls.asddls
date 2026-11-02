/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 20.07.2026
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

@EndUserText.label: 'Outstanding Lease Liability and Defer Interest Report - Grouping by TP for GR'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

define view entity ZI_RTR_OLL_BYTP_0
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_ROU_OutLeaseLiabRep(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as OutLeaseLiabRep

{
  key OutLeaseLiabRep.CompanyCode,
  key OutLeaseLiabRep.AgreementNumber,
  key OutLeaseLiabRep.RealEstateContract,
  key OutLeaseLiabRep.TradingPartner,
  key OutLeaseLiabRep.Type,
  key OutLeaseLiabRep.TypeGroup,

      OutLeaseLiabRep.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( OutLeaseLiabRep.LessThan1Year_2 as ze_rtr_oll_lessthan1year )           as LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( OutLeaseLiabRep.Between1And2Year_2 as ze_rtr_oll_between1and2year )     as Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( OutLeaseLiabRep.Between2And5Year_2 as ze_rtr_oll_between2and5year )     as Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( OutLeaseLiabRep.Between5And10Year_2 as ze_rtr_oll_between5and10year )   as Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( OutLeaseLiabRep.Between10And15Year_2 as ze_rtr_oll_between10and15year ) as Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( OutLeaseLiabRep.GreaterThan15Year_2 as ze_rtr_oll_greaterthan15year )   as GreaterThan15Year,

      OutLeaseLiabRep.REInterestRate,

      OutLeaseLiabRep._CompanyCode,
      OutLeaseLiabRep._CompanyCodeCurrency,
      OutLeaseLiabRep._Globalcompany,
      OutLeaseLiabRep._Type,
      OutLeaseLiabRep._TypeGroup
}
