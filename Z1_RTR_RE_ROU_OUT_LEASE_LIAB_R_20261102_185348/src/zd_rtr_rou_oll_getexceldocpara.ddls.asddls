/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 13.02.2026
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

@EndUserText.label: 'ROU Outstanding Lease Liability - Get Excel Document Param'
define abstract entity ZD_RTR_ROU_OLL_GetExcelDocPara
{
  key DummyKey           : abap.char(1);

  key CompanyCode        : bukrs;

  key RealEstateContract : recnvdmcnnr;

  key AgreementNumber    : ze_agreementnumber;

  key Type               : ze_rtr_oll_type;

      _DummyAssociation  : association to parent ZD_RTR_ROU_OLL_GetExcelParam on $projection.DummyKey = _DummyAssociation.DummyKey;
}
