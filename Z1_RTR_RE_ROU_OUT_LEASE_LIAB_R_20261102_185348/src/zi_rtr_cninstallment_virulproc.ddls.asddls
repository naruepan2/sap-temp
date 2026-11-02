/////////////////////////////////////////////////////////////////////////
// Project Name: SMILE
// Created by  : Naruepan W.
// Created on  : 17.03.2026
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

@AbapCatalog.viewEnhancementCategory: [ #NONE ]

@AccessControl.authorizationCheck: #NOT_REQUIRED

@EndUserText.label: 'Valuation Rule and Valuation Process'

@ObjectModel.usageType: { serviceQuality: #X, sizeCategory: #M, dataClass: #MIXED }

define view entity ZI_RTR_CNINSTALLMENT_VIRULPROC
  as select from ZI_VICERULE       as Vicerule

    inner join   ZI_VICEPROCESS    as Viceprocess    on  Vicerule.Intreno  = Viceprocess.Intreno
                                                     and Vicerule.Ruleguid = Viceprocess.Ruleguid

    inner join   ZI_VICECFRULE     as Vicecfrule     on  Viceprocess.Intreno     = Vicecfrule.intreno
                                                     and Viceprocess.Ruleguid    = Vicecfrule.ruleguid
                                                     and Viceprocess.Processguid = Vicecfrule.processguid

    inner join   ZI_REContractData as REContractData on Vicerule.Intreno = REContractData.InternalRealEstateNumber

{
  key Vicecfrule.intreno,
  key Vicecfrule.ruleguid,
  key Vicecfrule.processguid,
  key Vicecfrule.cfguid,

      REContractData.CompanyCode,
      REContractData.RealEstateContract,
      Vicerule.Termno,
      Vicerule.Termtype,
      Vicerule.Validfrom,
      Vicerule.Validto,
      Vicerule.Objnr,
      Vicerule.Objvalidfrom,
      Vicerule.Cerule,
      Vicerule.Consbeg,
      Vicecfrule.duedate as paymentduedate,
      Vicecfrule.dbervon,
      Vicecfrule.dberbis,
      Viceprocess.Rerf,
      Viceprocess.Derf,
      Viceprocess.Terf,
      Viceprocess.Reher,
      Viceprocess.Rbear,
      Viceprocess.Dbear,
      Viceprocess.Tbear,
      Viceprocess.Rbher,
      Viceprocess.Isinitialprocess,
      REContractData.ZZ1_DMValInstallPosted_Rec
}

where
      Vicerule.Cerule   like 'ZROU%'
  and Vicecfrule.cftype =    '7'
