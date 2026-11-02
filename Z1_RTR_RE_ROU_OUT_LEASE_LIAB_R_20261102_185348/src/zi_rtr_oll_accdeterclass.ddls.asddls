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
@EndUserText.label: 'ROU Outstanding Lease Liability - Account Determine Class'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_AccDeterClass
  as select from ZI_RTR_OLL_AccDeterClass_0 as AccDeterClass_0

  association [0..1] to ZI_RTR_OLL_ROUClass as _ROUClass on $projection.ROUClass = _ROUClass.ROUClass
{
  key AccDeterClass_0.AccountDeterminationValue,

      AccDeterClass_0.Identifier,

      cast(
        case
          when AccDeterClass_0.Parameter1 = 'LAND'
          then '1'

          when AccDeterClass_0.Parameter1 = 'BUILDING'
          then '2'

          when AccDeterClass_0.Parameter1 = 'PLANT_MACH'
          then '3'

          when AccDeterClass_0.Parameter1 = 'TOOL'
          then '4'

          when AccDeterClass_0.Parameter1 = 'FIXTURE_FI'
          then '5'

          when AccDeterClass_0.Parameter1 = 'VEHICLE'
          then '6'

          else ''
        end
        as ze_rou_class
      ) as ROUClass,

      _ROUClass
}
