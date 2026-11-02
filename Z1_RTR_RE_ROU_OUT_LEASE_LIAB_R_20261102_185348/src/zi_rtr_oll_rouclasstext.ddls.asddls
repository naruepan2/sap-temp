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

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROU Outstanding Lease Liability - ROU Class Text'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'ROUClass'
@ObjectModel.modelingPattern: #LANGUAGE_DEPENDENT_TEXT

@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}

define view entity ZI_RTR_OLL_ROUClassText
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_ROU_CLASS' ) as DOMAIN_VALUE_T
  association        to parent ZI_RTR_OLL_ROUClass as _ROUClass on $projection.ROUClass = _ROUClass.ROUClass
  association [0..1] to I_Language                 as _Language on $projection.Language = _Language.Language
{
      @ObjectModel.foreignKey.association: '_ROUClass'
      @ObjectModel.text.element: ['ROUClassText']
  key cast( DOMAIN_VALUE_T.value_low as ze_rou_class )                as ROUClass,

      @ObjectModel.foreignKey.association: '_Language'
      @Semantics.language: true
  key cast( DOMAIN_VALUE_T.language as spras preserving type )        as Language,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #LOW
      @Semantics.text: true
      cast(DOMAIN_VALUE_T.text as ze_rou_class_text preserving type ) as ROUClassText,

      @Analytics.hidden: true
      @Consumption.hidden: true
      DOMAIN_VALUE_T.value_low                                        as DomainValue,

      _ROUClass,
      _Language
}
