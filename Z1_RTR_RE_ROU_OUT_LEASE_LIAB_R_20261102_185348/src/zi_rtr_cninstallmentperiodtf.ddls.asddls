/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 11.02.2026
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

@EndUserText.label: 'Contract Installment Period TF'
@ClientHandling.type: #CLIENT_DEPENDENT
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #M
}
define table function ZI_RTR_CNInstallmentPeriodTF
  with parameters
    @Environment.systemField: #CLIENT
    P_Client : abap.clnt
returns
{
  key Client               : abap.clnt;
  key CompanyCode          : bukrs;
  key RealEstateContract   : recnvdmcnnr;
  key InstallmentNo        : abap.dec( 5, 0 );
      PaymentDueDate       : ze_receduedate;
}
implemented by method
  ZCL_RTR_CNInstallmentPeriodTF=>GET_DATA;
