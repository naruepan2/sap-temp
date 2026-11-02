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

define view entity ZI_RTR_APCP_CONTRACTTOASSET_3
  with parameters
    P_KeyDate : datum

  as select from ZI_RTR_APCP_CONTRACTTOASSET_2( P_KeyDate: $parameters.P_KeyDate )
{
  key CompanyCode,
  key RealEstateContract,
      AgreementNumber,
      CompanyCodeCurrency,
      LessThan1Year,
      Between1And2Year,
      Between2And5Year,
      Between5And10Year,
      Between10And15Year,
      GreaterThan15Year,
      GLCurrentPortion,
      AssetAcquisitionPostingDate,
      DMValInstallPosted,
      IsCNDataMigration,
      ContractEndYear,
      DMAPPosted,
      IsDMAPPosted,
      AssetDeactivationDate,
      AssetDeactivationYear,
      AssetDeactivationMonth,
      AssetDeactivationDays,
      AssetDeactivationMonthDays
}
where
     dats_is_valid(AssetAcquisitionPostingDate) = 1
  or IsDMAPPosted                               = 'X'
  or IsCNDataMigration                          = 'X'
