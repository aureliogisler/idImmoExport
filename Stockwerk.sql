SELECT 
CASE WHEN stw.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(stw.immobiliennr, 'SW', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(stw.immobiliennr, 'SB', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(stw.immobiliennr, 'ST', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(stw.immobiliennr, 'OP', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(stw.immobiliennr, 'RL', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(stw.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
utab1.housenumber AS houseNumber,
CASE WHEN stw.tk_stwart = '0010' THEN '901' ELSE CASE WHEN stw.tk_stwart = '1000' THEN '100' ELSE CASE WHEN stw.tk_stwart = '1010' THEN '101' ELSE CASE WHEN stw.tk_stwart = '1020' THEN '102' ELSE CASE WHEN stw.tk_stwart = '1030' THEN '103' ELSE CASE WHEN stw.tk_stwart = '1040' THEN '104' ELSE CASE WHEN stw.tk_stwart = '1050' THEN '105' ELSE CASE WHEN stw.tk_stwart = '1060' THEN '106' ELSE CASE WHEN stw.tk_stwart = '0009' THEN '902' ELSE CASE WHEN stw.tk_stwart = '0008' THEN '903' ELSE CASE WHEN stw.tk_stwart = '1070' THEN '107' ELSE CASE WHEN stw.tk_stwart = '1035' THEN '103' ELSE '900' END END END END END END END END END END END END AS floorNumber,
CASE WHEN stw.tk_stwart = '0010' THEN -1 ELSE CASE WHEN stw.tk_stwart = '1000' THEN 0 ELSE CASE WHEN stw.tk_stwart = '1010' THEN 1 ELSE CASE WHEN stw.tk_stwart = '1020' THEN 2 ELSE CASE WHEN stw.tk_stwart = '1030' THEN 3 ELSE CASE WHEN stw.tk_stwart = '1040' THEN 4 ELSE CASE WHEN stw.tk_stwart = '1050' THEN 5 ELSE CASE WHEN stw.tk_stwart = '1060' THEN 6 ELSE CASE WHEN stw.tk_stwart = '0009' THEN -2 ELSE CASE WHEN stw.tk_stwart = '0008' THEN -3 ELSE CASE WHEN stw.tk_stwart = '1070' THEN 7 ELSE CASE WHEN stw.tk_stwart = '1035' THEN 3 ELSE 90 END END END END END END END END END END END END AS levelNumber

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
WHERE NVL(immoteil.abdat, '31.12.9999') > '31.12.2022'
) utab1 ON utab1.realestatenumber = CASE WHEN stw.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(stw.immobiliennr, 'SW', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(stw.immobiliennr, 'SB', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(stw.immobiliennr, 'ST', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(stw.immobiliennr, 'OP', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(stw.immobiliennr, 'RL', '')) ELSE CASE WHEN stw.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(stw.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AND utab1.gebstmnr = stw.gebstmnr 
INNER JOIN immobilie ON immobilie.immobiliennr = stw.immobiliennr 

WHERE 
immobilie.immobiliennr != '99VW'
AND NVL(immobilie.abdat, '31.12.9999') > '31.12.2022' 
AND utab1.housenumber IS NOT NULL 

ORDER BY 
stw.immobiliennr,
utab1.housenumber,
CASE WHEN stw.tk_stwart = '0010' THEN -1 ELSE CASE WHEN stw.tk_stwart = '1000' THEN 0 ELSE CASE WHEN stw.tk_stwart = '1010' THEN 1 ELSE CASE WHEN stw.tk_stwart = '1020' THEN 2 ELSE CASE WHEN stw.tk_stwart = '1030' THEN 3 ELSE CASE WHEN stw.tk_stwart = '1040' THEN 4 ELSE CASE WHEN stw.tk_stwart = '1050' THEN 5 ELSE CASE WHEN stw.tk_stwart = '1060' THEN 6 ELSE CASE WHEN stw.tk_stwart = '0009' THEN -2 ELSE CASE WHEN stw.tk_stwart = '0008' THEN -3 ELSE CASE WHEN stw.tk_stwart = '1070' THEN 7 ELSE 90 END END END END END END END END END END END