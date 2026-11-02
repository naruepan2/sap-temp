*/////////////////////////////////////////////////////////////////////////
*// Project Name: SMILE
*// Created by  : Naruepan W.
*// Created on  : 09.03.2026
*// WRICEF ID   : RTR-RE011
*// TR Number   : GSDK911054
*//-----------------------------------------------------------------------
*// Description : Outstanding Lease Liability and Defer Interest Report
*//-----------------------------------------------------------------------
*// Change History
*//-----------------------------------------------------------------------
*// Date |TR Number |Search Term |Developer |Description
*// -------- ----------- ----------- ----------- -------------------------
*/////////////////////////////////////////////////////////////////////////

CLASS zcl_rtr_cnnoinstallmenttf DEFINITION
  PUBLIC FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
        FOR TABLE FUNCTION zi_rtr_cnnoinstallmenttf.
ENDCLASS.


CLASS zcl_rtr_cnnoinstallmenttf IMPLEMENTATION.
  METHOD get_data
         BY DATABASE FUNCTION FOR HDB
         LANGUAGE SQLSCRIPT
         OPTIONS READ-ONLY
         USING zi_rtr_cninstallment_virulproc.

    lt_result_0 = select distinct
                    mandt as client,
                    companycode,
                    realestatecontract,
                    ruleguid,
                    intreno,
                    consbeg,
                    derf,
                    terf,
                    paymentduedate,
                    zz1_dmvalinstallposted_rec
                  from zi_rtr_cninstallment_virulproc
                  where zi_rtr_cninstallment_virulproc.mandt = :p_client;

    RETURN select
            client,
            companycode,
            realestatecontract,
            ROW_NUMBER ( )
                OVER ( PARTITION BY intreno
                       ORDER BY consbeg desc ) as itemno,
            consbeg as startofconsideration,
            paymentduedate as paymentduedate,
            count( ruleguid )
                over ( partition by intreno, ruleguid, consbeg
                order by intreno, consbeg desc, derf desc, terf desc )
            + zz1_dmvalinstallposted_rec as noofinstallment
            from :lt_result_0
            ORDER BY companycode,
                     realestatecontract,
                     startofconsideration desc;
  ENDMETHOD.
ENDCLASS.
