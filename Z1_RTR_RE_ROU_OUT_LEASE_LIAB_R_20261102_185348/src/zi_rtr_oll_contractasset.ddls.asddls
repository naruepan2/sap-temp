/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 10.02.2026
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
@EndUserText.label: 'Contract Asset'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #XXL
}
define view entity ZI_RTR_OLL_ContractAsset
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum
  as select from ZI_RTR_OLL_ContractAsset_0( P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate ) as ContractAsset_0

  association [0..1] to I_FixedAsset          as _FixedAsset          on  $projection.CompanyCode      = _FixedAsset.CompanyCode
                                                                      and $projection.MasterFixedAsset = _FixedAsset.MasterFixedAsset
                                                                      and $projection.FixedAsset       = _FixedAsset.FixedAsset

  association [0..*] to I_FixedAssetForLedger as _FixedAssetForLedger on  $projection.CompanyCode      = _FixedAssetForLedger.CompanyCode
                                                                      and $projection.MasterFixedAsset = _FixedAssetForLedger.MasterFixedAsset
                                                                      and $projection.FixedAsset       = _FixedAssetForLedger.FixedAsset

{
  key ContractAsset_0.CompanyCode,

  key ContractAsset_0.RealEstateContract,

      ContractAsset_0.REStatusObjectAsset,

      cast(
        substring( ContractAsset_0.REStatusObjectAsset, 7, 12 )
        as anln1 preserving type
      ) as MasterFixedAsset,

      cast(
        substring( ContractAsset_0.REStatusObjectAsset, 19, 4 )
        as anln2 preserving type
      ) as FixedAsset,

      _FixedAsset,
      _FixedAssetForLedger
}
