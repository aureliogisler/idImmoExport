-- Vertragsparnter.sql

SELECT 
TEMP10.ID AS objectContractNumber,
CASE WHEN utab1.partner_id != 1 THEN utab1.partner_id + 100 ELSE TO_NUMBER(utab1.partner_id) END AS AddressNumber,
utab1.type,
'false' AS ForCooperative,
1 AS MandatoryPortionType,
ROUND(1 / (NVL(utab2.rowCounter, 0) + 1), 2) AS MandatoryPortionAmount

FROM
TEMP10
LEFT OUTER JOIN (
SELECT 
TEMP10.ID AS main_id,
partner.partner_id,
10 AS type

FROM
TEMP10 
INNER JOIN partner ON partner.partner_id = TEMP10.partner_id 

UNION ALL

SELECT 
TEMP10.ID AS main_id,
partner.partner_id,
20 AS type

FROM 
TEMP10 
INNER JOIN solidarmieter ON solidarmieter.partner_id = TEMP10.partner_id AND TEMP10.mv = solidarmieter.mv 
INNER JOIN partner ON partner.partner_id = solidarmieter.i_partner_id 
INNER JOIN mv ON mv.partner_id = solidarmieter.partner_id AND mv.mv = solidarmieter.mv 

WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE
) 

utab1 ON utab1.main_id = TEMP10.ID 

LEFT OUTER JOIN (SELECT COUNT(*) AS rowCounter, solidarmieter.partner_id, solidarmieter.mv FROM solidarmieter INNER JOIN mv ON mv.partner_id = solidarmieter.partner_id AND mv.mv = solidarmieter.mv WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE GROUP BY solidarmieter.partner_id, solidarmieter.mv) utab2 ON utab2.Partner_id = TEMP10.partner_id AND utab2.mv = TEMP10.mv

ORDER BY 
Temp10.id,
utab1.type