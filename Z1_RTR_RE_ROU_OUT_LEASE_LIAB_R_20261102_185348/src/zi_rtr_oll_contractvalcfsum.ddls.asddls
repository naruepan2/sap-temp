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
@EndUserText.label: 'Contract Valuation Cash Flow Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_OLL_ContractValCFSum
  as select from ZI_RTR_OLL_ValuationRuleCF as ValuationRuleCF
{
  key ValuationRuleCF.CompanyCode,

  key ValuationRuleCF.RealEstateContract,

      ValuationRuleCF.CompanyCodeCurrency,

      cast(
        min(
          case
            when ValuationRuleCF.RECashFlowType = '1' and
                 ( ValuationRuleCF.BookFlowType = 'ZA10' or
                   ValuationRuleCF.BookFlowType = 'ZA20' )
            then ValuationRuleCF.PostingDate
          end
        )
        as ze_asset_acquis_posting_date
      ) as AssetAcquisitionPostingDate,

      cast(
        max(
          case
            when ValuationRuleCF.RECashFlowType = '1' and
                 ValuationRuleCF.BookFlowType <> 'ZA10' and
                 ValuationRuleCF.BookFlowType <> 'ZA20'
            then ValuationRuleCF.PostingDate
          end
        )
        as ze_asset_modify_posting_date
      ) as AssetModificationPostingDate,

      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      cast(
        sum(
          case
            when ValuationRuleCF.RECashFlowType = '1'
            then ValuationRuleCF.AmountInCompanyCodeCurrency

            when ValuationRuleCF.RECashFlowType = '2' and
                 ValuationRuleCF.PaymentDueDate <= ValuationRuleCF._REValuationProcessStep.REConsiderationStartDate
            then ValuationRuleCF.AmountInCompanyCodeCurrency * -1
          end
        )
        as ze_rou_asset
      ) as ROUAsset
}

group by
  ValuationRuleCF.CompanyCode,
  ValuationRuleCF.RealEstateContract,
  ValuationRuleCF.CompanyCodeCurrency
