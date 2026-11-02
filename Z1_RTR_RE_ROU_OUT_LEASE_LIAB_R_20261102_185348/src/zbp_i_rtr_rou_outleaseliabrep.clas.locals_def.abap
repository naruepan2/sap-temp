*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section
*/////////////////////////////////////////////////////////////////////////
*// Project Name: SMILE
*// Created by  : Potsawat M.
*// Created on  : 12.02.2026
*// WRICEF ID   : RTR-RE011
*// TR Number   : GSDK911054
*//-----------------------------------------------------------------------
*// Description : Outstanding Lease Liability and Defer Interest Report
*//-----------------------------------------------------------------------
*// Change History
*//-----------------------------------------------------------------------
*// Date |TR Number |Search Term |Developer |Description
*// -------- ----------- ----------- ----------- -------------------------
*// 26/05/2026 | GSDK918255 | NW004 | Naruepan W. | Add Contract Type Name
*// 26/05/2026 | GSDK918255 | NW005 | Naruepan W. | Add check field Installment Frequency
*// 11/08/2026 | GSDK924603 | NW007 | Naruepan W. | Add column:
*//                                                     Total GL Current Portion of Lease Liability
*//                                                     Diff Current Portion
*//                                                     Total Long Term of Lease Liability
*//                                                     Diff Long Term
" // 09/09/2026 | GSDK927467 | NW008 | Naruepan W. | Bug fixed:
" //                                                    Change:
" //                                                     Total Long Term of Lease Liability -> Total GL Long Term of Lease Liability
" //                                                    Add:
" //                                                     Filename with Companycode and key date
" //                                                     Realestatecontract to APCP
*/////////////////////////////////////////////////////////////////////////
TYPES:
  gty_amount_value TYPE p LENGTH 12 DECIMALS 2,

  BEGIN OF gty_data,
    rouclass                     TYPE zi_rtr_rou_outleaseliabrep-rouclass,
    no                           TYPE i,
    type                         TYPE zi_rtr_rou_outleaseliabrep-type,
    typegroup                    TYPE zi_rtr_rou_outleaseliabrep-typegroup,
    companycode                  TYPE zi_rtr_rou_outleaseliabrep-companycode,
    agreementnumber              TYPE zi_rtr_rou_outleaseliabrep-agreementnumber,
    realestatecontract           TYPE zi_rtr_rou_outleaseliabrep-realestatecontract,
    recontracttype               TYPE zi_rtr_rou_outleaseliabrep-recontracttype,
    recontracttypename           TYPE zi_rtr_rou_outleaseliabrep-recontracttypename,            " NW004 (+)
    recontractname               TYPE zi_rtr_rou_outleaseliabrep-recontractname,
    version                      TYPE i,
    pono                         TYPE string,
    fixedassetexternalid         TYPE i_fixedasset-fixedassetexternalid,
    recontractcurrency           TYPE zi_rtr_rou_outleaseliabrep-recontractcurrency,
    companycodecurrency          TYPE i_companycode-currency,
    isvaryonsales                TYPE zi_rtr_rou_outleaseliabrep-isvaryonsales,
    zz1_extensionoption_rec      TYPE zi_rtr_rou_outleaseliabrep-zz1_extensionoption_rec,
    zz1_retireobligation_rec     TYPE zi_rtr_rou_outleaseliabrep-zz1_retireobligation_rec,
    zz1_terminateoption_rec      TYPE zi_rtr_rou_outleaseliabrep-zz1_terminateoption_rec,
    recontractnoticedate         TYPE zi_rtr_rou_outleaseliabrep-recontractnoticedate,
    getterminateamount           TYPE abap_boolean,                                             " NW001 (+)
    terminateamount              TYPE ze_terminate_amount,
    paymentmethod                TYPE zi_rtr_rou_outleaseliabrep-paymentmethod,
    installmentfrequency         TYPE zi_rtr_rou_outleaseliabrep-installmentfrequency,
    installmentfrequencyisfound  TYPE zi_rtr_rou_outleaseliabrep-installmentfrequencyisfound,   " NW005 (+)
    zz1_interestratetype_rec     TYPE zi_rtr_rou_outleaseliabrep-zz1_interestratetype_rec,
    reinterestrate               TYPE zi_rtr_rou_outleaseliabrep-reinterestrate,
    zz1_purchaseoption_rec       TYPE zi_rtr_rou_outleaseliabrep-zz1_purchaseoption_rec,
    zz1_guaranteeresidualv_rec   TYPE zi_rtr_rou_outleaseliabrep-zz1_guaranteeresidualv_rec,
    remeasurementquantity        TYPE zi_rtr_rou_outleaseliabrep-remeasurementquantity,
    remeasurementunit            TYPE zi_rtr_rou_outleaseliabrep-remeasurementunit,
    businesspartnersupplier      TYPE zi_rtr_rou_outleaseliabrep-businesspartnersupplier,
    businesspartnersuppliername  TYPE i_businesspartner-businesspartnerfullname,
    tradingpartner               TYPE zi_rtr_rou_outleaseliabrep-tradingpartner,
    tradingpartnername           TYPE i_globalcompany-companyname,
    assetacquisitionpostingdate  TYPE zi_rtr_rou_outleaseliabrep-assetacquisitionpostingdate,
    assetmodificationpostingdate TYPE zi_rtr_rou_outleaseliabrep-assetmodificationpostingdate,
    totalinstallmentno           TYPE zi_rtr_rou_outleaseliabrep-totalinstallmentno,
    currentapinstallment         TYPE zi_rtr_oll_apcplast-currentapinstallment,
    recontractsigndate           TYPE zi_rtr_rou_outleaseliabrep-recontractsigndate,
    contractstartdate            TYPE zi_rtr_rou_outleaseliabrep-contractstartdate,
    recontractfirstenddate       TYPE zi_rtr_rou_outleaseliabrep-recontractfirstenddate,
    contractenddate              TYPE zi_rtr_rou_outleaseliabrep-contractenddate,
    contractduration             TYPE c LENGTH 10,
    actualduration               TYPE c LENGTH 10,
    remainingduration            TYPE c LENGTH 10,
    remainingperiod              TYPE p LENGTH 5 DECIMALS 2,
    contractvalue                TYPE zi_rtr_rou_outleaseliabrep-contractvalue,
    netleaseliability            TYPE zi_rtr_rou_outleaseliabrep-netleaseliability,
    interest                     TYPE zi_rtr_rou_outleaseliabrep-contractvalue,
    rouasset                     TYPE zi_rtr_rou_outleaseliabrep-rouasset,
    exchangerate                 TYPE zi_rtr_rou_outleaseliabrep-exchangerate,
    realestatecontractforapcp    TYPE zi_rtr_rou_outleaseliabrep-realestatecontract,            " NW008 (+)
    "Value Year 00
    valuey00                     TYPE gty_amount_value,
    "Value Year 01
    valuey01m01                  TYPE gty_amount_value,
    valuey01m02                  TYPE gty_amount_value,
    valuey01m03                  TYPE gty_amount_value,
    valuey01m04                  TYPE gty_amount_value,
    valuey01m05                  TYPE gty_amount_value,
    valuey01m06                  TYPE gty_amount_value,
    valuey01m07                  TYPE gty_amount_value,
    valuey01m08                  TYPE gty_amount_value,
    valuey01m09                  TYPE gty_amount_value,
    valuey01m10                  TYPE gty_amount_value,
    valuey01m11                  TYPE gty_amount_value,
    valuey01m12                  TYPE gty_amount_value,
    valuey01                     TYPE gty_amount_value,
    "Value Year 02
    valuey02m01                  TYPE gty_amount_value,
    valuey02m02                  TYPE gty_amount_value,
    valuey02m03                  TYPE gty_amount_value,
    valuey02m04                  TYPE gty_amount_value,
    valuey02m05                  TYPE gty_amount_value,
    valuey02m06                  TYPE gty_amount_value,
    valuey02m07                  TYPE gty_amount_value,
    valuey02m08                  TYPE gty_amount_value,
    valuey02m09                  TYPE gty_amount_value,
    valuey02m10                  TYPE gty_amount_value,
    valuey02m11                  TYPE gty_amount_value,
    valuey02m12                  TYPE gty_amount_value,
    valuey02                     TYPE gty_amount_value,
    "Value Year 03
    valuey03m01                  TYPE gty_amount_value,
    valuey03m02                  TYPE gty_amount_value,
    valuey03m03                  TYPE gty_amount_value,
    valuey03m04                  TYPE gty_amount_value,
    valuey03m05                  TYPE gty_amount_value,
    valuey03m06                  TYPE gty_amount_value,
    valuey03m07                  TYPE gty_amount_value,
    valuey03m08                  TYPE gty_amount_value,
    valuey03m09                  TYPE gty_amount_value,
    valuey03m10                  TYPE gty_amount_value,
    valuey03m11                  TYPE gty_amount_value,
    valuey03m12                  TYPE gty_amount_value,
    valuey03                     TYPE gty_amount_value,
    "Value Year 04
    valuey04m01                  TYPE gty_amount_value,
    valuey04m02                  TYPE gty_amount_value,
    valuey04m03                  TYPE gty_amount_value,
    valuey04m04                  TYPE gty_amount_value,
    valuey04m05                  TYPE gty_amount_value,
    valuey04m06                  TYPE gty_amount_value,
    valuey04m07                  TYPE gty_amount_value,
    valuey04m08                  TYPE gty_amount_value,
    valuey04m09                  TYPE gty_amount_value,
    valuey04m10                  TYPE gty_amount_value,
    valuey04m11                  TYPE gty_amount_value,
    valuey04m12                  TYPE gty_amount_value,
    valuey04                     TYPE gty_amount_value,
    "Value Year 05
    valuey05m01                  TYPE gty_amount_value,
    valuey05m02                  TYPE gty_amount_value,
    valuey05m03                  TYPE gty_amount_value,
    valuey05m04                  TYPE gty_amount_value,
    valuey05m05                  TYPE gty_amount_value,
    valuey05m06                  TYPE gty_amount_value,
    valuey05m07                  TYPE gty_amount_value,
    valuey05m08                  TYPE gty_amount_value,
    valuey05m09                  TYPE gty_amount_value,
    valuey05m10                  TYPE gty_amount_value,
    valuey05m11                  TYPE gty_amount_value,
    valuey05m12                  TYPE gty_amount_value,
    valuey05                     TYPE gty_amount_value,
    "Value Year 06
    valuey06m01                  TYPE gty_amount_value,
    valuey06m02                  TYPE gty_amount_value,
    valuey06m03                  TYPE gty_amount_value,
    valuey06m04                  TYPE gty_amount_value,
    valuey06m05                  TYPE gty_amount_value,
    valuey06m06                  TYPE gty_amount_value,
    valuey06m07                  TYPE gty_amount_value,
    valuey06m08                  TYPE gty_amount_value,
    valuey06m09                  TYPE gty_amount_value,
    valuey06m10                  TYPE gty_amount_value,
    valuey06m11                  TYPE gty_amount_value,
    valuey06m12                  TYPE gty_amount_value,
    valuey06                     TYPE gty_amount_value,
    "Value Year 07 to 15
    valuey07                     TYPE gty_amount_value,
    valuey08                     TYPE gty_amount_value,
    valuey09                     TYPE gty_amount_value,
    valuey10                     TYPE gty_amount_value,
    valuey11                     TYPE gty_amount_value,
    valuey12                     TYPE gty_amount_value,
    valuey13                     TYPE gty_amount_value,
    valuey14                     TYPE gty_amount_value,
    valuey15                     TYPE gty_amount_value,
    "Value Year > 15
    valuey16                     TYPE gty_amount_value,                                             " NW004 (+)
    "LL
    lllt1y                       TYPE gty_amount_value,
    llbt1and2y                   TYPE gty_amount_value,
    llbt2and5y                   TYPE gty_amount_value,
    llbt5and10y                  TYPE gty_amount_value,
    llbt10and15y                 TYPE gty_amount_value,
    llgt15y                      TYPE gty_amount_value,
    totallt                      TYPE gty_amount_value,
    "Diff
    glcurrentportion             TYPE gty_amount_value,
    gllongterm                   TYPE gty_amount_value,
    diffcurrentportion           TYPE gty_amount_value,
    difflongterm                 TYPE gty_amount_value,

    " CR Columns
    glcurrentportion_apcp_rou    TYPE gty_amount_value,                                             " NW007 (+)
    diffcurrentportion_apcp_rou  TYPE gty_amount_value,                                             " NW007 (+)
    gllongterm_lt_rou            TYPE gty_amount_value,                                             " NW007 (+)
    difflongterm_lt_rou          TYPE gty_amount_value,                                             " NW007 (+)
    dummyamountvalue             TYPE gty_amount_value,                                             " NW007 (+)
  END OF gty_data,

  BEGIN OF gty_apcplast,
    companycode          TYPE zi_rtr_oll_apcplast-companycode,
    agreementnumber      TYPE zi_rtr_oll_apcplast-agreementnumber,
    currentapinstallment TYPE zi_rtr_oll_apcplast-currentapinstallment,
  END OF gty_apcplast,

  BEGIN OF gty_recondition,
    companycode        TYPE zi_recontractdata-companycode,
    realestatecontract TYPE zi_recontractdata-realestatecontract,
    reconditiontype    TYPE zi_recondition-reconditiontype,
    reunitprice        TYPE zi_recondition-reunitprice,
  END OF gty_recondition,

  BEGIN OF gty_terminateamount,
    companycode        TYPE zi_recontractdata-companycode,
    realestatecontract TYPE zi_recontractdata-realestatecontract,
    terminateamount    TYPE gty_data-terminateamount,
  END OF gty_terminateamount,

  BEGIN OF gty_companycode_rouclass,                                                                " NW007 (+)
    companycode TYPE zi_rtr_rou_outleaseliabrep-companycode,                                        " NW007 (+)
    rouclass    TYPE zi_rtr_rou_outleaseliabrep-rouclass,                                           " NW007 (+)
  END OF gty_companycode_rouclass.                                                                  " NW007 (+)

TYPES:
  gtty_data TYPE TABLE OF gty_data.

CONSTANTS:
  gc_number_of_year TYPE i VALUE 16,

  BEGIN OF gc_type,
    lease TYPE zi_rtr_rou_outleaseliabrep-type VALUE 'L',
    dfi   TYPE zi_rtr_rou_outleaseliabrep-type VALUE 'D',
    apcp  TYPE zi_rtr_rou_outleaseliabrep-type VALUE 'A',
  END OF gc_type.
