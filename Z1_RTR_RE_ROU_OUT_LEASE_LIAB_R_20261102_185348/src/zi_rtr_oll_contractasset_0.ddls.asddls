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
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ContractAsset_0
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum
  as select from ZI_REContractData  as REContract

    inner join   ZI_REValuationRule as REValuationRule on REValuationRule.InternalRealEstateNumber = REContract.InternalRealEstateNumber
{
  key REContract.CompanyCode,

  key REContract.RealEstateContract,

      cast(
        max( REValuationRule.REStatusObjectAsset )
        as ze_recevdmasobjnr preserving type
      ) as REStatusObjectAsset
}
where
       REContract.CompanyCode            = $parameters.P_CompanyCode
  and  REValuationRule.ValidityStartDate <= $parameters.P_KeyDate
  and  REValuationRule.ValidityEndDate   >= $parameters.P_KeyDate
  and(
       REValuationRule.REValuationRule   = 'ZROU'
    or REValuationRule.REValuationRule   = 'ZROU_BA'
  )

group by
  REContract.CompanyCode,
  REContract.RealEstateContract
