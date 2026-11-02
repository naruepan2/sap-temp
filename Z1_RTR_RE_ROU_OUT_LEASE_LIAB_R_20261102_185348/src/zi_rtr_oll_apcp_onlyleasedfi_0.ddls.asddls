/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 11.09.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK927467
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

@EndUserText.label: 'ROU Outstanding Lease Liability Only_Lease/DFI'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_APCP_OnlyLeaseDFI_0
  with parameters
    P_KeyDate : datum

  // Lease
  as select from ZI_RTR_OLL_ContractGeneral           as ContractGeneral

    join         ZI_RTR_OLL_ContractValCFClr(
                   P_KeyDate : $parameters.P_KeyDate) as ContractValCFClr on  ContractValCFClr.CompanyCode        = ContractGeneral.CompanyCode
                                                                          and ContractValCFClr.RealEstateContract = ContractGeneral.RealEstateContract

{
  key ContractGeneral.CompanyCode,

  key ContractGeneral.RealEstateContract,

  key ContractGeneral.ZZ1_AgreementNumber_Rec as AgreementNumber,

  key cast(
        'L'
        as ze_rtr_oll_type
      )                                       as Type,

      cast(
        'L'
        as ze_rtr_oll_typegroup
      )                                       as TypeGroup,

      ContractGeneral.ROUClass,

      cast('Lease' as ze_rou_datasource)      as DataSource
}

where
  (
       ContractGeneral.AssetAcquisitionPostingDate            <= $parameters.P_KeyDate
    or ContractGeneral.IsCNDataMigration                      =  'X'
  )

  and(
       substring(ContractGeneral.ContractEndDate, 1, 4)       >= substring($parameters.P_KeyDate, 1, 4)
    or ContractGeneral._ViceruleToAsset.AssetDeactivationYear >= substring($parameters.P_KeyDate, 1, 4)
  )

// DFI
union select from ZI_RTR_OLL_ContractGeneral           as ContractGeneral

  join            ZI_RTR_OLL_ContractValCFInt(
                    P_KeyDate : $parameters.P_KeyDate) as ContractValCFInt on  ContractValCFInt.CompanyCode        = ContractGeneral.CompanyCode
                                                                           and ContractValCFInt.RealEstateContract = ContractGeneral.RealEstateContract

{
  key ContractGeneral.CompanyCode,

  key ContractGeneral.RealEstateContract,

  key ContractGeneral.ZZ1_AgreementNumber_Rec as AgreementNumber,

  key cast(
        'D'
        as ze_rtr_oll_type
      )                                       as Type,

      cast(
        'D'
        as ze_rtr_oll_typegroup
      )                                       as TypeGroup,

      ContractGeneral.ROUClass,

      cast('DFI' as ze_rou_datasource)        as DataSource
}

where
  (
       ContractGeneral.AssetAcquisitionPostingDate            <= $parameters.P_KeyDate // NW002(+)
    or ContractGeneral.IsCNDataMigration                      =  'X'
  )
  and(
       substring(ContractGeneral.ContractEndDate, 1, 4)       >= substring($parameters.P_KeyDate, 1, 4)
    or ContractGeneral._ViceruleToAsset.AssetDeactivationYear >= substring($parameters.P_KeyDate, 1, 4)
  )
