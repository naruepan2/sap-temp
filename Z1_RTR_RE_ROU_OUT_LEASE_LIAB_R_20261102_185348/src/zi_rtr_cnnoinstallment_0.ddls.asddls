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

@EndUserText.label: 'Contract with Max Start of Consideration'

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #M, dataClass: #MIXED }

define view entity ZI_RTR_CNNOINSTALLMENT_0
  as select from ZI_RTR_CNNoInstallmentTF(P_Client : $session.client)

    inner join   ZI_RTR_CNNoInstallmentMaxConDt on  ZI_RTR_CNNoInstallmentTF.CompanyCode          = ZI_RTR_CNNoInstallmentMaxConDt.CompanyCode
                                                and ZI_RTR_CNNoInstallmentTF.RealEstateContract   = ZI_RTR_CNNoInstallmentMaxConDt.RealEstateContract
                                                and ZI_RTR_CNNoInstallmentTF.StartOfConsideration = ZI_RTR_CNNoInstallmentMaxConDt.StartOfConsideration

{
  key ZI_RTR_CNNoInstallmentTF.CompanyCode,
  key ZI_RTR_CNNoInstallmentTF.RealEstateContract,

      max(ZI_RTR_CNNoInstallmentTF.NoOfInstallment) as NoOfInstallment
}

group by
  ZI_RTR_CNNoInstallmentTF.CompanyCode,
  ZI_RTR_CNNoInstallmentTF.RealEstateContract
