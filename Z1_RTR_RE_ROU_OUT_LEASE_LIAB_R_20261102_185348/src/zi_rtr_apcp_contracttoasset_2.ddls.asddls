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

@EndUserText.label: 'Link RE Contract, Fixed Asset and APCP'

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_APCP_CONTRACTTOASSET_2
  with parameters
    P_KeyDate : datum

  as select from ZI_RTR_APCP_CONTRACTTOASSET_1        as ContractToAsset

    inner join   ZI_RTR_OLL_ContractAPCP(
                   P_KeyDate : $parameters.P_KeyDate) as ContractAPCP    on  ContractAPCP.CompanyCode     = ContractToAsset.CompanyCode
                                                                         and ContractAPCP.AgreementNumber = ContractToAsset.AgreementNumber

    inner join   ZI_RTR_OLL_ContractGeneral           as ContractGeneral on  ContractGeneral.CompanyCode        = ContractToAsset.CompanyCode
                                                                         and ContractGeneral.RealEstateContract = ContractToAsset.RealEstateContract

{
  key ContractToAsset.CompanyCode,
  key ContractToAsset.RealEstateContract,

      ContractToAsset.AgreementNumber,
      ContractAPCP.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractAPCP.LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractAPCP.Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractAPCP.Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractAPCP.Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractAPCP.Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractAPCP.GreaterThan15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractAPCP.GLCurrentPortion,

      ContractGeneral.AssetAcquisitionPostingDate,
      ContractToAsset.DMValInstallPosted,
      ContractGeneral.IsCNDataMigration,
      cast(substring(ContractGeneral.ContractEndDate, 1, 4) as abap.numc(4))   as ContractEndYear,
      ContractToAsset.DMAPPosted,
      ContractToAsset.IsDMAPPosted,

      cast(
          case
            when dats_is_valid(ContractToAsset.AssetDeactivationDate)       = 0
             and dats_is_valid(ContractGeneral.AssetAcquisitionPostingDate) = 1
                then cast('99991231' as abap.dats)
            else ContractToAsset.AssetDeactivationDate
          end as deakt preserving type)                                        as AssetDeactivationDate,

      cast(substring($projection.AssetDeactivationDate, 1, 4) as abap.numc(4)) as AssetDeactivationYear,
      cast(substring($projection.AssetDeactivationDate, 5, 2) as abap.numc(2)) as AssetDeactivationMonth,
      cast(substring($projection.AssetDeactivationDate, 7, 2) as abap.numc(2)) as AssetDeactivationDays,
      cast(substring($projection.AssetDeactivationDate, 1, 6) as abap.numc(6)) as AssetDeactivationMonthDays
}
