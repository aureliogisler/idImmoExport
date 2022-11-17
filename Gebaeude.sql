SELECT 
CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END AS realEstateNumber,
ROW_NUMBER() OVER (PARTITION BY immoteil.immobiliennr ORDER BY immobilie.immobiliennr, immoteil.gebstmnr) AS houseNumber,
immoteil.gebbez AS street,
immoteil.plz AS zip,
immoteil.ort AS city,
immobilie.tk_land AS canton,
immobilie.tk_staat AS country,
1 AS houseTyp,
immoteil.gebstmnr AS hausNr,
'' AS dateOfPurchase,
'' AS dateOfSale,
extract(year from geb.fertigdat) AS constructionYear,
'true' AS entranceSwitch,
'' AS buildingInsuranceVolume,
'' AS officialValue,
'' AS buildingInsuranceValue,
'' AS buildingInsuranceValueDate,
extpm_geb.nr AS federalBuildingIdentifier,
'' AS designation,
'' AS officialValueDate

FROM 
immoteil 
INNER JOIN immobilie ON immobilie.immobiliennr = immoteil.immobiliennr 
LEFT JOIN extpm_geb ON extpm_geb.immobiliennr = immobilie.immobiliennr AND extpm_geb.gebstmnr = immoteil.gebstmnr 
LEFT OUTER JOIN geb ON geb.immobiliennr = immoteil.immobiliennr AND geb.gebstmnr = immoteil.gebstmnr

WHERE 
immobilie.immobiliennr != '99VW'
AND NVL(immobilie.abdat, '31.12.9999') > '31.12.2022'
AND NVL(immoteil.abdat, '31.12.9999') > '31.12.2022'

ORDER BY 
CASE WHEN immobilie.immobiliennr LIKE '%SW' THEN CONCAT('1000', REPLACE(immobilie.immobiliennr, 'SW', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%SB' THEN CONCAT('1010', REPLACE(immobilie.immobiliennr, 'SB', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%ST' THEN CONCAT('1020', REPLACE(immobilie.immobiliennr, 'ST', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%OP' THEN CONCAT('1030', REPLACE(immobilie.immobiliennr, 'OP', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%RL' THEN CONCAT('1040', REPLACE(immobilie.immobiliennr, 'RL', '')) ELSE CASE WHEN immobilie.immobiliennr LIKE '%BÜ' THEN CONCAT('1050', REPLACE(immobilie.immobiliennr, 'BÜ', '')) ELSE '' END END END END END END,
immoteil.gebstmnr