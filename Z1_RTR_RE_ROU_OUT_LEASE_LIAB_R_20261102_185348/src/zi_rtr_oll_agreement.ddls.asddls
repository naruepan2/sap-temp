/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 12.02.2026
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

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROU Outstanding Lease Liability - Agreement'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_Agreement
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_APCP( P_KeyDate: $parameters.P_KeyDate ) as APCP

  association [1..1] to I_CompanyCode       as _CompanyCode on $projection.CompanyCode = _CompanyCode.CompanyCode

  association [0..1] to ZI_RTR_OLL_ROUClass as _ROUClass    on $projection.ROUClass = _ROUClass.ROUClass
{
  key APCP.CompanyCode,

  key APCP.AgreementNumber,

      cast(
        max( APCP.ROUClass )
        as ze_rou_class
      ) as ROUClass,

      _CompanyCode,
      _ROUClass
}

group by
  APCP.CompanyCode,
  APCP.AgreementNumber
