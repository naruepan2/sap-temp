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

@EndUserText.label: 'Link RE Contract to Fixed Asset'

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #XL, dataClass: #MIXED }

define view entity ZI_RTR_APCP_CONTRACTTOASSET_1
  as select from ZI_RTR_APCP_CONTRACTTOASSET_0  as MainContractToAsset

    inner join   ZI_RTR_APCP_CONTRACTASSETMaxDt as ContractToAssetMaxConDt on  MainContractToAsset.CompanyCode          = ContractToAssetMaxConDt.CompanyCode
                                                                           and MainContractToAsset.RealEstateContract   = ContractToAssetMaxConDt.RealEstateContract
                                                                           and MainContractToAsset.StartOfConsideration = ContractToAssetMaxConDt.StartOfConsideration

  association [0..1] to I_MasterFixedAsset    as _MasterFixedAsset    on  $projection.CompanyCode      = _MasterFixedAsset.CompanyCode
                                                                      and $projection.MasterFixedAsset = _MasterFixedAsset.MasterFixedAsset
  association [0..1] to I_FixedAsset          as _FixedAsset          on  $projection.AssetCompanyCode = _FixedAsset.CompanyCode
                                                                      and $projection.MasterFixedAsset = _FixedAsset.MasterFixedAsset
                                                                      and $projection.SubFixedAsset    = _FixedAsset.FixedAsset
  association [0..*] to I_FixedAssetForLedger as _FixedAssetForLedger on  $projection.AssetCompanyCode = _FixedAssetForLedger.CompanyCode
                                                                      and $projection.MasterFixedAsset = _FixedAssetForLedger.MasterFixedAsset
                                                                      and $projection.SubFixedAsset    = _FixedAssetForLedger.FixedAsset
  association [0..1] to I_CompanyCode         as _CompanyCode         on  $projection.CompanyCode = _CompanyCode.CompanyCode
  association [0..1] to I_CompanyCode         as _AssetCompanyCode    on  $projection.AssetCompanyCode = _AssetCompanyCode.CompanyCode
{
  key MainContractToAsset.Intreno,
  key MainContractToAsset.Ruleguid,

      @ObjectModel.foreignKey.association: '_CompanyCode'
      MainContractToAsset.CompanyCode,
      MainContractToAsset.AgreementNumber,
      MainContractToAsset.RealEstateContract,
      MainContractToAsset.ValuationRule,
      MainContractToAsset.StartOfConsideration,
      MainContractToAsset.Assetobjnr,
      @ObjectModel.foreignKey.association: '_FixedAsset'
      MainContractToAsset.AssetCompanyCode,
      @ObjectModel.foreignKey.association: '_MasterFixedAsset'
      MainContractToAsset.MasterFixedAsset,
      @ObjectModel.foreignKey.association: '_FixedAsset'
      MainContractToAsset.SubFixedAsset,
      MainContractToAsset.REContractType,
      MainContractToAsset.ContractStartDate,
      MainContractToAsset.ContractEndDate,
      MainContractToAsset.REContractName,
      MainContractToAsset.REContractActivateDate,

      MainContractToAsset.DMValInstallPosted,
      MainContractToAsset.DMAPPosted,
      MainContractToAsset.IsDMAPPosted,
      _FixedAsset.AssetDeactivationDate,

      _MasterFixedAsset,
      _FixedAsset,
      _FixedAssetForLedger,
      _CompanyCode,
      _AssetCompanyCode
}
