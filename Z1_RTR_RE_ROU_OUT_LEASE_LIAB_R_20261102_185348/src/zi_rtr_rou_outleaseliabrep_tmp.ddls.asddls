/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 20.07.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK922121
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

@EndUserText.label: 'ROU Outstanding Lease Liability and Defer Interest Report'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XXL }

define view entity ZI_RTR_ROU_OutLeaseLiabRep_Tmp
  with parameters
    P_CompanyCode : bukrs,
    P_KeyDate     : datum

  as select from    ZI_RTR_ROU_OutLeaseLiabRep_0(
                      P_KeyDate : $parameters.P_KeyDate)     as OutLeaseLiabRep_0

    left outer join ZI_RTR_OLL_ContractGeneral               as ContractGeneral on  ContractGeneral.CompanyCode        = OutLeaseLiabRep_0.CompanyCode
                                                                                and ContractGeneral.RealEstateContract = OutLeaseLiabRep_0.RealEstateContract

    left outer join ZI_RTR_OLL_CONTRACTGENERLAPCP(
                      P_Client      : $session.client,
                      P_CompanyCode : $parameters.P_CompanyCode,
                      P_KeyDate     : $parameters.P_KeyDate) as ContractAPCP    on  ContractAPCP.CompanyCode     = OutLeaseLiabRep_0.CompanyCode
                                                                                and ContractAPCP.AgreementNumber = OutLeaseLiabRep_0.AgreementNumber

  association [0..1] to ZI_RTR_OLL_ContractPartner     as _ContractSupplier        on  $projection.CompanyCode               = _ContractSupplier.CompanyCode
                                                                                   and $projection.RealEstateContract        = _ContractSupplier.RealEstateContract
                                                                                   and _ContractSupplier.BusinessPartnerRole = 'FLVN00'

  association [0..1] to ZI_RTR_OLL_ContractInterest    as _ContractInterest        on  $projection.CompanyCode        = _ContractInterest.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractInterest.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractAsset       as _ContractAsset           on  $projection.CompanyCode        = _ContractAsset.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractAsset.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractQty         as _ContractQty             on  $projection.CompanyCode        = _ContractQty.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractQty.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractVaryOnSales as _ContractVaryOnSales     on  $projection.CompanyCode        = _ContractVaryOnSales.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractVaryOnSales.RealEstateContract

  association [1..1] to I_CompanyCode                  as _CompanyCode             on  $projection.CompanyCode = _CompanyCode.CompanyCode

  association [1..1] to I_Currency                     as _CompanyCodeCurrency     on  $projection.CompanyCodeCurrency = _CompanyCodeCurrency.Currency

  association [0..1] to I_Globalcompany                as _Globalcompany           on  $projection.TradingPartner = _Globalcompany.Company

  association [0..1] to I_BusinessPartner              as _BusinessPartnerSupplier on  $projection.BusinessPartnerSupplier = _BusinessPartnerSupplier.BusinessPartner

  association [1..1] to ZI_RTR_OLL_Type                as _Type                    on  $projection.Type = _Type.Type

  association [1..1] to ZI_RTR_OLL_TypeGroup           as _TypeGroup               on  $projection.TypeGroup = _TypeGroup.TypeGroup

  association [0..1] to ZI_RTR_CNInstallmentPeriodSum  as _CNInstallmentPeriodSum  on  $projection.CompanyCode        = _CNInstallmentPeriodSum.CompanyCode
                                                                                   and $projection.RealEstateContract = _CNInstallmentPeriodSum.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractCondFreq    as _ContractCondFreq        on  $projection.CompanyCode        = _ContractCondFreq.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractCondFreq.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ROUClass            as _ROUClass                on  $projection.ROUClass = _ROUClass.ROUClass

  association [0..1] to ZI_RTR_OLL_ValuationRule       as _ValuationRule           on  $projection.CompanyCode        = _ValuationRule.CompanyCode
                                                                                   and $projection.RealEstateContract = _ValuationRule.RealEstateContract

  association [0..1] to ZI_RTR_OLL_ContractExchRate    as _ContractExchRate        on  $projection.CompanyCode        = _ContractExchRate.CompanyCode
                                                                                   and $projection.RealEstateContract = _ContractExchRate.RealEstateContract

  association [1..1] to I_Currency                     as _REContractCurrency_2    on  $projection.REContractCurrency_2 = _REContractCurrency_2.Currency

{
      @ObjectModel.foreignKey.association: '_CompanyCode'
  key OutLeaseLiabRep_0.CompanyCode,

  key OutLeaseLiabRep_0.RealEstateContract,

  key OutLeaseLiabRep_0.AgreementNumber,

      @ObjectModel.foreignKey.association: '_Type'
  key OutLeaseLiabRep_0.Type,

      @ObjectModel.foreignKey.association: '_TypeGroup'
      OutLeaseLiabRep_0.TypeGroup,

      @ObjectModel.foreignKey.association: '_ROUClass'
      OutLeaseLiabRep_0.ROUClass,

      @ObjectModel.foreignKey.association: '_CompanyCodeCurrency'
      coalesce(
        OutLeaseLiabRep_0.CompanyCodeCurrency,
        ContractAPCP.CompanyCodeCurrency
      )                              as CompanyCodeCurrency,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.LessThan1Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between1And2Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between2And5Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between5And10Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.Between10And15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.GreaterThan15Year,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.GLCurrentPortion,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      OutLeaseLiabRep_0.GLLongTerm,

      @ObjectModel.foreignKey.association: '_Currency'
      ContractGeneral.REContractCurrency,

      @ObjectModel.foreignKey.association: '_REContractCurrency_2'
      coalesce(
        ContractGeneral.REContractCurrency,
        ContractAPCP.REContractCurrency
      )                              as REContractCurrency_2,

      @EndUserText.label: 'Vendor Code'
      @ObjectModel.foreignKey.association: '_BusinessPartnerSupplier'
      coalesce(
        coalesce(
            cast(
                _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate).BusinessPartner
            as ze_businesspartner preserving type),
            cast(
                ContractAPCP.BusinessPartnerSupplier
            as ze_businesspartner preserving type)
        ),
        cast('          ' as ze_businesspartner preserving type)
      )                              as BusinessPartnerSupplier,

      @ObjectModel.foreignKey.association: '_Globalcompany'
      coalesce(
        coalesce(
           cast(
                _ContractSupplier(P_CompanyCode: $parameters.P_CompanyCode, P_KeyDate: $parameters.P_KeyDate)._BP001.Vbund
           as rassc preserving type),
           cast(
                ContractAPCP.TradingPartner
           as rassc preserving type)
        ),
        cast('      ' as rassc preserving type)
      )                              as TradingPartner,

      cast('DUMMY' as abap.char(5) ) as DummyField,

      _ContractExchRate.ExchangeRate,

      /* Associations */
      ContractGeneral._Currency,

      _CompanyCode,
      _CompanyCodeCurrency,
      _ContractSupplier,
      _ContractInterest,
      _ContractAsset,
      _ContractQty,
      _ContractVaryOnSales,
      _Globalcompany,
      _BusinessPartnerSupplier,
      _Type,
      _TypeGroup,
      _ROUClass,
      _ValuationRule,
      _ContractExchRate,
      _REContractCurrency_2
}

where
  OutLeaseLiabRep_0.CompanyCode = $parameters.P_CompanyCode
