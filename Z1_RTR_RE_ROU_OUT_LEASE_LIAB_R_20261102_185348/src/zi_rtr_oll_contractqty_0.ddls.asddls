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
@EndUserText.label: 'Contract Quantity'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ContractQty_0
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum
  as select from ZI_REContractData as REContract

    inner join   ZI_VICNMEASCN     as VICNMEASCN on VICNMEASCN.InternalRealEstateNumber = REContract.InternalRealEstateNumber
{
  key REContract.CompanyCode,

  key REContract.RealEstateContract,

      REContract.InternalRealEstateNumber,

      cast(
        max( concat( VICNMEASCN.ValidityEndDate, concat( VICNMEASCN.REMeasurementType, VICNMEASCN.REDifferingMeasurementObject ) ) )
        as abap.char( 34 )
      ) as REQtyObject
}
where
      REContract.CompanyCode       = $parameters.P_CompanyCode
  and VICNMEASCN.ValidityStartDate <= $parameters.P_KeyDate
  and VICNMEASCN.ValidityEndDate   >= $parameters.P_KeyDate

group by
  REContract.CompanyCode,
  REContract.RealEstateContract,
  REContract.InternalRealEstateNumber
