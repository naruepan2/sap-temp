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
@EndUserText.label: 'ROU Outstanding Lease Liability - Installment Frequency Text'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'InstallmentFrequency'
@ObjectModel.modelingPattern: #LANGUAGE_DEPENDENT_TEXT

@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}

define view entity ZI_RTR_OLL_InstallmentFreqText
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_INSTALLMENTFREQUENCY' ) as DOMAIN_VALUE_T
  association        to parent ZI_RTR_OLL_InstallmentFreq as _InstallmentFrequency on $projection.InstallmentFrequency = _InstallmentFrequency.InstallmentFrequency
  association [0..1] to I_Language                        as _Language             on $projection.Language = _Language.Language
{
      @ObjectModel.foreignKey.association: '_InstallmentFrequency'
      @ObjectModel.text.element: ['InstallmentFrequencyText']
  key cast( DOMAIN_VALUE_T.value_low as ze_installmentfrequency )                 as InstallmentFrequency,

      @ObjectModel.foreignKey.association: '_Language'
      @Semantics.language: true
  key cast( DOMAIN_VALUE_T.language as spras preserving type )                    as Language,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #LOW
      @Semantics.text: true
      cast(DOMAIN_VALUE_T.text as ze_installment_frequency_text preserving type ) as InstallmentFrequencyText,

      @Analytics.hidden: true
      @Consumption.hidden: true
      DOMAIN_VALUE_T.value_low                                                    as DomainValue,

      _InstallmentFrequency,
      _Language
}
