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

@EndUserText.label: 'Outstanding Lease Liability - Grouping by TP for GR'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_ADJFOREIGNCURRDFI_1
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_OLL_ADJFOREIGNCURRDFI_0(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as AdjForeignCurr_0

{
  key CompanyCode,
  key RealEstateContract,
  key AgreementNumber,

      TradingPartner,
      CompanyCodeCurrency,
      REContractCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      GreaterThan15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      GLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      GLLongTerm,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      DiffGLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      DiffGLLongTerm,

      cast(
        case
            when AdjForeignCurr_0.Between1And2Year <> 0
                then '1'
           when AdjForeignCurr_0.Between2And5Year <> 0
                then '2'
           when AdjForeignCurr_0.Between5And10Year <> 0
                then '3'
           when AdjForeignCurr_0.Between10And15Year <> 0
                then '4'
           when AdjForeignCurr_0.GreaterThan15Year <> 0
                then '5'
           else '6'
       end
       as abap.char(1)
      ) as DiffGLLongTermCondition,

      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}

// Allow tolerance between -1 to 1 only to avoid huge diffenence amount
where
      DiffGLCurrentPortion between cast( - 1 as ze_glcurrentportion ) and cast( 1 as ze_glcurrentportion )
  and DiffGLLongTerm       between cast( - 1 as ze_diffgllongterm ) and cast( 1 as ze_diffgllongterm )
