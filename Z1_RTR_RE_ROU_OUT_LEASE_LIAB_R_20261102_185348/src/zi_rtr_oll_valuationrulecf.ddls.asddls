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
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Valuation Rule Cashflow'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ValuationRuleCF
  as select from    ZI_RTR_OLL_ValuationRuleCF_2 as ValuationRuleCF_2

    inner join      ZI_VICECFRULE                as VICECFRULE       on  VICECFRULE.intreno     = ValuationRuleCF_2.InternalRealEstateNumber
                                                                     and VICECFRULE.ruleguid    = ValuationRuleCF_2.REValuationRuleUUID
                                                                     and VICECFRULE.processguid = ValuationRuleCF_2.REValuationProcessUUID

    inner join      I_CompanyCode                as CompanyCode      on CompanyCode.CompanyCode = ValuationRuleCF_2.CompanyCode

    left outer join I_REFlowType                 as REFlowType       on REFlowType.REFlowType = VICECFRULE.book_flowtype

    left outer join ZI_RTR_OLL_ContractExchRate  as ContractExchRate on  ContractExchRate.CompanyCode        = ValuationRuleCF_2.CompanyCode
                                                                     and ContractExchRate.RealEstateContract = ValuationRuleCF_2.RealEstateContract

  association [1..1] to ZI_VICECFRULE as _VICECFRULE on  $projection.InternalRealEstateNumber      = _VICECFRULE.intreno
                                                     and $projection.REValuationRuleUUID           = _VICECFRULE.ruleguid
                                                     and $projection.REValuationProcessUUID        = _VICECFRULE.processguid
                                                     and $projection.REValuationCashFlowRecordUUID = _VICECFRULE.cfguid
{
  key ValuationRuleCF_2.CompanyCode,

  key ValuationRuleCF_2.RealEstateContract,

  key VICECFRULE.ruleguid             as REValuationRuleRecordUUID,

  key VICECFRULE.processguid          as REValuationProcessRecordUUID,

  key VICECFRULE.cfguid               as REValuationCashFlowRecordUUID,

      ValuationRuleCF_2.InternalRealEstateNumber,

      @ObjectModel.foreignKey.association: '_REValuationRule'
      ValuationRuleCF_2.REValuationRuleUUID,

      @ObjectModel.foreignKey.association: '_REValuationProcessStep'
      ValuationRuleCF_2.REValuationProcessUUID,

      VICECFRULE.cftype               as RECashFlowType,

      VICECFRULE.cfstatus             as RECashFlowStatus,

      VICECFRULE.book_flowtype        as BookFlowType,

      VICECFRULE.dbervon              as CalculationPeriodStartDate,

      VICECFRULE.dberbis              as CalculationPeriodEndDate,

      VICECFRULE.dfaell               as PaymentDueDate,

      VICECFRULE.isrepaymentdif       as IsRePaymentDif,

      VICECFRULE.isretroactivechange  as IsRetroActiveChange,

      REFlowType.DebitCreditCode,

      @Semantics.amount.currencyCode: 'REConditionCurrency'
      cast(
        case
          when REFlowType.DebitCreditCode = 'S'
          then VICECFRULE.bbwhr * -1
          else VICECFRULE.bbwhr
        end
        as ze_tfm_bbwhr
      )                               as REConditionAmount,

      VICECFRULE.swhrkond             as REConditionCurrency,

      CompanyCode.Currency            as CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //      cast(
      //        case
      //          when CompanyCode.Currency = VICECFRULE.swhrkond
      //          then cast( $projection.REConditionAmount as abap.dec( 23, 2 ) )
      //          else ( cast( $projection.REConditionAmount as abap.dec( 23, 2 ) ) * ContractExchRate.ExchangeRate )
      //        end
      //        as fis_hsl
      //      )                               as AmountInCompanyCodeCurrency,

      cast(
        case
          when CompanyCode.Currency = VICECFRULE.swhrkond
          then cast( $projection.REConditionAmount as bapicurext )
          else ( cast( $projection.REConditionAmount as bapicurext ) * ContractExchRate.ExchangeRate )
        end
        as bapicurext
      )                               as AmountInCompanyCodeCurrency,

      VICECFRULE.postingdate          as PostingDate,

      VICECFRULE.iscompleteretirement as IsCompleteRetirement,

      ValuationRuleCF_2._REValuationProcessStep,
      ValuationRuleCF_2._REValuationRule,
      _VICECFRULE
}
