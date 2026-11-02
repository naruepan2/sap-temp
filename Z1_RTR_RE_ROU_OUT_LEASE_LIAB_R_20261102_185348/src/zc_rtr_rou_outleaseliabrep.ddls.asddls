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
// 26.05.2026 | GSDK918255 | NW001 | Naruepan W. | Add Contract Type Name
// 20/07/2026 | GSDK922121 | NW002 | Naruepan W. | Adjust difference amount when
//                                                 currency is foreign currency
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #CHECK

@Analytics.dataCategory: #CUBE
@Analytics.internalName: #LOCAL

@EndUserText.label: 'ROU Outstanding Lease Liability'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XXL }

@UI.presentationVariant: [ { qualifier: 'pROUOutLeaseLiabRepVariant',
                             text: 'ROU Outstanding Lease Liability',
                             sortOrder: [ { by: 'CompanyCode', direction: #ASC } ],
                             visualizations: [ { type: #AS_LINEITEM } ] } ]

@UI.selectionPresentationVariant: [ { presentationVariantQualifier: 'pROUOutLeaseLiabRepVariant' } ]

define view entity ZC_RTR_ROU_OutLeaseLiabRep
  with parameters
    @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' },
                                          useForValidation: true } ]
    P_CompanyCode : bukrs,

    P_KeyDate     : datum

  as select from ZI_RTR_ROU_OutLeaseLiabRep(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate)

{
      @Consumption.filter.hidden: true
      @Consumption.semanticObject: 'CompanyCode'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' },
                                            useForValidation: true } ]
      @UI.lineItem: [ { position: 20, importance: #HIGH } ]
  key CompanyCode,

      @Consumption.semanticObject: 'REContract'
      @Consumption.semanticObjectMapping.additionalBinding: [ { element: 'CompanyCode', localElement: 'CompanyCode' } ]
      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_REContractData', element: 'RealEstateContract' },
                                            additionalBinding: [ { element: 'CompanyCode', localElement: 'CompanyCode' } ],
                                            useForValidation: true } ]
  key RealEstateContract,

  key AgreementNumber,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_RTR_OLL_Type', element: 'Type' },
                                            useForValidation: true } ]
      @ObjectModel.text.element: [ 'TypeText' ]
      @UI.lineItem: [ { position: 15, importance: #HIGH } ]
  key Type,

      @UI.hidden: true
      _Type._Text[1: Language = $session.system_language].TypeText,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_RTR_OLL_TypeGroup', element: 'TypeGroup' },
                                            useForValidation: true } ]
      @ObjectModel.text.element: [ 'TypeGroupText' ]
      @UI.lineItem: [ { position: 10, importance: #HIGH } ]
      TypeGroup,

      @UI.hidden: true
      _TypeGroup._Text[1: Language = $session.system_language].TypeGroupText,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_RTR_OLL_ROUClass', element: 'ROUClass' },
                                            useForValidation: true } ]
      @ObjectModel.text.element: [ 'ROUClassText' ]
      ROUClass,

      @UI.hidden: true
      _ROUClass._Text[1: Language = $session.system_language].ROUClassText,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CurrencyStdVH', element: 'Currency' } } ]
      @EndUserText.label: 'Company Code Currency'
      @EndUserText.quickInfo: 'Company Code Currency'
      CompanyCodeCurrency,

      @DefaultAggregation: #SUM
      @UI.lineItem: [ { position: 40, importance: #MEDIUM } ]
      //      LessThan1Year,                                                                                //NW002(-)
      LessThan1Year_2                                                                     as LessThan1Year, //NW002(+)

      @DefaultAggregation: #SUM
      @UI.lineItem: [ { position: 50, importance: #MEDIUM } ]
      //      Between1And2Year,                                                                                //NW002(-)
      Between1And2Year_2                                                                  as Between1And2Year, //NW002(+)

      @DefaultAggregation: #SUM
      @UI.lineItem: [ { position: 60, importance: #MEDIUM } ]
      //      Between2And5Year,                                                                                //NW002(-)
      Between2And5Year_2                                                                  as Between2And5Year, //NW002(+)

      @DefaultAggregation: #SUM
      @UI.lineItem: [ { position: 70, importance: #MEDIUM } ]
      //      Between5And10Year,                                                                                //NW002(-)
      Between5And10Year_2                                                                 as Between5And10Year, //NW002(+)

      @DefaultAggregation: #SUM
      @UI.lineItem: [ { position: 80, importance: #MEDIUM } ]
      //      Between10And15Year,                                                                                //NW002(-)
      Between10And15Year_2                                                                as Between10And15Year, //NW002(+)

      @DefaultAggregation: #SUM
      @UI.lineItem: [ { position: 90, importance: #MEDIUM } ]
      //      GreaterThan15Year,                                                                                //NW002(-)
      GreaterThan15Year_2                                                                 as GreaterThan15Year, //NW002(+)

      @DefaultAggregation: #SUM
      //      GLCurrentPortion,                                                                                //NW002(-)
      GLCurrentPortion_2                                                                  as GLCurrentPortion, //NW002(+)

      @DefaultAggregation: #SUM
      //      GLLongTerm,                                                                                //NW002(-)
      GLLongTerm_2                                                                        as GLLongTerm, //NW002(+)

      InternalRealEstateNumber,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_REContractType', element: 'REContractType' },
                                            useForValidation: true } ]
      REContractType,

      REContractTypeName, // NW001(+)

      REContractName,

      @Consumption.filter.selectionType: #SINGLE
      ContractStartDate,

      @Consumption.filter.selectionType: #SINGLE
      ContractEndDate,

      @Consumption.filter.selectionType: #SINGLE
      REContractFirstEndDate,

      @Consumption.filter.selectionType: #SINGLE
      REContractNoticeDate,

      @Consumption.filter.selectionType: #SINGLE
      REContractSignDate,

      @UI.hidden: true
      REContractCurrency,

      @EndUserText.label: 'Contract Currency'
      @EndUserText.quickInfo: 'Contract Currency'
      REContractCurrency_2,

      ContractDurationMonths,

      ActualDurationMonths,

      RemainingDurationMonths,

      TotalInstallmentNo,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_RTR_OLL_PaymentMethod', element: 'PaymentMethod' },
                                            useForValidation: true } ]
      @EndUserText.label: 'Payment Method'
      @EndUserText.quickInfo: 'Payment Method'
      @ObjectModel.text.element: [ 'PaymentMethodText' ]
      PaymentMethod,

      @UI.hidden: true
      _PaymentMethod._Text[1: Language = $session.system_language].PaymentMethodText,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZI_RTR_OLL_InstallmentFreq',
                                                      element: 'InstallmentFrequency' },
                                            useForValidation: true } ]
      @ObjectModel.text.element: [ 'InstallmentFrequencyText' ]
      InstallmentFrequency,

      @UI.hidden: true
      _InstallmentFrequency._Text[1: Language = $session.system_language].InstallmentFrequencyText,

      ZZ1_DMAPPosted_Rec,

      ZZ1_DMValInstallPosted_Rec,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'ZZ1_INTERESTRATETYPE_V', element: 'Code' },
                                            useForValidation: true } ]
      // @ObjectModel.text.element: ['ZZ1_InterestRateTypeText']
      @UI.hidden: true
      ZZ1_InterestRateType_Rec,

      @EndUserText.label: 'Interest Rate Type'
      @EndUserText.quickInfo: 'Interest Rate Type'
      @ObjectModel.text.element: [ 'ZZ1_InterestRateTypeText' ]
      ZZ1_InterestRateType_Rec_2,

      @UI.hidden: true
      _ZZ1_InterestRateType_Rec._Text[1: Language = $session.system_language].Description as ZZ1_InterestRateTypeText,

      @EndUserText.label: 'Retire Obligation'
      @EndUserText.quickInfo: 'Retire Obligation'
      ZZ1_RetireObligation_Rec,

      @EndUserText.label: 'Purchase Option'
      @EndUserText.quickInfo: 'Purchase Option'
      ZZ1_PurchaseOption_Rec,

      @EndUserText.label: 'Terminate Option'
      @EndUserText.quickInfo: 'Terminate Option'
      ZZ1_TerminateOption_Rec,

      @EndUserText.label: 'Extension Option'
      @EndUserText.quickInfo: 'Extension Option'
      ZZ1_ExtensionOption_Rec,

      @EndUserText.label: 'Guarantee Residual value'
      @EndUserText.quickInfo: 'Guarantee Residual value'
      ZZ1_GuaranteeResidualv_Rec,

      IsCNDataMigration,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_BusinessPartnerSupplier', element: 'BusinessPartner' },
                                            useForValidation: true } ]
      @EndUserText.label: 'Business Partner'
      @EndUserText.quickInfo: 'Business Partner'
      BusinessPartnerSupplier,

      @EndUserText.label: 'Leasing Company'
      _BusinessPartnerSupplier.BusinessPartnerFullName                                    as BusinessPartnerSupplierName,

      @EndUserText.label: 'Trading Partner'
      @EndUserText.quickInfo: 'Trading Partner'
      @UI.lineItem: [ { position: 30, importance: #HIGH } ]
      TradingPartner,

      _Globalcompany.CompanyName                                                          as TradingPartnerName,

      @DefaultAggregation: #MIN
      @EndUserText.label: 'Interest Rate Min'
      @EndUserText.quickInfo: 'Interest Rate Min'
      @UI.lineItem: [ { position: 100, importance: #LOW } ]
      REInterestRate                                                                      as MinREInterestRate,

      @DefaultAggregation: #MAX
      @EndUserText.label: 'Interest Rate Max'
      @EndUserText.quickInfo: 'Interest Rate Max'
      @UI.lineItem: [ { position: 110, importance: #LOW } ]
      REInterestRate                                                                      as MaxREInterestRate,

      //      @Consumption.valueHelpDefinition: [
      //        {
      //          entity: { name: 'I_MasterFixedAsset', element: 'MasterFixedAsset' },
      //          additionalBinding: [ { element: 'CompanyCode', localElement: 'CompanyCode' } ],
      //          useForValidation: true
      //        }
      //      ]
      MasterFixedAsset,

      //      @Consumption.valueHelpDefinition: [
      //        {
      //          entity: { name: 'I_FixedAsset', element: 'FixedAsset' },
      //          additionalBinding: [
      //            { element: 'MasterFixedAsset', localElement: 'MasterFixedAsset' },
      //            { element: 'CompanyCode', localElement: 'CompanyCode' }
      //          ],
      //          useForValidation: true
      //        }
      //      ]
      FixedAsset,

      _FixedAsset.FixedAssetExternalID,

      REMeasurementQuantity,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_UnitOfMeasure', element: 'UnitOfMeasure' },
                                            useForValidation: true } ]
      REMeasurementUnit,

      IsVaryOnSales,

      @Consumption.filter.selectionType: #SINGLE
      AssetAcquisitionPostingDate,

      @Consumption.filter.selectionType: #SINGLE
      AssetModificationPostingDate,

      ROUAsset,

      ContractValue,

      NetLeaseLiability,

      ExchangeRate,

      @UI.hidden: true
      DummyField,

      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _Currency,
      _REAdjustmentTerm,
      _RECondition,
      _REContractType,
      _REKeyAssgmt,
      _RENoticeTerm,
      _REOrganizationalAssgmtTerm,
      _REPartnerAssgmt,
      _REPostingTerm,
      _REReminderRule,
      _RERenewalTerm,
      _RERhythmTerm,
      _RESalesReportingTerm,
      _RESalesRuleFrqcyTerm,
      _RESalesRuleTerm,
      _REValuationRuleCondition,
      _REValuationTerm,
      _ZZ1_InterestRateType_Rec,
      _Globalcompany,
      _BusinessPartnerSupplier,
      _Type,
      _TypeGroup,
      _ROUClass,
      _PaymentMethod,
      _InstallmentFrequency,
      _MasterFixedAsset,
      _FixedAsset,
      _FixedAssetForLedger,
      _ValuationRule,
      _ContractExchRate,
      _REContractCurrency_2
}
