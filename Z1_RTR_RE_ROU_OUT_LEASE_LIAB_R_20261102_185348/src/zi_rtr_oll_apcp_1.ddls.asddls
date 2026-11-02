/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 11.02.2026
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
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #XL
}
define view entity ZI_RTR_OLL_APCP_1
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_APCP_0 as APCP_0
{
  key APCP_0.CompanyCode,

  key APCP_0.AccountingDocument,

  key APCP_0.FiscalYear,

  key APCP_0.AccountingDocumentItem,

      APCP_0.Identifier,

      APCP_0.ChartOfAccounts,

      APCP_0.GLAccount,

      APCP_0.PostingDate,

      APCP_0.TransactionCurrency,

      APCP_0.AmountInTransactionCurrency,

      APCP_0.CompanyCodeCurrency,

      APCP_0.AmountInCompanyCodeCurrency,

      APCP_0.AdditionalCurrency1,

      APCP_0.AmountInAdditionalCurrency1,

      APCP_0.AdditionalCurrency2,

      APCP_0.AmountInAdditionalCurrency2,

      APCP_0.ROUClass,

      APCP_0.InstallmentNo,

      APCP_0.RealEstateContract,

      APCP_0.IsCNDataMigration,

      APCP_0.AgreementNumber,

      APCP_0.PurchaseOrder,

      APCP_0.PurchaseOrderItem,

      APCP_0.IsAPInvoice,

      APCP_0.IsActualAPInvoice,

      APCP_0._CNInstallmentPeriod.PaymentDueDate,

      cast(
        substring( APCP_0._CNInstallmentPeriod.PaymentDueDate, 1, 4 )
        as ze_year
      ) as CalculationYear,

      cast(
        substring( APCP_0._CNInstallmentPeriod.PaymentDueDate, 5, 2 )
        as ze_month
      ) as CalculationMonth,

      APCP_0._AdditionalCurrency1,
      APCP_0._AdditionalCurrency2,
      APCP_0._ChartOfAccounts,
      APCP_0._CNInstallmentPeriod,
      APCP_0._CompanyCode,
      APCP_0._CompanyCodeCurrency,
      APCP_0._FiscalYear,
      APCP_0._GLAccountInChartOfAccounts,
      APCP_0._JournalEntry,
      APCP_0._TransactionCurrency,
      APCP_0._ROUClass
}
where
       APCP_0.PostingDate                      <= $parameters.P_KeyDate
  and(
       APCP_0._ReverseJournalEntry.PostingDate is null
    or APCP_0._ReverseJournalEntry.PostingDate > $parameters.P_KeyDate
  )
