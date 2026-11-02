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
@EndUserText.label: 'ROU Outstanding Lease Liability - Type'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

@ObjectModel.representativeKey: 'Type'
@ObjectModel.semanticKey:  [ 'Type' ]
@ObjectModel.dataCategory:#VALUE_HELP
@ObjectModel.modelingPattern: #VALUE_HELP_PROVIDER

@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
@ObjectModel.resultSet.sizeCategory: #XS

define view entity ZI_RTR_OLL_Type
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZD_RTR_OLL_TYPE' ) as DOMAIN_VALUE
  composition [0..*] of ZI_RTR_OLL_TypeText as _Text
{
      @ObjectModel.text.association: '_Text'
  key cast( DOMAIN_VALUE.value_low as ze_rtr_oll_type) as Type,

      @Analytics.hidden: true
      @Consumption.hidden: true
      @Search.defaultSearchElement: true
      @Search.ranking: #HIGH
      DOMAIN_VALUE.value_low                           as DomainValue,

      _Text
}
