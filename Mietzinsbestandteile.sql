-- Mietzinsbestandteile.sql

SELECT DISTINCT
utab1.objectContractNumber,
TO_CHAR(utab1.ab_datum, 'DD.MM.YYYY') AS validFrom,
CASE WHEN obj_preis.tk_ertragsart = '01' THEN 1 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '02' THEN 1 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '03' THEN 1 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '04' THEN 1 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '05' THEN 1 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '06' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '07' THEN 1 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '08' THEN 1 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '10' THEN 800 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '11' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '20' THEN 160 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '21' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '30' THEN 480 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '31' THEN 450 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '33' THEN 470 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '34' THEN 700 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '35' THEN 470 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '36' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '37' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '38' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '39' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '40' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '41' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '42' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '43' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '44' THEN 460 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '50' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '51' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '52' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '53' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '54' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '60' THEN 9999 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '211' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '213' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '215' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '217' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '219' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '223' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '225' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '226' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '227' THEN 150 ELSE 
CASE WHEN obj_preis.tk_ertragsart = '228' THEN 150 END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END END AS rentComponentNumber,
NVL(obj_preis.mpreis, 0) AS amount


FROM 
obj_preis 

INNER JOIN 
(SELECT 
TEMP10.ID AS objectContractNumber,
mv.beginndat AS ab_datum,
vertragsobjekt.immobiliennr,
vertragsobjekt.gebstmnr,
vertragsobjekt.stwstmnr,
vertragsobjekt.objstmnr


FROM 
vertragsobjekt 
INNER JOIN mv ON mv.mv = vertragsobjekt.mv AND mv.partner_id = vertragsobjekt.partner_id 
INNER JOIN TEMP9 ON TEMP9.partner_id = mv.partner_id 
INNER JOIN TEMP10 ON TEMP10.immobiliennr = vertragsobjekt.immobiliennr AND TEMP10.gebstmnr = vertragsobjekt.gebstmnr AND TEMP10.stwstmnr = vertragsobjekt.stwstmnr AND TEMP10.objstmnr = vertragsobjekt.objstmnr 

WHERE 
1 = 1
AND NVL(mv.endedat, '31.12.9999') > SYSDATE) utab1 ON utab1.immobiliennr = obj_preis.immobiliennr AND utab1.gebstmnr = obj_preis.gebstmnr AND utab1.stwstmnr = obj_preis.stwstmnr AND utab1.objstmnr = obj_preis.objstmnr 
INNER JOIN (SELECT obj_preis.immobiliennr, obj_preis.gebstmnr, obj_preis.stwstmnr, obj_preis.objstmnr, MAX(obj_preis.zudat) AS newest FROM obj_preis GROUP BY obj_preis.immobiliennr, obj_preis.gebstmnr, obj_preis.stwstmnr, obj_preis.objstmnr) utab2 ON
utab2.immobiliennr = obj_preis.immobiliennr AND utab2.gebstmnr = obj_preis.gebstmnr AND utab2.stwstmnr = obj_preis.stwstmnr AND utab2.objstmnr = obj_preis.objstmnr AND obj_preis.zudat = utab2.newest 

ORDER BY 
utab1.objectContractNumber