/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 18.02.2026
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
@EndUserText.label: 'Contract Current Portion/ Long Term of Lease Liability'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #XL
}
define view entity ZI_RTR_OLL_ContractCPLT
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_CPLT( P_KeyDate: $parameters.P_KeyDate ) as CPLT
{
  key CPLT.CompanyCode,

  key CPLT.RealEstateContract,

      CPLT.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when CPLT.Identifier = 'CP_ROU_GL'
            then ( CPLT.AmountInCompanyCodeCurrency * -1 )
          end
        )
        as ze_glcurrentportion
      ) as GLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when CPLT.Identifier = 'LT_ROU_GL'
            then ( CPLT.AmountInCompanyCodeCurrency * -1 )
          end
        )
        as ze_gllongterm
      ) as GLLongTerm
}

group by
  CPLT.CompanyCode,
  CPLT.RealEstateContract,
  CPLT.CompanyCodeCurrency
