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
define view entity ZI_RTR_OLL_ContractExchRate
  as select from ZI_REContractData             as REContract

    inner join   ZI_RTR_OLL_ContractExchRate_1 as ContractExchRate_1 on ContractExchRate_1.intreno = REContract.InternalRealEstateNumber
{
  key REContract.CompanyCode,

  key REContract.RealEstateContract,

      REContract.REContractCurrency,

      REContract._CompanyCode.Currency as CompanyCodeCurrency,

      ContractExchRate_1.ExchangeRate
}
