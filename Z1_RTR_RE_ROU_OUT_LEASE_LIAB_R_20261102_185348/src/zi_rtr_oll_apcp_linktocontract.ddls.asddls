/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 11.09.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK927467
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

@EndUserText.label: 'ROU Outstanding Lease Liab. Link To Contract'

@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_OLL_APCP_LinkToContract
  with parameters
    P_KeyDate : datum

  as select distinct from ZI_RTR_OLL_Agreement(
                            P_KeyDate : $parameters.P_KeyDate) as Agreement

    join                  ZI_RTR_APCP_CONTRACTTOAPCP(
                            P_KeyDate : $parameters.P_KeyDate) as ContractAPCP    on  ContractAPCP.CompanyCode     = Agreement.CompanyCode
                                                                                  and ContractAPCP.AgreementNumber = Agreement.AgreementNumber

    join                  ZI_RTR_OLL_ContractGeneral           as ContractGeneral on  ContractGeneral.CompanyCode             = Agreement.CompanyCode
                                                                                  and ContractGeneral.ZZ1_AgreementNumber_Rec = Agreement.AgreementNumber
                                                                                  and ContractGeneral.ROUClass                = Agreement.ROUClass

    join                  ZI_RTR_OLL_CountAgreement(
                            P_KeyDate : $parameters.P_KeyDate) as CountAgreement  on  CountAgreement.CompanyCode     = Agreement.CompanyCode
                                                                                  and CountAgreement.AgreementNumber = Agreement.AgreementNumber

{
  key Agreement.CompanyCode,
  key Agreement.AgreementNumber,

      cast(
        case
        when CountAgreement.CountRealEstateContract = 1
        then ContractGeneral.RealEstateContract
        else cast('' as recnvdmcnnr)
        end
      as recnvdmcnnr preserving type) as RealEstateContract,

      Agreement.ROUClass,
      ContractAPCP.CompanyCodeCurrency
}
