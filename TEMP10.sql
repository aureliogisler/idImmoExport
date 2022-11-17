
  CREATE TABLE "IMMO"."TEMP10" 
   (	"ID" NUMBER(*,0), 
	"IMMOBILIENNR" VARCHAR2(20 BYTE), 
	"GEBSTMNR" VARCHAR2(20 BYTE), 
	"STWSTMNR" VARCHAR2(20 BYTE), 
	"OBJSTMNR" VARCHAR2(20 BYTE), 
	"MV" VARCHAR2(20 BYTE)
   ) SEGMENT CREATION IMMEDIATE 
  PCTFREE 10 PCTUSED 40 INITRANS 1 MAXTRANS 255 NOCOMPRESS LOGGING
  STORAGE(INITIAL 65536 NEXT 1048576 MINEXTENTS 1 MAXEXTENTS 2147483645
  PCTINCREASE 0 FREELISTS 1 FREELIST GROUPS 1 BUFFER_POOL DEFAULT FLASH_CACHE DEFAULT CELL_FLASH_CACHE DEFAULT)
  TABLESPACE "USERS" ;
 



INSERT INTO TEMP10 (id,immobiliennr,gebstmnr,stwstmnr,objstmnr,partner_id,mv)  
SELECT DISTINCT
-- CONCAT('1', 
	-- CONCAT(SUBSTR(CONCAT('00', REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(vertragsobjekt.immobiliennr, 'BÜ', ''), 'RL', ''), 'OP', ''), 'ST', ''), 'SB', ''), 'SW', '')), -2), 
	-- CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab3.housenumber), '999')), -3), 
	-- CONCAT(SUBSTR(CONCAT('000', NVL(remove_letters(utab1.levelNumber), '999')), -3), 
	-- SUBSTR(CONCAT('000', objNr.objNumber), -3))))
-- ) AS objectNumber,
vertragsobjekt.immobiliennr,
vertragsobjekt.gebstmnr,
vertragsobjekt.stwstmnr,
vertragsobjekt.objstmnr,
vertragsobjekt.partner_id,
mv.mv

FROM vertragsobjekt 
LEFT OUTER JOIN (
	SELECT 
	obj.immobiliennr,
	obj.gebstmnr,
	obj.stwstmnr,
	obj.objstmnr,
	ROW_NUMBER() OVER (PARTITION BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr ORDER BY obj.immobiliennr, obj.gebstmnr, obj.stwstmnr,	SUBSTR(obj.objstmnr, -2)) AS objNumber 
	FROM obj 
) objNr ON objNr.immobiliennr = vertragsobjekt.immobiliennr AND objNr.gebstmnr = vertragsobjekt.gebstmnr AND objNr.stwstmnr = vertragsobjekt.stwstmnr AND objNr.objstmnr = vertragsobjekt.objstmnr
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

WHERE 
1 = 1 
AND NVL(mv.endedat, '31.12.9999') > SYSDATE