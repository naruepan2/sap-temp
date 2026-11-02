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
// 26/05/2026 | GSDK918255 | NW001 | Naruepan W. | Add Contract Type Name
// 20/07/2026 | GSDK922121 | NW002 | Naruepan W. | Create new CDS to be successor of ZI_RTR_ROU_OutLeaseLiabRep_0
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'ROU Outstanding Lease Liability and Defer Interest Report'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XXL }

define view entity ZI_RTR_ROU_OutLeaseLiabRep
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  //  as select from    ZI_RTR_ROU_OutLeaseLiabRep_0(                                   // NW002(-)
  //                      P_KeyDate : $parameters.P_KeyDate)     as OutLeaseLiabRep_0   // NW002(-)
  as select from ZI_RTR_ROU_OutLeaseLiabRep_1(                                          // NW002(+)        Successor of ZI_RTR_ROU_OutLeaseLiabRep_0
                   P_CompanyCode : $parameters.P_CompanyCode,                           // NW002(+)
                   P_KeyDate     : $parameters.P_KeyDate) as OutLeaseLiabRep_0          // NW002(+)

{
  key CompanyCode,
  key RealEstateContract,
  key AgreementNumber,
  key Type,

      TypeGroup,
      ROUClass,
      CompanyCodeCurrency,
      LessThan1Year,
      Between1And2Year,
      Between2And5Year,
      Between5And10Year,
      Between10And15Year,
      GreaterThan15Year,
      GLCurrentPortion,
      GLLongTerm,
      LessThan1Year_2,
      Between1And2Year_2,
      Between2And5Year_2,
      Between5And10Year_2,
      Between10And15Year_2,
      GreaterThan15Year_2,
      GLCurrentPortion_2,
      GLLongTerm_2,
      InternalRealEstateNumber,
      REContractType,
      REContractTypeName,
      REContractName,
      ContractStartDate,
      ContractEndDate,
      REContractFirstEndDate,
      REContractNoticeDate,
      REContractSignDate,
      REContractCurrency,
      REContractCurrency_2,
      ContractDurationMonths,
      ActualDurationMonths,
      RemainingDurationMonths,
      TotalInstallmentNo,
      PaymentMethod,
      InstallmentFrequency,
      InstallmentFrequencyIsFound,
      ZZ1_DMAPPosted_Rec,
      ZZ1_DMValInstallPosted_Rec,
      ZZ1_InterestRateType_Rec,
      ZZ1_InterestRateType_Rec_2,
      ZZ1_RetireObligation_Rec,
      ZZ1_PurchaseOption_Rec,
      ZZ1_TerminateOption_Rec,
      ZZ1_ExtensionOption_Rec,
      ZZ1_GuaranteeResidualv_Rec,
      IsCNDataMigration,
      BusinessPartnerSupplier,
      TradingPartner,
      REInterestRate,
      MasterFixedAsset,
      FixedAsset,
      AssetDeactivationDate,
      REMeasurementQuantity,
      REMeasurementUnit,
      IsVaryOnSales,
      AssetAcquisitionPostingDate,
      AssetModificationPostingDate,
      ROUAsset,
      ContractValue,
      NetLeaseLiability,
      DummyField,
      ExchangeRate,

      /* Associations */
      _BusinessPartnerSupplier,
      _CompanyCode,
      _CompanyCodeCurrency,
      _ContractAsset,
      _ContractExchRate,
      _ContractInterest,
      _ContractQty,
      _ContractSupplier,
      _ContractVaryOnSales,
      _Currency,
      _FixedAsset,
      _FixedAssetForLedger,
      _Globalcompany,
      _InstallmentFrequency,
      _MasterFixedAsset,
      _PaymentMethod,
      _REAdjustmentTerm,
      _RECondition,
      _REContractCurrency_2,
      _REContractType,
      _REKeyAssgmt,
      _RENoticeTerm,
      _REOrganizationalAssgmtTerm,
      _REPartnerAssgmt,
      _REPostingTerm,
      _REReminderRule,
      _RERenewalTerm,
      _RERhythmTerm,
      _RESalesReportingTerm,
      _RESalesRuleFrqcyTerm,
      _RESalesRuleTerm,
      _REValuationRuleCondition,
      _REValuationTerm,
      _ROUClass,
      _Type,
      _TypeGroup,
      _ValuationRule,
      _ZZ1_InterestRateType_Rec
}
