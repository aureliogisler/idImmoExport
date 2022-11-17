--Objekte.sql

SELECT
CASE WHEN obj.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(obj.immobiliennr, 'SW', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(obj.immobiliennr, 'SB', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(obj.immobiliennr, 'ST', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(obj.immobiliennr, 'OP', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(obj.immobiliennr, 'RL', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(obj.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
utab3.housenumber AS houseNumber,
utab1.levelNumber AS levelNumber,
CONCAT('1', 
	CONCAT(SUBSTR(CONCAT('00', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(obj.immobiliennr, 'BÜ', ''), 'RL', ''), 'OP', ''), 'ST', ''), 'SB', ''), 'SW', '')), -2), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab3.housenumber), '999')), -3), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab1.levelNumber), '999')), -3), 
	SUBSTR(CONCAT('000', objNr.objNumber), -3))))
) AS objectNumber,
obj.objstmnr AS objectNrlegacy,
NVL(TEMP8.KLAS_NEW, vertragsobjekt.TK_OBJKLAS) AS objectType,
CASE WHEN LOWER(obj.objbez) LIKE '%link%' THEN 10 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%mitte%' THEN 20 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%recht%' THEN 30 ELSE 9999 END END END objectPosition,
TEMP8.group_new AS objectGroup,
'' AS physicalFlatNumber,
'' AS administrationFlatNumber,
extpm_obj.nr AS federalFlatIdentifier,
kaution_tab.kaution AS amount,
CASE WHEN kaution_tab.kaution != 0 THEN '01.01.1901' ELSE '' END AS validFrom,
CASE WHEN objvers.nettofl != 0 THEN 1 ELSE NULL END AS KeyNumber1,
CASE WHEN objvers.nettofl != 0 THEN objvers.nettofl ELSE NULL END AS KeyValue1,
CASE WHEN objvers.nettofl != 0 THEN TO_CHAR(objvers.zudat, 'DD.MM.YYYY') ELSE NULL END AS ValidFrom1,
'' AS KeyNumber2,
'' AS KeyValue2,
'' AS ValidFrom2,
'' AS KeyNumber3,
'' AS KeyValue3,
'' AS ValidFrom3,
'' AS KeyNumber4,
'' AS KeyValue4,
'' AS ValidFrom4,
'' AS KeyNumber5,
'' AS KeyValue5,
'' AS ValidFrom5,
obj.objbez AS text,
remove_letters(SUBSTR(obj.objstmnr, -2)) AS placeNumber,
objvers.anzzi AS numberOfRooms,
objvers.nettofl AS surface,
'' AS UseableSurface,
'' AS Designation,
'' AS NumberOfVotes,
'' AS MinimumOccupancyInitial,
'' AS MinimumOccupancyQuantity,
'' AS MaximumOccupancy,
mitben_tab.objekte AS JointUseListText,
nebenr_tab.objekte AS SideRoomListText,
CASE WHEN TEMP8.TK_OBJKLAS IN ('0414', '1157', '1203', '1253', '1256', '1259', '1303', '1353', '1403', '1454', '1553') THEN 'true' ELSE 'false' END AS "Subventioniert",
CASE WHEN TEMP8.TK_OBJKLAS IN ('1357', '1358', '1359') THEN 'true' ELSE 'false' END AS "IV gerecht",
CASE WHEN TEMP8.TK_OBJKLAS IN ('1262', '1355', '1455') THEN 'true' ELSE 'false' END AS "Eco",
CASE WHEN TEMP8.TK_OBJKLAS IN ('5250') THEN 'true' ELSE 'false' END AS "E-Mobilität",
CASE WHEN TEMP8.TK_OBJKLAS IN ('1260') THEN 'true' ELSE 'false' END AS "Atelierwohnung",
CASE WHEN TEMP8.TK_OBJKLAS IN ('1481', '1581', '1582', '1601') THEN 'true' ELSE 'false' END AS "Attika",
CASE WHEN TEMP8.TK_OBJKLAS IN ('1261', '1471', '1504', '1356') THEN 'true' ELSE 'false' END AS "Maisonette",
CASE WHEN TEMP8.TK_OBJKLAS IN ('1158') THEN 'true' ELSE 'false' END AS "Galerie-Unit",
CASE WHEN TEMP8.TK_OBJKLAS IN ('0411', '0412', '0413', '0414', '0421', '0422', '0423', '0431', '0432', '0433', '0441', '0442', '0443', '0451', '0452', '0453', '0511', '0512', '0513', '0521', '0522', '0523', '0900') THEN 'true' ELSE 'false' END AS "R-EFH-Typ"
,obj.immobiliennr,
obj.gebstmnr,
obj.stwstmnr

FROM 
obj 
LEFT OUTER JOIN (
	SELECT 
	obj.immobiliennr,
	obj.gebstmnr,
	obj.stwstmnr,
	obj.objstmnr,
	ROW_NUMBER() OVER (PARTITION BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr ORDER BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr,	SUBSTR(obj.objstmnr, -2)) AS objNumber 
	FROM obj 
) objNr ON objNr.immobiliennr = obj.immobiliennr AND objNr.gebstmnr = obj.gebstmnr AND objNr.stwstmnr = obj.stwstmnr AND objNr.objstmnr = obj.objstmnr
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
) utab1 ON utab1.immobiliennr = obj.immobiliennr AND utab1.gebstmnr = obj.gebstmnr AND utab1.stwstmnr = obj.stwstmnr 
LEFT OUTER JOIN (
	SELECT MAX(objvers.zudat) AS edate, immobiliennr, gebstmnr, stwstmnr, objstmnr FROM objvers GROUP BY immobiliennr, gebstmnr, stwstmnr, objstmnr) utab2 ON utab2.immobiliennr = obj.immobiliennr AND utab2.gebstmnr = obj.gebstmnr AND utab2.stwstmnr = obj.stwstmnr AND utab2.objstmnr = obj.objstmnr
LEFT OUTER JOIN objvers ON objvers.immobiliennr = obj.immobiliennr AND objvers.gebstmnr = obj.gebstmnr AND objvers.stwstmnr = obj.stwstmnr AND objvers.objstmnr = obj.objstmnr AND objvers.zudat = utab2.edate 
LEFT OUTER JOIN (
	SELECT 
	CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
	ROW_NUMBER() OVER (PARTITION BY immoteil.immobiliennr ORDER BY immobilie.immobiliennr, immoteil.gebstmnr) AS houseNumber,
	immoteil.gebstmnr 

	FROM 
	immoteil 
	INNER JOIN immobilie ON immobilie.immobiliennr = immoteil.immobiliennr 
	WHERE NVL(immoteil.abdat, '31.12.9999') > '31.12.2022'
) utab3 ON utab3.realestatenumber = CASE WHEN obj.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(obj.immobiliennr, 'SW', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(obj.immobiliennr, 'SB', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(obj.immobiliennr, 'ST', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(obj.immobiliennr, 'OP', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(obj.immobiliennr, 'RL', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(obj.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AND utab3.gebstmnr = obj.gebstmnr 
LEFT OUTER JOIN extpm_obj ON extpm_obj.immobiliennr = obj.immobiliennr AND extpm_obj.gebstmnr = obj.gebstmnr AND extpm_obj.objstmnr = obj.objstmnr 
INNER JOIN immobilie ON immobilie.immobiliennr = obj.immobiliennr 

LEFT OUTER JOIN (
	SELECT 
	SUM(kaution.kautionsbetrag) AS kaution,
	vertragsobjekt.immobiliennr,
	vertragsobjekt.gebstmnr,
	vertragsobjekt.stwstmnr,
	vertragsobjekt.objstmnr

	FROM 
	kaution 
	LEFT OUTER JOIN mv ON mv.mv = kaution.mv AND mv.partner_id = kaution.partner_id 
	LEFT OUTER JOIN vertragsobjekt ON vertragsobjekt.mv = mv.mv AND vertragsobjekt.partner_id = kaution.partner_id AND mv.max_ind = vertragsobjekt.aend_ind 

	WHERE 
	NVL(MV.ENDEDAT, '31.12.9999') > '31.12.2022'
	AND mv.tk_vertragsart != 'WOH_KB'

	GROUP BY 
	vertragsobjekt.immobiliennr,
	vertragsobjekt.gebstmnr,
	vertragsobjekt.stwstmnr,
	vertragsobjekt.objstmnr) 
kaution_tab ON kaution_tab.immobiliennr = obj.immobiliennr AND kaution_tab.gebstmnr = obj.gebstmnr AND kaution_tab.stwstmnr = obj.stwstmnr AND kaution_tab.objstmnr = obj.objstmnr 
LEFT OUTER JOIN (
	SELECT 
	MAX(aend_ind) AS max_aend_ind,
	MAX(vertragsobjekt.edat) AS max_edat,
	mv.mv,
	vertragsobjekt.immobiliennr,
	vertragsobjekt.gebstmnr,
	vertragsobjekt.stwstmnr,
	vertragsobjekt.objstmnr

	FROM
	vertragsobjekt 
	INNER JOIN mv ON mv.mv = vertragsobjekt.mv AND mv.partner_id = vertragsobjekt.partner_id 

	WHERE 
	NVL(MV.ENDEDAT, '31.12.9999') > '31.12.2022'
	AND mv.tk_vertragsart != 'WOH_KB' 

	GROUP BY 
	mv.mv,
	vertragsobjekt.immobiliennr,
	vertragsobjekt.gebstmnr,
	vertragsobjekt.stwstmnr,
	vertragsobjekt.objstmnr
) vertragsobj_utab ON vertragsobj_utab.immobiliennr = obj.immobiliennr AND vertragsobj_utab.gebstmnr = obj.gebstmnr AND vertragsobj_utab.objstmnr = obj.objstmnr 
LEFT OUTER JOIN vertragsobjekt ON vertragsobjekt.edat = vertragsobj_utab.max_edat AND vertragsobjekt.aend_ind = vertragsobj_utab.max_aend_ind AND vertragsobjekt.immobiliennr = vertragsobj_utab.immobiliennr AND vertragsobjekt.gebstmnr = vertragsobj_utab.gebstmnr AND vertragsobjekt.stwstmnr = vertragsobj_utab.stwstmnr AND vertragsobjekt.mv = vertragsobj_utab.mv AND vertragsobjekt.objstmnr = vertragsobj_utab.objstmnr  
LEFT OUTER JOIN TEMP8 ON TEMP8.TK_OBJKLAS = objvers.TK_OBJKLAS 
LEFT OUTER JOIN ( 
	SELECT 
	RTRIM (XMLAGG (XMLELEMENT (e, text_8051 || ', ')).EXTRACT ('//text()'), ', ') AS objekte,
	referenz_geb.gebstmnr,
	referenz_geb.immobiliennr


	FROM 
	ausstattung 
	INNER JOIN referenz_geb ON referenz_geb.key_geb = ausstattung.key_geb 
	INNER JOIN aust1 ON aust1.tk_ausstgrp = ausstattung.tk_ausstgrp AND aust1.tk_ausstbez = ausstattung.tk_ausstbez

	WHERE 
	ausstattung.TK_ausstgrp = 90

	GROUP BY 
	referenz_geb.gebstmnr,
	referenz_geb.immobiliennr
) mitben_tab ON mitben_tab.gebstmnr = obj.gebstmnr AND mitben_tab.immobiliennr = obj.immobiliennr 
LEFT OUTER JOIN (
	SELECT 
	RTRIM (XMLAGG (XMLELEMENT (e, text_8051 || ', ')).EXTRACT ('//text()'), ', ') AS objekte,
	referenz_obj.gebstmnr,
	referenz_obj.immobiliennr,
	referenz_obj.objstmnr


	FROM 
	ausstattung 
	INNER JOIN referenz_obj ON referenz_obj.key_obj = ausstattung.key_obj 
	INNER JOIN aust1 ON aust1.tk_ausstgrp = ausstattung.tk_ausstgrp AND aust1.tk_ausstbez = ausstattung.tk_ausstbez

	WHERE 
	ausstattung.TK_ausstgrp = 57

	GROUP BY 
	referenz_obj.gebstmnr,
	referenz_obj.immobiliennr,
	referenz_obj.objstmnr
) nebenr_tab ON nebenr_tab.gebstmnr = obj.gebstmnr AND nebenr_tab.immobiliennr = obj.immobiliennr AND nebenr_tab.objstmnr = obj.objstmnr  

WHERE 
1 = 1 
--AND CASE WHEN LOWER(obj.objbez) LIKE '%bastelraum%' THEN 214 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%lager%' THEN 207 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%garage%' THEN 301 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%2-%' THEN 20 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%3-%' THEN 30 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%3.5-%' THEN 35 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%parkplatz%' THEN 303 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%abgang%' THEN 9999 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%4-%' THEN 40 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%5-%' THEN 50 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%moped%' THEN 303 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%werkstatt%' THEN 204 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%laden%' THEN 203 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%kindergart%' THEN 203 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%dispo%' THEN 208 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%einstellpla%' THEN 302 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%1-%' THEN 10 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%archiv%' THEN 206 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%hobby%' THEN 217 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%4.0-%' THEN 40 ELSE CASE WHEN LOWER(obj.objbez) LIKE '%9-%' THEN 100 END END END END END END END END END END END END END END END END END END END END END IS NULL
--AND obj.objstmnr = '04001'
AND obj.immobiliennr != '99VW'
--AND obj.immobiliennr = '30ST'
AND NVL(immobilie.abdat, '31.12.9999') > '31.12.2022'
AND NVL(obj.abdat, '31.12.9999') > '31.12.2022' 
AND utab3.housenumber IS NOT NULL
--AND obj.gebstmnr = 'AH030A'
--AND CONCAT(utab3.housenumber, obj.objstmnr) = '104002'
--AND realestatenumber = '100004'
--AND CONCAT(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(obj.immobiliennr, 'BÜ', ''), 'RL', ''), 'OP', ''), 'ST', ''), 'SB', ''), 'SW', ''), CONCAT(utab3.housenumber, obj.objstmnr)) = '042013006' 
AND CONCAT(obj.immobiliennr, obj.gebstmnr) NOT IN (SELECT CONCAT(immoteil.immobiliennr, immoteil.gebstmnr) FROM immoteil WHERE NVL(immoteil.abdat, '31.12.9999') <= '31.12.2022')

ORDER BY 
obj.immobiliennr,
obj.gebstmnr,
obj.stwstmnr,
CONCAT('1', 
	CONCAT(SUBSTR(CONCAT('00', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(obj.immobiliennr, 'BÜ', ''), 'RL', ''), 'OP', ''), 'ST', ''), 'SB', ''), 'SW', '')), -2), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab3.housenumber), '999')), -3), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab1.levelNumber), '999')), -3), 
	SUBSTR(CONCAT('000', objNr.objNumber), -3))))
)