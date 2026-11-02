/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 20.07.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK922121
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
// 10/09/2026 | GSDK927467 | NW001 | Naruepan W. | Add association to ZI_RTR_OLL_CONTRACTGENERLAPCP and
//                                                 ZI_RTR_OLL_APCP_LinkToContract
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'ROU Outstanding Lease Liability and Defer Interest Report'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XXL }

define view entity ZI_RTR_ROU_OutLeaseLiabRep_1
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from    ZI_RTR_ROU_OutLeaseLiabRep_0(
                      P_KeyDate : $parameters.P_KeyDate)     as OutLeaseLiabRep_0

    left outer join ZI_RTR_OLL_ContractGeneral               as ContractGeneral   on  ContractGeneral.CompanyCode        = OutLeaseLiabRep_0.CompanyCode
                                                                                  and ContractGeneral.RealEstateContract = OutLeaseLiabRep_0.RealEstateContract

    left outer join ZI_RTR_OLL_ADJFOREIGNCURRDFI_1(
                      P_CompanyCode : $parameters.P_CompanyCode,
                      P_KeyDate     : $parameters.P_KeyDate) as AdjForeignCurrDFI on  AdjForeignCurrDFI.CompanyCode        = OutLeaseLiabRep_0.CompanyCode
                                                                                  and AdjForeignCurrDFI.AgreementNumber    = OutLeaseLiabRep_0.AgreementNumber
                                                                                  and AdjForeignCurrDFI.RealEstateContract = OutLeaseLiabRep_0.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractPartner     as _ContractSupplier        on  $projection.CompanyCode               = _ContractSupplier.CompanyCode
                                                                                   and $projection.RealEstateContract        = _ContractSupplier.RealEstateContract
                                                                                   and _ContractSupplier.BusinessPartnerRole = 'FLVN00'

  association [0..1] to ZI_RTR_OLL_ContractInterest    as _ContractInterest        on  $projection.CompanyCode        = _ContractInterest.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractInterest.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractAsset       as _ContractAsset           on  $projection.CompanyCode        = _ContractAsset.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractAsset.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractQty         as _ContractQty             on  $projection.CompanyCode        = _ContractQty.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractQty.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractVaryOnSales as _ContractVaryOnSales     on  $projection.CompanyCode        = _ContractVaryOnSales.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractVaryOnSales.RealEstateContract

  association [1..1] to I_CompanyCode                  as _CompanyCode             on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [1..1] to I_Currency                     as _CompanyCodeCurrency     on  $projection.CompanyCodeCurrency = _CompanyCodeCurrency.Currency

  association [0..1] to I_Globalcompany                as _Globalcompany           on  $projection.TradingPartner = _Globalcompany.Company

  association [0..1] to I_BusinessPartner              as _BusinessPartnerSupplier on  $projection.BusinessPartnerSupplier = _BusinessPartnerSupplier.BusinessPartner

  association [1..1] to ZI_RTR_OLL_Type                as _Type                    on  $projection.Type = _Type.Type

  association [1..1] to ZI_RTR_OLL_TypeGroup           as _TypeGroup               on  $projection.TypeGroup = _TypeGroup.TypeGroup

  association [0..1] to ZI_RTR_CNInstallmentPeriodSum  as _CNInstallmentPeriodSum  on  $projection.CompanyCode        = _CNInstallmentPeriodSum.CompanyCode
                                                                                   and $projection.RealEstateContract = _CNInstallmentPeriodSum.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractCondFreq    as _ContractCondFreq        on  $projection.CompanyCode        = _ContractCondFreq.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractCondFreq.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ROUClass            as _ROUClass                on  $projection.ROUClass = _ROUClass.ROUClass

  association [0..1] to ZI_RTR_OLL_PaymentMethod       as _PaymentMethod           on  $projection.PaymentMethod = _PaymentMethod.PaymentMethod

  association [0..1] to ZI_RTR_OLL_InstallmentFreq     as _InstallmentFrequency    on  $projection.InstallmentFrequency = _InstallmentFrequency.InstallmentFrequency

  association [0..1] to I_MasterFixedAsset             as _MasterFixedAsset        on  $projection.CompanyCode      = _MasterFixedAsset.CompanyCode
                                                                                   and $projection.masterfixedasset = _MasterFixedAsset.MasterFixedAsset

  association [0..1] to I_FixedAsset                   as _FixedAsset              on  $projection.CompanyCode      = _FixedAsset.CompanyCode
                                                                                   and $projection.masterfixedasset = _FixedAsset.MasterFixedAsset
                                                                                   and $projection.fixedasset       = _FixedAsset.FixedAsset

  association [0..*] to I_FixedAssetForLedger          as _FixedAssetForLedger     on  $projection.CompanyCode      = _FixedAssetForLedger.CompanyCode
                                                                                   and $projection.masterfixedasset = _FixedAssetForLedger.MasterFixedAsset
                                                                                   and $projection.fixedasset       = _FixedAssetForLedger.FixedAsset

  association [0..1] to ZI_RTR_OLL_ValuationRule       as _ValuationRule           on  $projection.CompanyCode        = _ValuationRule.CompanyCode
                                                                                   and $projection.RealEstateContract = _ValuationRule.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractExchRate    as _ContractExchRate        on  $projection.CompanyCode        = _ContractExchRate.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractExchRate.RealEstateContract

  association [1..1] to I_Currency                     as _REContractCurrency_2    on  $projection.REContractCurrency_2 = _REContractCurrency_2.Currency

{
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key OutLeaseLiabRep_0.CompanyCode,

  key OutLeaseLiabRep_0.RealEstateContract,

  key OutLeaseLiabRep_0.AgreementNumber,

      @ObjectModel.foreignKey.association: '_Type'
  key OutLeaseLiabRep_0.Type,

      @ObjectModel.foreignKey.association: '_TypeGroup'
      OutLeaseLiabRep_0.TypeGroup,

      @ObjectModel.foreignKey.association: '_ROUClass'
      OutLeaseLiabRep_0.ROUClass,

      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency'
      cast(
      case when OutLeaseLiabRep_0.CompanyCodeCurrency is not initial
            and OutLeaseLiabRep_0.CompanyCodeCurrency is not null
           then OutLeaseLiabRep_0.CompanyCodeCurrency
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CompanyCodeCurrency is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CompanyCodeCurrency is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CompanyCodeCurrency
           else cast('     ' as waers)
           end
           as waers preserving type
      )                                     as CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.GreaterThan15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.GLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.GLLongTerm,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case when AdjForeignCurrDFI.DiffGLCurrentPortion <> 0
            and AdjForeignCurrDFI.DiffGLCurrentPortion is not null
            and OutLeaseLiabRep_0.Type                  = 'D'
            and OutLeaseLiabRep_0.TypeGroup             = 'D'
           then OutLeaseLiabRep_0.LessThan1Year + AdjForeignCurrDFI.DiffGLCurrentPortion
           else OutLeaseLiabRep_0.LessThan1Year
           end
           as ze_rtr_oll_lessthan1year
      )                                     as LessThan1Year_2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case when AdjForeignCurrDFI.DiffGLLongTerm          <> 0
            and AdjForeignCurrDFI.DiffGLLongTerm          is not null
            and AdjForeignCurrDFI.DiffGLLongTermCondition  = '1'
            and OutLeaseLiabRep_0.Type = 'D'
            and OutLeaseLiabRep_0.TypeGroup                = 'D'
           then OutLeaseLiabRep_0.Between1And2Year + AdjForeignCurrDFI.DiffGLLongTerm
           else OutLeaseLiabRep_0.Between1And2Year
           end
           as ze_rtr_oll_between1and2year
      )                                     as Between1And2Year_2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case when AdjForeignCurrDFI.DiffGLLongTerm          <> 0
            and AdjForeignCurrDFI.DiffGLLongTerm          is not null
            and AdjForeignCurrDFI.DiffGLLongTermCondition  = '2'
            and OutLeaseLiabRep_0.Type = 'D'
            and OutLeaseLiabRep_0.TypeGroup                = 'D'
           then OutLeaseLiabRep_0.Between2And5Year + AdjForeignCurrDFI.DiffGLLongTerm
           else OutLeaseLiabRep_0.Between2And5Year
           end
           as ze_rtr_oll_between2and5year
      )                                     as Between2And5Year_2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case when AdjForeignCurrDFI.DiffGLLongTerm          <> 0
            and AdjForeignCurrDFI.DiffGLLongTerm          is not null
            and AdjForeignCurrDFI.DiffGLLongTermCondition  = '3'
            and OutLeaseLiabRep_0.Type = 'D'
            and OutLeaseLiabRep_0.TypeGroup                = 'D'
           then OutLeaseLiabRep_0.Between5And10Year + AdjForeignCurrDFI.DiffGLLongTerm
           else OutLeaseLiabRep_0.Between5And10Year
           end
           as ze_rtr_oll_between5and10year
      )                                     as Between5And10Year_2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case when AdjForeignCurrDFI.DiffGLLongTerm          <> 0
            and AdjForeignCurrDFI.DiffGLLongTerm          is not null
            and AdjForeignCurrDFI.DiffGLLongTermCondition  = '4'
            and OutLeaseLiabRep_0.Type = 'D'
            and OutLeaseLiabRep_0.TypeGroup                = 'D'
           then OutLeaseLiabRep_0.Between10And15Year + AdjForeignCurrDFI.DiffGLLongTerm
           else OutLeaseLiabRep_0.Between10And15Year
           end
           as ze_rtr_oll_between10and15year
      )                                     as Between10And15Year_2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
      case when AdjForeignCurrDFI.DiffGLLongTerm          <> 0
            and AdjForeignCurrDFI.DiffGLLongTerm          is not null
            and AdjForeignCurrDFI.DiffGLLongTermCondition  = '5'
            and OutLeaseLiabRep_0.Type = 'D'
            and OutLeaseLiabRep_0.TypeGroup                = 'D'
           then OutLeaseLiabRep_0.GreaterThan15Year + AdjForeignCurrDFI.DiffGLLongTerm
           else OutLeaseLiabRep_0.GreaterThan15Year
           end
           as ze_rtr_oll_greaterthan15year
      )                                     as GreaterThan15Year_2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //      cast(
      //      case when AdjForeignCurrDFI.DiffGLCurrentPortion <> 0
      //            and OutLeaseLiabRep_0.Type = 'D'
      //            and OutLeaseLiabRep_0.TypeGroup = 'D'
      //           then OutLeaseLiabRep_0.GLCurrentPortion + AdjForeignCurrDFI.DiffGLCurrentPortion
      //           else OutLeaseLiabRep_0.GLCurrentPortion
      //           end
      //           as ze_glcurrentportion
      //      )                                     as GLCurrentPortion_2,
      OutLeaseLiabRep_0.GLCurrentPortion    as GLCurrentPortion_2,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //      cast(
      //      case when AdjForeignCurrDFI.DiffGLLongTerm <> 0
      //            and OutLeaseLiabRep_0.Type = 'D'
      //            and OutLeaseLiabRep_0.TypeGroup = 'D'
      //           then OutLeaseLiabRep_0.GLLongTerm + AdjForeignCurrDFI.DiffGLLongTerm
      //           else OutLeaseLiabRep_0.GLLongTerm
      //           end
      //           as ze_gllongterm
      //      )                                     as GLLongTerm_2,
      OutLeaseLiabRep_0.GLLongTerm          as GLLongTerm_2,

      ContractGeneral.InternalRealEstateNumber,

      ContractGeneral.REContractType,

      ContractGeneral.REContractTypeName,

      ContractGeneral.REContractName,

      ContractGeneral.ContractStartDate,

      ContractGeneral.ContractEndDate,

      ContractGeneral.REContractFirstEndDate,

      ContractGeneral.REContractNoticeDate,

      ContractGeneral.REContractSignDate,

      @ObjectModel.foreignKey.association: '_Currency'
      ContractGeneral.REContractCurrency,

      @ObjectModel.foreignKey.association: '_REContractCurrency_2'
      cast(
      case when ContractGeneral.REContractCurrency is not initial
            and ContractGeneral.REContractCurrency is not null
           then ContractGeneral.REContractCurrency
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REContractCurrency is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REContractCurrency is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REContractCurrency
           else cast('' as recnwaers_cn)
           end
           as recnwaers_cn preserving type
      )                                     as REContractCurrency_2,

      ContractGeneral.ContractDurationMonths,

      ContractGeneral.ActualDurationMonths,

      cast(
        case
          when dats_is_valid(ContractGeneral.ContractEndDate)  = 1
           and dats_is_valid($parameters.P_KeyDate)            = 1
           and ContractGeneral.ContractEndDate                <> $parameters.P_KeyDate
          then((cast(substring(dats_add_days(ContractGeneral.ContractEndDate, 1, 'NULL'), 1, 4) as abap.int4) - cast(substring($parameters.P_KeyDate, 1, 4) as abap.int4)) * 12) +
              (cast(substring(dats_add_days(ContractGeneral.ContractEndDate, 1, 'NULL'), 5, 2) as abap.int4) - cast(substring($parameters.P_KeyDate, 5, 2) as abap.int4)) - 1
          else null
        end
        as ze_remainingmonths preserving type
      )                                     as RemainingDurationMonths,

      @EndUserText.label: 'Total Installment No'
      _CNInstallmentPeriodSum.InstallmentNo as TotalInstallmentNo,

      @ObjectModel.foreignKey.association: '_PaymentMethod'
      cast(
      case when _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).PaymentMethod is not initial
            and _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).PaymentMethod is not null
           then _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).PaymentMethod
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).PaymentMethod is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).PaymentMethod is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).PaymentMethod
           else cast('' as ze_recdpaymentformrh_char1)
           end
           as ze_recdpaymentformrh_char1 preserving type
      )                                     as PaymentMethod,

      @ObjectModel.foreignKey.association: '_InstallmentFrequency'
      cast(
      case when _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).InstallmentFrequency is not initial
            and _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).InstallmentFrequency is not null
           then _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).InstallmentFrequency
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).InstallmentFrequency is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).InstallmentFrequency is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).InstallmentFrequency
           else cast(' ' as ze_installmentfrequency)
           end
           as ze_installmentfrequency preserving type
      )                                     as InstallmentFrequency,

      case when _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).CompanyCode is not initial
             or _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).CompanyCode is not null
             or OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CompanyCode is not initial
             or OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CompanyCode is not null
        then cast('X' as abap_boolean preserving type)
        else cast(' ' as abap_boolean preserving type)
      end                                   as InstallmentFrequencyIsFound,

      ContractGeneral.ZZ1_DMAPPosted_Rec,

      ContractGeneral.ZZ1_DMValInstallPosted_Rec,

      @ObjectModel.foreignKey.association: '_ZZ1_InterestRateType_Rec'
      ContractGeneral.ZZ1_InterestRateType_Rec,

      @ObjectModel.foreignKey.association: '_ZZ1_InterestRateType_Rec'
      cast(
      case when ContractGeneral.ZZ1_InterestRateType_Rec is not initial
            and ContractGeneral.ZZ1_InterestRateType_Rec is not null
           then ContractGeneral.ZZ1_InterestRateType_Rec
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode : $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).InterestRateType is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode : $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).InterestRateType is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode : $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).InterestRateType
           else cast('' as abap.char(3))
           end
           as abap.char(3)
      )                                     as ZZ1_InterestRateType_Rec_2,

      cast(
      case when ContractGeneral.ZZ1_RetireObligation_Rec is not initial
            and ContractGeneral.ZZ1_RetireObligation_Rec is not null
           then ContractGeneral.ZZ1_RetireObligation_Rec
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).RetireObligation is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).RetireObligation is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).RetireObligation
           else cast('' as abap.char(1))
           end
           as abap.char(1)
      )                                     as ZZ1_RetireObligation_Rec,

      cast(
      case when ContractGeneral.ZZ1_PurchaseOption_Rec is not initial
            and ContractGeneral.ZZ1_PurchaseOption_Rec is not null
           then ContractGeneral.ZZ1_PurchaseOption_Rec
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).PurchaseOption is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).PurchaseOption is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).PurchaseOption
           else cast('' as abap.char(1))
           end
           as abap.char(1)
      )                                     as ZZ1_PurchaseOption_Rec,

      cast(
      case when ContractGeneral.ZZ1_TerminateOption_Rec is not initial
            and ContractGeneral.ZZ1_TerminateOption_Rec is not null
           then ContractGeneral.ZZ1_TerminateOption_Rec
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).TerminateOption is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).TerminateOption is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).TerminateOption
           else cast('' as abap.char(1))
           end
           as abap.char(1)
      )                                     as ZZ1_TerminateOption_Rec,

      cast(
      case when ContractGeneral.ZZ1_ExtensionOption_Rec is not initial
            and ContractGeneral.ZZ1_ExtensionOption_Rec is not null
           then ContractGeneral.ZZ1_ExtensionOption_Rec
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).ExtensionOption is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).ExtensionOption is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).ExtensionOption
           else cast('' as abap.char(1))
           end
           as abap.char(1)
      )                                     as ZZ1_ExtensionOption_Rec,

      cast(
      case when ContractGeneral.ZZ1_GuaranteeResidualv_Rec is not initial
            and ContractGeneral.ZZ1_GuaranteeResidualv_Rec is not null
           then ContractGeneral.ZZ1_GuaranteeResidualv_Rec
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).GuaranteeResidualv is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).GuaranteeResidualv is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).GuaranteeResidualv
           else cast(' ' as abap.char(1))
           end
           as abap.char(1)
      )                                     as ZZ1_GuaranteeResidualv_Rec,

      ContractGeneral.IsCNDataMigration,

      @EndUserText.label: 'Vendor Code'
      @ObjectModel.foreignKey.association: '_BusinessPartnerSupplier'
      cast(
      case when _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartner is not initial
            and _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartner is not null
           then _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartner
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartnerSupplier is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartnerSupplier is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartnerSupplier
           else cast('' as ze_businesspartner)
           end
           as ze_businesspartner preserving type
      )                                     as BusinessPartnerSupplier,

      @ObjectModel.foreignKey.association: '_Globalcompany'
      cast(
      case when _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._BP001.Vbund is not initial
            and _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._BP001.Vbund is not null
           then _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._BP001.Vbund
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).TradingPartner is not initial
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).TradingPartner is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).TradingPartner
           else cast('' as rassc)
           end
           as rassc preserving type
      )                                     as TradingPartner,

      cast(
      case when _ContractInterest(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REInterestRate <> 0
            and _ContractInterest(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REInterestRate is not null
           then _ContractInterest(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REInterestRate
           when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REInterestRate <> 0
            and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REInterestRate is not null
           then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REInterestRate
           else cast(0 as ze_receinterestrate)
           end
           as ze_receinterestrate preserving type
      )                                     as REInterestRate,

      @ObjectModel.foreignKey.association: '_MasterFixedAsset'
      _ContractAsset(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._FixedAsset.MasterFixedAsset,

      @ObjectModel.foreignKey.association: '_FixedAsset'
      _ContractAsset(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._FixedAsset.FixedAsset,

      _ContractAsset(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._FixedAsset.AssetDeactivationDate,

      _ContractQty(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._VICNMEASCN.REMeasurementQuantity,

      _ContractQty(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._VICNMEASCN.REMeasurementUnit,

      cast(
        case
          when _ContractVaryOnSales(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CountREConditionUUID is not initial
           and _ContractVaryOnSales(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CountREConditionUUID is not null
          then 'X'
          when OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).IsVaryOnSales is not initial
           and OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).IsVaryOnSales is not null
          then OutLeaseLiabRep_0._ContractGenerlAPCP(P_Client: $session.client, P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).IsVaryOnSales
          else ''
        end
        as ze_isvaryonsales preserving type
      )                                     as IsVaryOnSales,

      ContractGeneral.AssetAcquisitionPostingDate,

      ContractGeneral.AssetModificationPostingDate,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractGeneral.ROUAsset,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        case
          when OutLeaseLiabRep_0.CompanyCodeCurrency = _ValuationRule._REValuationProcessStep.Currency
          then cast(_ValuationRule._REValuationProcessStep.REContractValueAmount as abap.dec(23,2))
          else cast(_ValuationRule._REValuationProcessStep.REContractValueAmount as abap.dec(23,2)) * _ContractExchRate.ExchangeRate
        end
        as ze_rececnvalue
      )                                     as ContractValue,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        case
          when OutLeaseLiabRep_0.CompanyCodeCurrency = _ValuationRule._REValuationProcessStep.Currency
          then cast(_ValuationRule._REValuationProcessStep.RENetPresentValueAmount as abap.dec(23,2))
          else cast(_ValuationRule._REValuationProcessStep.RENetPresentValueAmount as abap.dec(23,2)) * _ContractExchRate.ExchangeRate
        end
        as ze_netleaseliability
      )                                     as NetLeaseLiability,

      cast('DUMMY' as abap.char(5))         as DummyField,

      _ContractExchRate.ExchangeRate,

      /* Associations */
      ContractGeneral._Currency,
      ContractGeneral._REAdjustmentTerm,
      ContractGeneral._RECondition,
      ContractGeneral._REContractType,
      ContractGeneral._REKeyAssgmt,
      ContractGeneral._RENoticeTerm,
      ContractGeneral._REOrganizationalAssgmtTerm,
      ContractGeneral._REPartnerAssgmt,
      ContractGeneral._REPostingTerm,
      ContractGeneral._REReminderRule,
      ContractGeneral._RERenewalTerm,
      ContractGeneral._RERhythmTerm,
      ContractGeneral._RESalesReportingTerm,
      ContractGeneral._RESalesRuleFrqcyTerm,
      ContractGeneral._RESalesRuleTerm,
      ContractGeneral._REValuationRuleCondition,
      ContractGeneral._REValuationTerm,
      ContractGeneral._ZZ1_InterestRateType_Rec,

      _CompanyCode,
      _CompanyCodeCurrency,
      _ContractSupplier,
      _ContractInterest,
      _ContractAsset,
      _ContractQty,
      _ContractVaryOnSales,
      _Globalcompany,
      _BusinessPartnerSupplier,
      _Type,
      _TypeGroup,
      _ROUClass,
      _PaymentMethod,
      _InstallmentFrequency,
      _MasterFixedAsset,
      _FixedAsset,
      _FixedAssetForLedger,
      _ValuationRule,
      _ContractExchRate,
      _REContractCurrency_2,
      _CNInstallmentPeriodSum,

      OutLeaseLiabRep_0._ContractGenerlAPCP // NW001(+)
}

where
  OutLeaseLiabRep_0.CompanyCode = $parameters.P_CompanyCode
