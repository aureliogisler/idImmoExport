--Mieter.sql

SELECT DISTINCT
CASE WHEN MV.PARTNER_ID != 1 THEN MV.PARTNER_ID + 100 ELSE 1 END AS AdressNumber,
CASE WHEN SUBSTR(utab3.bit, 12, 1) = '1' THEN 1 ELSE 0 END AS TenantSwitch,
CASE WHEN SUBSTR(utab3.bit, 1, 1) = '1' OR SUBSTR(utab3.bit, 2, 1) = '1' OR SUBSTR(utab3.bit, 3, 1) = '1' THEN 1 ELSE 0 END AS CooperativeSwitch,
CASE WHEN LENGTH(mv.kontonr) = 21 THEN 23 ELSE CASE WHEN mv.tk_rechnungsstellung = 4 THEN 37 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 9 THEN 33 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 2 THEN 77 ELSE 1 END END END END AS BeneficiaryType, -- 2 = Sammelesr, 9 Debit Direct, 4 = LSV, 5 = Kein ESR, mit Sollstellung, 
CASE WHEN LENGTH(mv.kontonr) = 21 THEN mv.kontonr ELSE mv_zahlung.teiln_nr END AS BeneficiaryAccountNumber, 
'' AS IndexBank,
CASE WHEN SUBSTR(utab3.bit, 1, 1) = '1' OR SUBSTR(utab3.bit, 2, 1) = '1' OR SUBSTR(utab3.bit, 3, 1) = '1' THEN '3' ELSE 
CASE WHEN SUBSTR(utab3.bit, 1, 1) = '0' AND SUBSTR(utab3.bit, 2, 1) = '0' AND SUBSTR(utab3.bit, 3, 1) = '0' AND SUBSTR(utab3.bit, 12, 1) = '1' THEN '1' ELSE 
CASE WHEN SUBSTR(utab3.bit, 8, 1) = '1' OR SUBSTR(utab3.bit, 9, 1) = '1' OR SUBSTR(utab3.bit, 10, 1) = '1' THEN '7' ELSE '10' END END END AS StatusNumber,
TO_CHAR(utab4.minbegin, 'DD.MM.YYYY') AS ValidFrom,
CASE WHEN LENGTH(mv.kontonr) = 21 THEN 15 ELSE CASE WHEN mv.tk_rechnungsstellung = 4 THEN 20 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 9 THEN 21 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 2 THEN 10 ELSE 10 END END END END AS InkassoZahlverfahren,
15 AS ExkassoGutschrift

FROM 
MV 
LEFT OUTER JOIN (SELECT MAX(MV) maxMv, partner_id FROM mv WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE GROUP BY partner_id) utabMax ON utabMax.partner_id = mv.partner_id
INNER JOIN partner ON partner.partner_id = mv.partner_id 
LEFT OUTER JOIN solidarmieter ON solidarmieter.partner_id = partner.partner_id 
LEFT JOIN partner_partner ON (partner_partner.partner_id = partner.partner_id OR partner_partner.i_partner_id = partner.partner_id) and partner_partner.tk_partnerart_detail = 01 

LEFT JOIN (SELECT CASE WHEN anteil.partner_id IS NULL THEN '0' ELSE '1' END || CASE WHEN anteil_n.partner_id IS NULL THEN '0' ELSE '1' END || CASE WHEN anteil_r.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN bank.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN darlk.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN darlk_n.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN debitor.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN eigent.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN hauswa.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN intere.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN kredit.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN miet_f.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN ohnekt.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN vers.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN hafter.partner_id IS NULL THEN '0' ELSE '1' END AS bit, partner.partner_id FROM partner 
LEFT JOIN geschaeftsbereich anteil ON anteil.partner_id = partner.partner_id AND anteil.tk_partnerart = 'ANTEIL'
LEFT JOIN geschaeftsbereich anteil_n ON anteil_n.partner_id = partner.partner_id AND anteil_n.tk_partnerart = 'ANTEIL-N'
LEFT JOIN geschaeftsbereich anteil_r ON anteil_r.partner_id = partner.partner_id AND anteil_r.tk_partnerart = 'ANTEIL-R'
LEFT JOIN geschaeftsbereich bank ON bank.partner_id = partner.partner_id AND bank.tk_partnerart = 'BANK'
LEFT JOIN geschaeftsbereich darlk ON darlk.partner_id = partner.partner_id AND darlk.tk_partnerart = 'DARLK'
LEFT JOIN geschaeftsbereich darlk_n ON darlk_n.partner_id = partner.partner_id AND darlk_n.tk_partnerart = 'DARLK-N'
LEFT JOIN geschaeftsbereich debitor ON debitor.partner_id = partner.partner_id AND debitor.tk_partnerart = 'DEBITO'
LEFT JOIN geschaeftsbereich eigent ON eigent.partner_id = partner.partner_id AND eigent.tk_partnerart = 'EIGENT'
LEFT JOIN geschaeftsbereich hauswa ON hauswa.partner_id = partner.partner_id AND hauswa.tk_partnerart = 'HAUSWA'
LEFT JOIN geschaeftsbereich intere ON intere.partner_id = partner.partner_id AND intere.tk_partnerart = 'INTERE'
LEFT JOIN geschaeftsbereich kredit ON kredit.partner_id = partner.partner_id AND kredit.tk_partnerart = 'KREDIT'
LEFT JOIN geschaeftsbereich miet_f ON miet_f.partner_id = partner.partner_id AND miet_f.tk_partnerart = 'MIET-F'
LEFT JOIN geschaeftsbereich ohnekt ON ohnekt.partner_id = partner.partner_id AND ohnekt.tk_partnerart = 'OHNEKT'
LEFT JOIN geschaeftsbereich vers ON vers.partner_id = partner.partner_id AND vers.tk_partnerart = 'VERS'
LEFT JOIN geschaeftsbereich hafter ON hafter.partner_id = partner.partner_id AND hafter.tk_partnerart = 'HAFTER') utab3 ON utab3.partner_id = mv.partner_id 
LEFT JOIN (SELECT MIN(mv.beginndat) AS minBegin, partner_id FROM mv WHERE NVL(MV.ENDEDAT, '31.12.9999') > SYSDATE GROUP BY partner_id) utab4 ON utab4.partner_id = mv.partner_id 
LEFT JOIN mv_zahlung ON mv_zahlung.mv = utabMax.maxMv AND mv_zahlung.partner_id = mv.partner_id 

WHERE 
1 = 1 
AND NVL(mv.endedat, '31.12.9999') > SYSDATE 
--AND partner.partner_id = 15497 
AND mv.mv = utabMax.maxMv
--AND mv.partner_id = '011050'
--AND SUBSTR(utab3.bit, 13, 1) = '1'

UNION ALL 

SELECT DISTINCT
CASE WHEN SOLIDARMIETER.I_PARTNER_ID != 1 THEN SOLIDARMIETER.I_PARTNER_ID + 100 ELSE 1 END AS AdressNumber,
CASE WHEN SUBSTR(utab3.bit, 12, 1) = '1' THEN 1 ELSE 0 END AS TenantSwitch,
CASE WHEN SUBSTR(utab3.bit, 1, 1) = '1' OR SUBSTR(utab3.bit, 2, 1) = '1' OR SUBSTR(utab3.bit, 3, 1) = '1' THEN 1 ELSE 0 END AS CooperativeSwitch,
CASE WHEN LENGTH(mv.kontonr) = 21 THEN 23 ELSE CASE WHEN mv.tk_rechnungsstellung = 4 THEN 37 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 9 THEN 33 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 2 THEN 77 ELSE 1 END END END END AS BeneficiaryType, -- 2 = Sammelesr, 9 Debit Direct, 4 = LSV, 5 = Kein ESR, mit Sollstellung, 
CASE WHEN LENGTH(mv.kontonr) = 21 THEN mv.kontonr ELSE mv_zahlung.teiln_nr END AS BeneficiaryAccountNumber, 
'' AS IndexBank,
CASE WHEN SUBSTR(utab3.bit, 1, 1) = '1' OR SUBSTR(utab3.bit, 2, 1) = '1' OR SUBSTR(utab3.bit, 3, 1) = '1' THEN '3' ELSE 
CASE WHEN SUBSTR(utab3.bit, 1, 1) = '0' AND SUBSTR(utab3.bit, 2, 1) = '0' AND SUBSTR(utab3.bit, 3, 1) = '0' AND SUBSTR(utab3.bit, 12, 1) = '1' THEN '1' ELSE 
CASE WHEN SUBSTR(utab3.bit, 8, 1) = '1' OR SUBSTR(utab3.bit, 9, 1) = '1' OR SUBSTR(utab3.bit, 10, 1) = '1' THEN '7' ELSE '10' END END END AS StatusNumber,
TO_CHAR(utab4.minbegin, 'DD.MM.YYYY') AS ValidFrom,
CASE WHEN LENGTH(mv.kontonr) = 21 THEN 15 ELSE CASE WHEN mv.tk_rechnungsstellung = 4 THEN 20 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 9 THEN 21 ELSE CASE WHEN mv_zahlung.tk_rechnungsstellung = 2 THEN 10 ELSE 10 END END END END AS InkassoZahlverfahren,
15 AS ExkassoGutschrift

FROM 
MV 
LEFT OUTER JOIN (SELECT MAX(MV) maxMv, partner_id FROM mv WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE GROUP BY partner_id) utabMax ON utabMax.partner_id = mv.partner_id
INNER JOIN partner ON partner.partner_id = mv.partner_id 
LEFT OUTER JOIN solidarmieter ON solidarmieter.partner_id = partner.partner_id 
LEFT JOIN partner_partner ON (partner_partner.partner_id = partner.partner_id OR partner_partner.i_partner_id = partner.partner_id) and partner_partner.tk_partnerart_detail = 01 

LEFT JOIN (SELECT CASE WHEN anteil.partner_id IS NULL THEN '0' ELSE '1' END || CASE WHEN anteil_n.partner_id IS NULL THEN '0' ELSE '1' END || CASE WHEN anteil_r.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN bank.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN darlk.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN darlk_n.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN debitor.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN eigent.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN hauswa.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN intere.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN kredit.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN miet_f.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN ohnekt.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN vers.partner_id IS NULL THEN '0' ELSE '1' END || 
CASE WHEN hafter.partner_id IS NULL THEN '0' ELSE '1' END AS bit, partner.partner_id FROM partner 
LEFT JOIN geschaeftsbereich anteil ON anteil.partner_id = partner.partner_id AND anteil.tk_partnerart = 'ANTEIL'
LEFT JOIN geschaeftsbereich anteil_n ON anteil_n.partner_id = partner.partner_id AND anteil_n.tk_partnerart = 'ANTEIL-N'
LEFT JOIN geschaeftsbereich anteil_r ON anteil_r.partner_id = partner.partner_id AND anteil_r.tk_partnerart = 'ANTEIL-R'
LEFT JOIN geschaeftsbereich bank ON bank.partner_id = partner.partner_id AND bank.tk_partnerart = 'BANK'
LEFT JOIN geschaeftsbereich darlk ON darlk.partner_id = partner.partner_id AND darlk.tk_partnerart = 'DARLK'
LEFT JOIN geschaeftsbereich darlk_n ON darlk_n.partner_id = partner.partner_id AND darlk_n.tk_partnerart = 'DARLK-N'
LEFT JOIN geschaeftsbereich debitor ON debitor.partner_id = partner.partner_id AND debitor.tk_partnerart = 'DEBITO'
LEFT JOIN geschaeftsbereich eigent ON eigent.partner_id = partner.partner_id AND eigent.tk_partnerart = 'EIGENT'
LEFT JOIN geschaeftsbereich hauswa ON hauswa.partner_id = partner.partner_id AND hauswa.tk_partnerart = 'HAUSWA'
LEFT JOIN geschaeftsbereich intere ON intere.partner_id = partner.partner_id AND intere.tk_partnerart = 'INTERE'
LEFT JOIN geschaeftsbereich kredit ON kredit.partner_id = partner.partner_id AND kredit.tk_partnerart = 'KREDIT'
LEFT JOIN geschaeftsbereich miet_f ON miet_f.partner_id = partner.partner_id AND miet_f.tk_partnerart = 'MIET-F'
LEFT JOIN geschaeftsbereich ohnekt ON ohnekt.partner_id = partner.partner_id AND ohnekt.tk_partnerart = 'OHNEKT'
LEFT JOIN geschaeftsbereich vers ON vers.partner_id = partner.partner_id AND vers.tk_partnerart = 'VERS'
LEFT JOIN geschaeftsbereich hafter ON hafter.partner_id = partner.partner_id AND hafter.tk_partnerart = 'HAFTER') utab3 ON utab3.partner_id = mv.partner_id 
LEFT JOIN (SELECT MIN(mv.beginndat) AS minBegin, partner_id FROM mv WHERE NVL(MV.ENDEDAT, '31.12.9999') > SYSDATE GROUP BY partner_id) utab4 ON utab4.partner_id = mv.partner_id 
LEFT JOIN mv_zahlung ON mv_zahlung.mv = utabMax.maxMv AND mv_zahlung.partner_id = mv.partner_id 

WHERE 
1 = 1 
AND NVL(mv.endedat, '31.12.9999') > SYSDATE 
--AND partner.partner_id = 15497 
AND mv.mv = utabMax.maxMv
--AND mv.partner_id = '011050'
--AND SUBSTR(utab3.bit, 13, 1) = '1'


ORDER BY 
AdressNumber ASC



