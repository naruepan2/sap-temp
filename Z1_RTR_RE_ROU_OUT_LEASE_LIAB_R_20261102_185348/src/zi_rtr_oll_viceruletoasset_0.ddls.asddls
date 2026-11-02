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

@EndUserText.label: 'Link Valuation Rule to Fixed Asset'

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #M, dataClass: #MIXED }

define view entity ZI_RTR_OLL_VICERULETOASSET_0
  as select from ZI_RTR_APCP_CONTRACTTOASSET_1

{
  key Intreno,
  key Ruleguid,
      CompanyCode,
      RealEstateContract,
      AgreementNumber,
      ValuationRule,
      StartOfConsideration,
      Assetobjnr,
      AssetCompanyCode,
      MasterFixedAsset,
      SubFixedAsset,
      REContractType,
      ContractStartDate,
      ContractEndDate,
      REContractName,
      REContractActivateDate,
      DMValInstallPosted,
      DMAPPosted,
      IsDMAPPosted
}
