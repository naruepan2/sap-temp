" /////////////////////////////////////////////////////////////////////////
" // Project Name: SMILE
" // Created by  : Naruepan W.
" // Created on  : 12.06.2026
" // WRICEF ID   : RTR-RE011
" // TR Number   : GSDK919389
" //-----------------------------------------------------------------------
" // Description : Outstanding Lease Liability and Defer Interest Report
" //-----------------------------------------------------------------------
" // Change History
" //-----------------------------------------------------------------------
" // Date |TR Number |Search Term |Developer |Description
" // -------- ----------- ----------- ----------- -------------------------
" /////////////////////////////////////////////////////////////////////////
CLASS zcl_rtr_oll_contractgenerlapcp DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_contractgeneralapcp FOR TABLE FUNCTION zi_rtr_oll_contractgenerlapcp.
ENDCLASS.


CLASS zcl_rtr_oll_contractgenerlapcp IMPLEMENTATION.
  METHOD get_contractgeneralapcp BY DATABASE FUNCTION
                                 FOR HDB LANGUAGE SQLSCRIPT
                                 OPTIONS READ-ONLY
                                 USING zi_rtr_oll_apcp_onlyleasedfi_1.

    RETURN select distinct
                  outleaseliabrep.mandt as client,
                  first_value( outleaseliabrep.companycode ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as companycode,
                  first_value( outleaseliabrep.agreementnumber ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as agreementnumber,
                  first_value( outleaseliabrep.recontractcurrency ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as recontractcurrency,
                  first_value( outleaseliabrep.companycodecurrency ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as companycodecurrency,
                  first_value( outleaseliabrep.isvaryonsales ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as isvaryonsales,
                  first_value( outleaseliabrep.zz1_extensionoption_rec ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as extensionoption,
                  first_value( outleaseliabrep.zz1_retireobligation_rec ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as retireobligation,
                  first_value( outleaseliabrep.zz1_terminateoption_rec ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as terminateoption,
                  first_value( outleaseliabrep.paymentmethod ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as paymentmethod,
                  first_value( outleaseliabrep.installmentfrequency ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as installmentfrequency,
                  first_value( outleaseliabrep.zz1_interestratetype_rec ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as interestratetype,
                  first_value( outleaseliabrep.reinterestrate ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as reinterestrate,
                  first_value( outleaseliabrep.zz1_purchaseoption_rec ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as purchaseoption,
                  first_value( outleaseliabrep.zz1_guaranteeresidualv_rec ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as guaranteeresidualv,
                  first_value( outleaseliabrep.businesspartnersupplier ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as businesspartnersupplier,
                  first_value( outleaseliabrep.tradingpartner ) over( PARTITION by companycode, agreementnumber order by companycode,agreementnumber ) as tradingpartner
             from zi_rtr_oll_apcp_onlyleasedfi_1( :p_companycode,
                                                  :p_keydate ) as outleaseliabrep
            where outleaseliabrep.mandt       = :p_client
              and outleaseliabrep.companycode = :p_companycode;
  ENDMETHOD.
ENDCLASS.
