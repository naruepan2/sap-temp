/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 13.02.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK911054
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
// 19/02/2026 | GSDK913869 | NW001 | Naruepan W. | Change Condition of Payment Method
// 25/02/2026 | GSDK914455 | NW002 | Naruepan W. | Use start of consideration date for filtering
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Contract Condition Frequency'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #M }

define view entity ZI_RTR_OLL_ContractCondFreq
  with parameters
    P_KeyDate : datum

  as select from    ZI_REContractData              as REContract

  // NW002 (+)
    inner join      ZI_RTR_CNNoInstallmentMaxConDt as ContractCondFreqMaxDate on  ContractCondFreqMaxDate.CompanyCode        = REContract.CompanyCode
                                                                              and ContractCondFreqMaxDate.RealEstateContract = REContract.RealEstateContract
  // NW002 (+)

    left outer join ZI_ReCondition                 as RECondition             on RECondition.InternalRealEstateNumber = REContract.InternalRealEstateNumber

    left outer join ZI_VITMRH                      as VITMRH_1110             on  VITMRH_1110.Intreno   = RECondition.InternalRealEstateNumber
                                                                              and VITMRH_1110.Termtype  = '1110'
                                                                              and VITMRH_1110.Termno    = RECondition.RERhythmTerm
                                                                              and VITMRH_1110.Validfrom <= $parameters.P_KeyDate
                                                                              and VITMRH_1110.Validto   >= $parameters.P_KeyDate

  association [0..1] to ZI_RTR_OLL_PaymentMethod   as _PaymentMethod        on $projection.PaymentMethod = _PaymentMethod.PaymentMethod
  association [0..1] to ZI_RTR_OLL_InstallmentFreq as _InstallmentFrequency on $projection.InstallmentFrequency = _InstallmentFrequency.InstallmentFrequency

{
  key REContract.CompanyCode,
  key REContract.RealEstateContract,

      @ObjectModel.foreignKey.association: '_PaymentMethod'
      cast(
        max(
          case
      // NW001 (-)
      //    when RECondition.REConditionType = 'Z110' or
      //         RECondition.REConditionType = 'A140' or
      //         RECondition.REConditionType = 'A150'
      //    then VITMRH_1110.Paymentformrh
      // NW001 (-)
      // NW001 (+)
            when(RECondition.REConditionType like 'Z1%'
                 or RECondition.REConditionType like 'Z4%'
                 or RECondition.REConditionType like 'A%')
             and(RECondition.REExtConditionPurpose = 'A'
                 or RECondition.REExtConditionPurpose = 'B')

            then VITMRH_1110.Paymentformrh
            else ''
      // NW001 (+)
          end
        )
      // NW001 (-)
      // as ze_recdpaymentformrh
      // NW001 (-)
      // NW001 (+)
         as ze_recdpaymentformrh_char1
      // NW001 (+)
      ) as PaymentMethod,

      @ObjectModel.foreignKey.association: '_InstallmentFrequency'
      cast(
        max(
          case
      // NW001 (-)
      //    when RECondition.REConditionType = 'Z110' or
      //         RECondition.REConditionType = 'A140' or
      //         RECondition.REConditionType = 'A150'
      // NW001 (-)
      // NW001 (+)
            when(RECondition.REConditionType like 'Z1%'
                 or RECondition.REConditionType like 'Z4%'
                 or RECondition.REConditionType like 'A%')
             and(RECondition.REExtConditionPurpose = 'A'
                 or RECondition.REExtConditionPurpose = 'B')
      // NW001 (+)
            then substring(RECondition.RERhythmTerm, 3, 1)
          end
        )
        as ze_installmentfrequency
      ) as InstallmentFrequency,

      _PaymentMethod,
      _InstallmentFrequency
}

// NW002 (-)
//where
//      RECondition.ValidityStartDate <= $parameters.P_KeyDate
//  and RECondition.ValidityEndDate   >= $parameters.P_KeyDate
// NW002 (-)
// NW002 (+)
where
  RECondition.ValidityEndDate >= ContractCondFreqMaxDate.StartOfConsideration
// NW002 (+)
group by
  REContract.CompanyCode,
  REContract.RealEstateContract
