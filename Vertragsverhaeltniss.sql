-- Vertragsverhältniss.sql

SELECT 
TEMP9.ID AS objectContractNumber,
MIN(vertragsobjekt.partner_id||SUBSTR(vertragsobjekt.immobiliennr, 1, 2)||vertragsobjekt.mv||'001000000001199') AS ESR

FROM 
vertragsobjekt 
INNER JOIN (SELECT MAX(aend_ind) AS maxIndex, mv.mv, mv.partner_id, objstmnr, immobiliennr, stwstmnr, gebstmnr FROM vertragsobjekt INNER JOIN mv ON mv.mv = vertragsobjekt.mv AND mv.partner_id = vertragsobjekt.partner_id AND NVL(mv.endedat, '31.12.9999') > SYSDATE GROUP BY mv.mv, mv.partner_id, objstmnr, immobiliennr, stwstmnr, gebstmnr) utab1 ON utab1.mv = vertragsobjekt.mv AND utab1.partner_id = vertragsobjekt.partner_id  AND utab1.objstmnr = vertragsobjekt.objstmnr AND utab1.immobiliennr = vertragsobjekt.immobiliennr AND utab1.stwstmnr = vertragsobjekt.stwstmnr AND utab1.gebstmnr = vertragsobjekt.gebstmnr AND utab1.maxindex = vertragsobjekt.aend_ind 
LEFT OUTER JOIN (SELECT CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber, ROW_NUMBER() OVER (PARTITION BY immoteil.immobiliennr ORDER BY immobilie.immobiliennr, immoteil.gebstmnr) AS houseNumber, immoteil.gebstmnr FROM immoteil INNER JOIN immobilie ON immobilie.immobiliennr = immoteil.immobiliennr ) utab3 ON utab3.realestatenumber = CASE WHEN vertragsobjekt.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(vertragsobjekt.immobiliennr, 'SW', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(vertragsobjekt.immobiliennr, 'SB', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(vertragsobjekt.immobiliennr, 'ST', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(vertragsobjekt.immobiliennr, 'OP', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(vertragsobjekt.immobiliennr, 'RL', '')) ELSE CASE WHEN vertragsobjekt.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(vertragsobjekt.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AND utab3.gebstmnr = vertragsobjekt.gebstmnr
INNER JOIN mv ON mv.mv = vertragsobjekt.mv AND mv.partner_id = vertragsobjekt.partner_id 
INNER JOIN TEMP9 ON TEMP9.partner_id = vertragsobjekt.partner_id 

WHERE 
1 = 1
AND NVL(mv.endedat, '31.12.9999') > SYSDATE 

GROUP BY TEMP9.ID

ORDER BY 
TEMP9.ID
