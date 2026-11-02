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

@EndUserText.label: 'Group by Outstanding Lease Liability and Derfer by TP'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #L }

define view entity ZI_RTR_OLL_AcctDocItemByTP
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_RTR_OLL_BYTP_TotalAmount_0(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as OLL_ByTPTLAmt

{
  key CompanyCode,
  key TradingPartner,
  key Type,
  key TypeGroup,

      CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      AmountInCompanyCodeCurrency,

      'ROU' as TypeCategory,

      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}

union select from ZI_RTR_OLL_AcctDocItemByTP_0(
                    P_CompanyCode : $parameters.P_CompanyCode,
                    P_KeyDate     : $parameters.P_KeyDate) as AcctDocItemByTP

{
  key CompanyCode,
  key TradingPartner,
  key Type,
  key TypeGroup,

      CompanyCodeCurrency,
      AmountInCompanyCodeCurrency,
      'ACCTDOCITEM' as TypeCategory,

      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}
