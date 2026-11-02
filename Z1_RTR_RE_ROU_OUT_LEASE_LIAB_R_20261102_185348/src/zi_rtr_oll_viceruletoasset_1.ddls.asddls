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

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity ZI_RTR_OLL_VICERULETOASSET_1
  as select from ZI_RTR_OLL_VICERULETOASSET_0 as ViceruleGeneral

  association [0..1] to I_MasterFixedAsset as _MasterFixedAsset on  $projection.CompanyCode      = _MasterFixedAsset.CompanyCode
                                                                and $projection.MasterFixedAsset = _MasterFixedAsset.MasterFixedAsset

  association [0..1] to I_FixedAsset       as _FixedAsset       on  $projection.AssetCompanyCode = _FixedAsset.CompanyCode
                                                                and $projection.MasterFixedAsset = _FixedAsset.MasterFixedAsset
                                                                and $projection.SubFixedAsset    = _FixedAsset.FixedAsset

  association [0..1] to I_CompanyCode      as _CompanyCode      on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [0..1] to I_CompanyCode      as _AssetCompanyCode on  $projection.AssetCompanyCode = _AssetCompanyCode.CompanyCode

{
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key ViceruleGeneral.CompanyCode,

  key ViceruleGeneral.RealEstateContract,

      ViceruleGeneral.AgreementNumber,

      @ObjectModel.foreignKey.association: '_AssetCompanyCode'
      ViceruleGeneral.AssetCompanyCode                                         as AssetCompanyCode,

      @ObjectModel.foreignKey.association: '_MasterFixedAsset'
      ViceruleGeneral.MasterFixedAsset                                         as MasterFixedAsset,

      @ObjectModel.foreignKey.association: '_FixedAsset'
      ViceruleGeneral.SubFixedAsset                                            as SubFixedAsset,

      cast(
          case
            when dats_is_valid(_FixedAsset.AssetDeactivationDate) = 0
                then cast('99991231' as abap.dats)
            else _FixedAsset.AssetDeactivationDate
          end as deakt preserving type)                                        as AssetDeactivationDate,

      cast(substring($projection.AssetDeactivationDate, 1, 4) as abap.numc(4)) as AssetDeactivationYear,
      cast(substring($projection.AssetDeactivationDate, 5, 2) as abap.numc(2)) as AssetDeactivationMonth,
      cast(substring($projection.AssetDeactivationDate, 7, 2) as abap.numc(2)) as AssetDeactivationDays,
      cast(substring($projection.AssetDeactivationDate, 1, 6) as abap.numc(6)) as AssetDeactivationMonthDays,

      /* Associations */
      _MasterFixedAsset,
      _FixedAsset,
      _CompanyCode,
      _AssetCompanyCode
}
