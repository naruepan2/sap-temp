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

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'ROU - Contract and Account Doc. by TP'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

define view entity ZI_RTR_OLL_BYTP_TOTALAMOUNT_3
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select distinct from ZI_RTR_OLL_BYTP_TOTALAMOUNT_2(
                          P_CompanyCode : $parameters.P_CompanyCode,
                          P_KeyDate     : $parameters.P_KeyDate)

{
  key CompanyCode,
  key TradingPartner,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInSummary,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInTB,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountDifferent,

      cast('DUMMY' as abap.char(5) ) as DummyField,

      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}
where
  CompanyCode = $parameters.P_CompanyCode
