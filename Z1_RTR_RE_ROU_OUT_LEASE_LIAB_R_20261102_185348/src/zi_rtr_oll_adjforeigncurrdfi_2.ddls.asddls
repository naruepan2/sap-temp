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

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'Outstanding Lease Liability - Grouping by TP for GR'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_ADJFOREIGNCURRDFI_2
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_OLL_ADJFOREIGNCURRDFI_1(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as AdjForeignCurr_1

{
  key AdjForeignCurr_1.CompanyCode,
  key AdjForeignCurr_1.TradingPartner,

      AdjForeignCurr_1.CompanyCodeCurrency,

      min(AdjForeignCurr_1.DiffGLLongTermCondition) as DiffGLLongTermCondition,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(AdjForeignCurr_1.DiffGLCurrentPortion)
        as ze_glcurrentportion)                     as DiffGLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(AdjForeignCurr_1.DiffGLLongTerm)
        as ze_diffgllongterm)                       as DiffGLLongTerm
}

group by
  AdjForeignCurr_1.CompanyCode,
  AdjForeignCurr_1.TradingPartner,
  AdjForeignCurr_1.CompanyCodeCurrency
