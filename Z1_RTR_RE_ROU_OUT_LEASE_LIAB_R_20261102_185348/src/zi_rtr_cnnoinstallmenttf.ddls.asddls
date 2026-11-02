/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 09.03.2026
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
@EndUserText.label: 'Contract No. of Installment TF'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #M
}
define table function ZI_RTR_CNNoInstallmentTF
  with parameters
    @Environment.systemField: #CLIENT
    P_Client : abap.clnt
returns
{
  key Client               : abap.clnt;
  key CompanyCode          : bukrs;
  key RealEstateContract   : recnvdmcnnr;
  key ItemNo               : abap.numc(4);
      StartOfConsideration : abap.dats;
      PaymentDueDate       : ze_receduedate;
      NoOfInstallment      : abap.numc(5);
}
implemented by method
  zcl_rtr_cnnoinstallmenttf=>get_data;
