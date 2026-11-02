/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 26.03.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK914455
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

@EndUserText.label: 'Contract Condition Frequency'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #M }

define view entity ZI_RTR_OLL_CONTRACTCONDFREQ_V2

  as select from    ZI_REContractData              as REContract

    inner join      ZI_RTR_CNNoInstallmentMaxConDt as ContractCondFreqMaxDate on  ContractCondFreqMaxDate.CompanyCode        = REContract.CompanyCode
                                                                              and ContractCondFreqMaxDate.RealEstateContract = REContract.RealEstateContract

    left outer join ZI_ReCondition                 as RECondition             on RECondition.InternalRealEstateNumber = REContract.InternalRealEstateNumber

    left outer join ZI_VITMRH                      as VITMRH_1110             on  VITMRH_1110.Intreno   =  RECondition.InternalRealEstateNumber
                                                                              and VITMRH_1110.Termtype  =  '1110'
                                                                              and VITMRH_1110.Termno    =  RECondition.RERhythmTerm
                                                                              and VITMRH_1110.Validfrom <= ContractCondFreqMaxDate.StartOfConsideration
                                                                              and VITMRH_1110.Validto   >= ContractCondFreqMaxDate.StartOfConsideration

  association [0..1] to ZI_RTR_OLL_PaymentMethod   as _PaymentMethod        on $projection.PaymentMethod = _PaymentMethod.PaymentMethod
  association [0..1] to ZI_RTR_OLL_InstallmentFreq as _InstallmentFrequency on $projection.InstallmentFrequency = _InstallmentFrequency.InstallmentFrequency

{
  key REContract.CompanyCode,
  key REContract.RealEstateContract,

      @ObjectModel.foreignKey.association: '_PaymentMethod'
      cast(
        max(
          case
            when(RECondition.REConditionType like 'Z1%'
                 or RECondition.REConditionType like 'Z4%'
                 or RECondition.REConditionType like 'A%')
             and(RECondition.REExtConditionPurpose = 'A'
                 or RECondition.REExtConditionPurpose = 'B')

            then VITMRH_1110.Paymentformrh
            else ''
          end
        )
         as ze_recdpaymentformrh_char1
      ) as PaymentMethod,

      @ObjectModel.foreignKey.association: '_InstallmentFrequency'
      cast(
        max(
          case
            when(RECondition.REConditionType like 'Z1%'
                 or RECondition.REConditionType like 'Z4%'
                 or RECondition.REConditionType like 'A%')
             and(RECondition.REExtConditionPurpose = 'A'
                 or RECondition.REExtConditionPurpose = 'B')
            then substring(RECondition.RERhythmTerm, 3, 1)
          end
        )
        as ze_installmentfrequency
      ) as InstallmentFrequency,

      _PaymentMethod,
      _InstallmentFrequency
}

where
  RECondition.ValidityEndDate >= ContractCondFreqMaxDate.StartOfConsideration

group by
  REContract.CompanyCode,
  REContract.RealEstateContract
