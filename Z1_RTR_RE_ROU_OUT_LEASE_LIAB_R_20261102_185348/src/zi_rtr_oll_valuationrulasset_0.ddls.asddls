/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 15.07.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK922121
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

@EndUserText.label: 'Valuation Cashflow: Interest'

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_VALUATIONRULASSET_0
  as select from    ZI_REContractData         as REContract

    inner join      ZI_REValuationRule        as REValuationRule        on REValuationRule.InternalRealEstateNumber = REContract.InternalRealEstateNumber

    inner join      ZI_REValuationProcessStep as REValuationProcessStep on  REValuationProcessStep.InternalRealEstateNumber = REValuationRule.InternalRealEstateNumber
                                                                        and REValuationProcessStep.REValuationRuleUUID      = REValuationRule.REValuationRuleUUID

    inner join      ZI_VICECFRULE             as ValuationRuleCF        on  ValuationRuleCF.intreno     = REValuationRule.InternalRealEstateNumber
                                                                        and ValuationRuleCF.ruleguid    = REValuationRule.REValuationRuleUUID
                                                                        and ValuationRuleCF.processguid = REValuationProcessStep.REValuationProcessUUID

    inner join      I_CompanyCode             as CompanyCode            on CompanyCode.CompanyCode = REContract.CompanyCode

    left outer join I_REFlowType              as REFlowType             on REFlowType.REFlowType = ValuationRuleCF.book_flowtype
{
  key REContract.CompanyCode              as CompanyCode,
  key REContract.RealEstateContract       as RealEstateContract,
  key ValuationRuleCF.ruleguid            as REValuationRuleRecordUUID,
  key ValuationRuleCF.processguid         as REValuationProcessRecordUUID,
  key ValuationRuleCF.cfguid              as REValuationCashFlowRecordUUID,

      ValuationRuleCF.cftype              as RECashFlowType,

      ValuationRuleCF.cfstatus            as RECashFlowStatus,

      ValuationRuleCF.book_flowtype       as BookFlowType,

      ValuationRuleCF.dbervon             as CalculationPeriodStartDate,

      ValuationRuleCF.dberbis             as CalculationPeriodEndDate,

      ValuationRuleCF.postingdate         as PostingDate,

      ValuationRuleCF.dfaell              as PaymentDueDate,

      ValuationRuleCF.isrepaymentdif      as IsRePaymentDif,

      ValuationRuleCF.isretroactivechange as IsRetroActiveChange,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        case
          when REFlowType.DebitCreditCode = 'S'
          then ValuationRuleCF.bbwhr * -1
          else ValuationRuleCF.bbwhr
        end
        as bapicurext
      )                                   as AmountInCompanyCodeCurrency,

      CompanyCode.Currency                as CompanyCodeCurrency,

      cast(
        substring(ValuationRuleCF.dfaell, 1, 4)
        as ze_year
      )                                   as CalculationYear,

      cast(
        substring(ValuationRuleCF.dfaell, 5, 2)
        as ze_month
      )                                   as CalculationMonth
}

where
  (
        ValuationRuleCF.cftype   = '1' // Assets
    and ValuationRuleCF.cfstatus = 'I' // Actual Record
  )
