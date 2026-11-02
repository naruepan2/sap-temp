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

@EndUserText.label: 'Max RE Contract Condition Date'

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #M, dataClass: #MIXED }

define view entity ZI_RTR_APCP_CONTRACTASSETMaxDt
  as select from ZI_RTR_APCP_CONTRACTTOASSET_0

{
  key CompanyCode,
  key RealEstateContract,

      max(StartOfConsideration) as StartOfConsideration
}

group by
  CompanyCode,
  RealEstateContract
