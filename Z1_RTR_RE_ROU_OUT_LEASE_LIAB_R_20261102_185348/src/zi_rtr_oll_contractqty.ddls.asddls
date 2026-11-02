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
define view entity ZI_RTR_OLL_ContractQty
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum
  as select from ZI_RTR_OLL_ContractQty_0( P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate ) as ContractQty_0

  association [1..1] to ZI_VICNMEASCN as _VICNMEASCN on  $projection.InternalRealEstateNumber     = _VICNMEASCN.InternalRealEstateNumber
                                                     and $projection.REDifferingMeasurementObject = _VICNMEASCN.REDifferingMeasurementObject
                                                     and $projection.REMeasurementType            = _VICNMEASCN.REMeasurementType
                                                     and $projection.ValidityEndDate              = _VICNMEASCN.ValidityEndDate
{
  key ContractQty_0.CompanyCode,

  key ContractQty_0.RealEstateContract,

      ContractQty_0.InternalRealEstateNumber,

      ContractQty_0.REQtyObject,

      cast(
        substring( ContractQty_0.REQtyObject, 1, 8 )
        as ze_rebdmeasvalidto
      ) as ValidityEndDate,

      cast(
        substring( ContractQty_0.REQtyObject, 9, 4 )
        as rebdmeas
      ) as REMeasurementType,

      cast(
        substring( ContractQty_0.REQtyObject, 13, 22 )
        as ze_recnmsobjnr
      ) as REDifferingMeasurementObject,

      _VICNMEASCN
}
