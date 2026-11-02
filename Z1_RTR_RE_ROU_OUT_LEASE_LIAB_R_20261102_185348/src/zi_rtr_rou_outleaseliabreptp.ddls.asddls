/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 12.02.2026
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

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'ROU Outstanding Lease Liability'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #C, sizeCategory: #XL }

define root view entity ZI_RTR_ROU_OutLeaseLiabRepTP
  with parameters
    @Consumption.hidden: true
    P_CompanyCode : bukrs,

    @Consumption.hidden: true
    P_KeyDate     : datum

  as select from ZI_RTR_ROU_OutLeaseLiabRep(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate) as OutLeaseLiabRep

{
  key OutLeaseLiabRep.CompanyCode,
  key OutLeaseLiabRep.RealEstateContract,
  key OutLeaseLiabRep.AgreementNumber,
  key OutLeaseLiabRep.Type
}
