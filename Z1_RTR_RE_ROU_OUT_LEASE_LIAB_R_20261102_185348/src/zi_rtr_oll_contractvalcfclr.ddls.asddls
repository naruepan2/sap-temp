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
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Valuation Cashflow: Clearing'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #XL
}
define view entity ZI_RTR_OLL_ContractValCFClr
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_ValuationCFClr as ValuationCFClr
{
  key ValuationCFClr.CompanyCode,

  key ValuationCFClr.RealEstateContract,

      ValuationCFClr.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) >= substring( dats_add_months( $parameters.P_KeyDate, 1, 'NULL' ), 1, 6 ) and
                 concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) <= substring( dats_add_months( $parameters.P_KeyDate, 12, 'NULL' ), 1, 6 )
            then ValuationCFClr.AmountInCompanyCodeCurrency
          end
        )
        as ze_rtr_oll_lessthan1year
      ) as LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) >= substring( dats_add_months( $parameters.P_KeyDate, 13, 'NULL' ), 1, 6 ) and
                 concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) <= substring( dats_add_months( $parameters.P_KeyDate, 24, 'NULL' ), 1, 6 )
            then ValuationCFClr.AmountInCompanyCodeCurrency
          end
        )
        as ze_rtr_oll_between1and2year
      ) as Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) >= substring( dats_add_months( $parameters.P_KeyDate, 25, 'NULL' ), 1, 6 ) and
                 concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) <= substring( dats_add_months( $parameters.P_KeyDate, 60, 'NULL' ), 1, 6 )
            then ValuationCFClr.AmountInCompanyCodeCurrency
          end
        )
        as ze_rtr_oll_between2and5year
      ) as Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) >= substring( dats_add_months( $parameters.P_KeyDate, 61, 'NULL' ), 1, 6 ) and
                 concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) <= substring( dats_add_months( $parameters.P_KeyDate, 120, 'NULL' ), 1, 6 )
            then ValuationCFClr.AmountInCompanyCodeCurrency
          end
        )
        as ze_rtr_oll_between5and10year
      ) as Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) >= substring( dats_add_months( $parameters.P_KeyDate, 121, 'NULL' ), 1, 6 ) and
                 concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) <= substring( dats_add_months( $parameters.P_KeyDate, 180, 'NULL' ), 1, 6 )
            then ValuationCFClr.AmountInCompanyCodeCurrency
          end
        )
        as ze_rtr_oll_between10and15year
      ) as Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when concat( ValuationCFClr.CalculationYear, ValuationCFClr.CalculationMonth ) >= substring( dats_add_months( $parameters.P_KeyDate, 181, 'NULL' ), 1, 6 )
            then ValuationCFClr.AmountInCompanyCodeCurrency
          end
        )
        as ze_rtr_oll_greaterthan15year
      ) as GreaterThan15Year
}

group by
  ValuationCFClr.CompanyCode,
  ValuationCFClr.RealEstateContract,
  ValuationCFClr.CompanyCodeCurrency
