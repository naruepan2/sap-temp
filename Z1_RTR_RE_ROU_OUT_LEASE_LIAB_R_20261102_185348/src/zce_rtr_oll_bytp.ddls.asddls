/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 22.06.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK920102
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
/////////////////////////////////////////////////////////////////////////
@ObjectModel.query.implementedBy: 'ABAP:ZCL_RTR_OLL_BYTP_CE'
@ObjectModel.usageType: { dataClass: #CUSTOMIZING, serviceQuality: #C, sizeCategory: #S }

@UI.headerInfo: { typeName: 'Outstanding Lease Liability and Defer',
                  typeNamePlural: 'Outstanding Lease Liability and Defers',
                  title: { type: #STANDARD, label: 'Header', value: 'TradingPartner' } }

define root custom entity ZCE_RTR_OLL_ByTP

{
      @UI.facet           : [ { id: 'General',
                     purpose: #STANDARD,
                     parentId: '',
                     position: 10,
                     label: 'General Information',
                     type : #IDENTIFICATION_REFERENCE } ]

      @UI.identification  : [ { position: 10 } ]
      @UI.lineItem        : [ { position: 10 } ]
  key CompanyCode         : bukrs;

      @UI.identification  : [ { position: 20 } ]
      @UI.lineItem        : [ { position: 20 } ]
  key TradingPartner      : rassc;

      @UI.identification  : [ { position: 30 } ]
      @UI.lineItem        : [ { position: 30 } ]
  key Type                : ze_rtr_oll_type;

      @UI.identification  : [ { position: 40 } ]
      @UI.lineItem        : [ { position: 40 } ]
  key TypeGroup           : ze_rtr_oll_typegroup;

      @Semantics.currencyCode: true
      @UI.identification  : [ { position: 50 } ]
      @UI.lineItem        : [ { position: 50 } ]
      CompanyCodeCurrency : waers;

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.identification  : [ { position: 60 } ]
      @UI.lineItem        : [ { position: 60 } ]
      LessThan1Year       : ze_rtr_oll_lessthan1year;

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.identification  : [ { position: 70 } ]
      @UI.lineItem        : [ { position: 70 } ]
      Between1And2Year    : ze_rtr_oll_between1and2year;

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.identification  : [ { position: 80 } ]
      @UI.lineItem        : [ { position: 80 } ]
      Between2And5Year    : ze_rtr_oll_between2and5year;

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.identification  : [ { position: 90 } ]
      @UI.lineItem        : [ { position: 90 } ]
      Between5And10Year   : ze_rtr_oll_between5and10year;

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.identification  : [ { position: 100 } ]
      @UI.lineItem        : [ { position: 100 } ]
      Between10And15Year  : ze_rtr_oll_between10and15year;

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      @UI.identification  : [ { position: 110 } ]
      @UI.lineItem        : [ { position: 110 } ]
      GreaterThan15Year   : ze_rtr_oll_greaterthan15year;

      @EndUserText.label  : 'Interest Rate Min'
      @UI.identification  : [ { position: 120 } ]
      @UI.lineItem        : [ { position: 120 } ]
      MinREInterestRate   : ze_receinterestrate;

      @EndUserText.label  : 'Interest Rate Max'
      @UI.identification  : [ { position: 130 } ]
      @UI.lineItem        : [ { position: 130 } ]
      MaxREInterestRate   : ze_receinterestrate;

      @UI.hidden          : true
      FiscalYear          : abap.numc(4);

      @UI.hidden          : true
      Period              : abap.numc(3);
}
