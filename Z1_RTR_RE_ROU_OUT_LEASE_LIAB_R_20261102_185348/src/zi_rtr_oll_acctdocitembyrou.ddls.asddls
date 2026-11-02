/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 13.08.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK924602
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

@EndUserText.label: 'Sum of Account.Docu. by ROU Class'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

define view entity ZI_RTR_OLL_ACCTDOCITEMBYROU
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum
  as select from ZI_RTR_OLL_AcctgDocItem2CN as AcctgDocItem

{
  key AcctgDocItem.CompanyCode,
  key cast(AcctgDocItem.Identifier as ze_identifier preserving type ) as Identifier,
  key cast( AcctgDocItem.ROUClass as ze_rou_class preserving type)    as ROUClass,

      AcctgDocItem.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum( - AcctgDocItem.AmountInCompanyCodeCurrency )
        as fis_hsl
      )                                                               as AmountInCompanyCodeCurrency,

      _CompanyCode,
      _CompanyCodeCurrency
}
where
      AcctgDocItem.PostingDate <= $parameters.P_KeyDate
  and AcctgDocItem.CompanyCode = $parameters.P_CompanyCode
group by
  AcctgDocItem.CompanyCode,
  AcctgDocItem.Identifier,
  AcctgDocItem.ROUClass,
  AcctgDocItem.CompanyCodeCurrency
