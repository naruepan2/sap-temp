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
@Search.searchable: true
define view entity ZI_RTR_OLL_GLAccount
  as select from I_GLAccount            as GLAccount

    join         ZI_RTR_OLL_GLAccount_0 as GLAccount_0 on  GLAccount_0.GLAccount   = GLAccount.GLAccount
                                                       and GLAccount_0.CompanyCode = GLAccount.CompanyCode

  association [0..1] to ZI_RTR_OLL_ROUClass as _ROUClass on $projection.ROUClass = _ROUClass.ROUClass
{
      @ObjectModel.text.association: '_Text'
      @Search.defaultSearchElement:true
      @Search.fuzzinessThreshold:0.8
      @Search.ranking:#HIGH
  key GLAccount.GLAccount,

      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_CompanyCodeStdVH',
                     element: 'CompanyCode' }
        }]
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key GLAccount.CompanyCode,

      @Consumption.valueHelpDefinition: [
        { entity:  { name:    'I_ChartOfAccountsStdVH',
                     element: 'ChartOfAccounts' }
        }]
      @ObjectModel.text.association: '_ChartOfAccountsText'
      @ObjectModel.foreignKey.association: '_ChartOfAccounts'
      GLAccount.ChartOfAccounts,

      @Consumption.hidden: true
      GLAccount_0.Identifier,

      cast(
        case
          when GLAccount_0.Parameter1 = 'LAND'
          then '1'

          when GLAccount_0.Parameter1 = 'BUILDING'
          then '2'

          when GLAccount_0.Parameter1 = 'PLANT_MACH'
          then '3'

          when GLAccount_0.Parameter1 = 'TOOL'
          then '4'

          when GLAccount_0.Parameter1 = 'FIXTURE_FI'
          then '5'

          when GLAccount_0.Parameter1 = 'VEHICLE'
          then '6'

          else ''
        end
        as ze_rou_class
      ) as ROUClass,

      GLAccount._ChartOfAccounts,
      GLAccount._ChartOfAccountsText,
      GLAccount._CompanyCode,
      GLAccount._GLAccountHierarchyNode,
      GLAccount._GLAccountInChartOfAccounts,
      GLAccount._GLAccountInCompanyCode,
      GLAccount._Text,
      _ROUClass
}
