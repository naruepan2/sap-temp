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
// 09.03.2026 | GSDK911054 | NW001 | Naruepan W. | Change sort of Installment No
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Contract Installment Period Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #M
}
define view entity ZI_RTR_CNInstallmentPeriodSum
  // NW001 (-)
  //  as select from ZI_RTR_CNInstallmentPeriod as CNInstallmentPeriod
  // NW001 (-)
  as select from ZI_RTR_CNNOINSTALLMENT_0 as CNInstallmentPeriod
{
      // NW001 (-)
      //  key CNInstallmentPeriod.CompanyCode,
      //
      //  key CNInstallmentPeriod.RealEstateContract,
      //
      //      cast(
      //        max( CNInstallmentPeriod.InstallmentNo )
      //        as ze_installmentnumber
      //      ) as InstallmentNo
      // NW001 (-)
      // NW001 (+)
  key CNInstallmentPeriod.CompanyCode,

  key CNInstallmentPeriod.RealEstateContract,

      cast( CNInstallmentPeriod.NoOfInstallment as ze_installmentnumber preserving type ) as InstallmentNo
      // NW001 (+)
}
// NW001 (-)
//group by
//  CNInstallmentPeriod.CompanyCode,
//  CNInstallmentPeriod.RealEstateContract
// NW001 (-)
