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
@EndUserText.label: 'Contract Vary on Sales'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ContractVaryOnSales
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum
  as select from ZI_REContractData as REContract

    inner join   ZI_ReCondition    as RECondition on RECondition.InternalRealEstateNumber = REContract.InternalRealEstateNumber
{
  key REContract.CompanyCode,

  key REContract.RealEstateContract,

      count( distinct RECondition.REConditionUUID ) as CountREConditionUUID
}
where
      REContract.CompanyCode               = $parameters.P_CompanyCode
  and RECondition.ValidityStartDate        <= $parameters.P_KeyDate
  and RECondition.ValidityEndDate          >= $parameters.P_KeyDate
  and RECondition.REConditionType          like 'A%'
  and RECondition.REConditionIsToBeDeleted =    ''

group by
  REContract.CompanyCode,
  REContract.RealEstateContract
