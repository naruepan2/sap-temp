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

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROU Outstanding Lease Liability - GL Account'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_GLAccount_0
  as select from I_GLAccount              as GLAccount

    join         ZI_EXT_AbapConfiguration as EXT_AbapConfiguration on EXT_AbapConfiguration.ValueLowChar = GLAccount.GLAccountExternal

{
  key GLAccount.GLAccount,

  key GLAccount.CompanyCode,

      cast( max( EXT_AbapConfiguration.Identifier ) as ze_identifier ) as Identifier,

      cast( max( EXT_AbapConfiguration.Parameter1 ) as ze_param1 )     as Parameter1
}

where
       EXT_AbapConfiguration.ProgramName = 'ZBP_I_RTR_ROU_OUTLEASELIABREP'
  and(
       EXT_AbapConfiguration.Identifier  = 'AP_CP_ROU_GL'
    or EXT_AbapConfiguration.Identifier  = 'CP_ROU_GL'
    or EXT_AbapConfiguration.Identifier  = 'LT_ROU_GL'
  )
  and  EXT_AbapConfiguration.ValueSign   = 'I'
  and  EXT_AbapConfiguration.ValueOption = 'EQ'

group by
  GLAccount.GLAccount,
  GLAccount.CompanyCode
