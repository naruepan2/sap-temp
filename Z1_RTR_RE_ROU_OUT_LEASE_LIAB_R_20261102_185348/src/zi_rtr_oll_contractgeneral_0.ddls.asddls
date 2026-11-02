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
// 17/03/2026 | GSDK911054 | NW001 | Naruepan W. | Add association to ZI_RTR_OLL_VICERULETOASSET_1
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
define view entity ZI_RTR_OLL_ContractGeneral_0
  as select from    ZI_REContractData as REContract

    left outer join I_CompanyCode     as CompanyCode on CompanyCode.CompanyCode = REContract.CompanyCode

  association [0..1] to ZI_RTR_OLL_ContractType2Class as _ContractType2Class on  $projection.CompanyCode    = _ContractType2Class.CompanyCode
                                                                             and $projection.REContractType = _ContractType2Class.REContractType
  // NW001(+)
  association [0..1] to ZI_RTR_OLL_VICERULETOASSET_1  as _ViceruleToAsset    on  $projection.CompanyCode        = _ViceruleToAsset.CompanyCode
                                                                             and $projection.RealEstateContract = _ViceruleToAsset.RealEstateContract
  // NW001(+)
  // NW002(+)
  association [0..*] to ZI_REContractTypeText         as _REContractTypeText on  $projection.REContractType = _REContractTypeText.REContractType
  // NW002(+)

{
  key REContract.CompanyCode,

  key REContract.RealEstateContract,

      REContract.InternalRealEstateNumber,

      CompanyCode.Currency                                                                      as CompanyCodeCurrency,

      REContract.REContractType,

      _REContractTypeText[ one to one: Language = $session.system_language ].REContractTypeName as REContractTypeName, // NW00(+)

      REContract.REContractName,

      REContract.ContractStartDate,

      REContract.ContractEndDate,

      REContract.REContractFirstEndDate,

      REContract.REContractNoticeDate,

      REContract.REContractSignDate,

      @ObjectModel.foreignKey.association: '_Currency'
      REContract.REContractCurrency,

      cast(
        case
          when dats_is_valid( REContract.REContractFirstEndDate ) = 1 and
               dats_is_valid( REContract.ContractStartDate ) = 1 and
               REContract.REContractFirstEndDate <> REContract.ContractStartDate
          then ( ( cast( substring( dats_add_days( REContract.REContractFirstEndDate, 1, 'NULL' ), 1, 4 ) as abap.int4 ) - cast( substring( REContract.ContractStartDate, 1, 4 ) as abap.int4 ) ) * 12 ) +
               ( cast( substring( dats_add_days( REContract.REContractFirstEndDate, 1, 'NULL' ), 5, 2 ) as abap.int4 ) - cast( substring( REContract.ContractStartDate, 5, 2 ) as abap.int4 ) )
          else null
        end
        as ze_contractdurationdays )                                                            as ContractDurationMonths,

      cast(
        case
          when dats_is_valid( REContract.ContractEndDate ) = 1 and
               dats_is_valid( REContract.ContractStartDate ) = 1 and
               REContract.ContractEndDate <> REContract.ContractStartDate
          then ( ( cast( substring( dats_add_days( REContract.ContractEndDate, 1, 'NULL' ), 1, 4 ) as abap.int4 ) - cast( substring( REContract.ContractStartDate, 1, 4 ) as abap.int4 ) ) * 12 ) +
               ( cast( substring( dats_add_days( REContract.ContractEndDate, 1, 'NULL' ), 5, 2 ) as abap.int4 ) - cast( substring( REContract.ContractStartDate, 5, 2 ) as abap.int4 ) )
          else null
        end
        as ze_actualdurationmonths )                                                            as ActualDurationMonths,

      //TotalInstallment,

      REContract.ZZ1_DMAPPosted_Rec,

      REContract.ZZ1_DMValInstallPosted_Rec,

      REContract.ZZ1_AgreementNumber_Rec,

      REContract.ZZ1_InterestRateType_Rec,

      REContract.ZZ1_RetireObligation_Rec,

      REContract.ZZ1_PurchaseOption_Rec,

      REContract.ZZ1_TerminateOption_Rec,

      REContract.ZZ1_ExtensionOption_Rec,

      REContract.ZZ1_GuaranteeResidualv_Rec,

      cast(
        case
          when REContract.ZZ1_DMValInstallPosted_Rec is not initial
          then 'X'

          else ''
        end as ze_is_cn_data_migration )                                                        as IsCNDataMigration,

      REContract._CompanyCode,
      REContract._Currency,
      REContract._REAdjustmentTerm,
      REContract._RECondition,
      REContract._REContractType,
      REContract._REKeyAssgmt,
      REContract._RENoticeTerm,
      REContract._REOrganizationalAssgmtTerm,
      REContract._REPartnerAssgmt,
      REContract._REPostingTerm,
      REContract._REReminderRule,
      REContract._RERenewalTerm,
      REContract._RERhythmTerm,
      REContract._RESalesReportingTerm,
      REContract._RESalesRuleFrqcyTerm,
      REContract._RESalesRuleTerm,
      REContract._REValuationRuleCondition,
      REContract._REValuationTerm,
      REContract._ZZ1_InterestRateType_Rec,

      _ContractType2Class,

      _ViceruleToAsset,   // NW001(+)
      _REContractTypeText // NW002(+)

}
