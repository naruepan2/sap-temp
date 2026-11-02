*/////////////////////////////////////////////////////////////////////////
*// Project Name: SMILE
*// Created by  : Naruepan W.
*// Created on  : 22.06.2026
*// WRICEF ID   : RTR-RE011
*// TR Number   : GSDK920102
*//-----------------------------------------------------------------------
*// Description : Outstanding Lease Liability and Defer Interest Report
*//-----------------------------------------------------------------------
*// Change History
*//-----------------------------------------------------------------------
*// Date |TR Number |Search Term |Developer |Description
*// -------- ----------- ----------- ----------- -------------------------
*/////////////////////////////////////////////////////////////////////////
CLASS zcl_rtr_oll_bytp_ce DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
ENDCLASS.


CLASS zcl_rtr_oll_bytp_ce IMPLEMENTATION.
  METHOD if_rap_query_provider~select.
    DATA lt_rtr_oll_bytp              TYPE TABLE OF zi_rtr_oll_bytp WITH EMPTY KEY.
    DATA lt_data                      TYPE TABLE OF zce_rtr_oll_bytp WITH EMPTY KEY.
    DATA lv_calendardate              TYPE i_calendardate-calendardate.
    DATA lt_companycode               TYPE TABLE OF zce_rtr_oll_bytp-companycode.

    DATA lt_period_range              TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_fiscalyear_range          TYPE if_rap_query_filter=>tt_range_option.

    DATA lt_companycode_range         TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_tradingpartner_range      TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_type_range                TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_typegroup_range           TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_companycodecurrency_range TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_lessthan1year_range       TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_between1and2year_range    TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_between2and5year_range    TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_between5and10year_range   TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_greaterthan15year_range   TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_minreinterestrate_range   TYPE if_rap_query_filter=>tt_range_option.
    DATA lt_maxreinterestrate_range   TYPE if_rap_query_filter=>tt_range_option.

    DATA lv_total_records             TYPE int8.
    DATA lv_table_records             TYPE int8.

    zcl_ext_custom_entity_utils=>get_sql_query_provider(
      EXPORTING io_request                = io_request
      IMPORTING ev_orderby_string         = DATA(lv_orderby_string)
*                ev_select_string          = DATA(lv_select_string)
*                ev_sql_where_string       = DATA(lv_sql_where_string)
*                ev_entity_id              =
                ev_up_to_rows             = DATA(lv_uptorow)
                ev_offset                 = DATA(lv_offset)
*                ev_is_ui_identification   =
                et_filter_cond            = DATA(lt_filter_cond)
*                eo_filter_as_tree         =
*                et_parameters             =
*                et_requested_elements     =
*                ev_search_expression      =
*                et_sort_elements          =
*                et_aggregated_elements    =
*                et_aggr_grouped_elements  =
                ev_is_data_requested      = DATA(lv_is_data_requested)
                ev_is_total_rec_requested = DATA(lv_is_total_rec_requested) ).

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Get Period and Year
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    IF     line_exists( lt_filter_cond[ name = 'PERIOD' ] )
       AND line_exists( lt_filter_cond[ name = 'FISCALYEAR' ] ).
      lt_period_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                 WHERE ( name = 'PERIOD' )
                                 ( LINES OF <ls_filter_cond>-range ) ).
      lt_fiscalyear_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                     WHERE ( name = 'FISCALYEAR' )
                                     FOR <ls_range> IN <ls_filter_cond>-range
                                     ( sign   = <ls_range>-sign
                                       option = <ls_range>-option
                                       low    = to_upper( <ls_range>-low )
                                       high   = to_upper( <ls_range>-high ) ) ).

      SELECT FROM i_calendardate
        FIELDS MAX( calendardate ) AS calendardate
        WHERE calendaryear  IN @lt_fiscalyear_range
          AND calendarmonth IN @lt_period_range
        INTO @lv_calendardate.
    ELSE.
      DATA(lv_system_date) = xco_cp=>sy->date( )->as( xco_cp_time=>format->abap )->value.
      DATA(lv_system_year) = substring( val = lv_system_date
                                        off = 0
                                        len = 4 ).
      DATA(lv_system_month) = substring( val = lv_system_date
                                         off = 4
                                         len = 2 ).

      SELECT FROM i_calendardate
        FIELDS MAX( calendardate ) AS calendardate
        WHERE calendaryear  = @lv_system_year
          AND calendarmonth = @lv_system_month
        INTO @lv_calendardate.
    ENDIF.

    IF line_exists( lt_filter_cond[ name = 'COMPANYCODE' ] ).
      lt_companycode = VALUE #( ( lt_filter_cond[ name = 'COMPANYCODE' ]-range[ 1 ]-low ) ).
    ELSE.
      SELECT FROM i_companycode
        FIELDS companycode
        WHERE chartofaccounts = 'PTGC'
        ORDER BY companycode
        INTO TABLE @lt_companycode.
    ENDIF.

    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    " Build Range
    """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
    lt_companycode_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                    WHERE ( name = 'COMPANYCODE' )
                                    FOR <ls_range> IN <ls_filter_cond>-range
                                    ( sign   = <ls_range>-sign
                                      option = <ls_range>-option
                                      low    = to_upper( <ls_range>-low )
                                      high   = to_upper( <ls_range>-high ) ) ).
    lt_tradingpartner_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                       WHERE ( name = 'TRADINGPARTNER' )
                                       FOR <ls_range> IN <ls_filter_cond>-range
                                       ( sign   = <ls_range>-sign
                                         option = <ls_range>-option
                                         low    = to_upper( <ls_range>-low )
                                         high   = to_upper( <ls_range>-high ) ) ).
    lt_type_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                             WHERE ( name = 'TYPE' )
                             FOR <ls_range> IN <ls_filter_cond>-range
                             ( sign   = <ls_range>-sign
                               option = <ls_range>-option
                               low    = to_upper( <ls_range>-low )
                               high   = to_upper( <ls_range>-high ) ) ).
    lt_typegroup_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                  WHERE ( name = 'TYPEGROUP' )
                                  FOR <ls_range> IN <ls_filter_cond>-range
                                  ( sign   = <ls_range>-sign
                                    option = <ls_range>-option
                                    low    = to_upper( <ls_range>-low )
                                    high   = to_upper( <ls_range>-high ) ) ).
    lt_companycodecurrency_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                            WHERE ( name = 'COMPANYCODECURRENCY' )
                                            FOR <ls_range> IN <ls_filter_cond>-range
                                            ( sign   = <ls_range>-sign
                                              option = <ls_range>-option
                                              low    = to_upper( <ls_range>-low )
                                              high   = to_upper( <ls_range>-high ) ) ).
    lt_lessthan1year_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                      WHERE ( name = 'LESSTHAN1YEAR' )
                                      FOR <ls_range> IN <ls_filter_cond>-range
                                      ( sign   = <ls_range>-sign
                                        option = <ls_range>-option
                                        low    = to_upper( <ls_range>-low )
                                        high   = to_upper( <ls_range>-high ) ) ).
    lt_between1and2year_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                         WHERE ( name = 'BETWEEN1AND2YEAR' )
                                         FOR <ls_range> IN <ls_filter_cond>-range
                                         ( sign   = <ls_range>-sign
                                           option = <ls_range>-option
                                           low    = to_upper( <ls_range>-low )
                                           high   = to_upper( <ls_range>-high ) ) ).
    lt_between2and5year_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                         WHERE ( name = 'BETWEEN2AND5YEAR' )
                                         FOR <ls_range> IN <ls_filter_cond>-range
                                         ( sign   = <ls_range>-sign
                                           option = <ls_range>-option
                                           low    = to_upper( <ls_range>-low )
                                           high   = to_upper( <ls_range>-high ) ) ).
    lt_between5and10year_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                          WHERE ( name = 'BETWEEN5AND10YEAR' )
                                          FOR <ls_range> IN <ls_filter_cond>-range
                                          ( sign   = <ls_range>-sign
                                            option = <ls_range>-option
                                            low    = to_upper( <ls_range>-low )
                                            high   = to_upper( <ls_range>-high ) ) ).
    lt_between5and10year_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                          WHERE ( name = 'BETWEEN5AND10YEAR' )
                                          FOR <ls_range> IN <ls_filter_cond>-range
                                          ( sign   = <ls_range>-sign
                                            option = <ls_range>-option
                                            low    = to_upper( <ls_range>-low )
                                            high   = to_upper( <ls_range>-high ) ) ).
    lt_greaterthan15year_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                          WHERE ( name = 'GREATERTHAN15YEAR' )
                                          FOR <ls_range> IN <ls_filter_cond>-range
                                          ( sign   = <ls_range>-sign
                                            option = <ls_range>-option
                                            low    = to_upper( <ls_range>-low )
                                            high   = to_upper( <ls_range>-high ) ) ).
    lt_minreinterestrate_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                          WHERE ( name = 'MINREINTERESTRATE' )
                                          FOR <ls_range> IN <ls_filter_cond>-range
                                          ( sign   = <ls_range>-sign
                                            option = <ls_range>-option
                                            low    = to_upper( <ls_range>-low )
                                            high   = to_upper( <ls_range>-high ) ) ).
    lt_maxreinterestrate_range = VALUE #( FOR <ls_filter_cond> IN lt_filter_cond
                                          WHERE ( name = 'MAXREINTERESTRATE' )
                                          FOR <ls_range> IN <ls_filter_cond>-range
                                          ( sign   = <ls_range>-sign
                                            option = <ls_range>-option
                                            low    = to_upper( <ls_range>-low )
                                            high   = to_upper( <ls_range>-high ) ) ).

    TRY.
        IF lv_is_data_requested IS NOT INITIAL.
          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          " Select data
          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
          LOOP AT lt_companycode INTO DATA(lv_companycode).
            CLEAR lt_rtr_oll_bytp.

            SELECT *
              FROM zi_rtr_oll_bytp( p_companycode = @lv_companycode,
                                    p_keydate     = @lv_calendardate )
              WHERE upper( companycode )         IN @lt_companycode_range
                AND upper( tradingpartner )      IN @lt_tradingpartner_range
                AND upper( type )                IN @lt_type_range
                AND upper( typegroup )           IN @lt_typegroup_range
                AND upper( companycodecurrency ) IN @lt_companycodecurrency_range
                AND lessthan1year                IN @lt_lessthan1year_range
                AND between1and2year             IN @lt_between1and2year_range
                AND between2and5year             IN @lt_between2and5year_range
                AND between5and10year            IN @lt_between5and10year_range
                AND greaterthan15year            IN @lt_greaterthan15year_range
                AND minreinterestrate            IN @lt_minreinterestrate_range
                AND maxreinterestrate            IN @lt_maxreinterestrate_range
              ORDER BY (lv_orderby_string)
              INTO TABLE @lt_rtr_oll_bytp
                 UP TO @lv_uptorow ROWS
              OFFSET @lv_offset.

            LOOP AT lt_rtr_oll_bytp ASSIGNING FIELD-SYMBOL(<ls_rtr_oll_bytp>).
              INSERT INITIAL LINE INTO TABLE lt_data ASSIGNING FIELD-SYMBOL(<ls_data>).
              <ls_data> = CORRESPONDING #( <ls_rtr_oll_bytp> ).
              <ls_data>-period = substring( val = lv_calendardate
                                            off = 4
                                            len = 2 ).
              <ls_data>-fiscalyear   = substring( val = lv_calendardate
                                                  off = 0
                                                  len = 4 ).
            ENDLOOP.
          ENDLOOP.

          io_response->set_data( lt_data ).
        ENDIF.
        IF lv_is_total_rec_requested IS NOT INITIAL.
          "  To set Line of io_response->set_total_number_of_records
          SELECT COUNT(*)
            FROM zi_rtr_oll_bytp( p_companycode = @lv_companycode,
                                  p_keydate     = @lv_calendardate )
            INTO @lv_table_records.

          lv_total_records += lv_table_records.

          io_response->set_total_number_of_records( iv_total_number_of_records = lv_total_records ).
        ENDIF.
      CATCH cx_rap_query_response_set_twic.
    ENDTRY.
  ENDMETHOD.
ENDCLASS.
