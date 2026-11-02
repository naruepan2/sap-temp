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

@EndUserText.label: 'Link RE Contract to Fixed Asset'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #XL, dataClass: #MIXED }

define view entity ZI_RTR_APCP_CONTRACTTOASSET_0
  as select from ZI_VICERULE       as Vicerule

    inner join   ZI_REContractData as REContractData on Vicerule.Intreno = REContractData.InternalRealEstateNumber

{
  key Vicerule.Intreno                                                     as Intreno,
  key bintohex(Vicerule.Ruleguid)                                          as Ruleguid,

      REContractData.CompanyCode                                           as CompanyCode,
      REContractData.ZZ1_AgreementNumber_Rec                               as AgreementNumber,
      REContractData.RealEstateContract                                    as RealEstateContract,
      Vicerule.Cerule                                                      as ValuationRule,
      Vicerule.Consbeg                                                     as StartOfConsideration,
      Vicerule.Assetobjnr,
      cast(substring(Vicerule.Assetobjnr, 3, 4) as bukrs preserving type)  as AssetCompanyCode,
      cast(substring(Vicerule.Assetobjnr, 7, 12) as anln1 preserving type) as MasterFixedAsset,
      cast(substring(Vicerule.Assetobjnr, 19, 4) as anln2 preserving type) as SubFixedAsset,
      REContractData.REContractType                                        as REContractType,
      REContractData.ContractStartDate                                     as ContractStartDate,
      REContractData.ContractEndDate                                       as ContractEndDate,
      REContractData.REContractName                                        as REContractName,
      REContractData.REContractActivateDate                                as REContractActivateDate,
      REContractData.ZZ1_DMValInstallPosted_Rec                            as DMValInstallPosted,
      REContractData.ZZ1_DMAPPosted_Rec                                    as DMAPPosted,

      cast(
        case
            when REContractData.ZZ1_DMAPPosted_Rec is not initial
            then 'X'
        else ''
        end as ze_isdmapposted preserving type)                            as IsDMAPPosted
}

where
  Vicerule.Cerule like 'ZROU%'

// e.g. 1994110000002 -> เอา digit ที่ 3 ต้องเป็น 9 เพราะเป็นสัญญา DM
union select from ZI_REContractData as REContractData

{
  key cast('' as recaintreno)                   as Intreno,
  key cast('0000000000000000' as abap.char(16)) as Ruleguid,

      REContractData.CompanyCode                as CompanyCode,
      REContractData.ZZ1_AgreementNumber_Rec    as AgreementNumber,
      REContractData.RealEstateContract         as RealEstateContract,
      cast('' as abap.char(10))                 as ValuationRule,
      cast('00000000' as abap.dats)             as StartOfConsideration,
      cast('' as abap.char(22))                 as Assetobjnr,
      cast('' as bukrs)                         as AssetCompanyCode,
      cast('' as anln1)                         as MasterFixedAsset,
      cast('' as anln2)                         as SubFixedAsset,
      REContractData.REContractType             as REContractType,
      REContractData.ContractStartDate          as ContractStartDate,
      REContractData.ContractEndDate            as ContractEndDate,
      REContractData.REContractName             as REContractName,
      REContractData.REContractActivateDate     as REContractActivateDate,
      REContractData.ZZ1_DMValInstallPosted_Rec as DMValInstallPosted,
      REContractData.ZZ1_DMAPPosted_Rec         as DMAPPosted,

      cast(
        case
            when REContractData.ZZ1_DMAPPosted_Rec is not initial
            then 'X'
        else ''
        end as ze_isdmapposted preserving type) as IsDMAPPosted
}

where
  substring(REContractData.RealEstateContract, 3, 1) = '9'
