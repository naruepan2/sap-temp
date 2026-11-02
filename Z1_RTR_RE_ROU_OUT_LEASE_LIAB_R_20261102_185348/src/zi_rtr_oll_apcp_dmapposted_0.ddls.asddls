/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 17.03.2026
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

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'DM AP Posted'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #M }

define view entity ZI_RTR_OLL_APCP_DMAPPosted_0
  as select from ZI_VICNCN

{
  key ZI_VICNCN.Bukrs                                                                        as CompanyCode,
  key ZI_VICNCN.Zz1AgreementnumberRec                                                        as AgreementNumber,

      max(cast(cast(ZI_VICNCN.Zz1DmappostedRec as abap.char(6)) as ze_currentapinstallment)) as CurrentAPInstallment
}
where
      ZI_VICNCN.Bukrs                 is not initial
  and ZI_VICNCN.Zz1AgreementnumberRec is not initial
  and ZI_VICNCN.Zz1DmappostedRec      is not initial
group by
  ZI_VICNCN.Bukrs,
  ZI_VICNCN.Zz1AgreementnumberRec
