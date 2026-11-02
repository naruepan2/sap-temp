/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 19.02.2026
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
@EndUserText.label: 'Contract Exchange Rate'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ContractExchRate_1
  as select from ZI_RTR_OLL_ContractExchRate_0 as ContractExchRate_0

    inner join   ZI_VICECFRULE                 as VICECFRULE on  VICECFRULE.intreno     = ContractExchRate_0.intreno
                                                             and VICECFRULE.cfstatus    = 'I'
                                                             and VICECFRULE.postingdate = ContractExchRate_0.postingdate
{
  key ContractExchRate_0.intreno,

      cast(
        max( VICECFRULE.ctrate )
        as ze_recactrate
      ) as ExchangeRate
}

group by
  ContractExchRate_0.intreno
