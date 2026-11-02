/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 13.02.2026
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
@EndUserText.label: 'ROU Outstanding Lease Liability - Type Text'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'Type'
@ObjectModel.modelingPattern: #LANGUAGE_DEPENDENT_TEXT

@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}

define view entity ZI_RTR_OLL_TypeText
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_RTR_OLL_TYPE' ) as DOMAIN_VALUE_T
  association        to parent ZI_RTR_OLL_Type as _Type     on $projection.Type = _Type.Type
  association [0..1] to I_Language             as _Language on $projection.Language = _Language.Language
{
      @ObjectModel.foreignKey.association: '_Type'
      @ObjectModel.text.element: ['TypeText']
  key cast( DOMAIN_VALUE_T.value_low as ze_rtr_oll_type )                as Type,

      @ObjectModel.foreignKey.association: '_Language'
      @Semantics.language: true
  key cast( DOMAIN_VALUE_T.language as spras preserving type )           as Language,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #LOW
      @Semantics.text: true
      cast(DOMAIN_VALUE_T.text as ze_rtr_oll_type_text preserving type ) as TypeText,

      @Analytics.hidden: true
      @Consumption.hidden: true
      DOMAIN_VALUE_T.value_low                                           as DomainValue,

      _Type,
      _Language
}
