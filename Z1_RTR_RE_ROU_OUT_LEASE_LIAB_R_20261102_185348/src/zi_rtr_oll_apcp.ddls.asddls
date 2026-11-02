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
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AP-CP'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #XL
}
define view entity ZI_RTR_OLL_APCP
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_APCP_1( P_KeyDate: $parameters.P_KeyDate ) as APCP_1

  association [0..1] to ZI_RTR_OLL_ROUClass as _ROUClass on $projection.ROUClass = _ROUClass.ROUClass
{
  key APCP_1.CompanyCode,

  key APCP_1.AgreementNumber,

  key APCP_1.CalculationYear,

  key APCP_1.CalculationMonth,

      //      APCP_1.TransactionCurrency,
      //
      //      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      //      cast(
      //        sum( APCP_1.AmountInTransactionCurrency * -1 )
      //        as fis_wsl
      //      ) as AmountInTransactionCurrency,

      APCP_1.CompanyCodeCurrency,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      cast(
        sum( APCP_1.AmountInCompanyCodeCurrency * -1 )
        as fis_hsl
      ) as AmountInCompanyCodeCurrency,

      cast(
        max( APCP_1.ROUClass )
        as ze_rou_class
      ) as ROUClass,

      cast(
        max( APCP_1.IsAPInvoice )
        as ze_isapinvoice
      ) as IsAPInvoice,

      cast(
        max( APCP_1.IsActualAPInvoice )
        as ze_isactualapinvoice
      ) as IsActualAPInvoice,

      _ROUClass
}

where
      APCP_1.AgreementNumber  is not initial
//  and APCP_1.CalculationYear  is not initial
//  and APCP_1.CalculationMonth is not initial

group by
  APCP_1.CompanyCode,
  APCP_1.AgreementNumber,
  APCP_1.CalculationYear,
  APCP_1.CalculationMonth,
  //  APCP_1.TransactionCurrency,
  APCP_1.CompanyCodeCurrency
