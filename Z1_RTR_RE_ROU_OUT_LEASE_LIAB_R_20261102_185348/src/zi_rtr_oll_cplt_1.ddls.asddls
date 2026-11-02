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
// 22/08/2026 | GSDK928504 | NW001 | Naruepan W. | Change:
//                                                  - Include reverse accounting document
//                                                    to calculate all amount
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Current Portion/LT Lease Liability by Agreement No.'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_CPLT_1
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_CPLT_0 as CPLT_0
{
  key CPLT_0.CompanyCode,

  key CPLT_0.AccountingDocument,

  key CPLT_0.FiscalYear,

  key CPLT_0.AccountingDocumentItem,

      CPLT_0.Identifier,

      CPLT_0.ChartOfAccounts,

      CPLT_0.GLAccount,

      CPLT_0.PostingDate,

      CPLT_0.TransactionCurrency,

      CPLT_0.AmountInTransactionCurrency,

      CPLT_0.CompanyCodeCurrency,

      CPLT_0.AmountInCompanyCodeCurrency,

      CPLT_0.AdditionalCurrency1,

      CPLT_0.AmountInAdditionalCurrency1,

      CPLT_0.AdditionalCurrency2,

      CPLT_0.AmountInAdditionalCurrency2,

      CPLT_0.ROUClass,

      CPLT_0.InstallmentNo,

      CPLT_0.RealEstateContract,

      CPLT_0.IsCNDataMigration,

      CPLT_0.AgreementNumber,

      CPLT_0.PurchaseOrder,

      CPLT_0.PurchaseOrderItem,

      CPLT_0._CNInstallmentPeriod.PaymentDueDate,

      cast(
        substring( CPLT_0._CNInstallmentPeriod.PaymentDueDate, 1, 4 )
        as ze_year
      ) as CalculationYear,

      cast(
        substring( CPLT_0._CNInstallmentPeriod.PaymentDueDate, 5, 2 )
        as ze_month
      ) as CalculationMonth,

      CPLT_0._AdditionalCurrency1,
      CPLT_0._AdditionalCurrency2,
      CPLT_0._ChartOfAccounts,
      CPLT_0._CompanyCode,
      CPLT_0._CompanyCodeCurrency,
      CPLT_0._FiscalYear,
      CPLT_0._GLAccountInChartOfAccounts,
      CPLT_0._JournalEntry,
      CPLT_0._TransactionCurrency
}
// NW001 (-)
//where
//       CPLT_0.PostingDate                      <= $parameters.P_KeyDate
//  and(
//       CPLT_0._ReverseJournalEntry.PostingDate is null
//    or CPLT_0._ReverseJournalEntry.PostingDate > $parameters.P_KeyDate
//  )
// NW001 (-)
// NW001 (+)
where
  CPLT_0.PostingDate <= $parameters.P_KeyDate
// NW001 (+)
