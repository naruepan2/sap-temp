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
@EndUserText.label: 'Accounting Doc Item with Purchase Order'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_AccItemPO
  as select from ZI_RTR_RE_ROU_LCA_GLAccItPO_3 as GLAccItPO
{
  key GLAccItPO.CompanyCode,

  key GLAccItPO.AccountingDocument,

  key GLAccItPO.FiscalYear,

  key GLAccItPO.AccountingDocumentItem,

      GLAccItPO.InstallmentNo,

      GLAccItPO.RealEstateContract,

      GLAccItPO.ZZ1_AgreementNumber_Rec,

      GLAccItPO.PurchaseOrder,

      GLAccItPO.PurchaseOrderItem,

      GLAccItPO._REContract
}
