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

@EndUserText.label: 'ROU Outstanding Lease Liability - Get Excel Param'

define root abstract entity ZD_RTR_ROU_OLL_GetExcelParam
{
  key DummyKey    : abap.char(1);

      @Consumption.valueHelpDefinition: [
        {
          entity  : { name: 'I_CompanyCodeVH', element: 'CompanyCode' },
          useForValidation: true
        }
      ]
      CompanyCode : bukrs;

      KeyDate     : datum;

      _Document   : composition [0..*] of ZD_RTR_ROU_OLL_GetExcelDocPara;
}
