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
@EndUserText.label: 'Current Portion/LT Lease Liability by Agreement No.'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_CPLT
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_CPLT_1( P_KeyDate: $parameters.P_KeyDate ) as CPLT_1
{
  key CPLT_1.CompanyCode,

  key CPLT_1.RealEstateContract,

  key CPLT_1.Identifier,

  key CPLT_1.CalculationYear,

  key CPLT_1.CalculationMonth,

      //      CPLT_1.TransactionCurrency,
      //
      //      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      //      cast(
      //        sum( CPLT_1.AmountInTransactionCurrency * -1 )
      //        as fis_wsl
      //      ) as AmountInTransactionCurrency,

      CPLT_1.CompanyCodeCurrency,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      cast(
       sum( CPLT_1.AmountInCompanyCodeCurrency )
       as fis_hsl
      ) as AmountInCompanyCodeCurrency
}

where
  CPLT_1.RealEstateContract is not initial
//  and CPLT_1.CalculationYear    is not initial
//  and CPLT_1.CalculationMonth   is not initial

group by
  CPLT_1.CompanyCode,
  CPLT_1.RealEstateContract,
  CPLT_1.Identifier,
  CPLT_1.CalculationYear,
  CPLT_1.CalculationMonth,
  //  CPLT_1.TransactionCurrency,
  CPLT_1.CompanyCodeCurrency
