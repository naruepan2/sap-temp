/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 09.02.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK911054
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
// 20/07/2026 | GSDK922121 | NW001 | Naruepan W. | Change CDS source to adjust difference amount when
//                                                 currency is foreign currency
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'Outstanding Lease Liability and Defer Interest Report - Grouping by TP for GR'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

define view entity ZI_RTR_OLL_ByTP
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  //  as select from ZI_RTR_ROU_OutLeaseLiabRep(                                    // NW001(-)
  //                   P_CompanyCode: $parameters.P_CompanyCode,                    // NW001(-)
  //                   P_KeyDate: $parameters.P_KeyDate ) as OutLeaseLiabRep        // NW001(-)
  as select from ZI_RTR_OLL_BYTP_0(                                                 // NW001(+)
                   P_CompanyCode : $parameters.P_CompanyCode,                       // NW001(+)
                   P_KeyDate     : $parameters.P_KeyDate) as OutLeaseLiabRep        // NW001(+)

{
  key OutLeaseLiabRep.CompanyCode,
  key OutLeaseLiabRep.TradingPartner,
  key OutLeaseLiabRep.Type,
  key OutLeaseLiabRep.TypeGroup,

      OutLeaseLiabRep.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.LessThan1Year)
        as ze_rtr_oll_lessthan1year
      ) as LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.Between1And2Year)
        as ze_rtr_oll_between1and2year
      ) as Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.Between2And5Year)
        as ze_rtr_oll_between2and5year
      ) as Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.Between5And10Year)
        as ze_rtr_oll_between5and10year
      ) as Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.Between10And15Year)
        as ze_rtr_oll_between10and15year
      ) as Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.GreaterThan15Year)
        as ze_rtr_oll_greaterthan15year
      ) as GreaterThan15Year,

      @EndUserText.label: 'Interest Rate Min'
      cast(
        min(OutLeaseLiabRep.REInterestRate)
        as ze_receinterestrate
      ) as MinREInterestRate,

      @EndUserText.label: 'Interest Rate Max'
      cast(
        max(OutLeaseLiabRep.REInterestRate)
        as ze_receinterestrate
      ) as MaxREInterestRate,

      OutLeaseLiabRep._CompanyCode,
      OutLeaseLiabRep._CompanyCodeCurrency,
      OutLeaseLiabRep._Globalcompany,
      OutLeaseLiabRep._Type,
      OutLeaseLiabRep._TypeGroup
}

group by
  OutLeaseLiabRep.CompanyCode,
  OutLeaseLiabRep.TradingPartner,
  OutLeaseLiabRep.Type,
  OutLeaseLiabRep.TypeGroup,
  OutLeaseLiabRep.CompanyCodeCurrency
