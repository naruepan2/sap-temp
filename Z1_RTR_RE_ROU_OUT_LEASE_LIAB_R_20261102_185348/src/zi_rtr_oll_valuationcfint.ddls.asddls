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
// 20/07/2026 | GSDK922121 | NW001 | Naruepan W. | Change formular of AmountInCompanyCodeCurrency
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Valuation Cashflow Interest'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ValuationCFInt
  as select from ZI_RTR_OLL_ValuationCFInt_0 as ValuationCFInt_0
{
  key ValuationCFInt_0.CompanyCode,

  key ValuationCFInt_0.RealEstateContract,

  key ValuationCFInt_0.CalculationYear,

  key ValuationCFInt_0.CalculationMonth,

      ValuationCFInt_0.REConditionCurrency,

      @Semantics: { amount : {currencyCode: 'REConditionCurrency'} }
      sum( ValuationCFInt_0.REConditionAmount ) as AmountInRECondition,

      ValuationCFInt_0.CompanyCodeCurrency,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      // NW001(-)
      //      cast(
      //        round( cast(
      //                sum( ValuationCFInt_0.AmountInCompanyCodeCurrency * -1 )
      //               as bapicurext
      //        ), 2 )
      //      as fis_hsl )                              as AmountInCompanyCodeCurrency,
      // NW001(-)
      // NW001(+)
      cast(
        sum( ValuationCFInt_0.AmountInCompanyCodeCurrency_2 * -1 )
      as fis_hsl )                              as AmountInCompanyCodeCurrency
      // NW001(+)
}

group by
  ValuationCFInt_0.CompanyCode,
  ValuationCFInt_0.RealEstateContract,
  ValuationCFInt_0.CalculationYear,
  ValuationCFInt_0.CalculationMonth,
  ValuationCFInt_0.REConditionCurrency,
  ValuationCFInt_0.CompanyCodeCurrency
