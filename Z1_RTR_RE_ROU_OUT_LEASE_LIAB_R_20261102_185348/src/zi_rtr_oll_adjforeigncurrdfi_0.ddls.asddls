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

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_ADJFOREIGNCURRDFI_0
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_ROU_OutLeaseLiabRep_Tmp(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as OutLeaseLiabRep

{
  key OutLeaseLiabRep.CompanyCode,
  key OutLeaseLiabRep.RealEstateContract,
  key OutLeaseLiabRep.AgreementNumber,

      OutLeaseLiabRep.TradingPartner,

      OutLeaseLiabRep.CompanyCodeCurrency,

      OutLeaseLiabRep.REContractCurrency,

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

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.GLCurrentPortion)
        as ze_glcurrentportion
      ) as GLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(OutLeaseLiabRep.GLLongTerm)
        as ze_gllongterm
      ) as GLLongTerm,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(coalesce(OutLeaseLiabRep.GLCurrentPortion, cast(0 as ze_glcurrentportion)) -
            coalesce(OutLeaseLiabRep.LessThan1Year, cast(0 as ze_diffglcurrentportion)))
        as ze_glcurrentportion
      ) as DiffGLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(coalesce(OutLeaseLiabRep.GLLongTerm, cast(0 as ze_glcurrentportion)) -
            (coalesce(OutLeaseLiabRep.Between1And2Year, cast(0 as ze_diffgllongterm)) +
             coalesce(OutLeaseLiabRep.Between2And5Year, cast(0 as ze_diffgllongterm)) +
             coalesce(OutLeaseLiabRep.Between5And10Year, cast(0 as ze_diffgllongterm)) +
             coalesce(OutLeaseLiabRep.Between10And15Year, cast(0 as ze_diffgllongterm)) +
             coalesce(OutLeaseLiabRep.GreaterThan15Year, cast(0 as ze_diffgllongterm))))
        as ze_diffgllongterm
      ) as DiffGLLongTerm,

      OutLeaseLiabRep._CompanyCode,
      OutLeaseLiabRep._CompanyCodeCurrency,
      OutLeaseLiabRep._Globalcompany
}

where
       OutLeaseLiabRep.CompanyCodeCurrency <> OutLeaseLiabRep.REContractCurrency
  and(
       OutLeaseLiabRep.Type                =  'L'
    or OutLeaseLiabRep.Type                =  'D'
  )

group by
  OutLeaseLiabRep.CompanyCode,
  OutLeaseLiabRep.RealEstateContract,
  OutLeaseLiabRep.AgreementNumber,
  OutLeaseLiabRep.TradingPartner,
  OutLeaseLiabRep.CompanyCodeCurrency,
  OutLeaseLiabRep.REContractCurrency
