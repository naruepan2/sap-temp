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
@EndUserText.label: 'Contract Type to ROU Class'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ContractType2Class
  as select from ZI_TIVCEASSETDIF         as TIVCEASSETDIF

    join         ZI_RTR_OLL_AccDeterClass as AccDeterClass on AccDeterClass.AccountDeterminationValue = TIVCEASSETDIF.AccountDeterminationValue

  association [0..1] to ZI_RTR_OLL_ROUClass as _ROUClass on $projection.ROUClass = _ROUClass.ROUClass
{
  key TIVCEASSETDIF.CompanyCode,

  key TIVCEASSETDIF.REContractType,

      cast(
        max( AccDeterClass.ROUClass )
        as ze_rou_class
      ) as ROUClass,
      
      _ROUClass
}
where
  TIVCEASSETDIF.ObjectType = 'IS'

group by
  TIVCEASSETDIF.CompanyCode,
  TIVCEASSETDIF.REContractType
