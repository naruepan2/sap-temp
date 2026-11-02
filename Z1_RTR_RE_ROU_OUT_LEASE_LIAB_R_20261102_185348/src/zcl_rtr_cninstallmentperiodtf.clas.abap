*/////////////////////////////////////////////////////////////////////////
*// Project Name: SMILE
*// Created by  : Potsawat M.
*// Created on  : 11.02.2026
*// WRICEF ID   : RTR-RE011
*// TR Number   : GSDK911054
*//-----------------------------------------------------------------------
*// Description : Outstanding Lease Liability and Defer Interest Report
*//-----------------------------------------------------------------------
*// Change History
*//-----------------------------------------------------------------------
*// Date |TR Number |Search Term |Developer |Description
*// -------- ----------- ----------- ----------- -------------------------
*// 19/02/2026 | GSDK913869 | NW001 | Naruepan W. | Change Condition with Client Dependent
*/////////////////////////////////////////////////////////////////////////

CLASS zcl_rtr_cninstallmentperiodtf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_amdp_marker_hdb.

    CLASS-METHODS get_data
        FOR TABLE FUNCTION zi_rtr_cninstallmentperiodtf.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_rtr_cninstallmentperiodtf IMPLEMENTATION.

  METHOD get_data
         BY DATABASE FUNCTION FOR HDB
         LANGUAGE SQLSCRIPT
         OPTIONS READ-ONLY
         USING zi_recontractdata zi_vicecfrule.

    RETURN
      select
        :p_client AS client,
        recontractdata.companycode,
        recontractdata.realestatecontract,
        count(paymentduedate)
          over(partition by valuationcf.internalrealestatenumber
               order by valuationcf.internalrealestatenumber, valuationcf.paymentduedate)
            + recontractdata.zz1_dmvalinstallposted_rec
          as installmentno,
        valuationcf.paymentduedate

        from (
          select
            recontractdata.internalrealestatenumber,
*            vicecfrule.dbervon as calculationperiodstartdate,
*            vicecfrule.dberbis as calculationperiodenddate
            vicecfrule.duedate as paymentduedate

            from zi_recontractdata as recontractdata

            inner join zi_vicecfrule as vicecfrule
            on vicecfrule.intreno = recontractdata.internalrealestatenumber and
               vicecfrule.cftype  = '7'
*           NW001 (+)
            where recontractdata.mandt = :p_client
              and vicecfrule.mandt     = :p_client
*           NW001 (+)
            group by
              recontractdata.internalrealestatenumber,
*              vicecfrule.dbervon,
*              vicecfrule.dberbis
              vicecfrule.duedate
        ) as valuationcf

        join zi_recontractdata as recontractdata
        on recontractdata.internalrealestatenumber = valuationcf.internalrealestatenumber

*       NW001 (+)
        where recontractdata.mandt = :p_client
*       NW001 (+)

        order by
          companycode,
          realestatecontract,
          installmentno;

  ENDMETHOD.

ENDCLASS.
