/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 11.09.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK927467
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
/////////////////////////////////////////////////////////////////////////
@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'ROU Outstanding Lease Liability Only_Lease/DFI'

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_APCP_OnlyLeaseDFI_1
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select distinct from ZI_RTR_OLL_APCP_OnlyLeaseDFI_0(
                            P_KeyDate : $parameters.P_KeyDate) as OutLeaseLiabOnlyLeaseDFI_0

    left outer join       ZI_RTR_OLL_ContractGeneral           as ContractGeneral on  ContractGeneral.CompanyCode        = OutLeaseLiabOnlyLeaseDFI_0.CompanyCode
                                                                                  and ContractGeneral.RealEstateContract = OutLeaseLiabOnlyLeaseDFI_0.RealEstateContract

  association [1..1] to I_CompanyCode                  as _CompanyCode         on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [1..1] to I_Currency                     as _CompanyCodeCurrency on  $projection.CompanyCodeCurrency = _CompanyCodeCurrency.Currency

  association [0..1] to ZI_RTR_OLL_ContractPartner     as _ContractSupplier    on  $projection.CompanyCode               = _ContractSupplier.CompanyCode
                                                                               and $projection.RealEstateContract        = _ContractSupplier.RealEstateContract
                                                                               and _ContractSupplier.BusinessPartnerRole = 'FLVN00'

  association [0..1] to ZI_RTR_OLL_ContractVaryOnSales as _ContractVaryOnSales on  $projection.CompanyCode        = _ContractVaryOnSales.CompanyCode
                                                                               and $projection.RealEstateContract = _ContractVaryOnSales.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractCondFreq    as _ContractCondFreq    on  $projection.CompanyCode        = _ContractCondFreq.CompanyCode
                                                                               and $projection.RealEstateContract = _ContractCondFreq.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractInterest    as _ContractInterest    on  $projection.CompanyCode        = _ContractInterest.CompanyCode
                                                                               and $projection.RealEstateContract = _ContractInterest.RealEstateContract

  association [0..1] to ZI_RTR_OLL_PaymentMethod       as _PaymentMethod       on  $projection.PaymentMethod = _PaymentMethod.PaymentMethod

{
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key OutLeaseLiabOnlyLeaseDFI_0.CompanyCode                                                                        as CompanyCode,

  key OutLeaseLiabOnlyLeaseDFI_0.RealEstateContract                                                                 as RealEstateContract,
  key OutLeaseLiabOnlyLeaseDFI_0.AgreementNumber                                                                    as AgreementNumber,

      @ObjectModel.foreignKey.association: '_Currency'
      ContractGeneral.REContractCurrency                                                                            as REContractCurrency,

      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency'
      ContractGeneral.CompanyCodeCurrency                                                                           as CompanyCodeCurrency,

      cast(
        case
          when _ContractVaryOnSales(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CountREConditionUUID is not null
           and _ContractVaryOnSales(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).CountREConditionUUID is not initial
          then 'X'
          else ''
        end
        as ze_isvaryonsales preserving type
      )                                                                                                             as IsVaryOnSales,

      ContractGeneral.ZZ1_ExtensionOption_Rec                                                                       as ZZ1_ExtensionOption_Rec,

      ContractGeneral.ZZ1_RetireObligation_Rec                                                                      as ZZ1_RetireObligation_Rec,

      ContractGeneral.ZZ1_TerminateOption_Rec                                                                       as ZZ1_TerminateOption_Rec,

      @ObjectModel.foreignKey.association: '_PaymentMethod'
      _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).PaymentMethod                                             as PaymentMethod,

      _ContractCondFreq(P_KeyDate: $parameters.P_KeyDate).InstallmentFrequency                                      as InstallmentFrequency,

      ContractGeneral.ZZ1_InterestRateType_Rec                                                                      as ZZ1_InterestRateType_Rec,

      _ContractInterest(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).REInterestRate  as REInterestRate,

      ContractGeneral.ZZ1_PurchaseOption_Rec                                                                        as ZZ1_PurchaseOption_Rec,

      ContractGeneral.ZZ1_GuaranteeResidualv_Rec                                                                    as ZZ1_GuaranteeResidualv_Rec,

      _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartner as BusinessPartnerSupplier,

      _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._BP001.Vbund    as TradingPartner,

      /* Association */
      _CompanyCode,
      ContractGeneral._Currency,

      _CompanyCodeCurrency,

      _ContractSupplier,
      _ContractVaryOnSales,
      _ContractCondFreq,
      _ContractInterest,
      _PaymentMethod
}

where
       OutLeaseLiabOnlyLeaseDFI_0.CompanyCode = $parameters.P_CompanyCode
  and(
       OutLeaseLiabOnlyLeaseDFI_0.Type        = 'L'
    or OutLeaseLiabOnlyLeaseDFI_0.Type        = 'D'
  )
