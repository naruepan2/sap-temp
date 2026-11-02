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
// 23/02/2026 | GSDK913869 | NW001 | Naruepan W. | Change data element from numc to char
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'ROU Outstanding Lease Liability - Payment Method Text'
@Metadata.ignorePropagatedAnnotations: true

@Search.searchable: true

@ObjectModel.dataCategory: #TEXT
@ObjectModel.representativeKey: 'PaymentMethod'
@ObjectModel.modelingPattern: #LANGUAGE_DEPENDENT_TEXT

@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}

define view entity ZI_RTR_OLL_PaymentMethodText
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZD_RECDPAYMENTFORMRH' ) as DOMAIN_VALUE_T
  association        to parent ZI_RTR_OLL_PaymentMethod as _PaymentMethod on $projection.PaymentMethod = _PaymentMethod.PaymentMethod
  association [0..1] to I_Language                      as _Language      on $projection.Language = _Language.Language
{
      @ObjectModel.foreignKey.association: '_PaymentMethod'
      @ObjectModel.text.element: ['PaymentMethodText']
      // NW001(-)
      // key cast( DOMAIN_VALUE_T.value_low as ze_recdpaymentformrh )        as PaymentMethod,
      // NW001(-)
      // NW001(+)
  key cast( DOMAIN_VALUE_T.value_low as ze_recdpaymentformrh_char1 )       as PaymentMethod,
      // NW001(+)

      @ObjectModel.foreignKey.association: '_Language'
      @Semantics.language: true
  key cast( DOMAIN_VALUE_T.language as spras preserving type )             as Language,

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #LOW
      @Semantics.text: true
      cast(DOMAIN_VALUE_T.text as ze_payment_method_text preserving type ) as PaymentMethodText,

      @Analytics.hidden: true
      @Consumption.hidden: true
      DOMAIN_VALUE_T.value_low                                             as DomainValue,

      _PaymentMethod,
      _Language
}
