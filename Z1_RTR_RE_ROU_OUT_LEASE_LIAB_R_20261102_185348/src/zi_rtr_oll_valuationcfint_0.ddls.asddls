/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 12.02.2026
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
@EndUserText.label: 'Valuation Cashflow: Interest'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ValuationCFInt_0
  as select from ZI_RTR_OLL_ValuationRuleCF as ValuationRuleCF
{
  key ValuationRuleCF.CompanyCode,

  key ValuationRuleCF.RealEstateContract,

  key ValuationRuleCF.REValuationCashFlowRecordUUID,

      ValuationRuleCF.RECashFlowType,

      ValuationRuleCF.CalculationPeriodStartDate,

      ValuationRuleCF.CalculationPeriodEndDate,

      ValuationRuleCF.PaymentDueDate,

      @Semantics.amount.currencyCode: 'REConditionCurrency'
      ValuationRuleCF.REConditionAmount,

      ValuationRuleCF.REConditionCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //      cast(
      //        case
      //          when ValuationRuleCF.DebitCreditCode = 'S'
      //          then ValuationRuleCF.AmountInCompanyCodeCurrency * -1
      //          else ValuationRuleCF.AmountInCompanyCodeCurrency
      //        end
      //        as fis_hsl
      //      ) as AmountInCompanyCodeCurrency,

      cast(
        case
          when ValuationRuleCF.DebitCreditCode = 'S'
          then ValuationRuleCF.AmountInCompanyCodeCurrency * -1
          else ValuationRuleCF.AmountInCompanyCodeCurrency
        end
        as bapicurext
      )                                                                      as AmountInCompanyCodeCurrency,

      // NW001(+)
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast( round( $projection.AmountInCompanyCodeCurrency, 2 ) as fis_hsl ) as AmountInCompanyCodeCurrency_2,
      // NW001(+)

      ValuationRuleCF.CompanyCodeCurrency,

      cast(
        substring( ValuationRuleCF.PaymentDueDate, 1, 4 )
        as ze_year
      )                                                                      as CalculationYear,

      cast(
        substring( ValuationRuleCF.PaymentDueDate, 5, 2 )
        as ze_month
      )                                                                      as CalculationMonth
}

where
  (
    ValuationRuleCF.RECashFlowType = '3'
  )
