/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 23.07.2026
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

@EndUserText.label: 'ROU - Calculate Amount by TP'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

define view entity ZI_RTR_OLL_BYTP_TOTALAMOUNT_2
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from    ZI_RTR_OLL_BYTP_TOTALAMOUNT_1(
                      P_CompanyCode : $parameters.P_CompanyCode,
                      P_KeyDate     : $parameters.P_KeyDate) as OLL_ByTPTotal

    left outer join ZI_RTR_OLL_AcctDocItemByTP_1(
                      P_CompanyCode : $parameters.P_CompanyCode,
                      P_KeyDate     : $parameters.P_KeyDate) as AcctDocItemBYTP on  OLL_ByTPTotal.CompanyCode         = AcctDocItemBYTP.CompanyCode
                                                                                and OLL_ByTPTotal.TradingPartner      = AcctDocItemBYTP.TradingPartner
                                                                                and OLL_ByTPTotal.CompanyCodeCurrency = AcctDocItemBYTP.CompanyCodeCurrency

{
  key OLL_ByTPTotal.CompanyCode,
  key OLL_ByTPTotal.TradingPartner,

      OLL_ByTPTotal.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        coalesce(OLL_ByTPTotal.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountinsummary))
        as ze_rtr_oll_amountinsummary
      )                                              as AmountInSummary,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        coalesce(AcctDocItemBYTP.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountintb))
        as ze_rtr_oll_amountintb
      )                                              as AmountInTB,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        coalesce(AcctDocItemBYTP.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountintb)) -
        coalesce(OLL_ByTPTotal.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountinsummary))
        as ze_rtr_oll_amountdifferent
      )                                              as AmountDifferent,

      cast('CONTRACTTOACCTDOCITEM' as abap.char(25)) as DataSource,

      /* Associations */
      OLL_ByTPTotal._CompanyCode,
      OLL_ByTPTotal._CompanyCodeCurrency,
      OLL_ByTPTotal._Globalcompany
}

union all select from ZI_RTR_OLL_AcctDocItemByTP_1(
                        P_CompanyCode : $parameters.P_CompanyCode,
                        P_KeyDate     : $parameters.P_KeyDate) as AcctDocItemBYTP

  left outer join     ZI_RTR_OLL_BYTP_TOTALAMOUNT_1(
                        P_CompanyCode : $parameters.P_CompanyCode,
                        P_KeyDate     : $parameters.P_KeyDate) as OLL_ByTPTotal on  AcctDocItemBYTP.CompanyCode         = OLL_ByTPTotal.CompanyCode
                                                                                and AcctDocItemBYTP.TradingPartner      = OLL_ByTPTotal.TradingPartner
                                                                                and AcctDocItemBYTP.CompanyCodeCurrency = OLL_ByTPTotal.CompanyCodeCurrency

{
  key AcctDocItemBYTP.CompanyCode,
  key AcctDocItemBYTP.TradingPartner,

      AcctDocItemBYTP.CompanyCodeCurrency,

      cast(
        coalesce(OLL_ByTPTotal.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountinsummary))
        as ze_rtr_oll_amountinsummary
      )                                              as AmountInSummary,

      cast(
        coalesce(AcctDocItemBYTP.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountintb))
        as ze_rtr_oll_amountintb
      )                                              as AmountInTB,

      cast(
        coalesce(AcctDocItemBYTP.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountintb)) -
        coalesce(OLL_ByTPTotal.AmountInCompanyCodeCurrency, cast(0 as ze_rtr_oll_amountinsummary))
        as ze_rtr_oll_amountdifferent
      )                                              as AmountDifferent,

      cast('ACCTDOCITEMTOCONTRACT' as abap.char(25)) as DataSource,

      AcctDocItemBYTP._CompanyCode,
      AcctDocItemBYTP._CompanyCodeCurrency,
      AcctDocItemBYTP._Globalcompany
}
