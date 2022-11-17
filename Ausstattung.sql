SELECT 
CASE WHEN obj.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(obj.immobiliennr, 'SW', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(obj.immobiliennr, 'SB', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(obj.immobiliennr, 'ST', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(obj.immobiliennr, 'OP', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(obj.immobiliennr, 'RL', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(obj.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
utab1.housenumber AS houseNumber,
CONCAT('1', 
	CONCAT(SUBSTR(CONCAT('00', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(obj.immobiliennr, 'BÜ', ''), 'RL', ''), 'OP', ''), 'ST', ''), 'SB', ''), 'SW', '')), -2), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab1.housenumber), '999')), -3), 
	CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab4.levelNumber), '999')), -3), 
	SUBSTR(CONCAT('000', objNr.objNumber), -3))))
) AS objectNumber,
TO_NUMBER(ausstattung.ausst_nr) AS uniqueEquipmentNumber,
ausstattung.typ AS shortDesignation,
CASE WHEN ausstattung.tk_ausstkat IN ('220005','220019','220020') THEN 1 ELSE CASE WHEN ausstattung.tk_ausstkat IN ('220001','220002') THEN 2 ELSE CASE WHEN ausstattung.tk_ausstkat = '220004' THEN 3 ELSE CASE WHEN ausstattung.tk_ausstkat = '220003' THEN 5 ELSE CASE WHEN ausstattung.tk_ausstkat = '220006' THEN 6 ELSE CASE WHEN ausstattung.tk_ausstkat = '220014' THEN 7 ELSE 8 END END END END END END AS equipmentType,
CASE WHEN ausstattung.tk_ausstgrp = 20 THEN 1 ELSE 2 END AS equipmentCategory,
TO_CHAR(einbaudatum, 'DD.MM.YYYY') AS dateOfPurchase,
'' AS warrantyUntil,
'' AS durationOfUse,
'' AS serialNumber,
'' AS "size",
'' AS amount,
'' AS validFrom,
'' AS stateNumber,
ausstattung.beschrieb AS designation

FROM 
ausstattung 
INNER JOIN referenz_obj ON referenz_obj.key_obj = ausstattung.key_obj 
INNER JOIN obj ON obj.objstmnr = referenz_obj.objstmnr AND obj.immobiliennr = referenz_obj.immobiliennr AND obj.stwstmnr = referenz_obj.stwstmnr AND obj.gebstmnr = referenz_obj.gebstmnr
LEFT OUTER JOIN (
SELECT 
CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
ROW_NUMBER() OVER (PARTITION BY immoteil.immobiliennr ORDER BY immobilie.immobiliennr, immoteil.gebstmnr) AS houseNumber,
immoteil.gebstmnr

FROM 
immoteil 
INNER JOIN immobilie ON immobilie.immobiliennr = immoteil.immobiliennr 
WHERE NVL(immoteil.abdat, '31.12.9999') > '31.12.2022'
) utab1 ON utab1.realestatenumber = CASE WHEN obj.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(obj.immobiliennr, 'SW', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(obj.immobiliennr, 'SB', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(obj.immobiliennr, 'ST', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(obj.immobiliennr, 'OP', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(obj.immobiliennr, 'RL', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(obj.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AND utab1.gebstmnr = obj.gebstmnr
LEFT OUTER JOIN (SELECT CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber, ROW_NUMBER() OVER (PARTITION BY immoteil.immobiliennr ORDER BY immobilie.immobiliennr, immoteil.gebstmnr) AS houseNumber, immoteil.gebstmnr FROM immoteil INNER JOIN immobilie ON immobilie.immobiliennr = immoteil.immobiliennr ) utab3 ON utab3.realestatenumber = CASE WHEN obj.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(obj.immobiliennr, 'SW', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(obj.immobiliennr, 'SB', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(obj.immobiliennr, 'ST', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(obj.immobiliennr, 'OP', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(obj.immobiliennr, 'RL', '')) ELSE CASE WHEN obj.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(obj.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AND utab3.gebstmnr = obj.gebstmnr
LEFT OUTER JOIN (
	SELECT 
	CASE WHEN stw.tk_stwart = '0010' THEN '901' ELSE CASE WHEN stw.tk_stwart = '1000' THEN '100' ELSE CASE WHEN stw.tk_stwart = '1010' THEN '101' ELSE CASE WHEN stw.tk_stwart = '1020' THEN '102' ELSE CASE WHEN stw.tk_stwart = '1030' THEN '103' ELSE CASE WHEN stw.tk_stwart = '1040' THEN '104' ELSE CASE WHEN stw.tk_stwart = '1050' THEN '105' ELSE CASE WHEN stw.tk_stwart = '1060' THEN '106' ELSE CASE WHEN stw.tk_stwart = '0009' THEN '902' ELSE CASE WHEN stw.tk_stwart = '0008' THEN '903' ELSE CASE WHEN stw.tk_stwart = '1070' THEN '107' ELSE '900' END END END END END END END END END END END AS levelnumber,
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
) utab4 ON utab4.immobiliennr = obj.immobiliennr AND utab4.gebstmnr = obj.gebstmnr AND utab4.stwstmnr = obj.stwstmnr 
LEFT OUTER JOIN (
	SELECT 
	obj.immobiliennr,
	obj.gebstmnr,
	obj.stwstmnr,
	obj.objstmnr,
	ROW_NUMBER() OVER (PARTITION BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr ORDER BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr,	obj.objstmnr) AS objNumber 
	FROM obj 
) objNr ON objNr.immobiliennr = obj.immobiliennr AND objNr.gebstmnr = obj.gebstmnr AND objNr.stwstmnr = obj.stwstmnr AND objNr.objstmnr = obj.objstmnr

WHERE 
ausstattung.tk_ausstbez = '22'
AND ausstattung.tk_ausstkat IN ('220001','220002','220003','220004','220005','220006','220014','220015','220019','220020')
AND utab1.housenumber IS NOT NULL


-- text_8052 - Für TK_AUSSTKAT
-- text_8051 - TK_AUSSTBEZ
-- text_8202 - TK_AUSSTGRP