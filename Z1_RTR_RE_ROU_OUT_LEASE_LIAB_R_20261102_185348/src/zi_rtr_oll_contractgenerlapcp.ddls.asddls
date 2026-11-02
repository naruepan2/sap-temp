//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
/////////////////////////////////////////////////////////////////////////
@AccessControl.authorizationCheck: #NOT_REQUIRED

@ClientHandling.algorithm: #SESSION_VARIABLE
@ClientHandling.type: #CLIENT_DEPENDENT

@EndUserText.label: 'ROU Outstanding Lease Liability (AP-CP)'

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define table function ZI_RTR_OLL_CONTRACTGENERLAPCP
  with parameters
    @Environment.systemField: #CLIENT
    P_Client      : abap.clnt,

    P_CompanyCode : bukrs,

    @Environment.systemField: #SYSTEM_DATE
    P_KeyDate     : abap.dats

returns

{
  key Client                  : abap.clnt;
  key CompanyCode             : bukrs;
  key AgreementNumber         : ze_rtr_agreementnumber;

      @Semantics.currencyCode: true
      REContractCurrency      : recnwaers_cn;

      @Semantics.currencyCode: true
      CompanyCodeCurrency     : waers;

      IsVaryOnSales           : ze_isvaryonsales;
      ExtensionOption         : abap.char(1);
      RetireObligation        : abap.char(1);
      TerminateOption         : abap.char(1);
      PaymentMethod           : ze_recdpaymentformrh_char1;
      InstallmentFrequency    : ze_installmentfrequency;
      InterestRateType        : abap.char(3);
      REInterestRate          : ze_receinterestrate;
      PurchaseOption          : abap.char(1);
      GuaranteeResidualv      : abap.char(1);
      BusinessPartnerSupplier : ze_businesspartner;
      TradingPartner          : rassc;
}

implemented by method
  zcl_rtr_oll_contractgenerlapcp=>get_contractgeneralapcp;
