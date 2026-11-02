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

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #L }

define view entity ZI_RTR_OLL_AcctDocItemByTP_1
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_OLL_AcctDocItemByTP_0(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate)

{
  key CompanyCode,
  key TradingPartner,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      sum(AmountInCompanyCodeCurrency) as AmountInCompanyCodeCurrency,

      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}

group by
  CompanyCode,
  TradingPartner,
  CompanyCodeCurrency
