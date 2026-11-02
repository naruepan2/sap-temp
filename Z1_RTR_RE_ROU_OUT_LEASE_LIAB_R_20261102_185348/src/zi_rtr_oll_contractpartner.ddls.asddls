/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 09.02.2026
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
@EndUserText.label: 'Contract Partner'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #L
}
define view entity ZI_RTR_OLL_ContractPartner
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from ZI_REContractData  as REContract

    inner join   ZI_REPartnerAssgmt as REPartnerAssgmt on REPartnerAssgmt.InternalRealEstateNumber = REContract.InternalRealEstateNumber

  association [0..1] to I_BusinessPartner as _BusinessPartner on $projection.BusinessPartner = _BusinessPartner.BusinessPartner

  association [0..1] to ZI_BP001          as _BP001           on $projection.BusinessPartner = _BP001.Partner
{
  key REContract.CompanyCode,

  key REContract.RealEstateContract,

  key REPartnerAssgmt.BusinessPartnerRole,

      @ObjectModel.foreignKey.association: '_BusinessPartner'
      cast(
        max( REPartnerAssgmt.BusinessPartner )
        as ze_businesspartner ) as BusinessPartner,

      _BusinessPartner,
      _BP001
}

where
      REContract.CompanyCode            = $parameters.P_CompanyCode
  and REPartnerAssgmt.ValidityStartDate <= $parameters.P_KeyDate
  and REPartnerAssgmt.ValidityEndDate   >= $parameters.P_KeyDate

group by
  REContract.CompanyCode,
  REContract.RealEstateContract,
  REPartnerAssgmt.BusinessPartnerRole
