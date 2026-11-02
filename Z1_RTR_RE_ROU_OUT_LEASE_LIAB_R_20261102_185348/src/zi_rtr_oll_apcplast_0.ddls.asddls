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
// 30/10/2026 | GSDK930569 | NW001 | Naruepan W. | Add condition of Is AP Invoice(IsAPInvoice) 
//                                                 must also flag 'X'
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
define view entity ZI_RTR_OLL_APCPLast_0
  with parameters
    P_KeyDate : datum
  as select from ZI_RTR_OLL_APCP_1( P_KeyDate: $parameters.P_KeyDate ) as APCP_1
{
  key APCP_1.CompanyCode,

  key APCP_1.AgreementNumber,

      cast(
        max( APCP_1.PaymentDueDate )
        as ze_receduedate
      ) as PaymentDueDate,

      cast(
        max(
          case
            when APCP_1.IsAPInvoice       = 'X'
             and APCP_1.IsActualAPInvoice = 'X'
            then APCP_1.InstallmentNo
          end
        )
        as ze_currentapinstallment
      ) as CurrentAPInstallment
}

group by
  APCP_1.CompanyCode,
  APCP_1.AgreementNumber
