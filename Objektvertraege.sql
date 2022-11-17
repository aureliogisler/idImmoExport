-- Objektvertrag.sql

SELECT DISTINCT 
TEMP10.Id AS objectContractNumber,
CASE WHEN vertragsobjekt.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(vertragsobjekt.immobiliennr, 'SW', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(vertragsobjekt.immobiliennr, 'SB', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(vertragsobjekt.immobiliennr, 'ST', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(vertragsobjekt.immobiliennr, 'OP', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(vertragsobjekt.immobiliennr, 'RL', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(vertragsobjekt.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
CONCAT('1', 
	CONCAT(SUBSTR(CONCAT('00', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(vertragsobjekt.immobiliennr, 'BÜ', ''), 'RL', ''), 'OP', ''), 'ST', ''), 'SB', ''), 'SW', '')), -2), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab3.housenumber), '999')), -3), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab1.levelNumber), '999')), -3), 
	SUBSTR(CONCAT('000', objNr.objNumber), -3))))
) AS objectNumber,
CASE WHEN vertragsobjekt.partner_id != 1 THEN vertragsobjekt.partner_id + 100 ELSE 1 END AS debtorNumber,
TEMP9.ID AS contractRelationNumber,
1,
CASE WHEN mv.beginndat > SYSDATE THEN 1 ELSE 2 END AS status,
CASE WHEN mv.tk_vertragsart LIKE 'AAP%' THEN CASE WHEN mv.mwst_pflicht_jn = 0 THEN 30 ELSE 31 END ELSE CASE WHEN mv.tk_vertragsart LIKE 'EFH%' OR mv.tk_vertragsart LIKE 'WOH%' THEN 10 ELSE CASE WHEN mv.tk_vertragsart LIKE 'GES%' THEN 20 ELSE CASE WHEN mv.mwst_pflicht_jn = 0 THEN 98 ELSE 99 END END END END AS typeOfUse,
120 AS contractType,
CASE WHEN SUBSTR(vertragsobjekt.objstmnr, 1, 1) <= 2 THEN 2 ELSE 1 END AS IncidentalCostRegulation,
TO_CHAR(mv.edat, 'DD.MM.YYYY') AS ContractDate,
TO_CHAR(mv.beginndat, 'DD.MM.YYYY') AS ContractStart,
1 AS TerminationDateJanuarySwitch,
1 AS TerminationDateFebruarySwitch,
1 AS TerminationDateMarchSwitch, 
1 AS TerminationDateAprilSwitch,
1 AS TerminationDateMaySwitch,
1 AS TerminationDateJuneSwitch,
1 AS TerminationDateJulySwitch,
1 AS TerminationDateAugustSwitch,
1 AS TerminationDateSeptemberSwitch,
1 AS TerminationDateOctoberSwitch,
1 AS TerminationDateNovemberSwitch,
0 AS TerminationDateDecemberSwitch,
CASE WHEN mv.endedat IS NOT NULL THEN 1 ELSE 0 END AS ContractTerminationSwitch,
null AS TerminationDate,
TO_CHAR(mv.endedat, 'DD.MM.YYYY') AS ContractEnd,
TO_CHAR(mv.auszugsdat, 'DD.MM.YYYY') AS MovingOutDate,
TO_CHAR(mv.beginndat, 'DD.MM.YYYY') AS ValidFrom,
1 AS DueDatesJanuarySwitch,
1 AS DueDatesFebruarySwitch,
1 AS DueDatesMarchSwitch,
1 AS DueDatesAprilSwitch,
1 AS DueDatesMaySwitch,
1 AS DueDatesJuniSwitch,
1 AS DueDatesJulySwitch,
1 AS DueDatesAugustSwitch,
1 AS DueDatesSeptemberSwitch,
1 AS DueDatesOctoberSwitch,
1 AS DueDatesNovemberSwitch,
1 AS DueDatesDecemberSwitch,
'' AS indexNumber,
'' AS indexCreditInPercent,
'' AS indexPossibleAsAt,
'' AS indexActualAsAt,
'' AS rentSecurityType,
'' AS depositAmount,
'' AS paymentUntil,
'' AS depositPaidSwitch,
'' AS depositDate,
'' AS depositAmountPaidIn,
Temp8.kuend AS kuendFrist,
vertragsobjekt.immobiliennr,
vertragsobjekt.gebstmnr,
vertragsobjekt.stwstmnr,
vertragsobjekt.objstmnr

FROM 
vertragsobjekt 
--INNER JOIN (SELECT MAX(aend_ind) AS maxIndex, mv, partner_id, objstmnr, immobiliennr, stwstmnr, gebstmnr FROM vertragsobjekt GROUP BY mv, partner_id, objstmnr, immobiliennr, stwstmnr, gebstmnr) utab1 ON utab1.mv = vertragsobjekt.mv AND utab1.partner_id = vertragsobjekt.partner_id  AND utab1.objstmnr = vertragsobjekt.objstmnr AND utab1.immobiliennr = vertragsobjekt.immobiliennr AND utab1.stwstmnr = vertragsobjekt.stwstmnr AND utab1.gebstmnr = vertragsobjekt.gebstmnr AND utab1.maxindex = vertragsobjekt.aend_ind 
LEFT OUTER JOIN (
	SELECT 
	CASE WHEN stw.tk_stwart = '0010' THEN '901' ELSE CASE WHEN stw.tk_stwart = '1000' THEN '100' ELSE CASE WHEN stw.tk_stwart = '1010' THEN '101' ELSE CASE WHEN stw.tk_stwart = '1020' THEN '102' ELSE CASE WHEN stw.tk_stwart = '1030' THEN '103' ELSE CASE WHEN stw.tk_stwart = '1040' THEN '104' ELSE CASE WHEN stw.tk_stwart = '1050' THEN '105' ELSE CASE WHEN stw.tk_stwart = '1060' THEN '106' ELSE CASE WHEN stw.tk_stwart = '0009' THEN '902' ELSE CASE WHEN stw.tk_stwart = '0008' THEN '903' ELSE CASE WHEN stw.tk_stwart = '1070' THEN '107' ELSE CASE WHEN stw.tk_stwart = '1035' THEN '103' ELSE '900' END END END END END END END END END END END END AS levelnumber,
	stw.immobiliennr,
	stw.gebstmnr,
	stw.stwstmnr
	FROM 
	stw 
	LEFT OUTER JOIN (
	SELECT 
	CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
	ROW_NUMBER() OVER (PARTITION BY immoteil.immobiliennr ORDER BY immobilie.immobiliennr, immoteil.gebstmnr) AS houseNumber,
	immoteil.gebstmnr
	FROM 
	immoteil 
	INNER JOIN immobilie ON immobilie.immobiliennr = immoteil.immobiliennr 
	) utab1 ON utab1.realestatenumber = CASE WHEN stw.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(stw.immobiliennr, 'SW', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(stw.immobiliennr, 'SB', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(stw.immobiliennr, 'ST', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(stw.immobiliennr, 'OP', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(stw.immobiliennr, 'RL', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(stw.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AND utab1.gebstmnr = stw.gebstmnr 
	INNER JOIN immobilie ON immobilie.immobiliennr = stw.immobiliennr 
	WHERE 
	immobilie.immobiliennr != '99VW'
	AND NVL(immobilie.abdat, '31.12.9999') > '31.12.2022'
	ORDER BY 
	stw.immobiliennr,
	stw.gebstmnr,
	CASE WHEN stw.tk_stwart = '0010' THEN -1 ELSE CASE WHEN stw.tk_stwart = '1000' THEN 0 ELSE CASE WHEN stw.tk_stwart = '1010' THEN 1 ELSE CASE WHEN stw.tk_stwart = '1020' THEN 2 ELSE CASE WHEN stw.tk_stwart = '1030' THEN 3 ELSE CASE WHEN stw.tk_stwart = '1040' THEN 4 ELSE CASE WHEN stw.tk_stwart = '1050' THEN 5 ELSE CASE WHEN stw.tk_stwart = '1060' THEN 6 ELSE CASE WHEN stw.tk_stwart = '0009' THEN -2 ELSE CASE WHEN stw.tk_stwart = '0008' THEN -3 ELSE CASE WHEN stw.tk_stwart = '1070' THEN 7 ELSE 90 END END END END END END END END END END END
) utab1 ON utab1.immobiliennr = vertragsobjekt.immobiliennr AND utab1.gebstmnr = vertragsobjekt.gebstmnr AND utab1.stwstmnr = vertragsobjekt.stwstmnr 
LEFT OUTER JOIN (
	SELECT 
	CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
	ROW_NUMBER() OVER (PARTITION BY immoteil.immobiliennr ORDER BY immobilie.immobiliennr, immoteil.gebstmnr) AS houseNumber,
	immoteil.gebstmnr 

	FROM 
	immoteil 
	INNER JOIN immobilie ON immobilie.immobiliennr = immoteil.immobiliennr 
	WHERE NVL(immoteil.abdat, '31.12.9999') > '31.12.2022'
) utab3 ON utab3.realestatenumber = CASE WHEN vertragsobjekt.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(vertragsobjekt.immobiliennr, 'SW', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(vertragsobjekt.immobiliennr, 'SB', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(vertragsobjekt.immobiliennr, 'ST', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(vertragsobjekt.immobiliennr, 'OP', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(vertragsobjekt.immobiliennr, 'RL', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(vertragsobjekt.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AND utab3.gebstmnr = vertragsobjekt.gebstmnr 
INNER JOIN mv ON mv.mv = vertragsobjekt.mv AND mv.partner_id = vertragsobjekt.partner_id 
INNER JOIN TEMP9 ON TEMP9.partner_id = vertragsobjekt.partner_id 
INNER JOIN TEMP8 ON TEMP8.TK_OBJKLAS = vertragsobjekt.tk_objklas 
LEFT OUTER JOIN (
	SELECT 
	obj.immobiliennr,
	obj.gebstmnr,
	obj.stwstmnr,
	obj.objstmnr,
	ROW_NUMBER() OVER (PARTITION BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr ORDER BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr,	SUBSTR(obj.objstmnr, -2)) AS objNumber 
	FROM obj 
) objNr ON objNr.immobiliennr = vertragsobjekt.immobiliennr AND objNr.gebstmnr = vertragsobjekt.gebstmnr AND objNr.stwstmnr = vertragsobjekt.stwstmnr AND objNr.objstmnr = vertragsobjekt.objstmnr
INNER JOIN TEMP10 ON TEMP10.immobiliennr = vertragsobjekt.immobiliennr AND TEMP10.gebstmnr = vertragsobjekt.gebstmnr AND TEMP10.stwstmnr = vertragsobjekt.stwstmnr AND TEMP10.objstmnr = vertragsobjekt.objstmnr AND TEMP10.mv = mv.mv 
INNER JOIN immobilie ON immobilie.immobiliennr = vertragsobjekt.immobiliennr 
INNER JOIN obj ON obj.immobiliennr = vertragsobjekt.immobiliennr AND obj.gebstmnr = vertragsobjekt.gebstmnr AND obj.stwstmnr = vertragsobjekt.stwstmnr AND obj.objstmnr = vertragsobjekt.objstmnr 

WHERE 
1 = 1
--vertragsobjekt.mv = '002'
--AND vertragsobjekt.partner_id = '008201'
--AND vertragsobjekt.partner_id IN ('005012','008846')
--AND vertragsobjekt.objstmnr = '04001'
AND NVL(mv.endedat, '31.12.9999') > SYSDATE 
AND NVL(immobilie.abdat, '31.12.9999') > '31.12.2022'
AND NVL(obj.abdat, '31.12.9999') > '31.12.2022' 
-- AND CONCAT('1', 
	-- CONCAT(SUBSTR(CONCAT('00', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(vertragsobjekt.immobiliennr, 'BÜ', ''), 'RL', ''), 'OP', ''), 'ST', ''), 'SB', ''), 'SW', '')), -2), 
	-- CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab3.housenumber), '999')), -3), 
	-- CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab1.levelNumber), '999')), -3), 
	-- SUBSTR(CONCAT('000', objNr.objNumber), -3))))
-- ) IN ('103053100001','103041100001')
--AND TEMP9.id = 1

ORDER BY 
TEMP10.Id

