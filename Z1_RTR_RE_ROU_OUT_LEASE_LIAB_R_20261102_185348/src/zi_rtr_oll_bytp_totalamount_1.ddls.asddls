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

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

define view entity ZI_RTR_OLL_BYTP_TOTALAMOUNT_1
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_OLL_BYTP_TotalAmount_0(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as OLL_ByTP

{
  key CompanyCode,
  key TradingPartner,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum((coalesce(AmountInCompanyCodeCurrency, cast(0 as fis_hsl)))) as AmountInCompanyCodeCurrency,

      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}
group by
  CompanyCode,
  TradingPartner,
  CompanyCodeCurrency
