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
// 10/03/2026 | GSDK911054 | NW001 | Naruepan W. | Change formula of APCP amount
// 29/05/2026 | GSDK918618 | NW002 | Naruepan W. | Change AssetAcquisitionPostingDate < $parameters.P_KeyDate
//                                                 to AssetAcquisitionPostingDate <= $parameters.P_KeyDate
// 10/09/2026 | GSDK927467 | NW003 | Naruepan W. | Add association to ZI_RTR_OLL_CONTRACTGENERLAPCP and
//                                                 ZI_RTR_OLL_APCP_LinkToContract
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #CHECK

@EndUserText.label: 'ROU Outstanding Lease Liability'

@Metadata.ignorePropagatedAnnotations: true

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #C, sizeCategory: #XL }

define view entity ZI_RTR_ROU_OutLeaseLiabRep_0
  with parameters
    P_KeyDate : datum

  // Lease
  as select from    ZI_RTR_OLL_ContractGeneral           as ContractGeneral

    join            ZI_RTR_OLL_ContractValCFClr(
                      P_KeyDate : $parameters.P_KeyDate) as ContractValCFClr on  ContractValCFClr.CompanyCode        = ContractGeneral.CompanyCode
                                                                             and ContractValCFClr.RealEstateContract = ContractGeneral.RealEstateContract

    left outer join ZI_RTR_OLL_ContractCPLT(
                      P_KeyDate : $parameters.P_KeyDate) as ContractCPLT     on  ContractCPLT.CompanyCode        = ContractGeneral.CompanyCode
                                                                             and ContractCPLT.RealEstateContract = ContractGeneral.RealEstateContract

  association [0..1] to ZI_RTR_OLL_CONTRACTGENERLAPCP as _ContractGenerlAPCP on  $projection.CompanyCode     = _ContractGenerlAPCP.CompanyCode // NW003 (+)
                                                                             and $projection.AgreementNumber = _ContractGenerlAPCP.AgreementNumber // NW003 (+)

{
  key ContractGeneral.CompanyCode,

  key ContractGeneral.RealEstateContract,

  key ContractGeneral.ZZ1_AgreementNumber_Rec as AgreementNumber,

  key cast(
        'L'
        as ze_rtr_oll_type
      )                                       as Type,

      cast(
        'L'
        as ze_rtr_oll_typegroup
      )                                       as TypeGroup,

      ContractGeneral.ROUClass,

      ContractGeneral.CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractValCFClr.LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractValCFClr.Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractValCFClr.Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractValCFClr.Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractValCFClr.Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractValCFClr.GreaterThan15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractCPLT.GLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      ContractCPLT.GLLongTerm,

      cast('Lease' as ze_rou_datasource )     as DataSource, // NW001 (+)

      _ContractGenerlAPCP // NW003 (+)

}

where
  (
       //       ContractGeneral.AssetAcquisitionPostingDate            < $parameters.P_KeyDate      //NW002(-)
       ContractGeneral.AssetAcquisitionPostingDate            <= $parameters.P_KeyDate //NW002(+)
    or ContractGeneral.IsCNDataMigration                      =  'X'
  )

  //  and  substring(ContractGeneral.ContractEndDate, 1, 4) >= substring($parameters.P_KeyDate, 1, 4)       // NW001 (-)
  and(
       substring(ContractGeneral.ContractEndDate, 1, 4)       >= substring($parameters.P_KeyDate, 1, 4) // NW001 (+)
    or ContractGeneral._ViceruleToAsset.AssetDeactivationYear >= substring($parameters.P_KeyDate, 1, 4) // NW001 (+)
  )
// DFI
union select from ZI_RTR_OLL_ContractGeneral           as ContractGeneral

  join            ZI_RTR_OLL_ContractValCFInt(
                    P_KeyDate : $parameters.P_KeyDate) as ContractValCFInt on  ContractValCFInt.CompanyCode        = ContractGeneral.CompanyCode
                                                                           and ContractValCFInt.RealEstateContract = ContractGeneral.RealEstateContract

association [0..1] to ZI_RTR_OLL_CONTRACTGENERLAPCP as _ContractGenerlAPCP on  $projection.CompanyCode     = _ContractGenerlAPCP.CompanyCode // NW003 (+)
                                                                           and $projection.AgreementNumber = _ContractGenerlAPCP.AgreementNumber // NW003 (+)

{
  key ContractGeneral.CompanyCode,

  key ContractGeneral.RealEstateContract,

  key ContractGeneral.ZZ1_AgreementNumber_Rec as AgreementNumber,

  key cast(
        'D'
        as ze_rtr_oll_type
      )                                       as Type,

      cast(
        'D'
        as ze_rtr_oll_typegroup
      )                                       as TypeGroup,

      ContractGeneral.ROUClass,

      ContractGeneral.CompanyCodeCurrency,

      ContractValCFInt.LessThan1Year,

      ContractValCFInt.Between1And2Year,

      ContractValCFInt.Between2And5Year,

      ContractValCFInt.Between5And10Year,

      ContractValCFInt.Between10And15Year,

      ContractValCFInt.GreaterThan15Year,

      cast(0 as ze_glcurrentportion)          as GLCurrentPortion,

      cast(0 as ze_gllongterm)                as GLLongTerm,

      cast('DFI' as ze_rou_datasource )       as DataSource, // NW001 (+)

      _ContractGenerlAPCP // NW003 (+)
}

where
  (
       //       ContractGeneral.AssetAcquisitionPostingDate            < $parameters.P_KeyDate              //NW002(-)
       ContractGeneral.AssetAcquisitionPostingDate            <= $parameters.P_KeyDate //NW002(+)
    or ContractGeneral.IsCNDataMigration                      =  'X'
  )

  //  and  substring(ContractGeneral.ContractEndDate, 1, 4) >= substring($parameters.P_KeyDate, 1, 4)       // NW001 (-)
  and(
       substring(ContractGeneral.ContractEndDate, 1, 4)       >= substring($parameters.P_KeyDate, 1, 4) // NW001 (+)
    or ContractGeneral._ViceruleToAsset.AssetDeactivationYear >= substring($parameters.P_KeyDate, 1, 4) // NW001 (+)
  )
// AP-CP
union select from ZI_RTR_OLL_Agreement(
                    P_KeyDate : $parameters.P_KeyDate) as Agreement


//  join            ZI_RTR_OLL_ContractAPCP( P_KeyDate: $parameters.P_KeyDate ) as ContractAPCP on  ContractAPCP.CompanyCode     = Agreement.CompanyCode        // NW001 (-)
//                                                                                              and ContractAPCP.AgreementNumber = Agreement.AgreementNumber    // NW001 (-)

  join            ZI_RTR_APCP_CONTRACTTOAPCP(                                                                                                        // NW001 (+)
                    P_KeyDate : $parameters.P_KeyDate) as ContractAPCP       on  ContractAPCP.CompanyCode     = Agreement.CompanyCode                // NW001 (+)
                                                                             and ContractAPCP.AgreementNumber = Agreement.AgreementNumber            // NW001 (+)

  join            ZI_RTR_OLL_APCP_LinkToContract(
                    P_KeyDate : $parameters.P_KeyDate) as APCPLinkToContract on  ContractAPCP.CompanyCode     = APCPLinkToContract.CompanyCode // NW003 (+)
                                                                             and ContractAPCP.AgreementNumber = APCPLinkToContract.AgreementNumber // NW003 (+)

association [0..1] to ZI_RTR_OLL_CONTRACTGENERLAPCP as _ContractGenerlAPCP on  $projection.CompanyCode     = _ContractGenerlAPCP.CompanyCode // NW003 (+)
                                                                           and $projection.AgreementNumber = _ContractGenerlAPCP.AgreementNumber // NW003 (+)

{
  key Agreement.CompanyCode,

      //        key ''                                                as RealEstateContract, // NW003 (-)
  key APCPLinkToContract.RealEstateContract                           as RealEstateContract, // NW003 (+)

  key Agreement.AgreementNumber,

  key cast(
        'A'
        as ze_rtr_oll_type
      )                                                               as Type,

      cast(
        'L'
        as ze_rtr_oll_typegroup
      )                                                               as TypeGroup,

      Agreement.ROUClass,

      ContractAPCP.CompanyCodeCurrency,


      //      ContractAPCP.LessThan1Year,                                                   // NW001 (-)
      //
      //      ContractAPCP.Between1And2Year,                                                // NW001 (-)
      //
      //      ContractAPCP.Between2And5Year,                                                // NW001 (-)
      //
      //      ContractAPCP.Between5And10Year,                                               // NW001 (-)
      //
      //      ContractAPCP.Between10And15Year,                                              // NW001 (-)
      //
      //      ContractAPCP.GreaterThan15Year,                                               // NW001 (-)


      cast(ContractAPCP.GLCurrentPortion as ze_rtr_oll_lessthan1year) as LessThan1Year,      // NW001 (+)

      cast(0 as ze_rtr_oll_between1and2year)                          as Between1And2Year,   // NW001 (+)

      cast(0 as ze_rtr_oll_between2and5year)                          as Between2And5Year,   // NW001 (+)

      cast(0 as ze_rtr_oll_between5and10year)                         as Between5And10Year,  // NW001 (+)

      cast(0 as ze_rtr_oll_between10and15year)                        as Between10And15Year, // NW001 (+)

      cast(0 as ze_rtr_oll_greaterthan15year)                         as GreaterThan15Year,  // NW001 (+)

      ContractAPCP.GLCurrentPortion,

      cast(0 as ze_gllongterm)                                        as GLLongTerm,

      cast('AP-CP' as ze_rou_datasource )                             as DataSource, // NW001 (+)

      _ContractGenerlAPCP // NW003 (+)
}
