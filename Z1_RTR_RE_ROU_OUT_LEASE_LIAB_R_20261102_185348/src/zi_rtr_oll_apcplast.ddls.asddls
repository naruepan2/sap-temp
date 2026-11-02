/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Potsawat M.
// Created on  : 18.02.2026
// WRICEF ID   : RTR-RE011
// TR Number   : GSDK911054
//-----------------------------------------------------------------------
// Description : Outstanding Lease Liability and Defer Interest Report
//-----------------------------------------------------------------------
// Change History
//-----------------------------------------------------------------------
// Date |TR Number |Search Term |Developer |Description
// -------- ----------- ----------- ----------- -------------------------
// 12/03/2026 | GSDK911054 | NW001 | Naruepan W. | Add CurrentAPInstallment by using DM AP Posted
//                                                 if Journal Entry was not found
/////////////////////////////////////////////////////////////////////////

@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'AP-CP Last Record'
@Metadata.ignorePropagatedAnnotations: false
@ObjectModel.usageType: {
  dataClass: #CUSTOMIZING,
  serviceQuality: #C,
  sizeCategory: #M
}
define view entity ZI_RTR_OLL_APCPLast
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_APCPLast_0( P_KeyDate: $parameters.P_KeyDate ) as APCPLast_0

  association [1..1] to ZI_RTR_OLL_APCP              as _APCP       on  $projection.CompanyCode      = _APCP.CompanyCode
                                                                    and $projection.AgreementNumber  = _APCP.AgreementNumber
                                                                    and $projection.CalculationYear  = _APCP.CalculationYear
                                                                    and $projection.CalculationMonth = _APCP.CalculationMonth
  // NW001 (+)
  association [0..1] to ZI_RTR_OLL_APCP_DMAPPosted_0 as _DMAPPosted on  $projection.CompanyCode     = _DMAPPosted.CompanyCode
                                                                    and $projection.AgreementNumber = _DMAPPosted.AgreementNumber
  // NW001 (+)
{
  key APCPLast_0.CompanyCode,

  key APCPLast_0.AgreementNumber,

      cast(
        substring( APCPLast_0.PaymentDueDate, 1, 4 )
        as ze_year
      )                                           as CalculationYear,

      cast(
        substring( APCPLast_0.PaymentDueDate, 5, 2 )
        as ze_month
      )                                           as CalculationMonth,
      // NW001 (-)
      //      APCPLast_0.CurrentAPInstallment,
      // NW001 (-)
      // NW001 (+)
      cast(
        case
            when APCPLast_0.CurrentAPInstallment is not initial
                then APCPLast_0.CurrentAPInstallment
            when _DMAPPosted.CurrentAPInstallment is not initial
                then _DMAPPosted.CurrentAPInstallment
            else '00000'
        end
      as ze_currentapinstallment preserving type) as CurrentAPInstallment,
      // NW001 (+)

      _APCP
}
