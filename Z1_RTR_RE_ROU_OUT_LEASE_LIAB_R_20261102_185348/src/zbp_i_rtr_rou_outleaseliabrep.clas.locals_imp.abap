" /////////////////////////////////////////////////////////////////////////
" // Project Name: SMILE
" // Created by  : Potsawat M.
" // Created on  : 12.02.2026
" // WRICEF ID   : RTR-RE011
" // TR Number   : GSDK911054
" //-----------------------------------------------------------------------
" // Description : Outstanding Lease Liability and Defer Interest Report
" //-----------------------------------------------------------------------
" // Change History
" //-----------------------------------------------------------------------
" // Date |TR Number |Search Term |Developer |Description
" // -------- ----------- ----------- ----------- -------------------------
" // 09/03/2025 | GSDK911054 | NW001 | Naruepan W. | Change formula of Terminate Amount
" // 23/03/2025 | GSDK913869 | NW002 | Naruepan W. | Change data type of payment method
" // 26/05/2026 | GSDK918255 | NW003 | Naruepan W. | Add Contract Type Name
" // 25/06/2026 | GSDK920102 | NW005 | Naruepan W. | Add check field Installment Frequency
" // 20/07/2026 | GSDK922121 | NW006 | Naruepan W. | Adjust difference amount when currency is foreign currency
" // 11/08/2026 | GSDK924603 | NW007 | Naruepan W. | Add column:
" //                                                     Total GL Current Portion of Lease Liability
" //                                                     Diff Current Portion
" //                                                     Total Long Term of Lease Liability
" //                                                     Diff Long Term
" // 09/09/2026 | GSDK927467 | NW008 | Naruepan W. | Bug fixed:
" //                                                    Change:
" //                                                     Total Long Term of Lease Liability -> Total GL Long Term of Lease Liability
" //                                                    Add:
" //                                                     Filename with Companycode and key date
" //                                                     Realestatecontract to APCP
" /////////////////////////////////////////////////////////////////////////
CLASS lhc_outleaseliabrep DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    " NW007 (+)
    TYPES: BEGIN OF ts_tradingpartner,
             tradingpartner TYPE zi_rtr_oll_acctdocitemrouandtp-tradingpartner,
           END OF ts_tradingpartner.
    TYPES tt_tradingpartner TYPE SORTED TABLE OF ts_tradingpartner WITH UNIQUE KEY tradingpartner.
    " NW007 (+)

    " NW008 (+)
    CONSTANTS mc_temporary_recn TYPE zi_rtr_rou_outleaseliabrep-realestatecontract VALUE '9999999999999'.
    " NW008 (+)

    DATA: BEGIN OF ms_parameter,
            companycode TYPE zi_rtr_rou_outleaseliabrep-companycode,
            keydate     TYPE cl_abap_context_info=>ty_system_date,
          END OF ms_parameter.

    DATA: BEGIN OF ms_excel,
            excel           TYPE REF TO zcl_excel,
            worksheet       TYPE REF TO zcl_excel_worksheet,
            row             TYPE i,
            column          TYPE i,
            components_data TYPE cl_abap_structdescr=>component_table,
          END OF ms_excel.

    DATA: BEGIN OF ms_excel_style,
            title                 TYPE REF TO zcl_excel_style,
            table_header_1        TYPE REF TO zcl_excel_style,
            table_header_2        TYPE REF TO zcl_excel_style,
            table_header_3        TYPE REF TO zcl_excel_style,
            table_header_4        TYPE REF TO zcl_excel_style,
            table_data_general_l  TYPE REF TO zcl_excel_style,
            table_data_general_c  TYPE REF TO zcl_excel_style,
            table_data_general_r  TYPE REF TO zcl_excel_style,
            table_data_number     TYPE REF TO zcl_excel_style,
            table_data_number_2   TYPE REF TO zcl_excel_style,
            table_data_percentage TYPE REF TO zcl_excel_style,
            agreement_1_1         TYPE REF TO zcl_excel_style,
            agreement_1_2         TYPE REF TO zcl_excel_style,
            agreement_2_1         TYPE REF TO zcl_excel_style,
            agreement_2_2         TYPE REF TO zcl_excel_style,
            rouclass_1_1          TYPE REF TO zcl_excel_style,
            rouclass_1_2          TYPE REF TO zcl_excel_style,
            rouclass_2_1          TYPE REF TO zcl_excel_style,
            rouclass_2_2          TYPE REF TO zcl_excel_style,
            total_1_1             TYPE REF TO zcl_excel_style,
            total_1_2             TYPE REF TO zcl_excel_style,
            total_2_1             TYPE REF TO zcl_excel_style,
            total_2_2             TYPE REF TO zcl_excel_style,
          END OF ms_excel_style.

    DATA: BEGIN OF ms_excel_border,
            dark  TYPE REF TO zcl_excel_style_border,
            light TYPE REF TO zcl_excel_style_border,
          END OF ms_excel_border.

    DATA mt_rouclasstext              TYPE HASHED TABLE OF zi_rtr_oll_rouclasstext
           WITH UNIQUE KEY primary_key
           COMPONENTS rouclass language.
    DATA mt_typetext                  TYPE HASHED TABLE OF zi_rtr_oll_typetext
           WITH UNIQUE KEY primary_key
           COMPONENTS type language.
    DATA mt_typegrouptext             TYPE HASHED TABLE OF zi_rtr_oll_typegrouptext
           WITH UNIQUE KEY primary_key
           COMPONENTS typegroup language.
    DATA mt_paymentmethodtext         TYPE HASHED TABLE OF zi_rtr_oll_paymentmethodtext
           WITH UNIQUE KEY primary_key
           COMPONENTS paymentmethod language.
    DATA mt_installmentfreqtext       TYPE HASHED TABLE OF zi_rtr_oll_installmentfreqtext
           WITH UNIQUE KEY primary_key
           COMPONENTS installmentfrequency language.
    DATA mt_interestratetype_rectext  TYPE HASHED TABLE OF zz1_interestratetype_w
           WITH UNIQUE KEY primary_key
           COMPONENTS code language.
    DATA mt_recondition               TYPE HASHED TABLE OF gty_recondition
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode realestatecontract reconditiontype.
    DATA mt_apcp                      TYPE HASHED TABLE OF zi_rtr_oll_apcp
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode agreementnumber calculationyear calculationmonth.
    DATA mt_terminateamount           TYPE HASHED TABLE OF gty_terminateamount
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode realestatecontract.

    DATA mv_language                  TYPE cl_abap_context_info=>ty_language_key.

    " NW007 (+)
    DATA mt_oll_acctdocitembyrou      TYPE HASHED TABLE OF zi_rtr_oll_acctdocitembyrou
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode identifier rouclass
           WITH NON-UNIQUE SORTED KEY secondary_key_1
           COMPONENTS companycode rouclass
           WITH NON-UNIQUE SORTED KEY secondary_key_2
           COMPONENTS identifier.
    DATA mt_oll_acctdocitembyrouandtp TYPE HASHED TABLE OF zi_rtr_oll_acctdocitemrouandtp
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode identifier rouclass tradingpartner
           WITH NON-UNIQUE SORTED KEY secondary_key_1
           COMPONENTS companycode rouclass tradingpartner
           WITH NON-UNIQUE SORTED KEY secondary_key_2
           COMPONENTS identifier tradingpartner.
    DATA mt_tradingpartner            TYPE tt_tradingpartner.
    " NW007 (+)

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR outleaseliabrep RESULT result.

    METHODS get_excel FOR MODIFY
      IMPORTING keys FOR ACTION outleaseliabrep~getexcel RESULT result.

    METHODS conv_month_2_duration
      IMPORTING iv_month    TYPE i
      EXPORTING ev_duration TYPE clike.

    METHODS format_date_out
      IMPORTING iv_in  TYPE cl_abap_context_info=>ty_system_date
      EXPORTING ev_out TYPE clike.

    METHODS format_amount_out
      IMPORTING iv_in       TYPE numeric
                iv_currency TYPE i_currency-currency
      EXPORTING ev_out      TYPE clike.

    METHODS format_rate_out
      IMPORTING iv_in  TYPE numeric
      EXPORTING ev_out TYPE clike.

    METHODS format_quantity_out
      IMPORTING iv_in   TYPE numeric
                iv_unit TYPE i_unitofmeasure-unitofmeasure
      EXPORTING ev_out  TYPE clike.

    METHODS format_po_item_out
      IMPORTING iv_purchaseorder     TYPE i_purchaseorderitemapi01-purchaseorder
                iv_purchaseorderitem TYPE i_purchaseorderitemapi01-purchaseorderitem
      EXPORTING ev_out               TYPE clike.

    METHODS format_boolean_out
      IMPORTING iv_in  TYPE abap_bool
      EXPORTING ev_out TYPE clike.

    METHODS _excel_create_style
      RAISING zcx_excel.

    METHODS _excel_title
      IMPORTING iv_companycode     TYPE i_companycode-companycode
                iv_companycodename TYPE clike
                iv_keydate         TYPE cl_abap_context_info=>ty_system_date
      RAISING   zcx_excel.

    METHODS _excel_width
      RAISING zcx_excel.

    METHODS _excel_table_header
      IMPORTING iv_keydate    TYPE cl_abap_context_info=>ty_system_date
                iv_start_year TYPE zi_rtr_oll_valuationcfclr-calculationyear
                iv_end_year   TYPE zi_rtr_oll_valuationcfclr-calculationyear
      RAISING   zcx_excel.

    METHODS _excel_append_data
      IMPORTING is_data       TYPE gty_data
                iv_start_year TYPE zi_rtr_oll_valuationcfclr-calculationyear
                iv_end_year   TYPE zi_rtr_oll_valuationcfclr-calculationyear
      RAISING   zcx_excel
                cx_abap_context_info_error.

    METHODS _excel_append_agreement_1
      IMPORTING is_data TYPE gty_data
      RAISING   zcx_excel
                cx_abap_context_info_error.

    METHODS _excel_append_agreement_2
      IMPORTING is_data TYPE gty_data
      RAISING   zcx_excel
                cx_abap_context_info_error.

    METHODS _excel_append_rouclass_1
      IMPORTING is_data TYPE gty_data
      RAISING   zcx_excel
                cx_abap_context_info_error.

    METHODS _excel_append_rouclass_2
      IMPORTING is_data TYPE gty_data
      RAISING   zcx_excel
                cx_abap_context_info_error.

    METHODS _excel_append_total_1
      IMPORTING is_data TYPE gty_data
      RAISING   zcx_excel
                cx_abap_context_info_error.

    METHODS _excel_append_total_2
      IMPORTING is_data TYPE gty_data
      RAISING   zcx_excel
                cx_abap_context_info_error.

    METHODS get_rouclasstext
      IMPORTING iv_rouclass            TYPE zi_rtr_oll_rouclasstext-rouclass
                iv_language            TYPE zi_rtr_oll_rouclasstext-language
      RETURNING VALUE(rv_rouclasstext) TYPE zi_rtr_oll_rouclasstext-rouclasstext.

    METHODS get_typetext
      IMPORTING iv_type            TYPE zi_rtr_oll_typetext-type
                iv_language        TYPE zi_rtr_oll_typetext-language
      RETURNING VALUE(rv_typetext) TYPE zi_rtr_oll_typetext-typetext.

    METHODS get_typegrouptext
      IMPORTING iv_typegroup            TYPE zi_rtr_oll_typegrouptext-typegroup
                iv_language             TYPE zi_rtr_oll_typegrouptext-language
      RETURNING VALUE(rv_typegrouptext) TYPE zi_rtr_oll_typegrouptext-typegrouptext.

    METHODS get_paymentmethodtext
      IMPORTING iv_paymentmethod            TYPE zi_rtr_oll_paymentmethodtext-paymentmethod
                iv_language                 TYPE zi_rtr_oll_paymentmethodtext-language
      RETURNING VALUE(rv_paymentmethodtext) TYPE zi_rtr_oll_paymentmethodtext-paymentmethodtext.

    METHODS get_installmentfreqtext
      IMPORTING iv_installmentfrequency            TYPE zi_rtr_oll_installmentfreqtext-installmentfrequency
                iv_language                        TYPE zi_rtr_oll_installmentfreqtext-language
      RETURNING VALUE(rv_installmentfrequencytext) TYPE zi_rtr_oll_installmentfreqtext-installmentfrequencytext.

    METHODS get_interestratetype_rectext
      IMPORTING iv_code               TYPE zz1_interestratetype_w-code
                iv_language           TYPE zz1_interestratetype_w-language
      RETURNING VALUE(rv_description) TYPE zz1_interestratetype_w-description.

    METHODS get_recondition
      IMPORTING iv_companycode        TYPE gty_recondition-companycode
                iv_realestatecontract TYPE gty_recondition-realestatecontract
                iv_reconditiontype    TYPE gty_recondition-reconditiontype
                iv_getfromdb          TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(rs_recondition) TYPE gty_recondition.

    METHODS get_apcp
      IMPORTING iv_companycode      TYPE zi_rtr_oll_apcp-companycode
                iv_agreementnumber  TYPE zi_rtr_oll_apcp-agreementnumber
                iv_calculationyear  TYPE zi_rtr_oll_apcp-calculationyear
                iv_calculationmonth TYPE zi_rtr_oll_apcp-calculationmonth
                iv_getfromdb        TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(rs_apcp)      TYPE zi_rtr_oll_apcp.

    METHODS get_terminateamount
      IMPORTING iv_companycode            TYPE gty_terminateamount-companycode
                iv_realestatecontract     TYPE gty_terminateamount-realestatecontract
                iv_getfromdb              TYPE abap_bool DEFAULT abap_true
      RETURNING VALUE(rv_terminateamount) TYPE gty_terminateamount-terminateamount.

    METHODS _get_additional_data_from_itab
      IMPORTING it_data       TYPE gtty_data
                iv_keydate    TYPE cl_abap_context_info=>ty_system_date
                iv_start_year TYPE zi_rtr_oll_valuationcfclr-calculationyear OPTIONAL
                iv_end_year   TYPE zi_rtr_oll_valuationcfclr-calculationyear OPTIONAL.

    METHODS _exclude_excel_components
      CHANGING cs_components_data TYPE cl_abap_structdescr=>component_table.

    " NW007 (+)
    METHODS _add_tradingpartner_components
      CHANGING cs_components_data TYPE cl_abap_structdescr=>component_table.

    METHODS _populate_amount_data_by_rou
      CHANGING ct_data_agreement_1 TYPE gtty_data OPTIONAL
               ct_data_agreement_2 TYPE gtty_data OPTIONAL
               ct_data_rouclass_1  TYPE gtty_data OPTIONAL
               ct_data_rouclass_2  TYPE gtty_data OPTIONAL
               ct_data_total_1     TYPE gtty_data OPTIONAL
               ct_data_total_2     TYPE gtty_data OPTIONAL.

    METHODS _append_amount_data_by_routp
      IMPORTING is_data_agreement_1 TYPE gty_data OPTIONAL
                is_data_agreement_2 TYPE gty_data OPTIONAL
                is_data_rouclass_1  TYPE gty_data OPTIONAL
                is_data_rouclass_2  TYPE gty_data OPTIONAL
                is_data_total_1     TYPE gty_data OPTIONAL
                is_data_total_2     TYPE gty_data OPTIONAL.

    METHODS _set_style_for_routp
      IMPORTING iv_method_name TYPE string.

    " NW007 (+)

ENDCLASS.


CLASS lhc_outleaseliabrep IMPLEMENTATION.
  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_excel.
    DATA lt_data                 TYPE TABLE OF gty_data.
    DATA ls_data                 TYPE gty_data.
    DATA ls_data_last            TYPE gty_data.
    DATA lt_data_agreement_1     TYPE TABLE OF gty_data.
    DATA ls_data_agreement_1     TYPE gty_data.
    DATA lt_data_agreement_2     TYPE TABLE OF gty_data.
    DATA ls_data_agreement_2     TYPE gty_data.
    DATA lt_data_rouclass_1      TYPE TABLE OF gty_data.
    DATA ls_data_rouclass_1      TYPE gty_data.
    DATA lt_data_rouclass_2      TYPE TABLE OF gty_data.
    DATA ls_data_rouclass_2      TYPE gty_data.
    DATA lt_data_total_1         TYPE TABLE OF gty_data.
    DATA ls_data_total_1         TYPE gty_data.
    DATA lt_data_total_2         TYPE TABLE OF gty_data.
    DATA ls_data_total_2         TYPE gty_data.
    DATA lo_struct_descr         TYPE REF TO cl_abap_structdescr.
    DATA lv_start_year           TYPE zi_rtr_oll_valuationcfclr-calculationyear.
    DATA lv_end_year             TYPE zi_rtr_oll_valuationcfclr-calculationyear.
    DATA lv_year                 TYPE n LENGTH 4.
    DATA lv_yy                   TYPE n LENGTH 2.
    DATA lv_mm                   TYPE n LENGTH 2.
    DATA lv_text                 TYPE c LENGTH 200.
    DATA lv_no                   TYPE i.
    DATA lv_pono                 TYPE c LENGTH 20.

    DATA lt_valuationcfclr       TYPE HASHED TABLE OF zi_rtr_oll_valuationcfclr
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode realestatecontract calculationyear calculationmonth
           WITH NON-UNIQUE SORTED KEY k1
           COMPONENTS companycode realestatecontract.
    DATA lt_valuationcfint       TYPE HASHED TABLE OF zi_rtr_oll_valuationcfint
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode realestatecontract calculationyear calculationmonth
           WITH NON-UNIQUE SORTED KEY k1
           COMPONENTS companycode realestatecontract.
    DATA lt_apcp                 TYPE HASHED TABLE OF zi_rtr_oll_apcp
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode agreementnumber calculationyear calculationmonth
           WITH NON-UNIQUE SORTED KEY k1
           COMPONENTS companycode agreementnumber.
    DATA lt_businesspartner      TYPE HASHED TABLE OF i_businesspartner
           WITH UNIQUE KEY primary_key
           COMPONENTS businesspartner.
    DATA lt_globalcompany        TYPE HASHED TABLE OF i_globalcompany
           WITH UNIQUE KEY primary_key
           COMPONENTS company.
    DATA lt_fixedasset           TYPE HASHED TABLE OF i_fixedasset
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode masterfixedasset fixedasset.
    DATA lt_rouct_po             TYPE HASHED TABLE OF zi_rtr_rouct_po
           WITH UNIQUE KEY primary_key
           COMPONENTS intreno ebeln ebelp
           WITH NON-UNIQUE SORTED KEY k1
           COMPONENTS intreno.
    DATA lt_apcplast             TYPE HASHED TABLE OF gty_apcplast
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode agreementnumber.
    DATA lt_contractversion      TYPE HASHED TABLE OF zi_rtr_oll_contractversion
           WITH UNIQUE KEY primary_key
           COMPONENTS internalrealestatenumber.

    " NW006 (+)
*    DATA lt_amount_diff_chk  TYPE RANGE OF gty_amount_value.
    " NW006 (+)
    " NW007 (+)
    DATA lt_companycode_rouclass TYPE HASHED TABLE OF gty_companycode_rouclass
           WITH UNIQUE KEY primary_key
           COMPONENTS companycode rouclass.
    " NW007 (+)

    TRY.
        DATA(ls_keys) = VALUE #( keys[ 1 ] OPTIONAL ).

        ms_parameter-companycode = ls_keys-%param-companycode.
        ms_parameter-keydate     = ls_keys-%param-keydate.

        IF ms_parameter-companycode IS INITIAL.
          RAISE EXCEPTION NEW zcx_ext_general_error( is_textid = VALUE #( msgid = 'SD_LSTG_EXCLSN'
                                                                          msgno = '001'
                                                                          attr1 = 'Company Code' ) ).
        ENDIF.

        IF ms_parameter-keydate IS INITIAL.
          RAISE EXCEPTION NEW zcx_ext_general_error( is_textid = VALUE #( msgid = 'SD_LSTG_EXCLSN'
                                                                          msgno = '001'
                                                                          attr1 = 'Key Date' ) ).
        ENDIF.

        TRY.
            mv_language = cl_abap_context_info=>get_user_language_abap_format( ).
          CATCH cx_abap_context_info_error.
        ENDTRY.

        IF mv_language IS INITIAL.
          mv_language = 'E'.
        ENDIF.

        lv_start_year = ms_parameter-keydate(4).
        lv_start_year -= 1.

*        lv_end_year = lv_start_year + gc_number_of_year - 1.           " NW003 (-)

        " TODO: variable is assigned but never used (ABAP cleaner)
        DATA(lv_gt_number_of_year) = gc_number_of_year - 1.             " NW003 (+)
        lv_end_year = lv_start_year + gc_number_of_year.                " NW003 (+)

        " Select
        SELECT SINGLE companycode~companycode,
                      companycode~companycodename,
                      companycode~currency
          FROM i_companycode AS companycode
          WHERE companycode = @ms_parameter-companycode
          INTO @DATA(ls_companycode).

        SELECT *
          FROM zi_rtr_rou_outleaseliabrep( p_companycode = @ms_parameter-companycode,
                                           p_keydate     = @ms_parameter-keydate )
          INTO TABLE @DATA(lt_outleaseliabrep).

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_valuationcfclr[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING companycode = companycode realestatecontract = realestatecontract
            EXCEPT * ).

          IF lt_outleaseliabrep IS NOT INITIAL.
            SELECT valuationcfclr~*

              FROM zi_rtr_oll_valuationcfclr AS valuationcfclr

                     JOIN
                       @lt_valuationcfclr AS lt_valuationcfclr ON  lt_valuationcfclr~companycode        = valuationcfclr~companycode
                                                               AND lt_valuationcfclr~realestatecontract = valuationcfclr~realestatecontract

              INTO TABLE @lt_valuationcfclr.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_valuationcfint[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING companycode = companycode realestatecontract = realestatecontract
            EXCEPT * ).

          IF lt_valuationcfint IS NOT INITIAL.
            SELECT valuationcfint~*

              FROM zi_rtr_oll_valuationcfint AS valuationcfint

                     JOIN
                       @lt_valuationcfint AS lt_valuationcfint ON  lt_valuationcfint~companycode        = valuationcfint~companycode
                                                               AND lt_valuationcfint~realestatecontract = valuationcfint~realestatecontract

              INTO TABLE @lt_valuationcfint.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_apcp[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING companycode = companycode agreementnumber = agreementnumber
            EXCEPT * ).

          IF lt_apcp IS NOT INITIAL.
            SELECT apcp~*

              FROM zi_rtr_oll_apcp( p_keydate = @ms_parameter-keydate ) AS apcp

                     JOIN
                       @lt_apcp AS lt_apcp ON  lt_apcp~companycode     = apcp~companycode
                                           AND lt_apcp~agreementnumber = apcp~agreementnumber

              INTO TABLE @lt_apcp.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_businesspartner[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING businesspartner = businesspartnersupplier
            EXCEPT * ).

          IF lt_businesspartner IS NOT INITIAL.
            SELECT businesspartner~businesspartner,
                   businesspartner~businesspartnerfullname

              FROM i_businesspartner AS businesspartner

                     JOIN
                       @lt_businesspartner AS lt_businesspartner ON lt_businesspartner~businesspartner = businesspartner~businesspartner

              INTO CORRESPONDING FIELDS OF TABLE @lt_businesspartner.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_globalcompany[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING company = tradingpartner
            EXCEPT * ).

          IF lt_globalcompany IS NOT INITIAL.
            SELECT globalcompany~*

              FROM i_globalcompany AS globalcompany

                     JOIN
                       @lt_globalcompany AS lt_globalcompany ON lt_globalcompany~company = globalcompany~company

              INTO TABLE @lt_globalcompany.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_fixedasset[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING companycode = companycode
                    masterfixedasset = masterfixedasset
                    fixedasset = fixedasset
            EXCEPT * ).

          IF lt_fixedasset IS NOT INITIAL.
            SELECT fixedasset~*

              FROM i_fixedasset AS fixedasset

                     JOIN
                       @lt_fixedasset AS lt_fixedasset ON  lt_fixedasset~companycode      = fixedasset~companycode
                                                       AND lt_fixedasset~masterfixedasset = fixedasset~masterfixedasset
                                                       AND lt_fixedasset~fixedasset       = fixedasset~fixedasset

              INTO TABLE @lt_fixedasset.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_rouct_po[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING intreno = internalrealestatenumber
            EXCEPT * ).

          IF lt_rouct_po IS NOT INITIAL.
            SELECT rouct_po~*

              FROM zi_rtr_rouct_po AS rouct_po

                     JOIN
                       @lt_rouct_po AS lt_rouct_po ON lt_rouct_po~intreno = rouct_po~intreno

              INTO TABLE @lt_rouct_po.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_apcplast[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING companycode = companycode
                    agreementnumber = agreementnumber
            EXCEPT * ).

          IF lt_apcplast IS NOT INITIAL.
            SELECT apcplast~companycode,
                   apcplast~agreementnumber,
                   apcplast~currentapinstallment

              FROM zi_rtr_oll_apcplast( p_keydate = @ms_parameter-keydate ) AS apcplast

                     JOIN
                       @lt_apcplast AS lt_apcplast ON  lt_apcplast~companycode     = apcplast~companycode
                                                   AND lt_apcplast~agreementnumber = apcplast~agreementnumber

*            JOIN zi_rtr_oll_apcp( p_keydate = @ms_parameter-keydate ) AS apcp
*            ON apcp~companycode = apcplast~companycode AND
*               apcp~agreementnumber = apcplast~agreementnumber AND
*               apcp~calculationyear = apcplast~calculationyear AND
*               apcp~calculationmonth = apcplast~calculationmonth

              INTO TABLE @lt_apcplast.

            LOOP AT lt_apcplast ASSIGNING FIELD-SYMBOL(<ls_apcplast>).
              <ls_apcplast>-currentapinstallment = |{ <ls_apcplast>-currentapinstallment ALPHA = IN }|.
            ENDLOOP.
          ENDIF.
        ENDIF.

        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_contractversion[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING internalrealestatenumber = internalrealestatenumber
            EXCEPT * ).

          IF lt_contractversion IS NOT INITIAL.
            SELECT contractversion~*

              FROM zi_rtr_oll_contractversion AS contractversion

                     JOIN
                       @lt_contractversion AS lt_contractversion ON lt_contractversion~internalrealestatenumber = contractversion~internalrealestatenumber

              INTO TABLE @lt_contractversion.
          ENDIF.
        ENDIF.

        " NW007 (+)
        IF lt_outleaseliabrep[] IS NOT INITIAL.
          lt_companycode_rouclass[] = CORRESPONDING #(
            lt_outleaseliabrep DISCARDING DUPLICATES
            MAPPING companycode = companycode
                    rouclass    = rouclass
            EXCEPT * ).

          SELECT
            FROM zi_rtr_oll_acctdocitembyrou( p_companycode = @ms_parameter-companycode,
                                              p_keydate     = @ms_parameter-keydate ) AS oll_acctdocitembyrou
                   JOIN
                     @lt_companycode_rouclass AS companycode_rou ON  oll_acctdocitembyrou~companycode = companycode_rou~companycode
                                                                 AND oll_acctdocitembyrou~rouclass    = companycode_rou~rouclass
            FIELDS oll_acctdocitembyrou~*
            INTO CORRESPONDING FIELDS OF TABLE @mt_oll_acctdocitembyrou.

          SELECT
            FROM zi_rtr_oll_acctdocitemrouandtp( p_companycode = @ms_parameter-companycode,
                                                 p_keydate     = @ms_parameter-keydate ) AS oll_acctdocitembyrouandtp
                   JOIN
                     @lt_companycode_rouclass AS companycode_rou ON  oll_acctdocitembyrouandtp~companycode = companycode_rou~companycode
                                                                 AND oll_acctdocitembyrouandtp~rouclass    = companycode_rou~rouclass
            FIELDS oll_acctdocitembyrouandtp~*
            WHERE amountincompanycodecurrency <> 0
            INTO CORRESPONDING FIELDS OF TABLE @mt_oll_acctdocitembyrouandtp.
          IF sy-subrc = 0.
            mt_tradingpartner = CORRESPONDING #( mt_oll_acctdocitembyrouandtp
                                                 DISCARDING DUPLICATES
                                                 MAPPING tradingpartner = tradingpartner
                                                 EXCEPT * ).
          ENDIF.
        ENDIF.
        " NW007 (+)

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " Prepare
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        LOOP AT lt_outleaseliabrep ASSIGNING FIELD-SYMBOL(<ls_outleaseliabrep>).
          " Replace data
          <ls_outleaseliabrep>-recontractcurrency       = <ls_outleaseliabrep>-recontractcurrency_2.
          <ls_outleaseliabrep>-zz1_interestratetype_rec = <ls_outleaseliabrep>-zz1_interestratetype_rec_2.

          " Move data
          APPEND CORRESPONDING #( <ls_outleaseliabrep> ) TO lt_data
                 ASSIGNING FIELD-SYMBOL(<ls_data>).

          " Header
          IF <ls_outleaseliabrep>-type = gc_type-apcp.
            " NW008 (+)
            <ls_data>-realestatecontractforapcp = <ls_data>-realestatecontract.
            " NW008 (+)

            " Temporary RECN for sort
            <ls_data>-realestatecontract        = mc_temporary_recn.
          ENDIF.

          <ls_data>-companycodecurrency = ls_companycode-currency.

          DATA(ls_businesspartner) = VALUE #( lt_businesspartner[ businesspartner = <ls_data>-businesspartnersupplier ] OPTIONAL ).
          <ls_data>-businesspartnersuppliername = ls_businesspartner-businesspartnerfullname.

          DATA(ls_globalcompany) = VALUE #( lt_globalcompany[ company = <ls_data>-tradingpartner ] OPTIONAL ).
          <ls_data>-tradingpartnername = ls_globalcompany-companyname.

          DATA(ls_fixedasset) = VALUE #( lt_fixedasset[ companycode      = <ls_outleaseliabrep>-companycode
                                                        masterfixedasset = <ls_outleaseliabrep>-masterfixedasset
                                                        fixedasset       = <ls_outleaseliabrep>-fixedasset ]
                                         OPTIONAL ).
          <ls_data>-fixedassetexternalid = ls_fixedasset-fixedassetexternalid.

          conv_month_2_duration( EXPORTING iv_month    = <ls_outleaseliabrep>-contractdurationmonths
                                 IMPORTING ev_duration = <ls_data>-contractduration ).

          conv_month_2_duration( EXPORTING iv_month    = <ls_outleaseliabrep>-actualdurationmonths
                                 IMPORTING ev_duration = <ls_data>-actualduration ).

          conv_month_2_duration( EXPORTING iv_month    = <ls_outleaseliabrep>-remainingdurationmonths
                                 IMPORTING ev_duration = <ls_data>-remainingduration ).

          IF <ls_outleaseliabrep>-remainingdurationmonths > 0.
            <ls_data>-remainingperiod = <ls_outleaseliabrep>-remainingdurationmonths / '12.0'.
          ENDIF.

          IF <ls_outleaseliabrep>-recontractnoticedate IS NOT INITIAL.
            " NW001 (-)
*            <ls_data>-terminateamount = get_terminateamount(
*              iv_companycode        = <ls_outleaseliabrep>-companycode
*              iv_realestatecontract = <ls_outleaseliabrep>-realestatecontract
*            ).
            " NW001 (-)
            " NW001 (+)
            <ls_data>-getterminateamount = abap_true.
            " NW001 (+)
          ENDIF.

          " NW006 (+)
          <ls_outleaseliabrep>-lessthan1year      = <ls_outleaseliabrep>-lessthan1year_2.
          <ls_outleaseliabrep>-between1and2year   = <ls_outleaseliabrep>-between1and2year_2.
          <ls_outleaseliabrep>-between2and5year   = <ls_outleaseliabrep>-between2and5year_2.
          <ls_outleaseliabrep>-between5and10year  = <ls_outleaseliabrep>-between5and10year_2.
          <ls_outleaseliabrep>-between10and15year = <ls_outleaseliabrep>-between10and15year_2.
          <ls_outleaseliabrep>-greaterthan15year  = <ls_outleaseliabrep>-greaterthan15year_2.
          <ls_outleaseliabrep>-glcurrentportion   = <ls_outleaseliabrep>-glcurrentportion_2.
          <ls_outleaseliabrep>-gllongterm         = <ls_outleaseliabrep>-gllongterm_2.
          " NW006 (+)

          <ls_data>-lllt1y        = <ls_outleaseliabrep>-lessthan1year.
          <ls_data>-llbt1and2y    = <ls_outleaseliabrep>-between1and2year.
          <ls_data>-totallt      += <ls_outleaseliabrep>-between1and2year.
          <ls_data>-llbt2and5y    = <ls_outleaseliabrep>-between2and5year.
          <ls_data>-totallt      += <ls_outleaseliabrep>-between2and5year.
          <ls_data>-llbt5and10y   = <ls_outleaseliabrep>-between5and10year.
          <ls_data>-totallt      += <ls_outleaseliabrep>-between5and10year.
          <ls_data>-llbt10and15y  = <ls_outleaseliabrep>-between10and15year.
          <ls_data>-totallt      += <ls_outleaseliabrep>-between10and15year.
          <ls_data>-llgt15y       = <ls_outleaseliabrep>-greaterthan15year.
          <ls_data>-totallt      += <ls_outleaseliabrep>-greaterthan15year.

          LOOP AT lt_rouct_po ASSIGNING FIELD-SYMBOL(<ls_rouct_po>)
               USING KEY k1
               WHERE intreno = <ls_outleaseliabrep>-internalrealestatenumber.

            format_po_item_out( EXPORTING iv_purchaseorder     = <ls_rouct_po>-ebeln
                                          iv_purchaseorderitem = <ls_rouct_po>-ebelp
                                IMPORTING ev_out               = lv_pono ).

            IF <ls_data>-pono IS INITIAL.
              <ls_data>-pono = lv_pono.
            ELSE.
              <ls_data>-pono = |{ <ls_data>-pono }, { lv_pono }|.
            ENDIF.

          ENDLOOP.

          IF <ls_outleaseliabrep>-type = gc_type-apcp.
            DATA(ls_apcplast) = VALUE #( lt_apcplast[ companycode     = <ls_outleaseliabrep>-companycode
                                                      agreementnumber = <ls_outleaseliabrep>-agreementnumber ]
                                         OPTIONAL ).
            <ls_data>-currentapinstallment = ls_apcplast-currentapinstallment.
          ENDIF.

          <ls_data>-interest = <ls_data>-contractvalue - <ls_data>-netleaseliability.

          DATA(ls_contractversion) = VALUE #( lt_contractversion[
                                                  internalrealestatenumber = <ls_outleaseliabrep>-internalrealestatenumber ] OPTIONAL ).
          <ls_data>-version = ls_contractversion-version.

          " Value Lease
          IF <ls_outleaseliabrep>-type = gc_type-lease.
            LOOP AT lt_valuationcfclr ASSIGNING FIELD-SYMBOL(<ls_valuationcfclr>)
                 USING KEY k1
                 WHERE     companycode        = <ls_outleaseliabrep>-companycode
                       AND realestatecontract = <ls_outleaseliabrep>-realestatecontract.

              lv_year = <ls_valuationcfclr>-calculationyear.
              lv_mm = <ls_valuationcfclr>-calculationmonth.

              IF |{ lv_year }{ lv_mm }| <= ms_parameter-keydate(6).
                CONTINUE.
              ENDIF.

              IF lv_year < lv_start_year.
                lv_year = lv_start_year.
              ELSEIF lv_year > lv_end_year.
                lv_year = lv_end_year.
              ENDIF.

              lv_yy = lv_year - lv_start_year.

              ASSIGN COMPONENT |VALUEY{ lv_yy }|
                     OF STRUCTURE <ls_data>
                     TO FIELD-SYMBOL(<lv_valueyxx>).
              IF sy-subrc = 0.
                <lv_valueyxx> += <ls_valuationcfclr>-amountincompanycodecurrency.
              ENDIF.

              ASSIGN COMPONENT |VALUEY{ lv_yy }M{ lv_mm }|
                     OF STRUCTURE <ls_data>
                     TO FIELD-SYMBOL(<lv_valueyxxmxx>).
              IF sy-subrc = 0.
                <lv_valueyxxmxx> += <ls_valuationcfclr>-amountincompanycodecurrency.
              ENDIF.

            ENDLOOP.

          ENDIF.

          " Value DFI
          IF <ls_outleaseliabrep>-type = gc_type-dfi.
            LOOP AT lt_valuationcfint ASSIGNING FIELD-SYMBOL(<ls_valuationcfint>)
                 USING KEY k1
                 WHERE     companycode        = <ls_outleaseliabrep>-companycode
                       AND realestatecontract = <ls_outleaseliabrep>-realestatecontract.

              lv_year = <ls_valuationcfint>-calculationyear.
              lv_mm = <ls_valuationcfint>-calculationmonth.

              IF |{ lv_year }{ lv_mm }| <= ms_parameter-keydate(6).
                CONTINUE.
              ENDIF.

              IF lv_year < lv_start_year.
                lv_year = lv_start_year.
              ELSEIF lv_year > lv_end_year.
                lv_year = lv_end_year.
              ENDIF.

              lv_yy = lv_year - lv_start_year.

              ASSIGN COMPONENT |VALUEY{ lv_yy }|
                     OF STRUCTURE <ls_data>
                     TO <lv_valueyxx>.
              IF sy-subrc = 0.
                <lv_valueyxx> += <ls_valuationcfint>-amountincompanycodecurrency.
              ENDIF.

              ASSIGN COMPONENT |VALUEY{ lv_yy }M{ lv_mm }|
                     OF STRUCTURE <ls_data>
                     TO <lv_valueyxxmxx>.
              IF sy-subrc = 0.
                <lv_valueyxxmxx> += <ls_valuationcfint>-amountincompanycodecurrency.
              ENDIF.

            ENDLOOP.

          ENDIF.

          " Value APCP
          IF <ls_outleaseliabrep>-type = gc_type-apcp.
            LOOP AT lt_apcp ASSIGNING FIELD-SYMBOL(<ls_apcp>)
                 USING KEY k1
                 WHERE     companycode     = <ls_outleaseliabrep>-companycode
                       AND agreementnumber = <ls_outleaseliabrep>-agreementnumber.

              lv_year = <ls_apcp>-calculationyear.
              lv_mm = <ls_apcp>-calculationmonth.

              IF lv_year < lv_start_year.
                lv_year = lv_start_year.
              ELSEIF lv_year > lv_end_year.
                lv_year = lv_end_year.
              ENDIF.

              lv_yy = lv_year - lv_start_year.

              ASSIGN COMPONENT |VALUEY{ lv_yy }|
                     OF STRUCTURE <ls_data>
                     TO <lv_valueyxx>.
              IF sy-subrc = 0.
                <lv_valueyxx> += <ls_apcp>-amountincompanycodecurrency.
              ENDIF.

              ASSIGN COMPONENT |VALUEY{ lv_yy }M{ lv_mm }|
                     OF STRUCTURE <ls_data>
                     TO <lv_valueyxxmxx>.
              IF sy-subrc = 0.
                <lv_valueyxxmxx> += <ls_apcp>-amountincompanycodecurrency.
              ENDIF.

            ENDLOOP.

          ENDIF.

        ENDLOOP.

        SORT lt_data
             BY rouclass
                agreementnumber
                realestatecontract
                typegroup DESCENDING.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " Diff
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        LOOP AT lt_data ASSIGNING <ls_data>.
          IF <ls_data>-type = gc_type-lease.
            " NW001 (-)
*            <ls_data>-diffcurrentportion = <ls_data>-glcurrentportion - <ls_data>-lllt1y.
*            <ls_data>-difflongterm = <ls_data>-gllongterm - <ls_data>-totallt.
*
*            LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data_2>)
*              WHERE realestatecontract = <ls_data>-realestatecontract AND
*                    agreementnumber = <ls_data>-agreementnumber AND
*                    type = gc_type-dfi.
*
*              <ls_data>-diffcurrentportion += <ls_data_2>-lllt1y.
*              <ls_data>-difflongterm += <ls_data_2>-totallt.
*            ENDLOOP.
            " NW001 (-)
            " NW001 (+)
            DATA(lv_lllt1y_lease)  = VALUE gty_amount_value( ).
            DATA(lv_totallt_lease) = VALUE gty_amount_value( ).

            DATA(lv_lllt1y_dfi)  = VALUE gty_amount_value( ).
            DATA(lv_totallt_dfi) = VALUE gty_amount_value( ).

            LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<ls_data_2>)
                 WHERE     realestatecontract = <ls_data>-realestatecontract
                       AND agreementnumber    = <ls_data>-agreementnumber
                       AND (    type = gc_type-lease
                             OR type = gc_type-dfi ).
              CASE <ls_data_2>-type.
                WHEN gc_type-lease.
                  lv_lllt1y_lease  += <ls_data_2>-lllt1y.
                  lv_totallt_lease += <ls_data_2>-totallt.
                WHEN gc_type-dfi.
                  lv_lllt1y_dfi  += <ls_data_2>-lllt1y.
                  lv_totallt_dfi += <ls_data_2>-totallt.
              ENDCASE.
            ENDLOOP.

            lv_lllt1y_lease  += lv_lllt1y_dfi.
            lv_totallt_lease += lv_totallt_dfi.

            " NW006 (-)
*            <ls_data>-diffcurrentportion = <ls_data>-glcurrentportion - lv_lllt1y_lease.
*            <ls_data>-difflongterm       = <ls_data>-gllongterm - lv_totallt_lease.
            " NW006 (-)
            " NW006 (+)
            "-----------------------------------------------------------------------------------------------------
            " Unused now because this logic was populated by CDS "ZI_RTR_OLL_ADJFOREIGNCURRDFI_1"
            "-----------------------------------------------------------------------------------------------------
*            DATA(lv_diffcurrentportion) = CONV gty_amount_value( <ls_data>-glcurrentportion - lv_lllt1y_lease ).
*            DATA(lv_difflongterm)       = CONV gty_amount_value( <ls_data>-gllongterm - lv_totallt_lease ).
*            lt_amount_diff_chk          = VALUE #( sign   = 'I'
*                                                   option = 'BT'
*                                                   ( low = '-1' high = '1' ) ).
*
*            " Populate difference amount when currency is foreign currency
*            IF <ls_data>-recontractcurrency <> <ls_data>-companycodecurrency.
*              DATA(lv_start_cp_date) = xco_cp=>sy->date( )->overwrite( iv_year  = ms_parameter-keydate(4)
*                                                                       iv_month = ms_parameter-keydate+4(2)
*                                                                       iv_day   = '01' )->add( iv_month = 1
*                                                                )->as( io_format = xco_cp_time=>format->abap
*                                                                )->value.
*              DATA(lv_start_lt_date) = xco_cp=>sy->date( )->overwrite( iv_year  = ms_parameter-keydate(4)
*                                                                       iv_month = ms_parameter-keydate+4(2)
*                                                                       iv_day   = '01' )->add( iv_month = 13
*                                                                )->as( io_format = xco_cp_time=>format->abap
*                                                                )->value.
*
*              IF     lv_diffcurrentportion <> 0
*                 AND lv_diffcurrentportion IN lt_amount_diff_chk.
*                lv_yy = lv_start_cp_date(4) - ms_parameter-keydate(4) + 1.
*                lv_mm = lv_start_cp_date+4(2).
*
*                LOOP AT lt_data ASSIGNING <ls_data_2>
*                     WHERE     realestatecontract = <ls_data>-realestatecontract
*                           AND agreementnumber    = <ls_data>-agreementnumber
*                           AND type               = gc_type-dfi.
*                  ASSIGN COMPONENT |VALUEY{ lv_yy }M{ lv_mm }|
*                         OF STRUCTURE <ls_data_2>
*                         TO <lv_valueyxxmxx>.
*                  IF sy-subrc = 0.
*                    <lv_valueyxxmxx> += lv_diffcurrentportion.
*                  ENDIF.
*
*                  ASSIGN COMPONENT |LLLT1Y|
*                         OF STRUCTURE <ls_data_2>
*                         TO FIELD-SYMBOL(<lv_valueylllt1y>).
*                  IF sy-subrc = 0.
*                    <lv_valueylllt1y> += lv_diffcurrentportion.
*                  ENDIF.
*                ENDLOOP.
*              ENDIF.
*
*              IF     lv_difflongterm <> 0
*                 AND lv_difflongterm IN lt_amount_diff_chk.
*                lv_yy = lv_start_lt_date(4) - ms_parameter-keydate(4) + 1.
*                lv_mm = lv_start_lt_date+4(2).
*
*                LOOP AT lt_data ASSIGNING <ls_data_2>
*                     WHERE     realestatecontract = <ls_data>-realestatecontract
*                           AND agreementnumber    = <ls_data>-agreementnumber
*                           AND type               = gc_type-dfi.
*                  ASSIGN COMPONENT |VALUEY{ lv_yy }M{ lv_mm }|
*                         OF STRUCTURE <ls_data_2>
*                         TO <lv_valueyxxmxx>.
*                  IF sy-subrc = 0.
*                    <lv_valueyxxmxx> += lv_difflongterm.
*                  ENDIF.
*
*                  ASSIGN COMPONENT |TOTALLT|
*                         OF STRUCTURE <ls_data_2>
*                         TO FIELD-SYMBOL(<lv_valueytotallt>).
*                  IF sy-subrc = 0.
*                    <lv_valueytotallt> += lv_difflongterm.
*                  ENDIF.
*                ENDLOOP.
*              ENDIF.
*
*              CLEAR: lv_lllt1y_lease,
*                     lv_totallt_lease,
*                     lv_lllt1y_dfi,
*                     lv_totallt_dfi.
*
*              LOOP AT lt_data ASSIGNING <ls_data_2>
*                   WHERE     realestatecontract = <ls_data>-realestatecontract
*                         AND agreementnumber    = <ls_data>-agreementnumber
*                         AND (    type = gc_type-lease
*                               OR type = gc_type-dfi ).
*                CASE <ls_data_2>-type.
*                  WHEN gc_type-lease.
*                    lv_lllt1y_lease  += <ls_data_2>-lllt1y.
*                    lv_totallt_lease += <ls_data_2>-totallt.
*                  WHEN gc_type-dfi.
*                    lv_lllt1y_dfi  += <ls_data_2>-lllt1y.
*                    lv_totallt_dfi += <ls_data_2>-totallt.
*                ENDCASE.
*              ENDLOOP.
*
*              lv_lllt1y_lease  += lv_lllt1y_dfi.
*              lv_totallt_lease += lv_totallt_dfi.
*
*              <ls_data>-diffcurrentportion = <ls_data>-glcurrentportion - lv_lllt1y_lease.
*              <ls_data>-difflongterm       = <ls_data>-gllongterm - lv_totallt_lease.
*            ELSE.
*              <ls_data>-diffcurrentportion = lv_diffcurrentportion.
*              <ls_data>-difflongterm       = lv_difflongterm.
*            ENDIF.

            "-----------------------------------------------------------------------------------------------------
            " Retrieve logic before editing instead because we created CDS "ZI_RTR_OLL_ADJFOREIGNCURRDFI_1"
            " to adjust it already
            "-----------------------------------------------------------------------------------------------------
            <ls_data>-diffcurrentportion = <ls_data>-glcurrentportion - lv_lllt1y_lease.
            <ls_data>-difflongterm       = <ls_data>-gllongterm - lv_totallt_lease.
            " NW006 (+)
            " NW001 (+)
          ELSEIF <ls_data>-type = gc_type-apcp.
            <ls_data>-diffcurrentportion = <ls_data>-glcurrentportion - <ls_data>-lllt1y.
            <ls_data>-difflongterm       = <ls_data>-gllongterm - <ls_data>-totallt.
          ENDIF.

        ENDLOOP.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " Prepare Excel
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        ms_excel-excel     = NEW zcl_excel( ).
        ms_excel-worksheet = ms_excel-excel->get_active_worksheet( ).

        lo_struct_descr ?= cl_abap_typedescr=>describe_by_data( ls_data ).
        ms_excel-components_data = lo_struct_descr->get_components( ).

        _add_tradingpartner_components( CHANGING cs_components_data = ms_excel-components_data ).    " NW007 (+)

        _exclude_excel_components( CHANGING cs_components_data = ms_excel-components_data ).

        ms_excel-worksheet->set_title( 'ROU Outstanding Lease Liability' ).

        _excel_create_style( ).

        _excel_title( iv_companycode     = ms_parameter-companycode
                      iv_companycodename = ls_companycode-companycodename
                      iv_keydate         = ms_parameter-keydate ).

        _excel_width( ).

        _excel_table_header( iv_keydate    = ms_parameter-keydate
                             iv_start_year = lv_start_year
                             iv_end_year   = lv_end_year ).

        IF lt_data IS NOT INITIAL.
          _get_additional_data_from_itab( it_data       = lt_data
                                          iv_keydate    = ms_parameter-keydate
                                          iv_start_year = lv_start_year
                                          iv_end_year   = lv_end_year ).
        ENDIF.

        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        " Data
        """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
        LOOP AT lt_data ASSIGNING <ls_data>.

          CLEAR:
            ls_data_agreement_1,
            ls_data_agreement_2,
            ls_data_rouclass_1,
            ls_data_rouclass_2,
            ls_data_total_1,
            ls_data_total_2.

          IF <ls_data>-realestatecontract = mc_temporary_recn.
            CLEAR <ls_data>-realestatecontract.

            " NW008 (+)
            IF <ls_data>-realestatecontractforapcp IS NOT INITIAL.
              <ls_data>-realestatecontract = <ls_data>-realestatecontractforapcp.
            ENDIF.
            " NW008 (+)
          ENDIF.

          IF ls_data_last-rouclass <> <ls_data>-rouclass.
            CLEAR lv_no.
          ENDIF.

          IF ls_data_last-agreementnumber <> <ls_data>-agreementnumber.

            lv_no += 1.

            LOOP AT lt_data_agreement_1 ASSIGNING FIELD-SYMBOL(<ls_data_agreement_1>).
              _excel_append_agreement_1( is_data = <ls_data_agreement_1> ).
            ENDLOOP.

            " NW001 (-)
*            LOOP AT lt_data_agreement_2 ASSIGNING FIELD-SYMBOL(<ls_data_agreement_2>).
*              _excel_append_agreement_2( is_data = <ls_data_agreement_2> ).
*            ENDLOOP.
            " NW001 (-)
            " NW001 (+)
            LOOP AT lt_data_agreement_2 ASSIGNING FIELD-SYMBOL(<ls_data_agreement_2>).
              DATA(lt_data_agreement_temp2) = lt_data.
              DELETE lt_data_agreement_temp2 WHERE agreementnumber <> <ls_data_agreement_2>-agreementnumber.
              DELETE lt_data_agreement_temp2 WHERE realestatecontract IS INITIAL.
              SORT lt_data_agreement_temp2 BY realestatecontract. "#EC CI_SORTLOOP
              DELETE ADJACENT DUPLICATES FROM lt_data_agreement_temp2 COMPARING agreementnumber realestatecontract.

              LOOP AT lt_data_agreement_temp2 INTO DATA(ls_data_agreement_temp2) WHERE getterminateamount IS NOT INITIAL.
                <ls_data_agreement_2>-terminateamount += get_terminateamount(
                    iv_companycode        = ls_data_agreement_temp2-companycode
                    iv_realestatecontract = ls_data_agreement_temp2-realestatecontract
                    iv_getfromdb          = space ).
              ENDLOOP.
              " NW001 (+)

              _excel_append_agreement_2( is_data = <ls_data_agreement_2> ).
            ENDLOOP.

            CLEAR:
              lt_data_agreement_1[],
              lt_data_agreement_2[].

          ENDIF.

          IF ls_data_last-rouclass <> <ls_data>-rouclass.
            " NW007 (+)
            _populate_amount_data_by_rou( CHANGING ct_data_rouclass_2 = lt_data_rouclass_2 ).
            " NW007 (+)

            LOOP AT lt_data_rouclass_1 ASSIGNING FIELD-SYMBOL(<ls_data_rouclass_1>).
              _excel_append_rouclass_1( is_data = <ls_data_rouclass_1> ).
            ENDLOOP.

            LOOP AT lt_data_rouclass_2 ASSIGNING FIELD-SYMBOL(<ls_data_rouclass_2>).
              _excel_append_rouclass_2( is_data = <ls_data_rouclass_2> ).
            ENDLOOP.

            CLEAR:
              lt_data_rouclass_1[],
              lt_data_rouclass_2[].

          ENDIF.

          <ls_data>-no = lv_no.

          " Sub Total and Total
          LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).

            " Amount
            IF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
               OR <ls_com_data>-name CP 'VALUEY*'
               OR <ls_com_data>-name  = 'LLLT1Y'
               OR <ls_com_data>-name  = 'LLBT1AND2Y'
               OR <ls_com_data>-name  = 'LLBT2AND5Y'
               OR <ls_com_data>-name  = 'LLBT5AND10Y'
               OR <ls_com_data>-name  = 'LLBT10AND15Y'
               OR <ls_com_data>-name  = 'LLGT15Y'
               OR <ls_com_data>-name  = 'TOTALLT'
               OR <ls_com_data>-name  = 'GLCURRENTPORTION'
               OR <ls_com_data>-name  = 'GLLONGTERM'
               OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
               OR <ls_com_data>-name  = 'DIFFLONGTERM'.

              ASSIGN COMPONENT <ls_com_data>-name
                     OF STRUCTURE <ls_data>
                     TO FIELD-SYMBOL(<lv_value>).
              IF sy-subrc <> 0.
                CONTINUE.
              ENDIF.

              ASSIGN COMPONENT <ls_com_data>-name
                     OF STRUCTURE ls_data_total_1
                     TO FIELD-SYMBOL(<lv_value_total>).
              IF sy-subrc = 0.
                <lv_value_total> = <lv_value>.
              ENDIF.

            ENDIF.

          ENDLOOP.

          ls_data_agreement_1 = ls_data_total_1.
          ls_data_agreement_2 = ls_data_total_1.
          ls_data_rouclass_1 = ls_data_total_1.
          ls_data_rouclass_2 = ls_data_total_1.
          ls_data_total_2 = ls_data_total_1.

          ls_data_agreement_1-typegroup       = <ls_data>-typegroup.
          ls_data_agreement_1-rouclass        = <ls_data>-rouclass.
          ls_data_agreement_1-agreementnumber = <ls_data>-agreementnumber.

          ls_data_agreement_2-rouclass        = <ls_data>-rouclass.
          ls_data_agreement_2-agreementnumber = <ls_data>-agreementnumber.

          ls_data_rouclass_1-typegroup   = <ls_data>-typegroup.
          ls_data_rouclass_1-rouclass    = <ls_data>-rouclass.
          ls_data_rouclass_1-companycode = <ls_data>-companycode.            " NW007 (+)

          ls_data_rouclass_2-rouclass    = <ls_data>-rouclass.
          ls_data_rouclass_2-companycode = <ls_data>-companycode.            " NW007 (+)

          ls_data_total_1-typegroup = <ls_data>-typegroup.

          COLLECT ls_data_agreement_1 INTO lt_data_agreement_1.
          COLLECT ls_data_agreement_2 INTO lt_data_agreement_2.
          COLLECT ls_data_rouclass_1 INTO lt_data_rouclass_1.
          COLLECT ls_data_rouclass_2 INTO lt_data_rouclass_2.
          COLLECT ls_data_total_1 INTO lt_data_total_1.
          COLLECT ls_data_total_2 INTO lt_data_total_2.

          _excel_append_data( is_data       = <ls_data>
                              iv_start_year = lv_start_year
                              iv_end_year   = lv_end_year ).

          ls_data_last = <ls_data>.

        ENDLOOP.

        " NW007 (+)
        _populate_amount_data_by_rou( CHANGING ct_data_rouclass_2 = lt_data_rouclass_2
                                               ct_data_total_2    = lt_data_total_2 ).
        " NW007 (+)

        LOOP AT lt_data_agreement_1 ASSIGNING <ls_data_agreement_1>.
          _excel_append_agreement_1( is_data = <ls_data_agreement_1> ).
        ENDLOOP.

        LOOP AT lt_data_agreement_2 ASSIGNING <ls_data_agreement_2>.
          _excel_append_agreement_2( is_data = <ls_data_agreement_2> ).
        ENDLOOP.

        LOOP AT lt_data_rouclass_1 ASSIGNING <ls_data_rouclass_1>.
          _excel_append_rouclass_1( is_data = <ls_data_rouclass_1> ).
        ENDLOOP.

        LOOP AT lt_data_rouclass_2 ASSIGNING <ls_data_rouclass_2>.
          _excel_append_rouclass_2( is_data = <ls_data_rouclass_2> ).
        ENDLOOP.

        LOOP AT lt_data_total_1 ASSIGNING FIELD-SYMBOL(<ls_data_total_1>).
          _excel_append_total_1( is_data = <ls_data_total_1> ).
        ENDLOOP.

        LOOP AT lt_data_total_2 ASSIGNING FIELD-SYMBOL(<ls_data_total_2>).
          _excel_append_total_2( is_data = <ls_data_total_2> ).
        ENDLOOP.

        DATA(lo_excel_writer) = CAST zif_excel_writer( NEW zcl_excel_writer_2007( ) ).

        DATA(lv_excel) = lo_excel_writer->write_file( ms_excel-excel ).

        " NW008 (+)
        " DDMMYYYY
        DATA(lv_filename_keydate)     = |{ keys[ 1 ]-%param-keydate+6(2) }{ keys[ 1 ]-%param-keydate+4(2) }{ keys[ 1 ]-%param-keydate+0(4) }|.

        " Company code without space
        DATA(lv_filename_companycode) = condense( keys[ 1 ]-%param-companycode ).
        " NW008 (+)

        APPEND VALUE #(
            %cid   = keys[ 1 ]-%cid
            %param = VALUE #(
                filecontent = lv_excel
                filename    = |ROU Outstanding Lease Liability_{ lv_filename_companycode }_{ lv_filename_keydate }.xlsx|
                mimetype    = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet' ) )
               TO result.

      CATCH cx_root INTO DATA(lx_root).
        lv_text = lx_root->get_text( ).

        LOOP AT keys ASSIGNING FIELD-SYMBOL(<ls_keys>).
          APPEND VALUE #( %cid = <ls_keys>-%cid ) TO failed-outleaseliabrep.

          APPEND VALUE #( %cid                        = <ls_keys>-%cid
                          %msg                        = new_message_with_text(
                                                            severity = if_abap_behv_message=>severity-error
                                                            text     = lv_text )
                          %element-companycode        = if_abap_behv=>mk-on
                          %element-realestatecontract = if_abap_behv=>mk-on
                          %element-agreementnumber    = if_abap_behv=>mk-on
                          %element-type               = if_abap_behv=>mk-on )
                 TO reported-outleaseliabrep.
        ENDLOOP.

    ENDTRY.
  ENDMETHOD.

  METHOD conv_month_2_duration.
    DATA lv_y TYPE i.
    DATA lv_m TYPE i.
    DATA lv_f TYPE f.

    CLEAR ev_duration.

    IF iv_month <= 0.
      RETURN.
    ENDIF.

    lv_f = iv_month.

    DATA(lv_a) = lv_f / '12.0'.
    lv_y = round( val  = lv_a
                  dec  = 0
                  mode = cl_abap_math=>round_down ).

    lv_m = iv_month MOD 12.

    IF lv_y IS NOT INITIAL.
      ev_duration = |{ lv_y NUMBER = RAW ALIGN = LEFT }Y|.
    ENDIF.

    IF lv_m IS NOT INITIAL.
      ev_duration = |{ ev_duration }{ lv_m NUMBER = RAW ALIGN = LEFT }M|.
    ENDIF.
  ENDMETHOD.

  METHOD format_date_out.
    CLEAR ev_out.

    IF iv_in IS INITIAL.
      RETURN.
    ENDIF.

    ev_out = |{ iv_in DATE = USER }|.
  ENDMETHOD.

  METHOD format_amount_out.
    CLEAR ev_out.

    IF iv_in IS INITIAL.
      RETURN.
    ENDIF.

    ev_out = |{ iv_in CURRENCY = iv_currency SIGN = LEFT NUMBER = USER }|.
  ENDMETHOD.

  METHOD format_rate_out.
    CLEAR ev_out.

    IF iv_in IS INITIAL.
      RETURN.
    ENDIF.

    ev_out = |{ iv_in SIGN = LEFT DECIMALS = 2 }%|.
  ENDMETHOD.

  METHOD format_quantity_out.
    " TODO: parameter IV_UNIT is only used in commented-out code (ABAP cleaner)

    CLEAR ev_out.

    IF iv_in IS INITIAL.
      RETURN.
    ENDIF.

    ev_out = |{ iv_in SIGN = LEFT NUMBER = USER }|.

*    zcl_ext_abap_utilities=>get_unitofmeasure(
*      EXPORTING
*        iv_unit          = iv_unit
*      IMPORTING
*        es_unitofmeasure = DATA(ls_unitofmeasure)
*    ).
*
*    ev_out = |{ iv_in SIGN = LEFT DECIMALS = ls_unitofmeasure-unitofmeasuredspnmbrofdcmls }|.
  ENDMETHOD.

  METHOD _excel_create_style.
    CONSTANTS:
      BEGIN OF lc_format_code,
        number     TYPE string VALUE '#,##0.00_);(#,##0.00)',
        percentage TYPE string VALUE '0.00%',
      END OF lc_format_code.

    " Excel Border Style
    ms_excel_border-dark = NEW zcl_excel_style_border( ).
    ms_excel_border-dark->border_color-rgb = zcl_excel_style_color=>c_black.
    ms_excel_border-dark->border_style = zcl_excel_style_border=>c_border_thin.

    ms_excel_border-light = NEW zcl_excel_style_border( ).
    ms_excel_border-light->border_color-rgb = zcl_excel_style_color=>c_gray.
    ms_excel_border-light->border_style = zcl_excel_style_border=>c_border_thin.

    " Excel Style
    ms_excel_style-title = ms_excel-excel->add_new_style( ).
    ms_excel_style-title->font->bold = abap_true.

    ms_excel_style-table_header_1 = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_header_1->borders->right = ms_excel_border-dark.
    ms_excel_style-table_header_1->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_header_1->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_header_1->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_header_1->alignment->wraptext   = abap_true.
    ms_excel_style-table_header_1->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_center.
    ms_excel_style-table_header_1->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-table_header_1->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-table_header_1->fill->fgcolor-rgb = 'FFC0E6F5'.

    ms_excel_style-table_header_2 = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_header_2->borders->right = ms_excel_border-dark.
    ms_excel_style-table_header_2->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_header_2->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_header_2->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_header_2->alignment->wraptext   = abap_true.
    ms_excel_style-table_header_2->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_center.
    ms_excel_style-table_header_2->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-table_header_2->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-table_header_2->fill->fgcolor-rgb = 'FFE5F5FB'.

    ms_excel_style-table_header_3 = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_header_3->borders->right = ms_excel_border-dark.
    ms_excel_style-table_header_3->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_header_3->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_header_3->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_header_3->alignment->wraptext   = abap_true.
    ms_excel_style-table_header_3->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_center.
    ms_excel_style-table_header_3->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-table_header_3->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-table_header_3->fill->fgcolor-rgb = 'FFF7C7AC'.

    ms_excel_style-table_header_4 = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_header_4->borders->right = ms_excel_border-dark.
    ms_excel_style-table_header_4->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_header_4->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_header_4->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_header_4->alignment->wraptext   = abap_true.
    ms_excel_style-table_header_4->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_center.
    ms_excel_style-table_header_4->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-table_header_4->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-table_header_4->fill->fgcolor-rgb = 'FFF1A983'.

    ms_excel_style-table_data_general_l = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_data_general_l->borders->right = ms_excel_border-dark.
    ms_excel_style-table_data_general_l->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_data_general_l->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_data_general_l->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_data_general_l->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_left.
    ms_excel_style-table_data_general_l->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.

    ms_excel_style-table_data_general_c = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_data_general_c->borders->right = ms_excel_border-dark.
    ms_excel_style-table_data_general_c->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_data_general_c->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_data_general_c->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_data_general_c->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_center.
    ms_excel_style-table_data_general_c->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.

    ms_excel_style-table_data_general_r = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_data_general_r->borders->right = ms_excel_border-dark.
    ms_excel_style-table_data_general_r->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_data_general_r->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_data_general_r->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_data_general_r->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-table_data_general_r->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.

    ms_excel_style-table_data_number = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_data_number->borders->right = ms_excel_border-dark.
    ms_excel_style-table_data_number->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_data_number->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_data_number->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_data_number->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-table_data_number->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-table_data_number->number_format->format_code = lc_format_code-number.

    ms_excel_style-table_data_number_2 = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_data_number_2->borders->right = ms_excel_border-dark.
    ms_excel_style-table_data_number_2->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_data_number_2->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_data_number_2->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_data_number_2->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-table_data_number_2->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-table_data_number_2->number_format->format_code = lc_format_code-number.
    ms_excel_style-table_data_number_2->font->color-rgb = zcl_excel_style_color=>c_red.

    ms_excel_style-table_data_percentage = ms_excel-excel->add_new_style( ).
    ms_excel_style-table_data_percentage->borders->right = ms_excel_border-dark.
    ms_excel_style-table_data_percentage->borders->down  = ms_excel_border-dark.
    ms_excel_style-table_data_percentage->borders->left  = ms_excel_border-dark.
    ms_excel_style-table_data_percentage->borders->top   = ms_excel_border-dark.
    ms_excel_style-table_data_percentage->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-table_data_percentage->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-table_data_percentage->number_format->format_code = lc_format_code-percentage.

    ms_excel_style-agreement_1_1 = ms_excel-excel->add_new_style( ).
*    ms_excel_style-agreement_1_1->borders->right = ms_excel_border-dark.
    ms_excel_style-agreement_1_1->borders->down = ms_excel_border-dark.
*    ms_excel_style-agreement_1_1->borders->left  = ms_excel_border-dark.
    ms_excel_style-agreement_1_1->borders->top  = ms_excel_border-dark.
    ms_excel_style-agreement_1_1->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_left.
    ms_excel_style-agreement_1_1->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-agreement_1_1->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-agreement_1_1->fill->fgcolor-rgb = 'FFCAEDFB'.

    ms_excel_style-agreement_1_2 = ms_excel-excel->add_new_style( ).
    ms_excel_style-agreement_1_2->borders->right = ms_excel_border-dark.
    ms_excel_style-agreement_1_2->borders->down  = ms_excel_border-dark.
    ms_excel_style-agreement_1_2->borders->left  = ms_excel_border-dark.
    ms_excel_style-agreement_1_2->borders->top   = ms_excel_border-dark.
    ms_excel_style-agreement_1_2->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-agreement_1_2->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-agreement_1_2->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-agreement_1_2->fill->fgcolor-rgb = 'FFCAEDFB'.
    ms_excel_style-agreement_1_2->number_format->format_code = lc_format_code-number.

    ms_excel_style-agreement_2_1 = ms_excel-excel->add_new_style( ).
*    ms_excel_style-agreement_2_1->borders->right = ms_excel_border-dark.
    ms_excel_style-agreement_2_1->borders->down = ms_excel_border-dark.
*    ms_excel_style-agreement_2_1->borders->left  = ms_excel_border-dark.
    ms_excel_style-agreement_2_1->borders->top  = ms_excel_border-dark.
    ms_excel_style-agreement_2_1->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_left.
    ms_excel_style-agreement_2_1->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-agreement_2_1->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-agreement_2_1->fill->fgcolor-rgb = 'FF94DCF8'.

    ms_excel_style-agreement_2_2 = ms_excel-excel->add_new_style( ).
    ms_excel_style-agreement_2_2->borders->right = ms_excel_border-dark.
    ms_excel_style-agreement_2_2->borders->down  = ms_excel_border-dark.
    ms_excel_style-agreement_2_2->borders->left  = ms_excel_border-dark.
    ms_excel_style-agreement_2_2->borders->top   = ms_excel_border-dark.
    ms_excel_style-agreement_2_2->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-agreement_2_2->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-agreement_2_2->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-agreement_2_2->fill->fgcolor-rgb = 'FF94DCF8'.
    ms_excel_style-agreement_2_2->number_format->format_code = lc_format_code-number.

    ms_excel_style-rouclass_1_1 = ms_excel-excel->add_new_style( ).
*    ms_excel_style-rouclass_1_1->borders->right = ms_excel_border-dark.
    ms_excel_style-rouclass_1_1->borders->down = ms_excel_border-dark.
*    ms_excel_style-rouclass_1_1->borders->left  = ms_excel_border-dark.
    ms_excel_style-rouclass_1_1->borders->top  = ms_excel_border-dark.
    ms_excel_style-rouclass_1_1->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_left.
    ms_excel_style-rouclass_1_1->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-rouclass_1_1->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-rouclass_1_1->fill->fgcolor-rgb = 'FFCAEDFB'.
    ms_excel_style-rouclass_1_1->font->bold = abap_true.

    ms_excel_style-rouclass_1_2 = ms_excel-excel->add_new_style( ).
    ms_excel_style-rouclass_1_2->borders->right = ms_excel_border-dark.
    ms_excel_style-rouclass_1_2->borders->down  = ms_excel_border-dark.
    ms_excel_style-rouclass_1_2->borders->left  = ms_excel_border-dark.
    ms_excel_style-rouclass_1_2->borders->top   = ms_excel_border-dark.
    ms_excel_style-rouclass_1_2->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-rouclass_1_2->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-rouclass_1_2->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-rouclass_1_2->fill->fgcolor-rgb = 'FFCAEDFB'.
    ms_excel_style-rouclass_1_2->font->bold = abap_true.
    ms_excel_style-rouclass_1_2->number_format->format_code = lc_format_code-number.

    ms_excel_style-rouclass_2_1 = ms_excel-excel->add_new_style( ).
*    ms_excel_style-rouclass_2_1->borders->right = ms_excel_border-dark.
    ms_excel_style-rouclass_2_1->borders->down = ms_excel_border-dark.
*    ms_excel_style-rouclass_2_1->borders->left  = ms_excel_border-dark.
    ms_excel_style-rouclass_2_1->borders->top  = ms_excel_border-dark.
    ms_excel_style-rouclass_2_1->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_left.
    ms_excel_style-rouclass_2_1->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-rouclass_2_1->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-rouclass_2_1->fill->fgcolor-rgb = 'FF94DCF8'.
    ms_excel_style-rouclass_2_1->font->bold = abap_true.

    ms_excel_style-rouclass_2_2 = ms_excel-excel->add_new_style( ).
    ms_excel_style-rouclass_2_2->borders->right = ms_excel_border-dark.
    ms_excel_style-rouclass_2_2->borders->down  = ms_excel_border-dark.
    ms_excel_style-rouclass_2_2->borders->left  = ms_excel_border-dark.
    ms_excel_style-rouclass_2_2->borders->top   = ms_excel_border-dark.
    ms_excel_style-rouclass_2_2->alignment->horizontal = zcl_excel_style_alignment=>c_horizontal_right.
    ms_excel_style-rouclass_2_2->alignment->vertical   = zcl_excel_style_alignment=>c_vertical_center.
    ms_excel_style-rouclass_2_2->fill->filltype = zcl_excel_style_fill=>c_fill_solid.
    ms_excel_style-rouclass_2_2->fill->fgcolor-rgb = 'FF94DCF8'.
    ms_excel_style-rouclass_2_2->font->bold = abap_true.
    ms_excel_style-rouclass_2_2->number_format->format_code = lc_format_code-number.

    ms_excel_style-total_1_1 = ms_excel_style-rouclass_1_1.

    ms_excel_style-total_1_2 = ms_excel_style-rouclass_1_2.

    ms_excel_style-total_2_1 = ms_excel_style-rouclass_2_1.

    ms_excel_style-total_2_2 = ms_excel_style-rouclass_2_2.
  ENDMETHOD.

  METHOD _excel_title.
    " Title 1
    ms_excel-row    += 1.
    ms_excel-column  = 1.

    ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                  ip_row    = ms_excel-row
                                  ip_value  = |Company Code: { iv_companycode } { iv_companycodename }|
                                  ip_style  = ms_excel_style-title ).

    " Title 2
    ms_excel-row    += 1.
    ms_excel-column  = 1.

    ms_excel-worksheet->set_cell(
        ip_column = ms_excel-column
        ip_row    = ms_excel-row
        ip_value  = |ROU Outstanding Lease Liability and Deferred Interest, As of Date: { iv_keydate DATE = USER }|
        ip_style  = ms_excel_style-title ).

    " Blank
    ms_excel-row    += 1.
    ms_excel-column  = 1.
  ENDMETHOD.

  METHOD _excel_width.
    DATA lv_excel_width TYPE p LENGTH 5 DECIMALS 2.
    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA lv_yy          TYPE n LENGTH 2.
    DATA lv_mm          TYPE n LENGTH 2.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      lv_excel_width = 10.

      " VALUEY__M__
      IF <ls_com_data>-name CP 'VALUEY*'.
        lv_yy = <ls_com_data>-name+6(2).

        TRY.
            lv_mm = <ls_com_data>-name+9(2).
          CATCH cx_root.
            CLEAR lv_mm.
        ENDTRY.

        IF lv_mm = '00'.
          lv_excel_width = 16.
        ELSE.
          lv_excel_width = 13.
        ENDIF.

      ELSEIF <ls_com_data>-name = 'ROUCLASS'.
*        lv_excel_width = 15.                                       " NW001 (+)
        lv_excel_width = 22.                                        " NW001 (+)
      ELSEIF <ls_com_data>-name = 'NO'.

      ELSEIF <ls_com_data>-name = 'TYPE'.

      ELSEIF <ls_com_data>-name = 'TYPEGROUP'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'AGREEMENTNUMBER'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'REALESTATECONTRACT'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'RECONTRACTTYPE'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'RECONTRACTTYPENAME'.             " NW003 (+)
        lv_excel_width = 30.                                        " NW003 (+)
      ELSEIF <ls_com_data>-name = 'RECONTRACTNAME'.
        lv_excel_width = 45.
      ELSEIF <ls_com_data>-name = 'VERSION'.

      ELSEIF <ls_com_data>-name = 'PONO'.
        lv_excel_width = 30.
      ELSEIF <ls_com_data>-name = 'FIXEDASSETEXTERNALID'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'RECONTRACTCURRENCY'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'COMPANYCODECURRENCY'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'ISVARYONSALES'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'ZZ1_EXTENSIONOPTION_REC'.
        lv_excel_width = 25.
      ELSEIF <ls_com_data>-name = 'ZZ1_RETIREOBLIGATION_REC'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'ZZ1_TERMINATEOPTION_REC'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'RECONTRACTNOTICEDATE'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'TERMINATEAMOUNT'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'PAYMENTMETHOD'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'INSTALLMENTFREQUENCY'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'ZZ1_INTERESTRATETYPE_REC'.
        lv_excel_width = 25.
      ELSEIF <ls_com_data>-name = 'REINTERESTRATE'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'ZZ1_PURCHASEOPTION_REC'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'ZZ1_GUARANTEERESIDUALV_REC'.
        lv_excel_width = 25.
      ELSEIF <ls_com_data>-name = 'REMEASUREMENTQUANTITY'.

      ELSEIF <ls_com_data>-name = 'REMEASUREMENTUNIT'.

      ELSEIF <ls_com_data>-name = 'BUSINESSPARTNERSUPPLIER'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'BUSINESSPARTNERSUPPLIERNAME'.
        lv_excel_width = 40.
      ELSEIF <ls_com_data>-name = 'TRADINGPARTNER'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'TRADINGPARTNERNAME'.
        lv_excel_width = 25.
      ELSEIF <ls_com_data>-name = 'ASSETACQUISITIONPOSTINGDATE'.
        lv_excel_width = 25.
      ELSEIF <ls_com_data>-name = 'ASSETMODIFICATIONPOSTINGDATE'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'TOTALINSTALLMENTNO'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'CURRENTAPINSTALLMENT'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'RECONTRACTSIGNDATE'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'CONTRACTSTARTDATE'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'RECONTRACTFIRSTENDDATE'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'CONTRACTENDDATE'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'CONTRACTDURATION'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'ACTUALDURATION'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'REMAININGDURATION'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'REMAININGPERIOD'.
        lv_excel_width = 20.
      ELSEIF <ls_com_data>-name = 'CONTRACTVALUE'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'NETLEASELIABILITY'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'INTEREST'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'ROUASSET'.
        lv_excel_width = 15.
      ELSEIF <ls_com_data>-name = 'EXCHANGERATE'.
        lv_excel_width = 25.
      ELSEIF <ls_com_data>-name = 'LLLT1Y'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'LLBT1AND2Y'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'LLBT2AND5Y'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'LLBT5AND10Y'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'LLBT10AND15Y'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'LLGT15Y'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'TOTALLT'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'GLCURRENTPORTION'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'GLLONGTERM'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'DIFFCURRENTPORTION'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'DIFFLONGTERM'.
        lv_excel_width = 16.
        " NW007 (+)
      ELSEIF <ls_com_data>-name = 'GLCURRENTPORTION_APCP_ROU'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'DIFFCURRENTPORTION_APCP_ROU'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'GLLONGTERM_LT_ROU'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name = 'DIFFLONGTERM_LT_ROU'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name CP 'GLCURRENTPORTION_ROUTP*'.
        lv_excel_width = 16.
      ELSEIF <ls_com_data>-name CP 'GLLONGTERM_ROUTP*'.
        lv_excel_width = 16.
        " NW007 (+)
      ENDIF.

      " Fix bug width
      lv_excel_width += '0.6'.

      ms_excel-worksheet->get_column( ip_column = ms_excel-column
      )->set_width( ip_width = lv_excel_width ).

    ENDLOOP.
  ENDMETHOD.

  METHOD _excel_table_header.
    " NW007 (+)
    DATA lv_tradingpartner TYPE zi_rtr_oll_acctdocitemrouandtp-tradingpartner.
    DATA lv_fieldname      TYPE c LENGTH 30.
    " NW007 (+)

    DATA lv_excel_value    TYPE c LENGTH 200.
    DATA lo_excel_style    TYPE REF TO zcl_excel_style.
    DATA lv_merge_row      TYPE i.
    DATA lv_merge_column   TYPE i.
    DATA lv_year           TYPE n LENGTH 4.
    DATA lv_yy             TYPE n LENGTH 2.
    DATA lv_mm             TYPE n LENGTH 2.

    " Table Header 1
    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      " VALUEY__M__
      IF <ls_com_data>-name CP 'VALUEY*'.
        lv_yy = <ls_com_data>-name+6(2).

        TRY.
            lv_mm = <ls_com_data>-name+9(2).
          CATCH cx_root.
            CLEAR lv_mm.
        ENDTRY.

        lv_year = iv_start_year + lv_yy.

        IF lv_year = iv_start_year.
          lv_excel_value = |<= Y{ lv_year }|.
        ELSEIF lv_year = iv_end_year.
          lv_excel_value = |>= Y{ lv_year }|.
        ELSE.
          lv_excel_value = |Y{ lv_year }|.
        ENDIF.

        IF lv_mm = '01'.
          lv_merge_row = 1.
          lv_merge_column = 13.
        ENDIF.

        lo_excel_style = ms_excel_style-table_header_1.

      ELSEIF <ls_com_data>-name = 'LLLT1Y'.
        lv_excel_value = |LL < 1 Y|.
        lo_excel_style = ms_excel_style-table_header_3.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'LLBT1AND2Y'.
        lv_excel_value = |LL 1-2 Y|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'LLBT2AND5Y'.
        lv_excel_value = |LL 2-5 Y|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'LLBT5AND10Y'.
        lv_excel_value = |LL 5-10 Y|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'LLBT10AND15Y'.
        lv_excel_value = |LL 10-15 Y|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'LLGT15Y'.
        lv_excel_value = |LL > 15 Y|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'TOTALLT'.
        lv_excel_value = |Total LT|.
        lo_excel_style = ms_excel_style-table_header_4.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'GLCURRENTPORTION'.
        lv_excel_value = |GL: Current Portion of Lease Liability|.
        lo_excel_style = ms_excel_style-table_header_3.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'GLLONGTERM'.
        lv_excel_value = |GL: Long Term of Lease Liability|.
        lo_excel_style = ms_excel_style-table_header_4.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'DIFFCURRENTPORTION'.
        lv_excel_value = |Diff Current Portion|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'DIFFLONGTERM'.
        lv_excel_value = |Diff Long Term|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
        " NW007 (+)
      ELSEIF <ls_com_data>-name = 'GLCURRENTPORTION_APCP_ROU'.
        lv_excel_value = |Total GL Current Portion of Lease Liability|.
        lo_excel_style = ms_excel_style-table_header_3.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'GLLONGTERM_LT_ROU'.
*        lv_excel_value = |Total Long Term of Lease Liability|.             " NW008 (-)
        lv_excel_value = |Total GL Long Term of Lease Liability|.           " NW008 (+)
        lo_excel_style = ms_excel_style-table_header_4.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'DIFFCURRENTPORTION_APCP_ROU'.
        lv_excel_value = |Diff Current Portion|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
      ELSEIF <ls_com_data>-name = 'DIFFLONGTERM_LT_ROU'.
        lv_excel_value = |Diff Long Term|.
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 3.
        lv_merge_column = 1.
        " NW007 (+)
      ENDIF.

      " Merge
      IF    lv_merge_row    IS NOT INITIAL
         OR lv_merge_column IS NOT INITIAL.

        ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                       ip_column_end   = ms_excel-column + lv_merge_column - 1
                                       ip_row          = ms_excel-row
                                       ip_row_to       = ms_excel-row + lv_merge_row - 1
                                       ip_style        = lo_excel_style
                                       ip_value        = lv_excel_value ).

      ELSE.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    " Table Header 1
    LOOP AT mt_tradingpartner INTO DATA(ls_tradingpartner).
      lv_tradingpartner = COND #( WHEN ls_tradingpartner-tradingpartner IS INITIAL
                                  THEN '0'
                                  ELSE ls_tradingpartner-tradingpartner ).
      lv_tradingpartner = condense( val = |{ lv_tradingpartner ALPHA = OUT }| ).

      DO 2 TIMES.
        CLEAR:
          lv_excel_value,
          lo_excel_style,
          lv_merge_row,
          lv_merge_column.

        lv_fieldname = SWITCH #( sy-index
                                 WHEN 1 THEN 'GLCURRENTPORTION_ROUTP'
                                 WHEN 2 THEN 'GLLONGTERM_ROUTP' ).

        lv_fieldname = |{ lv_fieldname }{ lv_tradingpartner }|.

        ASSIGN ms_excel-components_data[ name = lv_fieldname ] TO <ls_com_data> ELSE UNASSIGN.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        ms_excel-column = sy-tabix.

        IF ls_tradingpartner-tradingpartner IS INITIAL.
          lv_excel_value = |Non TP|.
          lo_excel_style = ms_excel_style-table_header_1.
          lv_merge_row = 1.
          lv_merge_column = 2.
        ELSE.
          lv_excel_value = |Trading Partner { lv_tradingpartner }|.
          lo_excel_style = ms_excel_style-table_header_1.
          lv_merge_row = 1.
          lv_merge_column = 2.
        ENDIF.

        " Merge
        IF    lv_merge_row    IS NOT INITIAL
           OR lv_merge_column IS NOT INITIAL.

          ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                         ip_column_end   = ms_excel-column + lv_merge_column - 1
                                         ip_row          = ms_excel-row
                                         ip_row_to       = ms_excel-row + lv_merge_row - 1
                                         ip_style        = lo_excel_style
                                         ip_value        = lv_excel_value ).

        ELSE.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = lv_excel_value
                                        ip_style  = lo_excel_style ).
        ENDIF.

        EXIT.
      ENDDO.
    ENDLOOP.
    " NW007 (+)

    " Table Header 2
    ms_excel-row    += 1.
    ms_excel-column  = 1.

    DATA(lv_cp_date) = xco_cp=>sy->date( )->overwrite( iv_year  = iv_keydate(4)
                                                       iv_month = iv_keydate+4(2)
                                                       iv_day   = iv_keydate+6(2)
    )->add( iv_month = 12
    )->as( io_format = xco_cp_time=>format->abap
    )->value.

    LOOP AT ms_excel-components_data ASSIGNING <ls_com_data>.
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      " VALUEY__M__
      IF <ls_com_data>-name CP 'VALUEY*'.
        lv_yy = <ls_com_data>-name+6(2).

        TRY.
            lv_mm = <ls_com_data>-name+9(2).
          CATCH cx_root.
            CLEAR lv_mm.
        ENDTRY.

        lv_year = iv_start_year + lv_yy.

        IF |{ lv_year }{ lv_mm }| <= lv_cp_date(6).
          lv_excel_value = |CP|.
        ELSE.
          lv_excel_value = |LT|.
        ENDIF.

        IF     lv_mm   = '00'
           AND lv_year = lv_cp_date(4).

          lv_excel_value = |CP / LT|.
        ENDIF.

        IF lv_mm = '00'.
          lo_excel_style = ms_excel_style-table_header_1.
        ELSE.
          lo_excel_style = ms_excel_style-table_header_2.
        ENDIF.
        " NW007 (+)

        " NW007 (+)
      ENDIF.

      IF lv_excel_value IS NOT INITIAL.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    " Table Header 2
    LOOP AT mt_tradingpartner INTO ls_tradingpartner.
      lv_tradingpartner = COND #( WHEN ls_tradingpartner-tradingpartner IS INITIAL
                                  THEN '0'
                                  ELSE ls_tradingpartner-tradingpartner ).
      lv_tradingpartner = condense( val = |{ lv_tradingpartner ALPHA = OUT }| ).

      DO 2 TIMES.
        CLEAR:
          lv_excel_value,
          lo_excel_style,
          lv_merge_row,
          lv_merge_column.

        lv_excel_value = SWITCH #( sy-index
                                   WHEN 1 THEN |GL: Current Portion of Lease Liability|
                                   WHEN 2 THEN |GL: Long Term of Lease Liability| ).
        lo_excel_style = ms_excel_style-table_header_1.
        lv_merge_row = 2.
        lv_merge_column = 1.

        lv_fieldname = SWITCH #( sy-index
                                 WHEN 1 THEN 'GLCURRENTPORTION_ROUTP'
                                 WHEN 2 THEN 'GLLONGTERM_ROUTP' ).

        lv_fieldname = |{ lv_fieldname }{ lv_tradingpartner }|.

        ASSIGN ms_excel-components_data[ name = lv_fieldname ] TO <ls_com_data> ELSE UNASSIGN.
        IF sy-subrc <> 0.
          CONTINUE.
        ENDIF.

        ms_excel-column = sy-tabix.

        " Merge
        IF    lv_merge_row    IS NOT INITIAL
           OR lv_merge_column IS NOT INITIAL.

          ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                         ip_column_end   = ms_excel-column + lv_merge_column - 1
                                         ip_row          = ms_excel-row
                                         ip_row_to       = ms_excel-row + lv_merge_row - 1
                                         ip_style        = lo_excel_style
                                         ip_value        = lv_excel_value ).

        ELSE.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = lv_excel_value
                                        ip_style  = lo_excel_style ).
        ENDIF.
      ENDDO.
    ENDLOOP.
    " NW007 (+)

    " Table Header 3
    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING <ls_com_data>.
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      " VALUEY__M__
      IF <ls_com_data>-name CP 'VALUEY*'.
        lv_yy = <ls_com_data>-name+6(2).

        TRY.
            lv_mm = <ls_com_data>-name+9(2).
          CATCH cx_root.
            CLEAR lv_mm.
        ENDTRY.

        lv_year = iv_start_year + lv_yy.

        IF lv_year = iv_start_year.
          lv_excel_value = |Before FY|.
        ELSE.
          CASE lv_mm.
            WHEN '00'.
              lv_excel_value = |Total Outstanding|.
            WHEN '01'.
              lv_excel_value = |Jan|.
            WHEN '02'.
              lv_excel_value = |Feb|.
            WHEN '03'.
              lv_excel_value = |Mar|.
            WHEN '04'.
              lv_excel_value = |Apr|.
            WHEN '05'.
              lv_excel_value = |May|.
            WHEN '06'.
              lv_excel_value = |Jun|.
            WHEN '07'.
              lv_excel_value = |Jul|.
            WHEN '08'.
              lv_excel_value = |Aug|.
            WHEN '09'.
              lv_excel_value = |Sep|.
            WHEN '10'.
              lv_excel_value = |Oct|.
            WHEN '11'.
              lv_excel_value = |Nov|.
            WHEN '12'.
              lv_excel_value = |Dec|.
          ENDCASE.
        ENDIF.

        IF lv_mm = '00'.
          lo_excel_style = ms_excel_style-table_header_1.
        ELSE.
          lo_excel_style = ms_excel_style-table_header_2.
        ENDIF.

      ELSEIF <ls_com_data>-name = 'ROUCLASS'.
        lv_excel_value = |ROU Class|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'NO'.
        lv_excel_value = |No.|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'TYPE'.
        lv_excel_value = |Type|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'TYPEGROUP'.
        lv_excel_value = |Type Group|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'AGREEMENTNUMBER'.
        lv_excel_value = |Agreement No.|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'REALESTATECONTRACT'.
        lv_excel_value = |Contract No.|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'RECONTRACTTYPE'.
        lv_excel_value = |Contract Type|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'RECONTRACTTYPENAME'.             " NW003 (+)
        lv_excel_value = |Contract Type Name|.                      " NW003 (+)
        lo_excel_style = ms_excel_style-table_header_1.             " NW003 (+)
      ELSEIF <ls_com_data>-name = 'RECONTRACTNAME'.
        lv_excel_value = |Contract Name|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'VERSION'.
        lv_excel_value = |Version|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'PONO'.
        lv_excel_value = |PO No.|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'FIXEDASSETEXTERNALID'.
        lv_excel_value = |Asset No.|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'RECONTRACTCURRENCY'.
        lv_excel_value = |Contract Currency|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'COMPANYCODECURRENCY'.
        lv_excel_value = |Company Code Currency|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ISVARYONSALES'.
        lv_excel_value = |Vary on Sale or Usage ?|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ZZ1_EXTENSIONOPTION_REC'.
        lv_excel_value = |Potential Extension Option|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ZZ1_RETIREOBLIGATION_REC'.
        lv_excel_value = |Retirement Obligation|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ZZ1_TERMINATEOPTION_REC'.
        lv_excel_value = |Terminate Option|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'RECONTRACTNOTICEDATE'.
        lv_excel_value = |Terminate Date|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'TERMINATEAMOUNT'.
        lv_excel_value = |Terminate Amount|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'PAYMENTMETHOD'.
        lv_excel_value = |Payment Method|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'INSTALLMENTFREQUENCY'.
        lv_excel_value = |Installment Frequency|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ZZ1_INTERESTRATETYPE_REC'.
        lv_excel_value = |Interest Type|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'REINTERESTRATE'.
        lv_excel_value = |Interest Rate|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ZZ1_PURCHASEOPTION_REC'.
        lv_excel_value = |Purchase Option|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ZZ1_GUARANTEERESIDUALV_REC'.
        lv_excel_value = |Guarantee Residual Value|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'REMEASUREMENTQUANTITY'.
        lv_excel_value = |Qty|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'REMEASUREMENTUNIT'.
        lv_excel_value = |UoM|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'BUSINESSPARTNERSUPPLIER'.
        lv_excel_value = |Vendor Code|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'BUSINESSPARTNERSUPPLIERNAME'.
        lv_excel_value = |Vendor Name|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'TRADINGPARTNER'.
        lv_excel_value = |Trading Partner no.|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'TRADINGPARTNERNAME'.
        lv_excel_value = |Trading Partner name|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ASSETACQUISITIONPOSTINGDATE'.
        lv_excel_value = |Asset Acquisition Posting Date|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ASSETMODIFICATIONPOSTINGDATE'.
        lv_excel_value = |Asset Modification Date|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'TOTALINSTALLMENTNO'.
        lv_excel_value = |No. of Installment|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'CURRENTAPINSTALLMENT'.
        lv_excel_value = |Current AP Installment|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'RECONTRACTSIGNDATE'.
        lv_excel_value = |Contract Conclusion|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'CONTRACTSTARTDATE'.
        lv_excel_value = |Contract Start|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'RECONTRACTFIRSTENDDATE'.
        lv_excel_value = |Contract End|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'CONTRACTENDDATE'.
        lv_excel_value = |End of Term|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'CONTRACTDURATION'.
        lv_excel_value = |Contract duration|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ACTUALDURATION'.
        lv_excel_value = |Actual duration|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'REMAININGDURATION'.
        lv_excel_value = |Remaining Y/M|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'REMAININGPERIOD'.
        lv_excel_value = |Remaining Period|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'CONTRACTVALUE'.
        lv_excel_value = |Contract Value|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'NETLEASELIABILITY'.
        lv_excel_value = |Net Lease Liability|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'INTEREST'.
        lv_excel_value = |Interest|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'ROUASSET'.
        lv_excel_value = |ROU Asset|.
        lo_excel_style = ms_excel_style-table_header_1.
      ELSEIF <ls_com_data>-name = 'EXCHANGERATE'.
        lv_excel_value = |LC1 Historical Exchange Rate|.
        lo_excel_style = ms_excel_style-table_header_1.
      ENDIF.

      IF lv_excel_value IS NOT INITIAL.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD _excel_append_data.
    " TODO: parameter IV_END_YEAR is never used (ABAP cleaner)

    DATA lv_excel_value    TYPE c LENGTH 200.
    DATA lo_excel_style    TYPE REF TO zcl_excel_style.
    DATA lv_year           TYPE n LENGTH 4.
    DATA lv_yy             TYPE n LENGTH 2.
    DATA lv_mm             TYPE n LENGTH 2.
    DATA lv_display_zero_1 TYPE abap_bool.
    DATA lv_display_zero_2 TYPE abap_bool.
    DATA lv_type_dfi       TYPE abap_bool.
    DATA lv_type_apcp      TYPE abap_bool.

    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      CLEAR lv_excel_value.

      ms_excel-column = sy-tabix.

      ASSIGN COMPONENT <ls_com_data>-name
             OF STRUCTURE is_data
             TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF <ls_com_data>-name = 'TYPE'.
        IF <lv_value> = 'D'.        " Is DFI ?
          lv_type_dfi = abap_true.
        ELSEIF <lv_value> = 'A'.    " Is AP-CP ?
          lv_type_apcp = abap_true.
        ENDIF.
      ENDIF.

      CASE <ls_com_data>-type->type_kind.
        WHEN cl_abap_typedescr=>typekind_date.
          format_date_out( EXPORTING iv_in  = <lv_value>
                           IMPORTING ev_out = lv_excel_value ).
          lo_excel_style = ms_excel_style-table_data_general_c.
        WHEN cl_abap_typedescr=>typekind_packed.

          IF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
             OR <ls_com_data>-name  = 'CONTRACTVALUE'
             OR <ls_com_data>-name  = 'NETLEASELIABILITY'
             OR <ls_com_data>-name  = 'INTEREST'
             OR <ls_com_data>-name  = 'ROUASSET'
             OR <ls_com_data>-name CP 'VALUEY*'
             OR <ls_com_data>-name  = 'LLLT1Y'
             OR <ls_com_data>-name  = 'LLBT1AND2Y'
             OR <ls_com_data>-name  = 'LLBT2AND5Y'
             OR <ls_com_data>-name  = 'LLBT5AND10Y'
             OR <ls_com_data>-name  = 'LLBT10AND15Y'
             OR <ls_com_data>-name  = 'LLGT15Y'
             OR <ls_com_data>-name  = 'TOTALLT'
             OR <ls_com_data>-name  = 'GLCURRENTPORTION'
             OR <ls_com_data>-name  = 'GLLONGTERM'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
             OR <ls_com_data>-name  = 'DIFFLONGTERM'
             " NW007 (+)
             OR <ls_com_data>-name  = 'GLCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'GLLONGTERM_LT_ROU'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'.
            " NW007 (+)

            lo_excel_style = ms_excel_style-table_data_number.

            " Display zero amount when column EI or EP has value
            IF    <ls_com_data>-name = 'LLLT1Y'
               OR <ls_com_data>-name = 'GLCURRENTPORTION'.
              IF <lv_value> IS NOT INITIAL.
                lv_display_zero_1 = abap_true.
              ENDIF.
            ENDIF.

            " Display zero amount when column EO or EQ has value
            IF    <ls_com_data>-name = 'TOTALLT'
               OR <ls_com_data>-name = 'GLLONGTERM'.
              IF <lv_value> IS NOT INITIAL.
                lv_display_zero_2 = abap_true.
              ENDIF.
            ENDIF.

            IF     <ls_com_data>-name CP 'VALUEY*'
               AND is_data-type        = gc_type-apcp
               AND <lv_value>         IS NOT INITIAL.

              lv_yy = <ls_com_data>-name+6(2).

              TRY.
                  lv_mm = <ls_com_data>-name+9(2).
                CATCH cx_root.
                  CLEAR lv_mm.
              ENDTRY.

              lv_year = iv_start_year + lv_yy.

              DATA(ls_apcp) = get_apcp( iv_companycode      = ms_parameter-companycode
                                        iv_agreementnumber  = is_data-agreementnumber
                                        iv_calculationyear  = lv_year
                                        iv_calculationmonth = lv_mm
                                        iv_getfromdb        = space ).

              IF ls_apcp-isapinvoice = abap_true.
                lo_excel_style = ms_excel_style-table_data_number_2.
              ENDIF.

            ENDIF.

            IF <lv_value> IS NOT INITIAL.
              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = <lv_value>
                                            ip_style  = lo_excel_style ).
            ELSE.
*              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
*                                            ip_row    = ms_excel-row
*                                            ip_value  = ''
*                                            ip_style  = lo_excel_style ).

              IF <ls_com_data>-name = 'DIFFCURRENTPORTION'.
                IF     lv_display_zero_1 IS NOT INITIAL
                   AND lv_type_dfi       IS INITIAL.
                  ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                                ip_row    = ms_excel-row
                                                ip_value  = '0.00'
                                                ip_style  = lo_excel_style ).
                ELSE.
                  ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                                ip_row    = ms_excel-row
                                                ip_value  = ''
                                                ip_style  = lo_excel_style ).
                ENDIF.
              ELSEIF <ls_com_data>-name = 'DIFFLONGTERM'.
                IF     lv_display_zero_2 IS NOT INITIAL
                   AND lv_type_dfi       IS INITIAL.
                  ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                                ip_row    = ms_excel-row
                                                ip_value  = '0.00'
                                                ip_style  = lo_excel_style ).
                ELSE.
                  ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                                ip_row    = ms_excel-row
                                                ip_value  = ''
                                                ip_style  = lo_excel_style ).
                ENDIF.
              ELSE.
                ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                              ip_row    = ms_excel-row
                                              ip_value  = ''
                                              ip_style  = lo_excel_style ).
              ENDIF.
            ENDIF.

            CONTINUE.

          ELSEIF <ls_com_data>-name = 'REINTERESTRATE'.

            format_rate_out( EXPORTING iv_in  = <lv_value>
                             IMPORTING ev_out = lv_excel_value ).
            lo_excel_style = ms_excel_style-table_data_percentage.

          ELSEIF    <ls_com_data>-name = 'REMEASUREMENTQUANTITY'
                 OR <ls_com_data>-name = 'EXCHANGERATE'.

            lo_excel_style = ms_excel_style-table_data_general_r.

            IF <lv_value> IS NOT INITIAL.
              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = <lv_value>
                                            ip_style  = lo_excel_style ).
            ELSE.
              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = ''
                                            ip_style  = lo_excel_style ).
            ENDIF.

            CONTINUE.

          ELSEIF     <ls_com_data>-name  = 'REMAININGPERIOD'
                 AND lv_type_apcp       IS NOT INITIAL.

            lo_excel_style = ms_excel_style-table_data_general_r.

            IF <lv_value> IS NOT INITIAL.
              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = <lv_value>
                                            ip_style  = lo_excel_style ).
            ELSE.
              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = ''
                                            ip_style  = lo_excel_style ).
            ENDIF.

            CONTINUE.

          ELSE.
            lv_excel_value = |{ <lv_value> }|.
            lo_excel_style = ms_excel_style-table_data_general_r.
          ENDIF.

        WHEN cl_abap_typedescr=>typekind_int.

          IF <ls_com_data>-name = 'VERSION'.

            lo_excel_style = ms_excel_style-table_data_general_r.

            IF <lv_value> IS NOT INITIAL.
              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = <lv_value>
                                            ip_style  = lo_excel_style ).
            ELSE.
              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = ''
                                            ip_style  = lo_excel_style ).
            ENDIF.

            CONTINUE.

          ELSE.
            lv_excel_value = |{ <lv_value> }|.
            lo_excel_style = ms_excel_style-table_data_general_r.
          ENDIF.

        WHEN cl_abap_typedescr=>typekind_num.

          IF <ls_com_data>-name = 'PAYMENTMETHOD'.

            " NW002(-)
*            lv_excel_value = get_paymentmethodtext(
*              EXPORTING
*                iv_paymentmethod = <lv_value>
*                iv_language = mv_language
*            ).
*
*            lo_excel_style = ms_excel_style-table_data_general_l.
            " NW002 (-)

          ELSEIF    <ls_com_data>-name = 'TOTALINSTALLMENTNO'
                 OR <ls_com_data>-name = 'CURRENTAPINSTALLMENT'.

            IF <lv_value> IS NOT INITIAL.
              lv_excel_value = |{ <lv_value> ALPHA = OUT }|.
            ENDIF.

            lo_excel_style = ms_excel_style-table_data_general_r.

          ELSE.
            lv_excel_value = |{ <lv_value> ALPHA = OUT }|.
            lo_excel_style = ms_excel_style-table_data_general_l.

          ENDIF.

        WHEN OTHERS.

          IF    <ls_com_data>-name = 'ISVARYONSALES'
             OR <ls_com_data>-name = 'ZZ1_EXTENSIONOPTION_REC'
             OR <ls_com_data>-name = 'ZZ1_RETIREOBLIGATION_REC'
             OR <ls_com_data>-name = 'ZZ1_TERMINATEOPTION_REC'.

            format_boolean_out( EXPORTING iv_in  = <lv_value>
                                IMPORTING ev_out = lv_excel_value ).
            lo_excel_style = ms_excel_style-table_data_general_c.

          ELSEIF <ls_com_data>-name = 'ZZ1_PURCHASEOPTION_REC'.

            DATA(ls_recondition) = get_recondition( iv_companycode        = ms_parameter-companycode
                                                    iv_realestatecontract = is_data-realestatecontract
                                                    iv_reconditiontype    = 'Z300'
                                                    iv_getfromdb          = space ).

            IF     <lv_value>                  = abap_true
               AND ls_recondition-reunitprice IS NOT INITIAL.

              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = ls_recondition-reunitprice
                                            ip_style  = lo_excel_style ).
              lo_excel_style = ms_excel_style-table_data_general_r.

              CONTINUE.

            ENDIF.

            format_boolean_out( EXPORTING iv_in  = <lv_value>
                                IMPORTING ev_out = lv_excel_value ).
            lo_excel_style = ms_excel_style-table_data_general_c.

          ELSEIF <ls_com_data>-name = 'ZZ1_GUARANTEERESIDUALV_REC'.

            ls_recondition = get_recondition( iv_companycode        = ms_parameter-companycode
                                              iv_realestatecontract = is_data-realestatecontract
                                              iv_reconditiontype    = 'Z310'
                                              iv_getfromdb          = space ).

            IF     <lv_value>                  = abap_true
               AND ls_recondition-reunitprice IS NOT INITIAL.

              ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                            ip_row    = ms_excel-row
                                            ip_value  = ls_recondition-reunitprice
                                            ip_style  = lo_excel_style ).
              lo_excel_style = ms_excel_style-table_data_general_r.

              CONTINUE.

            ENDIF.

            format_boolean_out( EXPORTING iv_in  = <lv_value>
                                IMPORTING ev_out = lv_excel_value ).
            lo_excel_style = ms_excel_style-table_data_general_c.

          ELSEIF <ls_com_data>-name = 'ROUCLASS'.
            lv_excel_value = get_rouclasstext( iv_rouclass = <lv_value>
                                               iv_language = mv_language ).

            lo_excel_style = ms_excel_style-table_data_general_l.

          ELSEIF <ls_com_data>-name = 'TYPE'.
            lv_excel_value = get_typetext( iv_type     = <lv_value>
                                           iv_language = mv_language ).

            lo_excel_style = ms_excel_style-table_data_general_l.

          ELSEIF <ls_com_data>-name = 'TYPEGROUP'.
            lv_excel_value = get_typegrouptext( iv_typegroup = <lv_value>
                                                iv_language  = mv_language ).

            lo_excel_style = ms_excel_style-table_data_general_l.

          ELSEIF <ls_com_data>-name = 'INSTALLMENTFREQUENCY'.

            " NW005 (-)
*            lv_excel_value = get_installmentfreqtext( iv_installmentfrequency = <lv_value>
*                                                      iv_language             = mv_language ).
            " NW005 (-)
            " NW005 (+)
            ASSIGN COMPONENT 'INSTALLMENTFREQUENCYISFOUND' OF STRUCTURE is_data TO FIELD-SYMBOL(<lv_installmentfreqisfound>) ELSE UNASSIGN.
            IF <lv_installmentfreqisfound> IS ASSIGNED.
              IF <lv_installmentfreqisfound> IS NOT INITIAL.
                lv_excel_value = get_installmentfreqtext( iv_installmentfrequency = <lv_value>
                                                          iv_language             = mv_language ).
              ENDIF.
            ENDIF.
            " NW005 (+)

*            ASSIGN COMPONENT 'TYPE' OF STRUCTURE is_data TO FIELD-SYMBOL(<lv_value_type>) ELSE UNASSIGN.
*            IF <lv_value_type> IS ASSIGNED.
*              IF <lv_value_type> <> gc_type-apcp.
*                lv_excel_value = get_installmentfreqtext( iv_installmentfrequency = <lv_value>
*                                                          iv_language             = mv_language ).
*              ELSE.
*                CLEAR lv_excel_value.
*              ENDIF.
*            ENDIF.

            lo_excel_style = ms_excel_style-table_data_general_l.

          ELSEIF <ls_com_data>-name = 'ZZ1_INTERESTRATETYPE_REC'.
            lv_excel_value = get_interestratetype_rectext( iv_code     = <lv_value>
                                                           iv_language = mv_language ).

            lo_excel_style = ms_excel_style-table_data_general_l.

          ELSEIF <ls_com_data>-name = 'BUSINESSPARTNERSUPPLIER'.

            lv_excel_value = |{ <lv_value> ALPHA = OUT }|.
            lo_excel_style = ms_excel_style-table_data_general_l.

            " NW002(+)
          ELSEIF <ls_com_data>-name = 'PAYMENTMETHOD'.
            lv_excel_value = get_paymentmethodtext( iv_paymentmethod = <lv_value>
                                                    iv_language      = mv_language ).

            lo_excel_style = ms_excel_style-table_data_general_l.
            " NW002 (+)

          ELSE.
            lv_excel_value = |{ <lv_value> }|.
            lo_excel_style = ms_excel_style-table_data_general_l.
          ENDIF.

      ENDCASE.

      ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                    ip_row    = ms_excel-row
                                    ip_value  = lv_excel_value
                                    ip_style  = lo_excel_style ).

    ENDLOOP.

    " NW007 (+)
    _set_style_for_routp( iv_method_name = '_EXCEL_APPEND_DATA' ).
    " NW007 (+)
  ENDMETHOD.

  METHOD _excel_append_agreement_1.
    DATA lv_excel_value  TYPE c LENGTH 200.
    DATA lo_excel_style  TYPE REF TO zcl_excel_style.
    DATA lv_merge_row    TYPE i.
    DATA lv_merge_column TYPE i.

    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      ASSIGN COMPONENT <ls_com_data>-name
             OF STRUCTURE is_data
             TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF ms_excel-column = 1.
        DATA(lv_typegrouptext) = get_typegrouptext( iv_typegroup = is_data-typegroup
                                                    iv_language  = mv_language ).

        lv_excel_value = |*Total { lv_typegrouptext } { is_data-agreementnumber }|.
        lo_excel_style = ms_excel_style-agreement_1_1.
*        lv_merge_row = 1.
*        lv_merge_column = line_index( ms_excel-components_data[ name = 'VALUEY00' ] ) - 1.

      ELSEIF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
             OR <ls_com_data>-name CP 'VALUEY*'
             OR <ls_com_data>-name  = 'LLLT1Y'
             OR <ls_com_data>-name  = 'LLBT1AND2Y'
             OR <ls_com_data>-name  = 'LLBT2AND5Y'
             OR <ls_com_data>-name  = 'LLBT5AND10Y'
             OR <ls_com_data>-name  = 'LLBT10AND15Y'
             OR <ls_com_data>-name  = 'LLGT15Y'
             OR <ls_com_data>-name  = 'TOTALLT'
             OR <ls_com_data>-name  = 'GLCURRENTPORTION'
             OR <ls_com_data>-name  = 'GLLONGTERM'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
             OR <ls_com_data>-name  = 'DIFFLONGTERM'
             " NW007 (+)
             OR <ls_com_data>-name  = 'GLCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'GLLONGTERM_LT_ROU'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'.
        " NW007 (+)

        lo_excel_style = ms_excel_style-agreement_1_2.

        IF <lv_value> IS NOT INITIAL.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = <lv_value>
                                        ip_style  = lo_excel_style ).
        ELSE.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = ''
                                        ip_style  = lo_excel_style ).
        ENDIF.

        CONTINUE.

      ELSEIF ms_excel-column < line_index( ms_excel-components_data[ name = 'VALUEY00' ] ).

        lo_excel_style = ms_excel_style-agreement_1_1.

      ELSE.
        CONTINUE.

      ENDIF.

      " Merge
      IF    lv_merge_row    IS NOT INITIAL
         OR lv_merge_column IS NOT INITIAL.

        ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                       ip_column_end   = ms_excel-column + lv_merge_column - 1
                                       ip_row          = ms_excel-row
                                       ip_row_to       = ms_excel-row + lv_merge_row - 1
                                       ip_style        = lo_excel_style
                                       ip_value        = lv_excel_value ).

      ELSE.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    _set_style_for_routp( iv_method_name = '_EXCEL_APPEND_AGREEMENT_1' ).
    " NW007 (+)
  ENDMETHOD.

  METHOD _excel_append_agreement_2.
    DATA lv_excel_value  TYPE c LENGTH 200.
    DATA lo_excel_style  TYPE REF TO zcl_excel_style.
    DATA lv_merge_row    TYPE i.
    DATA lv_merge_column TYPE i.

    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      ASSIGN COMPONENT <ls_com_data>-name
             OF STRUCTURE is_data
             TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF ms_excel-column = 1.

        lv_excel_value = |*Total Net Lease Liability { is_data-agreementnumber }|.
        lo_excel_style = ms_excel_style-agreement_2_1.
*        lv_merge_row = 1.
*        lv_merge_column = line_index( ms_excel-components_data[ name = 'VALUEY00' ] ) - 1.

      ELSEIF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
             OR <ls_com_data>-name CP 'VALUEY*'
             OR <ls_com_data>-name  = 'LLLT1Y'
             OR <ls_com_data>-name  = 'LLBT1AND2Y'
             OR <ls_com_data>-name  = 'LLBT2AND5Y'
             OR <ls_com_data>-name  = 'LLBT5AND10Y'
             OR <ls_com_data>-name  = 'LLBT10AND15Y'
             OR <ls_com_data>-name  = 'LLGT15Y'
             OR <ls_com_data>-name  = 'TOTALLT'
             OR <ls_com_data>-name  = 'GLCURRENTPORTION'
             OR <ls_com_data>-name  = 'GLLONGTERM'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
             OR <ls_com_data>-name  = 'DIFFLONGTERM'
             " NW007 (+)
             OR <ls_com_data>-name  = 'GLCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'GLLONGTERM_LT_ROU'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'.
        " NW007 (+)

        lo_excel_style = ms_excel_style-agreement_2_2.

        IF <lv_value> IS NOT INITIAL.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = <lv_value>
                                        ip_style  = lo_excel_style ).
        ELSE.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = ''
                                        ip_style  = lo_excel_style ).
        ENDIF.

        CONTINUE.

      ELSEIF ms_excel-column < line_index( ms_excel-components_data[ name = 'VALUEY00' ] ).

        lo_excel_style = ms_excel_style-agreement_2_1.

      ELSE.
        CONTINUE.

      ENDIF.

      " Merge
      IF    lv_merge_row    IS NOT INITIAL
         OR lv_merge_column IS NOT INITIAL.

        ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                       ip_column_end   = ms_excel-column + lv_merge_column - 1
                                       ip_row          = ms_excel-row
                                       ip_row_to       = ms_excel-row + lv_merge_row - 1
                                       ip_style        = lo_excel_style
                                       ip_value        = lv_excel_value ).

      ELSE.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    _set_style_for_routp( iv_method_name = '_EXCEL_APPEND_AGREEMENT_2' ).
    " NW007 (+)
  ENDMETHOD.

  METHOD _excel_append_rouclass_1.
    DATA lv_excel_value  TYPE c LENGTH 200.
    DATA lo_excel_style  TYPE REF TO zcl_excel_style.
    DATA lv_merge_row    TYPE i.
    DATA lv_merge_column TYPE i.

    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      ASSIGN COMPONENT <ls_com_data>-name
             OF STRUCTURE is_data
             TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF ms_excel-column = 1.
        DATA(lv_rouclasstext) = get_rouclasstext( iv_rouclass = is_data-rouclass
                                                  iv_language = mv_language ).

        DATA(lv_typegrouptext) = get_typegrouptext( iv_typegroup = is_data-typegroup
                                                    iv_language  = mv_language ).

        lv_excel_value = |**Total { lv_typegrouptext } { lv_rouclasstext }|.
        lo_excel_style = ms_excel_style-rouclass_1_1.
*        lv_merge_row = 1.
*        lv_merge_column = line_index( ms_excel-components_data[ name = 'VALUEY00' ] ) - 1.

      ELSEIF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
             OR <ls_com_data>-name CP 'VALUEY*'
             OR <ls_com_data>-name  = 'LLLT1Y'
             OR <ls_com_data>-name  = 'LLBT1AND2Y'
             OR <ls_com_data>-name  = 'LLBT2AND5Y'
             OR <ls_com_data>-name  = 'LLBT5AND10Y'
             OR <ls_com_data>-name  = 'LLBT10AND15Y'
             OR <ls_com_data>-name  = 'LLGT15Y'
             OR <ls_com_data>-name  = 'TOTALLT'
             OR <ls_com_data>-name  = 'GLCURRENTPORTION'
             OR <ls_com_data>-name  = 'GLLONGTERM'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
             OR <ls_com_data>-name  = 'DIFFLONGTERM'
             " NW007 (+)
             OR <ls_com_data>-name  = 'GLCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'GLLONGTERM_LT_ROU'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'.
        " NW007 (+)

        lo_excel_style = ms_excel_style-rouclass_1_2.

        IF <lv_value> IS NOT INITIAL.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = <lv_value>
                                        ip_style  = lo_excel_style ).
        ELSE.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = ''
                                        ip_style  = lo_excel_style ).
        ENDIF.

        CONTINUE.

      ELSEIF ms_excel-column < line_index( ms_excel-components_data[ name = 'VALUEY00' ] ).

        lo_excel_style = ms_excel_style-rouclass_1_1.

      ELSE.
        CONTINUE.

      ENDIF.

      " Merge
      IF    lv_merge_row    IS NOT INITIAL
         OR lv_merge_column IS NOT INITIAL.

        ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                       ip_column_end   = ms_excel-column + lv_merge_column - 1
                                       ip_row          = ms_excel-row
                                       ip_row_to       = ms_excel-row + lv_merge_row - 1
                                       ip_style        = lo_excel_style
                                       ip_value        = lv_excel_value ).

      ELSE.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    _set_style_for_routp( iv_method_name = '_EXCEL_APPEND_ROUCLASS_1' ).
    " NW007 (+)
  ENDMETHOD.

  METHOD _excel_append_rouclass_2.
    DATA lv_excel_value  TYPE c LENGTH 200.
    DATA lo_excel_style  TYPE REF TO zcl_excel_style.
    DATA lv_merge_row    TYPE i.
    DATA lv_merge_column TYPE i.

    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      ASSIGN COMPONENT <ls_com_data>-name
             OF STRUCTURE is_data
             TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF ms_excel-column = 1.
        DATA(lv_rouclasstext) = get_rouclasstext( iv_rouclass = is_data-rouclass
                                                  iv_language = mv_language ).

        lv_excel_value = |**Total Net Lease Liability { lv_rouclasstext }|.
        lo_excel_style = ms_excel_style-rouclass_2_1.
*        lv_merge_row = 1.
*        lv_merge_column = line_index( ms_excel-components_data[ name = 'VALUEY00' ] ) - 1.

      ELSEIF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
             OR <ls_com_data>-name CP 'VALUEY*'
             OR <ls_com_data>-name  = 'LLLT1Y'
             OR <ls_com_data>-name  = 'LLBT1AND2Y'
             OR <ls_com_data>-name  = 'LLBT2AND5Y'
             OR <ls_com_data>-name  = 'LLBT5AND10Y'
             OR <ls_com_data>-name  = 'LLBT10AND15Y'
             OR <ls_com_data>-name  = 'LLGT15Y'
             OR <ls_com_data>-name  = 'TOTALLT'
             OR <ls_com_data>-name  = 'GLCURRENTPORTION'
             OR <ls_com_data>-name  = 'GLLONGTERM'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
             OR <ls_com_data>-name  = 'DIFFLONGTERM'
             " NW007 (+)
             OR <ls_com_data>-name  = 'GLCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'GLLONGTERM_LT_ROU'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'.
        " NW007 (+)

        lo_excel_style = ms_excel_style-rouclass_2_2.

        IF <lv_value> IS NOT INITIAL.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = <lv_value>
                                        ip_style  = lo_excel_style ).
        ELSE.
          " NW008 (+)
          IF    <ls_com_data>-name = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name = 'DIFFLONGTERM_LT_ROU'.
            ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                          ip_row    = ms_excel-row
                                          ip_value  = '0.00'
                                          ip_style  = lo_excel_style ).
          ELSE.
            " NW008 (+)
            ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                          ip_row    = ms_excel-row
                                          ip_value  = ''
                                          ip_style  = lo_excel_style ).
            " NW008 (+)
          ENDIF.
          " NW008 (+)
        ENDIF.

        CONTINUE.

      ELSEIF ms_excel-column < line_index( ms_excel-components_data[ name = 'VALUEY00' ] ).

        lo_excel_style = ms_excel_style-rouclass_2_1.

      ELSE.
        CONTINUE.

      ENDIF.

      " Merge
      IF    lv_merge_row    IS NOT INITIAL
         OR lv_merge_column IS NOT INITIAL.

        ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                       ip_column_end   = ms_excel-column + lv_merge_column - 1
                                       ip_row          = ms_excel-row
                                       ip_row_to       = ms_excel-row + lv_merge_row - 1
                                       ip_style        = lo_excel_style
                                       ip_value        = lv_excel_value ).

      ELSE.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    _set_style_for_routp( iv_method_name = '_EXCEL_APPEND_ROUCLASS_2' ).
    _append_amount_data_by_routp( is_data_rouclass_2 = is_data ).
    " NW007 (+)
  ENDMETHOD.

  METHOD _excel_append_total_1.
    DATA lv_excel_value  TYPE c LENGTH 200.
    DATA lo_excel_style  TYPE REF TO zcl_excel_style.
    DATA lv_merge_row    TYPE i.
    DATA lv_merge_column TYPE i.

    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      ASSIGN COMPONENT <ls_com_data>-name
             OF STRUCTURE is_data
             TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF ms_excel-column = 1.
        DATA(lv_typegrouptext) = get_typegrouptext( iv_typegroup = is_data-typegroup
                                                    iv_language  = mv_language ).

        lv_excel_value = |***Total { lv_typegrouptext }|.
        lo_excel_style = ms_excel_style-total_1_1.
*        lv_merge_row = 1.
*        lv_merge_column = line_index( ms_excel-components_data[ name = 'VALUEY00' ] ) - 1.

      ELSEIF ms_excel-column < line_index( ms_excel-components_data[ name = 'VALUEY00' ] ).

        lo_excel_style = ms_excel_style-total_1_1.

      ELSEIF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
             OR <ls_com_data>-name CP 'VALUEY*'
             OR <ls_com_data>-name  = 'LLLT1Y'
             OR <ls_com_data>-name  = 'LLBT1AND2Y'
             OR <ls_com_data>-name  = 'LLBT2AND5Y'
             OR <ls_com_data>-name  = 'LLBT5AND10Y'
             OR <ls_com_data>-name  = 'LLBT10AND15Y'
             OR <ls_com_data>-name  = 'LLGT15Y'
             OR <ls_com_data>-name  = 'TOTALLT'
             OR <ls_com_data>-name  = 'GLCURRENTPORTION'
             OR <ls_com_data>-name  = 'GLLONGTERM'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
             OR <ls_com_data>-name  = 'DIFFLONGTERM'
             " NW007 (+)
             OR <ls_com_data>-name  = 'GLCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'GLLONGTERM_LT_ROU'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'
             OR <ls_com_data>-name CP 'GLCURRENTPORTION_ROUTP*'.
        " NW007 (+)

        lo_excel_style = ms_excel_style-total_1_2.

        IF <lv_value> IS NOT INITIAL.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = <lv_value>
                                        ip_style  = lo_excel_style ).
        ELSE.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = ''
                                        ip_style  = lo_excel_style ).
        ENDIF.

        CONTINUE.

      ELSE.
        CONTINUE.

      ENDIF.

      " Merge
      IF    lv_merge_row    IS NOT INITIAL
         OR lv_merge_column IS NOT INITIAL.

        ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                       ip_column_end   = ms_excel-column + lv_merge_column - 1
                                       ip_row          = ms_excel-row
                                       ip_row_to       = ms_excel-row + lv_merge_row - 1
                                       ip_style        = lo_excel_style
                                       ip_value        = lv_excel_value ).

      ELSE.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    _set_style_for_routp( iv_method_name = '_EXCEL_APPEND_TOTAL_1' ).
    " NW007 (+)
  ENDMETHOD.

  METHOD _excel_append_total_2.
    DATA lv_excel_value  TYPE c LENGTH 200.
    DATA lo_excel_style  TYPE REF TO zcl_excel_style.
    DATA lv_merge_row    TYPE i.
    DATA lv_merge_column TYPE i.

    ms_excel-row    += 1.
    ms_excel-column  = 1.

    LOOP AT ms_excel-components_data ASSIGNING FIELD-SYMBOL(<ls_com_data>).
      ms_excel-column = sy-tabix.

      CLEAR:
        lv_excel_value,
        lo_excel_style,
        lv_merge_row,
        lv_merge_column.

      ASSIGN COMPONENT <ls_com_data>-name
             OF STRUCTURE is_data
             TO FIELD-SYMBOL(<lv_value>).
      IF sy-subrc <> 0.
        CONTINUE.
      ENDIF.

      IF ms_excel-column = 1.
        lv_excel_value = |***Total Net Lease Liability|.
        lo_excel_style = ms_excel_style-total_2_1.
*        lv_merge_row = 1.
*        lv_merge_column = line_index( ms_excel-components_data[ name = 'VALUEY00' ] ) - 1.

      ELSEIF ms_excel-column < line_index( ms_excel-components_data[ name = 'VALUEY00' ] ).

        lo_excel_style = ms_excel_style-total_2_1.

      ELSEIF    <ls_com_data>-name  = 'TERMINATEAMOUNT'
             OR <ls_com_data>-name CP 'VALUEY*'
             OR <ls_com_data>-name  = 'LLLT1Y'
             OR <ls_com_data>-name  = 'LLBT1AND2Y'
             OR <ls_com_data>-name  = 'LLBT2AND5Y'
             OR <ls_com_data>-name  = 'LLBT5AND10Y'
             OR <ls_com_data>-name  = 'LLBT10AND15Y'
             OR <ls_com_data>-name  = 'LLGT15Y'
             OR <ls_com_data>-name  = 'TOTALLT'
             OR <ls_com_data>-name  = 'GLCURRENTPORTION'
             OR <ls_com_data>-name  = 'GLLONGTERM'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION'
             OR <ls_com_data>-name  = 'DIFFLONGTERM'
             " NW007 (+)
             OR <ls_com_data>-name  = 'GLCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'GLLONGTERM_LT_ROU'
             OR <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'
             OR <ls_com_data>-name CP 'GLCURRENTPORTION_ROUTP*'.
        " NW007 (+)

        lo_excel_style = ms_excel_style-total_2_2.

        IF <lv_value> IS NOT INITIAL.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = <lv_value>
                                        ip_style  = lo_excel_style ).
        ELSE.
          " NW008 (+)
          IF    <ls_com_data>-name  = 'DIFFCURRENTPORTION_APCP_ROU'
             OR <ls_com_data>-name  = 'DIFFLONGTERM_LT_ROU'
             OR <ls_com_data>-name CP 'GLCURRENTPORTION_ROUTP*'.
            ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                          ip_row    = ms_excel-row
                                          ip_value  = '0.00'
                                          ip_style  = lo_excel_style ).
          ELSE.
            " NW008 (+)
            ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                          ip_row    = ms_excel-row
                                          ip_value  = ''
                                          ip_style  = lo_excel_style ).
            " NW008 (+)
          ENDIF.
          " NW008 (+)
        ENDIF.

        CONTINUE.

      ELSE.
        CONTINUE.

      ENDIF.

      " Merge
      IF    lv_merge_row    IS NOT INITIAL
         OR lv_merge_column IS NOT INITIAL.

        ms_excel-worksheet->set_merge( ip_column_start = ms_excel-column
                                       ip_column_end   = ms_excel-column + lv_merge_column - 1
                                       ip_row          = ms_excel-row
                                       ip_row_to       = ms_excel-row + lv_merge_row - 1
                                       ip_style        = lo_excel_style
                                       ip_value        = lv_excel_value ).

      ELSE.
        ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                      ip_row    = ms_excel-row
                                      ip_value  = lv_excel_value
                                      ip_style  = lo_excel_style ).
      ENDIF.

    ENDLOOP.

    " NW007 (+)
    _set_style_for_routp( iv_method_name = '_EXCEL_APPEND_TOTAL_2' ).
    _append_amount_data_by_routp( is_data_total_2 = is_data ).
    " NW007 (+)
  ENDMETHOD.

  METHOD format_po_item_out.
    CLEAR ev_out.

    IF    iv_purchaseorder     IS INITIAL
       OR iv_purchaseorderitem IS INITIAL.

      RETURN.
    ENDIF.

    ev_out = |{ iv_purchaseorder ALPHA = OUT }#{ iv_purchaseorderitem ALPHA = OUT }|.
  ENDMETHOD.

  METHOD format_boolean_out.
    CLEAR ev_out.

    IF iv_in = abap_true.
      ev_out = |Yes|.
    ENDIF.
  ENDMETHOD.

  METHOD get_rouclasstext.
    DATA(ls_rouclasstext) = VALUE #( mt_rouclasstext[ rouclass = iv_rouclass
                                                      language = iv_language ]
                                     OPTIONAL ).

    IF ls_rouclasstext IS NOT INITIAL.
      rv_rouclasstext = ls_rouclasstext-rouclasstext.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM zi_rtr_oll_rouclasstext
      WHERE rouclass = @iv_rouclass
        AND language = @iv_language
      INTO @ls_rouclasstext.

    IF ls_rouclasstext IS NOT INITIAL.
      INSERT ls_rouclasstext INTO TABLE mt_rouclasstext.
    ENDIF.

    rv_rouclasstext = ls_rouclasstext-rouclasstext.
  ENDMETHOD.

  METHOD get_installmentfreqtext.
    DATA(ls_installmentfreqtext) = VALUE #( mt_installmentfreqtext[ installmentfrequency = iv_installmentfrequency
                                                                    language             = iv_language ]
                                            OPTIONAL ).

    IF ls_installmentfreqtext IS NOT INITIAL.
      rv_installmentfrequencytext = ls_installmentfreqtext-installmentfrequencytext.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM zi_rtr_oll_installmentfreqtext
      WHERE installmentfrequency = @iv_installmentfrequency
        AND language             = @iv_language
      INTO @ls_installmentfreqtext.

    IF ls_installmentfreqtext IS NOT INITIAL.
      INSERT ls_installmentfreqtext INTO TABLE mt_installmentfreqtext.
    ENDIF.

    rv_installmentfrequencytext = ls_installmentfreqtext-installmentfrequencytext.
  ENDMETHOD.

  METHOD get_interestratetype_rectext.
    DATA(ls_interestratetype_rectext) = VALUE #( mt_interestratetype_rectext[ code     = iv_code
                                                                              language = iv_language ]
                                                 OPTIONAL ).

    IF ls_interestratetype_rectext IS NOT INITIAL.
      rv_description = ls_interestratetype_rectext-description.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM zz1_interestratetype_w
      WHERE code     = @iv_code
        AND language = @iv_language
      INTO @ls_interestratetype_rectext.

    IF ls_interestratetype_rectext IS NOT INITIAL.
      INSERT ls_interestratetype_rectext INTO TABLE mt_interestratetype_rectext.
    ENDIF.

    rv_description = ls_interestratetype_rectext-description.
  ENDMETHOD.

  METHOD get_paymentmethodtext.
    IF iv_paymentmethod IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_paymentmethodtext) = VALUE #( mt_paymentmethodtext[ paymentmethod = iv_paymentmethod
                                                                language      = iv_language ]
                                          OPTIONAL ).

    IF ls_paymentmethodtext IS NOT INITIAL.
      rv_paymentmethodtext = ls_paymentmethodtext-paymentmethodtext.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM zi_rtr_oll_paymentmethodtext
      WHERE paymentmethod = @iv_paymentmethod
        AND language      = @iv_language
      INTO @ls_paymentmethodtext.

    IF ls_paymentmethodtext IS NOT INITIAL.
      INSERT ls_paymentmethodtext INTO TABLE mt_paymentmethodtext.
    ENDIF.

    rv_paymentmethodtext = ls_paymentmethodtext-paymentmethodtext.
  ENDMETHOD.

  METHOD get_typegrouptext.
    DATA(ls_typegrouptext) = VALUE #( mt_typegrouptext[ typegroup = iv_typegroup
                                                        language  = iv_language ]
                                      OPTIONAL ).

    IF ls_typegrouptext IS NOT INITIAL.
      rv_typegrouptext = ls_typegrouptext-typegrouptext.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM zi_rtr_oll_typegrouptext
      WHERE typegroup = @iv_typegroup
        AND language  = @iv_language
      INTO @ls_typegrouptext.

    IF ls_typegrouptext IS NOT INITIAL.
      INSERT ls_typegrouptext INTO TABLE mt_typegrouptext.
    ENDIF.

    rv_typegrouptext = ls_typegrouptext-typegrouptext.
  ENDMETHOD.

  METHOD get_typetext.
    DATA(ls_typetext) = VALUE #( mt_typetext[ type     = iv_type
                                              language = iv_language ]
                                 OPTIONAL ).

    IF ls_typetext IS NOT INITIAL.
      rv_typetext = ls_typetext-typetext.
      RETURN.
    ENDIF.

    SELECT SINGLE * FROM zi_rtr_oll_typetext
      WHERE type     = @iv_type
        AND language = @iv_language
      INTO @ls_typetext.

    IF ls_typetext IS NOT INITIAL.
      INSERT ls_typetext INTO TABLE mt_typetext.
    ENDIF.

    rv_typetext = ls_typetext-typetext.
  ENDMETHOD.

  METHOD get_recondition.
    TRY.
        rs_recondition = mt_recondition[ companycode        = iv_companycode
                                         realestatecontract = iv_realestatecontract
                                         reconditiontype    = iv_reconditiontype ].
      CATCH cx_sy_itab_line_not_found.
        IF iv_getfromdb IS INITIAL.
          RETURN.
        ENDIF.

        SELECT SINGLE recontractdata~companycode,
                      recontractdata~realestatecontract,
                      recondition~reconditiontype,
                      recondition~reunitprice

          FROM zi_recontractdata AS recontractdata

                 JOIN
                   zi_recondition AS recondition ON recondition~internalrealestatenumber = recontractdata~internalrealestatenumber

          WHERE recontractdata~companycode         = @iv_companycode
            AND recontractdata~realestatecontract  = @iv_realestatecontract
            AND recondition~reconditiontype        = @iv_reconditiontype
            AND recondition~validitystartdate     <= @ms_parameter-keydate
            AND recondition~validityenddate       >= @ms_parameter-keydate
          INTO @rs_recondition.

        IF rs_recondition IS NOT INITIAL.
          INSERT rs_recondition INTO TABLE mt_recondition.
        ENDIF.
    ENDTRY.
  ENDMETHOD.

  METHOD get_apcp.
    TRY.
        rs_apcp = mt_apcp[ companycode      = iv_companycode
                           agreementnumber  = iv_agreementnumber
                           calculationyear  = iv_calculationyear
                           calculationmonth = iv_calculationmonth ].
      CATCH cx_sy_itab_line_not_found.
        IF iv_getfromdb IS INITIAL.
          RETURN.
        ENDIF.

        SELECT SINGLE apcp~*

          FROM zi_rtr_oll_apcp( p_keydate = @ms_parameter-keydate ) AS apcp

          WHERE apcp~companycode      = @iv_companycode
            AND apcp~agreementnumber  = @iv_agreementnumber
            AND apcp~calculationyear  = @iv_calculationyear
            AND apcp~calculationmonth = @iv_calculationmonth
          INTO @rs_apcp.

        IF rs_apcp IS NOT INITIAL.
          INSERT rs_apcp INTO TABLE mt_apcp.
        ENDIF.
    ENDTRY.
  ENDMETHOD.

  METHOD get_terminateamount.
    DATA ls_terminateamount LIKE LINE OF mt_terminateamount.

    TRY.
        rv_terminateamount = mt_terminateamount[ companycode        = iv_companycode
                                                 realestatecontract = iv_realestatecontract ]-terminateamount.
      CATCH cx_sy_itab_line_not_found.
        IF iv_getfromdb IS INITIAL.
          RETURN.
        ENDIF.

        ls_terminateamount-companycode        = iv_companycode.
        ls_terminateamount-realestatecontract = iv_realestatecontract.

        SELECT valuationrulecf~* FROM zi_rtr_oll_valuationrulecf AS valuationrulecf

          WHERE valuationrulecf~companycode        = @iv_companycode
            AND valuationrulecf~realestatecontract = @iv_realestatecontract
            AND (    (     valuationrulecf~recashflowtype        = '1'
                       AND valuationrulecf~bookflowtype         <> 'ZA10'
                       AND valuationrulecf~bookflowtype         <> 'ZA20'
                       AND valuationrulecf~iscompleteretirement  = 'X' )
                  OR (     valuationrulecf~recashflowtype        = '4'
                       AND valuationrulecf~isrepaymentdif        = 'X' ) )

          INTO TABLE @DATA(lt_valuationrulecf).

        SORT lt_valuationrulecf
             BY recashflowtype
                bookflowtype
                paymentduedate DESCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_valuationrulecf
               COMPARING recashflowtype bookflowtype.

        LOOP AT lt_valuationrulecf ASSIGNING FIELD-SYMBOL(<ls_valuationrulecf>).
          IF <ls_valuationrulecf>-recashflowtype = '1'.
            ls_terminateamount-terminateamount -= <ls_valuationrulecf>-amountincompanycodecurrency.
          ELSE.
            ls_terminateamount-terminateamount += <ls_valuationrulecf>-amountincompanycodecurrency.
          ENDIF.
        ENDLOOP.

        INSERT ls_terminateamount INTO TABLE mt_terminateamount.

        rv_terminateamount = ls_terminateamount-terminateamount.
    ENDTRY.
  ENDMETHOD.

  METHOD _add_tradingpartner_components.
    DATA lv_tradingpartner TYPE zi_rtr_oll_acctdocitemrouandtp-tradingpartner.
    DATA lv_fieldname      TYPE c LENGTH 30.

    TRY.
        LOOP AT mt_tradingpartner INTO DATA(ls_tradingpartner).
          DATA(ls_dummyamountvalue) = cs_components_data[ name = 'DUMMYAMOUNTVALUE' ].

          lv_tradingpartner = COND #( WHEN ls_tradingpartner-tradingpartner IS INITIAL
                                      THEN '0'
                                      ELSE ls_tradingpartner-tradingpartner ).
          lv_tradingpartner = condense( val = |{ lv_tradingpartner ALPHA = OUT }| ).

          DO 2 TIMES.
            lv_fieldname = SWITCH #( sy-index
                                     WHEN 1 THEN 'GLCURRENTPORTION_ROUTP'
                                     WHEN 2 THEN 'GLLONGTERM_ROUTP' ).

            ls_dummyamountvalue-name = |{ lv_fieldname }{ lv_tradingpartner }|.

            INSERT ls_dummyamountvalue INTO TABLE cs_components_data.
          ENDDO.
        ENDLOOP.
      CATCH cx_sy_itab_line_not_found.
    ENDTRY.
  ENDMETHOD.

  METHOD _exclude_excel_components.
    DELETE cs_components_data WHERE name = 'COMPANYCODE'.
    DELETE cs_components_data WHERE name = 'GETTERMINATEAMOUNT'.
    DELETE cs_components_data WHERE name = 'INSTALLMENTFREQUENCYISFOUND'.       " NW005 (+)
    DELETE cs_components_data WHERE name = 'DUMMYAMOUNTVALUE'.                  " NW007 (+)
    DELETE cs_components_data WHERE name = 'REALESTATECONTRACTFORAPCP'.         " NW008 (+)
  ENDMETHOD.

  METHOD _get_additional_data_from_itab.
    TYPES: BEGIN OF lty_apcp_key,
             companycode     TYPE zi_rtr_rou_outleaseliabrep-companycode,
             agreementnumber TYPE zi_rtr_rou_outleaseliabrep-agreementnumber,
           END OF lty_apcp_key.
    TYPES ltty_apcp_key TYPE HASHED TABLE OF lty_apcp_key WITH UNIQUE KEY companycode agreementnumber.

    TYPES: BEGIN OF lty_rouclasstext_key,
             rouclass TYPE zi_rtr_rou_outleaseliabrep-rouclass,
           END OF lty_rouclasstext_key.
    TYPES ltty_rouclasstext_key TYPE HASHED TABLE OF lty_rouclasstext_key WITH UNIQUE KEY rouclass.

    TYPES: BEGIN OF lty_installmentfreqtext_key,
             installmentfrequency TYPE zi_rtr_rou_outleaseliabrep-installmentfrequency,
           END OF lty_installmentfreqtext_key.
    TYPES ltty_installmentfreqtext_key TYPE HASHED TABLE OF lty_installmentfreqtext_key WITH UNIQUE KEY installmentfrequency.

    TYPES: BEGIN OF lty_interestrectext_key,
             interestratetype TYPE zi_rtr_rou_outleaseliabrep-zz1_interestratetype_rec,
           END OF lty_interestrectext_key.
    TYPES ltty_interestrectext_key TYPE HASHED TABLE OF lty_interestrectext_key WITH UNIQUE KEY interestratetype.

    TYPES: BEGIN OF lty_paymentmethodtext_key,
             paymentmethod TYPE zi_rtr_rou_outleaseliabrep-paymentmethod,
           END OF lty_paymentmethodtext_key.
    TYPES ltty_paymentmethodtext_key TYPE HASHED TABLE OF lty_paymentmethodtext_key WITH UNIQUE KEY paymentmethod.

    TYPES: BEGIN OF lty_typegrouptext_key,
             typegroup TYPE zi_rtr_rou_outleaseliabrep-typegroup,
           END OF lty_typegrouptext_key.
    TYPES ltty_typegrouptext_key TYPE HASHED TABLE OF lty_typegrouptext_key WITH UNIQUE KEY typegroup.

    TYPES: BEGIN OF lty_typetext_key,
             type TYPE zi_rtr_rou_outleaseliabrep-type,
           END OF lty_typetext_key.
    TYPES ltty_typetext_key TYPE HASHED TABLE OF lty_typetext_key WITH UNIQUE KEY type.

    TYPES: BEGIN OF lty_recondition_key,
             companycode        TYPE zi_rtr_rou_outleaseliabrep-companycode,
             realestatecontract TYPE zi_rtr_rou_outleaseliabrep-realestatecontract,
           END OF lty_recondition_key.
    TYPES ltty_recondition_key TYPE HASHED TABLE OF lty_recondition_key WITH UNIQUE KEY companycode realestatecontract.

    TYPES: BEGIN OF lty_valuationrulecf_key,
             companycode        TYPE zi_rtr_rou_outleaseliabrep-companycode,
             realestatecontract TYPE zi_rtr_rou_outleaseliabrep-realestatecontract,
           END OF lty_valuationrulecf_key.
    TYPES ltty_valuationrulecf_key TYPE HASHED TABLE OF lty_valuationrulecf_key WITH UNIQUE KEY companycode realestatecontract.

    DATA lt_apcp_key                TYPE ltty_apcp_key.
    DATA lt_rouclasstext_key        TYPE ltty_rouclasstext_key.
    DATA lt_installmentfreqtext_key TYPE ltty_installmentfreqtext_key.
    DATA lt_interestrectext_key     TYPE ltty_interestrectext_key.
    DATA lt_paymentmethodtext_key   TYPE ltty_paymentmethodtext_key.
    DATA lt_typegrouptext_key       TYPE ltty_typegrouptext_key.
    DATA lt_typetext_key            TYPE ltty_typetext_key.
    DATA lt_recondition_key         TYPE ltty_recondition_key.
    DATA lt_valuationrulecf_key     TYPE ltty_valuationrulecf_key.

    DATA lt_apcp                    TYPE TABLE OF zi_rtr_oll_apcp WITH EMPTY KEY.
    DATA lt_rouclasstext            TYPE TABLE OF zi_rtr_oll_rouclasstext WITH EMPTY KEY.
    DATA lt_installmentfreqtext     TYPE TABLE OF zi_rtr_oll_installmentfreqtext WITH EMPTY KEY.
    DATA lt_interestratetype_w      TYPE TABLE OF zz1_interestratetype_w WITH EMPTY KEY.
    DATA lt_paymentmethodtext       TYPE TABLE OF zi_rtr_oll_paymentmethodtext WITH EMPTY KEY.
    DATA lt_typegrouptext           TYPE TABLE OF zi_rtr_oll_typegrouptext WITH EMPTY KEY.
    DATA lt_typetext                TYPE TABLE OF zi_rtr_oll_typetext WITH EMPTY KEY.
    DATA lt_valuationrulecf         TYPE TABLE OF zi_rtr_oll_valuationrulecf WITH EMPTY KEY
                                                                             WITH NON-UNIQUE SORTED KEY realestatecontract COMPONENTS companycode realestatecontract.
    DATA ls_terminateamount         LIKE LINE OF mt_terminateamount.

    lt_apcp_key                = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING companycode     = companycode
                                                                                        agreementnumber = agreementnumber EXCEPT * ).
    lt_rouclasstext_key        = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING rouclass = rouclass EXCEPT * ).
    lt_installmentfreqtext_key = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING installmentfrequency = installmentfrequency EXCEPT * ).
    lt_interestrectext_key     = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING interestratetype = zz1_interestratetype_rec EXCEPT * ).
    lt_paymentmethodtext_key   = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING paymentmethod = paymentmethod EXCEPT * ).
    lt_typegrouptext_key       = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING typegroup = typegroup EXCEPT * ).
    lt_recondition_key         = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING companycode        = companycode
                                                                                        realestatecontract = realestatecontract EXCEPT * ).
    lt_valuationrulecf_key     = CORRESPONDING #( it_data DISCARDING DUPLICATES MAPPING companycode        = companycode
                                                                                        realestatecontract = realestatecontract EXCEPT * ).

    " AP-CP
    IF lt_apcp_key IS NOT INITIAL.
      SELECT apcp~*
        FROM zi_rtr_oll_apcp( p_keydate = @iv_keydate ) AS apcp
               INNER JOIN
                 @lt_apcp_key AS zit_data_key ON  apcp~companycode     = zit_data_key~companycode
                                              AND apcp~agreementnumber = zit_data_key~agreementnumber
        WHERE apcp~calculationyear BETWEEN @iv_start_year AND @iv_end_year
        INTO TABLE @lt_apcp.

      IF lt_apcp IS NOT INITIAL.
        INSERT LINES OF lt_apcp INTO TABLE mt_apcp.
      ENDIF.
    ENDIF.

    " ROU Outstanding Lease Liability - ROU Class Text
    IF lt_rouclasstext_key IS NOT INITIAL.
      SELECT rouclasstext~*
        FROM zi_rtr_oll_rouclasstext AS rouclasstext
               INNER JOIN
                 @lt_rouclasstext_key AS zit_rouclasstext ON rouclasstext~rouclass = zit_rouclasstext~rouclass
        WHERE rouclasstext~language = @mv_language
        INTO TABLE @lt_rouclasstext.

      IF lt_rouclasstext IS NOT INITIAL.
        INSERT LINES OF lt_rouclasstext INTO TABLE mt_rouclasstext.
      ENDIF.
    ENDIF.

    " ROU Outstanding Lease Liability - ROU Class Text
    IF lt_installmentfreqtext_key IS NOT INITIAL.
      SELECT installmentfreqtext~*
        FROM zi_rtr_oll_installmentfreqtext AS installmentfreqtext
               INNER JOIN
                 @lt_installmentfreqtext_key AS zit_installmentfreqtext ON installmentfreqtext~installmentfrequency = zit_installmentfreqtext~installmentfrequency
        WHERE installmentfreqtext~language = @mv_language
        INTO TABLE @lt_installmentfreqtext.

      IF lt_installmentfreqtext IS NOT INITIAL.
        INSERT LINES OF lt_installmentfreqtext INTO TABLE mt_installmentfreqtext.
      ENDIF.
    ENDIF.

    " Interest Rate Type
    IF lt_interestrectext_key IS NOT INITIAL.
      SELECT interestratetype~*
        FROM zz1_interestratetype_w AS interestratetype
               INNER JOIN
                 @lt_interestrectext_key AS zit_interestrectext_key ON interestratetype~code = zit_interestrectext_key~interestratetype
        WHERE interestratetype~language = @mv_language
        INTO TABLE @lt_interestratetype_w.

      IF lt_interestratetype_w IS NOT INITIAL.
        INSERT LINES OF lt_interestratetype_w INTO TABLE mt_interestratetype_rectext.
      ENDIF.
    ENDIF.

    " ROU Outstanding Lease Liability - Payment Method Text
    IF lt_paymentmethodtext_key IS NOT INITIAL.
      SELECT paymentmethodtext~*
        FROM zi_rtr_oll_paymentmethodtext AS paymentmethodtext
               INNER JOIN
                 @lt_paymentmethodtext_key AS zit_paymentmethodtext_key ON paymentmethodtext~paymentmethod = zit_paymentmethodtext_key~paymentmethod
        WHERE paymentmethodtext~language = @mv_language
        INTO TABLE @lt_paymentmethodtext.

      IF lt_paymentmethodtext IS NOT INITIAL.
        INSERT LINES OF lt_paymentmethodtext INTO TABLE mt_paymentmethodtext.
      ENDIF.
    ENDIF.

    " ROU Outstanding Lease Liability - Type Group Text
    IF lt_typegrouptext_key IS NOT INITIAL.
      SELECT typegrouptext~*
        FROM zi_rtr_oll_typegrouptext AS typegrouptext
               INNER JOIN
                 @lt_typegrouptext_key AS zit_typegrouptext_key ON typegrouptext~typegroup = zit_typegrouptext_key~typegroup
        WHERE typegrouptext~language = @mv_language
        INTO TABLE @lt_typegrouptext.

      IF lt_typegrouptext IS NOT INITIAL.
        INSERT LINES OF lt_typegrouptext INTO TABLE mt_typegrouptext.
      ENDIF.
    ENDIF.

    " ROU Outstanding Lease Liability - Type Text
    IF lt_typetext_key IS NOT INITIAL.
      SELECT typetext~*
        FROM zi_rtr_oll_typetext AS typetext
               INNER JOIN
                 @lt_typetext_key AS zit_typetext_key ON typetext~type = zit_typetext_key~type
        WHERE typetext~language = @mv_language
        INTO TABLE @lt_typetext.

      IF lt_typetext IS NOT INITIAL.
        INSERT LINES OF lt_typetext INTO TABLE mt_typetext.
      ENDIF.
    ENDIF.

    IF lt_recondition_key IS NOT INITIAL.
      SELECT recontractdata~companycode,
             recontractdata~realestatecontract,
             recondition~reconditiontype,
             recondition~reunitprice
        FROM zi_recontractdata AS recontractdata
               JOIN
                 zi_recondition AS recondition ON recondition~internalrealestatenumber = recontractdata~internalrealestatenumber
                   JOIN
                     @lt_recondition_key AS zit_recondition_key ON  recontractdata~companycode        = zit_recondition_key~companycode
                                                                AND recontractdata~realestatecontract = zit_recondition_key~realestatecontract
        WHERE recondition~reconditiontype   IN ( 'Z300', 'Z310' )
          AND recondition~validitystartdate <= @iv_keydate
          AND recondition~validityenddate   >= @iv_keydate
        INTO TABLE @FINAL(lt_recondition).

      IF lt_recondition IS NOT INITIAL.
*        mt_recondition = CORRESPONDING #( lt_recondition ).
        mt_recondition = CORRESPONDING #( lt_recondition DISCARDING DUPLICATES ).
      ENDIF.
    ENDIF.

    " Valuation Rule Cashflow
    IF lt_valuationrulecf_key IS NOT INITIAL.
      SELECT valuationrulecf~*
        FROM zi_rtr_oll_valuationrulecf AS valuationrulecf
               INNER JOIN
                 @lt_valuationrulecf_key AS zit_valuationrulecf_key ON  valuationrulecf~companycode        = zit_valuationrulecf_key~companycode
                                                                    AND valuationrulecf~realestatecontract = zit_valuationrulecf_key~realestatecontract
        WHERE (     valuationrulecf~recashflowtype        = '1'
                AND valuationrulecf~bookflowtype         <> 'ZA10'
                AND valuationrulecf~bookflowtype         <> 'ZA20'
                AND valuationrulecf~iscompleteretirement  = 'X' )
           OR (     valuationrulecf~recashflowtype        = '4'
                AND valuationrulecf~isrepaymentdif        = 'X' )
        INTO TABLE @lt_valuationrulecf.
      IF lt_valuationrulecf IS NOT INITIAL.
        SORT lt_valuationrulecf
             BY companycode
                realestatecontract
                recashflowtype
                bookflowtype
                paymentduedate DESCENDING.
        DELETE ADJACENT DUPLICATES FROM lt_valuationrulecf
               COMPARING companycode realestatecontract recashflowtype bookflowtype.

        LOOP AT lt_valuationrulecf ASSIGNING FIELD-SYMBOL(<ls_valuationrulecf>)
             GROUP BY ( companycode        = <ls_valuationrulecf>-companycode
                        realestatecontract = <ls_valuationrulecf>-realestatecontract )
             ASCENDING.
          CLEAR ls_terminateamount.

          ls_terminateamount-companycode        = <ls_valuationrulecf>-companycode.
          ls_terminateamount-realestatecontract = <ls_valuationrulecf>-realestatecontract.

          LOOP AT GROUP <ls_valuationrulecf> ASSIGNING FIELD-SYMBOL(<ls_valuationrulecf_grp>).
            IF <ls_valuationrulecf>-recashflowtype = '1'.
              ls_terminateamount-terminateamount -= <ls_valuationrulecf_grp>-amountincompanycodecurrency.
            ELSE.
              ls_terminateamount-terminateamount += <ls_valuationrulecf_grp>-amountincompanycodecurrency.
            ENDIF.
          ENDLOOP.

          INSERT ls_terminateamount INTO TABLE mt_terminateamount.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD _populate_amount_data_by_rou.
    DATA ls_oll_acctdocitembyrou LIKE LINE OF mt_oll_acctdocitembyrou.
    DATA lv_total_ap_cp_rou_gl   TYPE fis_hsl.
    DATA lv_total_lt_rou_gl      TYPE fis_hsl.

    IF ct_data_agreement_1 IS SUPPLIED.

    ENDIF.

    IF ct_data_agreement_2 IS SUPPLIED.

    ENDIF.

    IF ct_data_rouclass_1 IS SUPPLIED.

    ENDIF.

    IF ct_data_rouclass_2 IS SUPPLIED.
      LOOP AT ct_data_rouclass_2 ASSIGNING FIELD-SYMBOL(<ls_data_rouclass_2>).
        LOOP AT mt_oll_acctdocitembyrou INTO ls_oll_acctdocitembyrou
             USING KEY secondary_key_1
             WHERE     companycode = <ls_data_rouclass_2>-companycode
                   AND (    identifier = 'AP_CP_ROU_GL'
                         OR identifier = 'CP_ROU_GL' )
                   AND rouclass = <ls_data_rouclass_2>-rouclass.
          <ls_data_rouclass_2>-glcurrentportion_apcp_rou += ls_oll_acctdocitembyrou-amountincompanycodecurrency.
        ENDLOOP.

        LOOP AT mt_oll_acctdocitembyrou INTO ls_oll_acctdocitembyrou
             WHERE     companycode = <ls_data_rouclass_2>-companycode
                   AND identifier  = 'LT_ROU_GL'
                   AND rouclass    = <ls_data_rouclass_2>-rouclass.
          <ls_data_rouclass_2>-gllongterm_lt_rou += ls_oll_acctdocitembyrou-amountincompanycodecurrency.
        ENDLOOP.

        " Column: ET - EI
        <ls_data_rouclass_2>-diffcurrentportion_apcp_rou = <ls_data_rouclass_2>-glcurrentportion_apcp_rou - <ls_data_rouclass_2>-lllt1y.

        " Column: EV - EO
        <ls_data_rouclass_2>-difflongterm_lt_rou         = <ls_data_rouclass_2>-gllongterm_lt_rou - <ls_data_rouclass_2>-totallt.
      ENDLOOP.
    ENDIF.

    IF ct_data_total_1 IS SUPPLIED.

    ENDIF.

    IF ct_data_total_2 IS SUPPLIED.
      lv_total_ap_cp_rou_gl = REDUCE #( INIT lv_total TYPE fis_hsl
                                        FOR <ls_oll_acctdocitembyrou_1> IN mt_oll_acctdocitembyrou
                                        WHERE (    identifier = 'AP_CP_ROU_GL'
                                                OR identifier = 'CP_ROU_GL' )
                                        NEXT lv_total += <ls_oll_acctdocitembyrou_1>-amountincompanycodecurrency ).

      lv_total_lt_rou_gl = REDUCE #( INIT lv_total TYPE fis_hsl
                                        FOR <ls_oll_acctdocitembyrou_1> IN mt_oll_acctdocitembyrou
                                        USING KEY secondary_key_2
                                        WHERE ( identifier = 'LT_ROU_GL' )
                                        NEXT lv_total += <ls_oll_acctdocitembyrou_1>-amountincompanycodecurrency ).

      LOOP AT ct_data_total_2 ASSIGNING FIELD-SYMBOL(<ls_data_total_2>).
        <ls_data_total_2>-glcurrentportion_apcp_rou   = lv_total_ap_cp_rou_gl.
        <ls_data_total_2>-gllongterm_lt_rou           = lv_total_lt_rou_gl.

        " Column: ET - EI
        <ls_data_total_2>-diffcurrentportion_apcp_rou = <ls_data_total_2>-glcurrentportion_apcp_rou - <ls_data_total_2>-lllt1y.

        " Column: EV - EO
        <ls_data_total_2>-difflongterm_lt_rou         = <ls_data_total_2>-gllongterm_lt_rou - <ls_data_total_2>-totallt.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD _append_amount_data_by_routp.
    DATA ls_tradingpartner            TYPE ts_tradingpartner.

    " TODO: variable is assigned but never used (ABAP cleaner)
    DATA ls_oll_acctdocitembyrouandtp LIKE LINE OF mt_oll_acctdocitembyrouandtp.

    DATA lv_tradingpartner            TYPE zi_rtr_oll_acctdocitemrouandtp-tradingpartner.
    DATA lv_fieldname                 TYPE c LENGTH 30.

    DATA lv_amountbytp                TYPE fis_hsl.
    DATA lv_totalamountbytp           TYPE fis_hsl.

    DATA lo_excel_style               TYPE REF TO zcl_excel_style.

    IF mt_tradingpartner IS INITIAL.
      RETURN.
    ENDIF.

    IF is_data_agreement_1 IS SUPPLIED.

    ENDIF.

    IF is_data_agreement_2 IS SUPPLIED.

    ENDIF.

    IF is_data_rouclass_1 IS SUPPLIED.

    ENDIF.

    IF is_data_rouclass_2 IS SUPPLIED.
      LOOP AT mt_tradingpartner INTO ls_tradingpartner.
        CLEAR: ls_oll_acctdocitembyrouandtp,
               lv_amountbytp.

        lv_tradingpartner = COND #( WHEN ls_tradingpartner-tradingpartner IS INITIAL
                                    THEN '0'
                                    ELSE ls_tradingpartner-tradingpartner ).
        lv_tradingpartner = condense( val = |{ lv_tradingpartner ALPHA = OUT }| ).

        DO 2 TIMES.
          CASE sy-index.
            WHEN 1.
              lv_fieldname = 'GLCURRENTPORTION_ROUTP'.

              lv_amountbytp = REDUCE #( INIT lv_total TYPE fis_hsl
                                        FOR <ls_oll_acctdocitembyrouandtp> IN mt_oll_acctdocitembyrouandtp
                                        USING KEY secondary_key_1
                                        WHERE (     companycode = is_data_rouclass_2-companycode
                                                AND (    identifier = 'AP_CP_ROU_GL'
                                                      OR identifier = 'CP_ROU_GL' )
                                                AND rouclass       = is_data_rouclass_2-rouclass
                                                AND tradingpartner = ls_tradingpartner-tradingpartner )
                                        NEXT lv_total += <ls_oll_acctdocitembyrouandtp>-amountincompanycodecurrency ).
            WHEN 2.
              lv_fieldname = 'GLLONGTERM_ROUTP'.

              lv_amountbytp = REDUCE #( INIT lv_total TYPE fis_hsl
                                        FOR <ls_oll_acctdocitembyrouandtp> IN mt_oll_acctdocitembyrouandtp
                                        USING KEY primary_key
                                        WHERE (     companycode    = is_data_rouclass_2-companycode
                                                AND identifier     = 'LT_ROU_GL'
                                                AND rouclass       = is_data_rouclass_2-rouclass
                                                AND tradingpartner = ls_tradingpartner-tradingpartner )
                                        NEXT lv_total += <ls_oll_acctdocitembyrouandtp>-amountincompanycodecurrency ).
          ENDCASE.

          lv_fieldname = |{ lv_fieldname }{ lv_tradingpartner }|.

          READ TABLE ms_excel-components_data TRANSPORTING NO FIELDS WITH KEY name = lv_fieldname.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          ms_excel-column = sy-tabix.

          CLEAR lo_excel_style.

          lo_excel_style = ms_excel_style-rouclass_2_2.

          TRY.
              IF lv_amountbytp IS NOT INITIAL.

                ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                              ip_row    = ms_excel-row
                                              ip_value  = lv_amountbytp
                                              ip_style  = lo_excel_style ).

              ELSE.
                ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                              ip_row    = ms_excel-row
                                              ip_value  = ''
                                              ip_style  = lo_excel_style ).
              ENDIF.
            CATCH zcx_excel.
          ENDTRY.
        ENDDO.
      ENDLOOP.
    ENDIF.

    IF is_data_total_1 IS SUPPLIED.

    ENDIF.

    IF is_data_total_2 IS SUPPLIED.
      LOOP AT mt_tradingpartner INTO ls_tradingpartner.
        CLEAR: ls_oll_acctdocitembyrouandtp,
               lv_totalamountbytp.

        lv_tradingpartner = COND #( WHEN ls_tradingpartner-tradingpartner IS INITIAL
                                    THEN '0'
                                    ELSE ls_tradingpartner-tradingpartner ).
        lv_tradingpartner = condense( val = |{ lv_tradingpartner ALPHA = OUT }| ).

        DO 2 TIMES.
          CASE sy-index.
            WHEN 1.
              lv_fieldname = 'GLCURRENTPORTION_ROUTP'.

              lv_totalamountbytp = REDUCE #( INIT lv_total TYPE fis_hsl
                                                FOR <ls_oll_acctdocitembyrouandtp> IN mt_oll_acctdocitembyrouandtp
                                                WHERE (     (    identifier = 'AP_CP_ROU_GL'
                                                              OR identifier = 'CP_ROU_GL' )
                                                        AND tradingpartner = ls_tradingpartner-tradingpartner )
                                                NEXT lv_total += <ls_oll_acctdocitembyrouandtp>-amountincompanycodecurrency ).
            WHEN 2.
              lv_fieldname = 'GLLONGTERM_ROUTP'.

              lv_totalamountbytp = REDUCE #( INIT lv_total TYPE fis_hsl
                                                FOR <ls_oll_acctdocitembyrouandtp> IN mt_oll_acctdocitembyrouandtp
                                                USING KEY secondary_key_2
                                                WHERE (     identifier     = 'LT_ROU_GL'
                                                        AND tradingpartner = ls_tradingpartner-tradingpartner )
                                                NEXT lv_total += <ls_oll_acctdocitembyrouandtp>-amountincompanycodecurrency ).
          ENDCASE.

          lv_fieldname = |{ lv_fieldname }{ lv_tradingpartner }|.

          READ TABLE ms_excel-components_data TRANSPORTING NO FIELDS WITH KEY name = lv_fieldname.
          IF sy-subrc <> 0.
            CONTINUE.
          ENDIF.

          ms_excel-column = sy-tabix.

          CLEAR lo_excel_style.

          lo_excel_style = ms_excel_style-total_2_2.

          TRY.
              IF lv_totalamountbytp IS NOT INITIAL.

                ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                              ip_row    = ms_excel-row
                                              ip_value  = lv_totalamountbytp
                                              ip_style  = lo_excel_style ).

              ELSE.
                ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                              ip_row    = ms_excel-row
                                              ip_value  = ''
                                              ip_style  = lo_excel_style ).
              ENDIF.
            CATCH zcx_excel.
          ENDTRY.
        ENDDO.
      ENDLOOP.
    ENDIF.
  ENDMETHOD.

  METHOD _set_style_for_routp.
    DATA lo_excel_style TYPE REF TO zcl_excel_style.

    LOOP AT ms_excel-components_data TRANSPORTING NO FIELDS
         WHERE    name CP 'GLCURRENTPORTION_ROUTP*'
               OR name CP 'GLLONGTERM_ROUTP*'.
      ms_excel-column = sy-tabix.

      lo_excel_style = COND #( WHEN iv_method_name = '_EXCEL_APPEND_DATA'        THEN ms_excel_style-table_data_number
                               WHEN iv_method_name = '_EXCEL_APPEND_AGREEMENT_1' THEN ms_excel_style-agreement_1_2
                               WHEN iv_method_name = '_EXCEL_APPEND_AGREEMENT_2' THEN ms_excel_style-agreement_2_2
                               WHEN iv_method_name = '_EXCEL_APPEND_ROUCLASS_1'  THEN ms_excel_style-rouclass_1_2
                               WHEN iv_method_name = '_EXCEL_APPEND_ROUCLASS_2'  THEN ms_excel_style-rouclass_2_2
                               WHEN iv_method_name = '_EXCEL_APPEND_TOTAL_1'     THEN ms_excel_style-total_1_2
                               WHEN iv_method_name = '_EXCEL_APPEND_TOTAL_2'     THEN ms_excel_style-total_2_2 ).

      TRY.
          ms_excel-worksheet->set_cell( ip_column = ms_excel-column
                                        ip_row    = ms_excel-row
                                        ip_value  = ''
                                        ip_style  = lo_excel_style ).
        CATCH zcx_excel.
      ENDTRY.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.


CLASS lsc_zi_rtr_rou_outleaseliabrep DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS save_modified    REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.


CLASS lsc_zi_rtr_rou_outleaseliabrep IMPLEMENTATION.
  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.
ENDCLASS.
