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
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_CPLT_0
  as select from ZI_RTR_OLL_AcctgDocItem2CN as AcctgDocItem2CN
{
  key AcctgDocItem2CN.CompanyCode,

  key AcctgDocItem2CN.AccountingDocument,

  key AcctgDocItem2CN.FiscalYear,

  key AcctgDocItem2CN.AccountingDocumentItem,

      AcctgDocItem2CN.Identifier,

      AcctgDocItem2CN.ChartOfAccounts,

      AcctgDocItem2CN.GLAccount,

      AcctgDocItem2CN.PostingDate,

      AcctgDocItem2CN.TransactionCurrency,

      AcctgDocItem2CN.AmountInTransactionCurrency,

      AcctgDocItem2CN.CompanyCodeCurrency,

      AcctgDocItem2CN.AmountInCompanyCodeCurrency,

      AcctgDocItem2CN.AdditionalCurrency1,

      AcctgDocItem2CN.AmountInAdditionalCurrency1,

      AcctgDocItem2CN.AdditionalCurrency2,

      AcctgDocItem2CN.AmountInAdditionalCurrency2,

      AcctgDocItem2CN.ReverseDocumentFiscalYear,

      AcctgDocItem2CN.ReverseDocument,

      AcctgDocItem2CN.ROUClass,

      AcctgDocItem2CN.InstallmentNo,

      AcctgDocItem2CN.RealEstateContract,

      AcctgDocItem2CN.IsCNDataMigration,

      AcctgDocItem2CN.AgreementNumber,

      AcctgDocItem2CN.PurchaseOrder,

      AcctgDocItem2CN.PurchaseOrderItem,

      AcctgDocItem2CN._AdditionalCurrency1,
      AcctgDocItem2CN._AdditionalCurrency2,
      AcctgDocItem2CN._ChartOfAccounts,
      AcctgDocItem2CN._CNInstallmentPeriod,
      AcctgDocItem2CN._CompanyCode,
      AcctgDocItem2CN._CompanyCodeCurrency,
      AcctgDocItem2CN._FiscalYear,
      AcctgDocItem2CN._GLAccountInChartOfAccounts,
      AcctgDocItem2CN._JournalEntry,
      AcctgDocItem2CN._ReverseJournalEntry,
      AcctgDocItem2CN._ROUClass,
      AcctgDocItem2CN._TransactionCurrency
}
where
  (
       AcctgDocItem2CN.Identifier = 'CP_ROU_GL'
    or AcctgDocItem2CN.Identifier = 'LT_ROU_GL'
  )
