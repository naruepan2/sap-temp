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

@EndUserText.label: 'Sum of Account.Docu. by Trading Partner'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

define view entity ZI_RTR_OLL_AcctDocItemByTP_0
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum
  as select from ZI_RTR_OLL_AcctgDocItem2CN as AcctgDocItem

{
  key AcctgDocItem.CompanyCode,
  key AcctgDocItem.TradingPartner,
  key cast('' as ze_rtr_oll_type preserving type)      as Type,
  key cast('' as ze_rtr_oll_typegroup preserving type) as TypeGroup,

      AcctgDocItem.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum( - AcctgDocItem.AmountInCompanyCodeCurrency )
        as fis_hsl
      )                                                as AmountInCompanyCodeCurrency,

      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}
where
      AcctgDocItem.PostingDate <= $parameters.P_KeyDate
  and AcctgDocItem.CompanyCode = $parameters.P_CompanyCode
group by
  AcctgDocItem.CompanyCode,
  AcctgDocItem.TradingPartner,
  AcctgDocItem.CompanyCodeCurrency
