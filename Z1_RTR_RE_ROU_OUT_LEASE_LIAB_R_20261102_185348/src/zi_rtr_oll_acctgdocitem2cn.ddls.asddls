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
@EndUserText.label: 'Accounting Document Item to Contract'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #XL
}
define view entity ZI_RTR_OLL_AcctgDocItem2CN
  as select from I_OperationalAcctgDocItem as OperationalAcctgDocItem

    join         ZI_RTR_OLL_GLAccount      as OLL_GLAccount on  OLL_GLAccount.GLAccount   = OperationalAcctgDocItem.GLAccount
                                                            and OLL_GLAccount.CompanyCode = OperationalAcctgDocItem.CompanyCode

  association [0..1] to I_JournalEntry             as _ReverseJournalEntry on  $projection.CompanyCode               = _ReverseJournalEntry.CompanyCode
                                                                           and $projection.reversedocumentfiscalyear = _ReverseJournalEntry.FiscalYear
                                                                           and $projection.reversedocument           = _ReverseJournalEntry.AccountingDocument

  association [0..1] to ZI_RTR_OLL_AccItemCN       as _AccItemCN           on  $projection.CompanyCode            = _AccItemCN.CompanyCode
                                                                           and $projection.AccountingDocument     = _AccItemCN.AccountingDocument
                                                                           and $projection.FiscalYear             = _AccItemCN.FiscalYear
                                                                           and $projection.AccountingDocumentItem = _AccItemCN.AccountingDocumentItem

  association [0..1] to ZI_RTR_OLL_AccItemPO       as _AccItemPO           on  $projection.CompanyCode            = _AccItemPO.CompanyCode
                                                                           and $projection.AccountingDocument     = _AccItemPO.AccountingDocument
                                                                           and $projection.FiscalYear             = _AccItemPO.FiscalYear
                                                                           and $projection.AccountingDocumentItem = _AccItemPO.AccountingDocumentItem

  association [0..1] to ZI_RTR_CNInstallmentPeriod as _CNInstallmentPeriod on  $projection.CompanyCode        = _CNInstallmentPeriod.CompanyCode
                                                                           and $projection.RealEstateContract = _CNInstallmentPeriod.RealEstateContract
                                                                           and $projection.InstallmentNo      = _CNInstallmentPeriod.InstallmentNo

  association [0..1] to ZI_RTR_OLL_ROUClass        as _ROUClass            on  $projection.ROUClass = _ROUClass.ROUClass

  association [0..1] to I_Globalcompany            as _Globalcompany       on  $projection.TradingPartner = _Globalcompany.Company
{
  key OperationalAcctgDocItem.CompanyCode,

  key OperationalAcctgDocItem.AccountingDocument,

  key OperationalAcctgDocItem.FiscalYear,

  key OperationalAcctgDocItem.AccountingDocumentItem,

      OLL_GLAccount.Identifier,

      OperationalAcctgDocItem.ChartOfAccounts,

      OperationalAcctgDocItem.GLAccount,

      OperationalAcctgDocItem.PostingDate,

      OperationalAcctgDocItem.DebitCreditCode,

      OperationalAcctgDocItem.TransactionCurrency,

      @Semantics: { amount : {currencyCode: 'TransactionCurrency'} }
      OperationalAcctgDocItem.AmountInTransactionCurrency,

      OperationalAcctgDocItem.CompanyCodeCurrency,

      @Semantics: { amount : {currencyCode: 'CompanyCodeCurrency'} }
      OperationalAcctgDocItem.AmountInCompanyCodeCurrency,

      OperationalAcctgDocItem.AdditionalCurrency1,

      @Semantics: { amount : {currencyCode: 'AdditionalCurrency1'} }
      OperationalAcctgDocItem.AmountInAdditionalCurrency1,

      OperationalAcctgDocItem.AdditionalCurrency2,

      @Semantics: { amount : {currencyCode: 'AdditionalCurrency2'} }
      OperationalAcctgDocItem.AmountInAdditionalCurrency2,

      OperationalAcctgDocItem._JournalEntry.ReverseDocumentFiscalYear,

      OperationalAcctgDocItem._JournalEntry.ReverseDocument,

      OperationalAcctgDocItem.DocumentItemText,

      OperationalAcctgDocItem.PartnerCompany as TradingPartner,

      OLL_GLAccount.ROUClass,

      cast(
        case
          when _AccItemCN.InstallmentNo is not null and
               _AccItemCN.InstallmentNo is not initial
          then _AccItemCN.InstallmentNo

          when _AccItemPO.InstallmentNo is not null and
               _AccItemPO.InstallmentNo is not initial
          then _AccItemPO.InstallmentNo
        end
        as ze_installmentnumber )            as InstallmentNo,

      cast(
        case
          when _AccItemCN.RealEstateContract is not null and
               _AccItemCN.RealEstateContract is not initial
          then _AccItemCN.RealEstateContract

          when _AccItemPO.RealEstateContract is not null and
               _AccItemPO.RealEstateContract is not initial
          then _AccItemPO.RealEstateContract

          else ''
        end as recnvdmcnnr )                 as RealEstateContract,

      cast(
        case
          when _AccItemCN.RealEstateContract is not null and
               _AccItemCN.RealEstateContract is not initial and
               _AccItemCN._REContract.ZZ1_DMValInstallPosted_Rec is not initial
          then 'X'

          when _AccItemPO.RealEstateContract is not null and
               _AccItemPO.RealEstateContract is not initial and
               _AccItemPO._REContract.ZZ1_DMValInstallPosted_Rec is not initial
          then 'X'

          else ''
        end as ze_is_cn_data_migration )     as IsCNDataMigration,

      cast(
        case
          when _AccItemCN.RealEstateContract is not null and
               _AccItemCN.RealEstateContract is not initial
          then _AccItemCN.ZZ1_AgreementNumber_Rec

          when _AccItemPO.RealEstateContract is not null and
               _AccItemPO.RealEstateContract is not initial
          then _AccItemPO.ZZ1_AgreementNumber_Rec

          else OperationalAcctgDocItem.AssignmentReference
        end as ze_agreementnumber )          as AgreementNumber,

      _AccItemPO.PurchaseOrder,

      _AccItemPO.PurchaseOrderItem,

      OperationalAcctgDocItem._CompanyCode,
      OperationalAcctgDocItem._FiscalYear,
      OperationalAcctgDocItem._JournalEntry,
      OperationalAcctgDocItem._ChartOfAccounts,
      OperationalAcctgDocItem._GLAccountInChartOfAccounts,
      OperationalAcctgDocItem._TransactionCurrency,
      OperationalAcctgDocItem._CompanyCodeCurrency,
      OperationalAcctgDocItem._AdditionalCurrency1,
      OperationalAcctgDocItem._AdditionalCurrency2,
      _CNInstallmentPeriod,
      _ReverseJournalEntry,
      _ROUClass,
      _Globalcompany
}
