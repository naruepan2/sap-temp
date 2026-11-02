/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 23.07.2026
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

@AccessControl.authorizationCheck: #CHECK

@Analytics.dataCategory: #CUBE
@Analytics.internalName: #LOCAL

@EndUserText.label: 'ROU Outstanding to Contract and Acct.Doc. by TP'

@Metadata.ignorePropagatedAnnotations: false

@ObjectModel.usageType: { dataClass: #TRANSACTIONAL, serviceQuality: #D, sizeCategory: #XL }

@UI.presentationVariant: [ { qualifier: 'pContrtAccDocVariant',
                             text: 'Grouping by Trading Partner',
                             sortOrder: [ { by: 'CompanyCode', direction: #ASC } ],
                             visualizations: [ { type: #AS_LINEITEM } ] } ]

@UI.selectionPresentationVariant: [ { presentationVariantQualifier: 'pContrtAccDocVariant' } ]

define view entity ZC_RTR_ROU_CONTRTACCDOC_BYTP
  with parameters
    @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' },
                                          useForValidation: true } ]
    P_CompanyCode : bukrs,

    P_KeyDate     : datum

  as select from ZI_RTR_OLL_BYTP_TOTALAMOUNT_3(
                   P_CompanyCode : $parameters.P_CompanyCode,
                   P_KeyDate     : $parameters.P_KeyDate)

{
      @Consumption.filter.hidden: true
      @Consumption.semanticObject: 'CompanyCode'
      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CompanyCodeVH', element: 'CompanyCode' },
                                            useForValidation: true } ]
      @UI.lineItem: [ { position: 10, importance: #HIGH } ]
  key CompanyCode,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_Globalcompany', element: 'Company' } } ]
      @UI.lineItem: [ { position: 20, importance: #HIGH } ]
  key TradingPartner,

      @Consumption.valueHelpDefinition: [ { entity: { name: 'I_CurrencyStdVH', element: 'Currency' } } ]
      @EndUserText.label: 'Company Code Currency'
      @EndUserText.quickInfo: 'Company Code Currency'
      @UI.lineItem: [ { position: 30, importance: #HIGH } ]
      CompanyCodeCurrency,

      @DefaultAggregation: #SUM
      @EndUserText.label: 'Summary Amount'
      @EndUserText.quickInfo: 'Summary Amount'
      @UI.lineItem: [ { position: 40, importance: #HIGH } ]
      AmountInSummary,

      @DefaultAggregation: #SUM
      @EndUserText.label: 'TB Amount'
      @EndUserText.quickInfo: 'TB Amount'
      @UI.lineItem: [ { position: 50, importance: #HIGH } ]
      AmountInTB,

      @DefaultAggregation: #SUM
      @EndUserText.label: 'Difference Amount'
      @EndUserText.quickInfo: 'Difference Amount'
      @UI.lineItem: [ { position: 60, importance: #HIGH } ]
      AmountDifferent,
      
      @UI.hidden: true
      DummyField,

      /* Associations */
      _CompanyCode,
      _CompanyCodeCurrency,
      _Globalcompany
}
