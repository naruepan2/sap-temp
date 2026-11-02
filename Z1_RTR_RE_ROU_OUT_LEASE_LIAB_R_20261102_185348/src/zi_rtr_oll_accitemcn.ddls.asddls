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
@EndUserText.label: 'Accounting Doc Item with CN'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_AccItemCN
  as select from ZI_RTR_RE_ROU_LCA_GLAccItCN_2 as GLAccItCN
{
  key GLAccItCN.CompanyCode,

  key GLAccItCN.AccountingDocument,

  key GLAccItCN.FiscalYear,

  key GLAccItCN.AccountingDocumentItem,

      GLAccItCN.InstallmentNo,

      GLAccItCN.RealEstateContract,

      GLAccItCN.ZZ1_AgreementNumber_Rec,

      GLAccItCN._REContract
}
