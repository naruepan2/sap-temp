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
// 17/03/2026 | GSDK911054 | NW001 | Naruepan W. | Add association to _ViceruleToAsset(ZI_RTR_OLL_VICERULETOASSET_1)
// 26/05/2026 | GSDK918255 | NW002 | Naruepan W. | Add Contract Type Name
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract General Information'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #XL
}
define view entity ZI_RTR_OLL_ContractGeneral
  as select from ZI_RTR_OLL_ContractGeneral_0 as ContractGeneral_0

  association [0..*] to ZI_RTR_OLL_ValuationRuleCF  as _ValuationRuleCF  on  $projection.CompanyCode        = _ValuationRuleCF.CompanyCode
                                                                         and $projection.RealEstateContract = _ValuationRuleCF.RealEstateContract

  association [0..*] to ZI_RTR_OLL_ValuationCFClr   as _ValuationCFClr   on  $projection.CompanyCode        = _ValuationCFClr.CompanyCode
                                                                         and $projection.RealEstateContract = _ValuationCFClr.RealEstateContract

  association [0..*] to ZI_RTR_OLL_ValuationCFInt   as _ValuationCFInt   on  $projection.CompanyCode        = _ValuationCFInt.CompanyCode
                                                                         and $projection.RealEstateContract = _ValuationCFInt.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ROUClass         as _ROUClass         on  $projection.ROUClass = _ROUClass.ROUClass

  association [0..1] to ZI_RTR_OLL_ContractValCFSum as _ContractValCFSum on  $projection.CompanyCode        = _ContractValCFSum.CompanyCode
                                                                         and $projection.RealEstateContract = _ContractValCFSum.RealEstateContract
{
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key ContractGeneral_0.CompanyCode,

  key ContractGeneral_0.RealEstateContract,

      ContractGeneral_0.InternalRealEstateNumber,

      ContractGeneral_0.CompanyCodeCurrency,

      @ObjectModel.foreignKey.association: '_REContractType'
      ContractGeneral_0.REContractType,

      @ObjectModel.foreignKey.association: '_REContractTypeText' // NW002(+)
      ContractGeneral_0.REContractTypeName,                      // NW002(+)

      ContractGeneral_0.REContractName,

      ContractGeneral_0.ContractStartDate,

      @EndUserText.quickInfo: 'End of Term'
      ContractGeneral_0.ContractEndDate,

      ContractGeneral_0.REContractFirstEndDate,

      ContractGeneral_0.REContractNoticeDate,

      ContractGeneral_0.REContractSignDate,

      @ObjectModel.foreignKey.association: '_Currency'
      ContractGeneral_0.REContractCurrency,

      ContractGeneral_0.ContractDurationMonths,

      ContractGeneral_0.ActualDurationMonths,

      ContractGeneral_0.ZZ1_DMAPPosted_Rec,

      ContractGeneral_0.ZZ1_DMValInstallPosted_Rec,

      ContractGeneral_0.ZZ1_AgreementNumber_Rec,

      ContractGeneral_0.ZZ1_InterestRateType_Rec,

      ContractGeneral_0.ZZ1_RetireObligation_Rec,

      ContractGeneral_0.ZZ1_PurchaseOption_Rec,

      ContractGeneral_0.ZZ1_TerminateOption_Rec,

      ContractGeneral_0.ZZ1_ExtensionOption_Rec,

      ContractGeneral_0.ZZ1_GuaranteeResidualv_Rec,

      ContractGeneral_0.IsCNDataMigration,

      @ObjectModel.foreignKey.association: '_ROUClass'
      _ContractType2Class.ROUClass as ROUClass,

      _ContractValCFSum.AssetAcquisitionPostingDate,

      _ContractValCFSum.AssetModificationPostingDate,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      _ContractValCFSum.ROUAsset,

      ContractGeneral_0._CompanyCode,
      ContractGeneral_0._Currency,
      ContractGeneral_0._REAdjustmentTerm,
      ContractGeneral_0._RECondition,
      ContractGeneral_0._REContractType,
      ContractGeneral_0._REKeyAssgmt,
      ContractGeneral_0._RENoticeTerm,
      ContractGeneral_0._REOrganizationalAssgmtTerm,
      ContractGeneral_0._REPartnerAssgmt,
      ContractGeneral_0._REPostingTerm,
      ContractGeneral_0._REReminderRule,
      ContractGeneral_0._RERenewalTerm,
      ContractGeneral_0._RERhythmTerm,
      ContractGeneral_0._RESalesReportingTerm,
      ContractGeneral_0._RESalesRuleFrqcyTerm,
      ContractGeneral_0._RESalesRuleTerm,
      ContractGeneral_0._REValuationRuleCondition,
      ContractGeneral_0._REValuationTerm,
      ContractGeneral_0._ZZ1_InterestRateType_Rec,

      _ValuationRuleCF,
      _ValuationCFClr,
      _ValuationCFInt,
      _ROUClass,
      _ContractValCFSum,

      _ViceruleToAsset,                     // NW001(+)
      ContractGeneral_0._REContractTypeText // NW002(+)
}
