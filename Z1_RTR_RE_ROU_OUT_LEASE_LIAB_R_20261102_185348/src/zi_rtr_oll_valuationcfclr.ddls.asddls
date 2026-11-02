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
@EndUserText.label: 'Valuation Cashflow Clearing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ValuationCFClr
  as select from ZI_RTR_OLL_ValuationCFClr_0 as ValuationCFClr_0
{
  key ValuationCFClr_0.CompanyCode,

  key ValuationCFClr_0.RealEstateContract,

  key ValuationCFClr_0.CalculationYear,

  key ValuationCFClr_0.CalculationMonth,

      ValuationCFClr_0.CompanyCodeCurrency,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      cast(
        sum( ValuationCFClr_0.AmountInCompanyCodeCurrency )
        as fis_hsl
      ) as AmountInCompanyCodeCurrency
}

group by
  ValuationCFClr_0.CompanyCode,
  ValuationCFClr_0.RealEstateContract,
  ValuationCFClr_0.CalculationYear,
  ValuationCFClr_0.CalculationMonth,
  ValuationCFClr_0.CompanyCodeCurrency
