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

define view entity ZI_RTR_OLL_BYTP_TotalAmount_0
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_OLL_ByTP(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as OLL_ByTP

{
  key CompanyCode,
  key TradingPartner,
  key Type,
  key TypeGroup,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        (coalesce(LessThan1Year, cast(0 as ze_diffgllongterm)) +
         coalesce(Between1And2Year, cast(0 as ze_diffgllongterm)) +
         coalesce(Between2And5Year, cast(0 as ze_diffgllongterm)) +
         coalesce(Between5And10Year, cast(0 as ze_diffgllongterm)) +
         coalesce(Between10And15Year, cast(0 as ze_diffgllongterm)) +
         coalesce(GreaterThan15Year, cast(0 as ze_diffgllongterm)))
       as fis_hsl
      ) as AmountInCompanyCodeCurrency,

      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany,
      _Type,
      _TypeGroup
}
where
  CompanyCode = $parameters.P_CompanyCode
