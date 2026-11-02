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

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_APCP_CONTRACTTOAPCP
  with parameters
    P_KeyDate : datum

  as select distinct from ZI_RTR_APCP_CONTRACTTOASSET_3(P_KeyDate : $parameters.P_KeyDate) as ContractToAssetAPCP

{
  key ContractToAssetAPCP.CompanyCode,
  key ContractToAssetAPCP.AgreementNumber,

      ContractToAssetAPCP.CompanyCodeCurrency,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractToAssetAPCP.LessThan1Year,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractToAssetAPCP.Between1And2Year,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractToAssetAPCP.Between2And5Year,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractToAssetAPCP.Between5And10Year,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractToAssetAPCP.Between10And15Year,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractToAssetAPCP.GreaterThan15Year,
      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractToAssetAPCP.GLCurrentPortion
}

where
  // If has any of AP-CP = 0.00
  (
    (
             LessThan1Year               is not null
      and    LessThan1Year               is not initial
    )
    or(
             Between1And2Year            is not null
      and    Between1And2Year            is not initial
    )
    or(
             Between2And5Year            is not null
      and    Between2And5Year            is not initial
    )
    or(
             Between5And10Year           is not null
      and    LessThan1Year               is not initial
    )
    or(
             Between10And15Year          is not null
      and    Between10And15Year          is not initial
    )
    or(
             GreaterThan15Year           is not null
      and    GreaterThan15Year           is not initial
    )
    or(
             GLCurrentPortion            is not null
      and    GLCurrentPortion            is not initial
    )
  )
  // 1. If has any of AP-CP <> 0.00,
  // 2. If DM AP Posted > 0 or Asset Acquisition Posting Date < As Date (Key Date)
  //    and Asset Deactivation Year >= As Date (Key Date) or Contract that has year of end of term >= As Date (Key Date)
  or(
             // If has any of AP-CP <> 0.00
             (
               (
                 LessThan1Year           is null
                 or   LessThan1Year      is initial
               )
               and(
                      Between1And2Year   is null
                 or   Between1And2Year   is initial
               )
               and(
                      Between2And5Year   is null
                 or   Between2And5Year   is initial
               )
               and(
                      Between5And10Year  is null
                 or   LessThan1Year      is initial
               )
               and(
                      Between10And15Year is null
                 or   Between10And15Year is initial
               )
               and(
                      GreaterThan15Year  is null
                 or   GreaterThan15Year  is initial
               )
               and(
                      GLCurrentPortion   is null
                 or   GLCurrentPortion   is initial
               )
             )
    and(
      (
             // Contract that has asset acquisition posting date < As of date.
             AssetAcquisitionPostingDate < $parameters.P_KeyDate
        or   IsCNDataMigration           = 'X'
      )
      and(
        (
             // Contract that has AssetDeactivationYear >= year of as of date or
             // Contract that has year of end of term (RECNENDABS) >= year of as of date.
             AssetDeactivationYear       >= cast(substring($parameters.P_KeyDate, 1, 4) as abap.numc( 4 ))
          or ContractEndYear             >= cast(substring($parameters.P_KeyDate, 1, 4) as abap.numc( 4 ))
        )
      )
    )
  )
