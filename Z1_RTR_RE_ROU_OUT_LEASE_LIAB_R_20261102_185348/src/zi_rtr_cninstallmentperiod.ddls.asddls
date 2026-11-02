/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 11.02.2026
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
@EndUserText.label: 'Contract Installment Period'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #S
}
define view entity ZI_RTR_CNInstallmentPeriod
  as select from ZI_RTR_CNInstallmentPeriodTF( P_Client: $session.client ) as CNInstallmentPeriodTF
{
  key CNInstallmentPeriodTF.CompanyCode,

  key CNInstallmentPeriodTF.RealEstateContract,

  key cast(
        lpad(
          replace_regexpr(
            pcre => '[^0-9]',
            value => cast(
              CNInstallmentPeriodTF.InstallmentNo
              as abap.char( 10 )
            ),
            with => '',
            result_length => 5
          ),
          5,
          '0'
        )
        as ze_installmentnumber
      ) as InstallmentNo,

      //      CNInstallmentPeriodTF.CalculationPeriodStartDate,
      //
      //      CNInstallmentPeriodTF.CalculationPeriodEndDate

      CNInstallmentPeriodTF.PaymentDueDate
}
