SELECT 
austritt_dat,
CASE WHEN kundenkto.partner_id != '000001' THEN kundenkto.partner_id + 100 END AS debtorNumber,
1 AS contractStatus,
TO_CHAR(eintritt_dat, 'DD.MM.YYYY') AS contractDate,
CASE WHEN SUBSTR(kundenkto.KONTO, 1, 1) = 'D' THEN '2' ELSE '1' END AS contractCode,
kundenkto.konto AS designation,
'' AS beneficiarySwitch,
'' AS beneficiaryAccount,
'' AS pensionFundPortionSwitch,
'' AS pensionFundAddressNumber,
'' AS pensionFundPortion,
'' AS outpaymentBlocked,
CASE WHEN austritt_dat IS NULL THEN 'false' ELSE 'true' END AS contractTerminationSwitch,
'' AS terminationDate,
austritt_dat AS terminationDateOn,
'' AS assignedFrom,
'' AS assignedUntil,
CASE WHEN immobiliennr IS NULL THEN 'true' ELSE 'false' END AS independentOfObject,
immobiliennr AS objectContractNumber,
0 AS amount,
ROWNUM AS keyNumber,
'31.03.2022' AS valueDate,
NVL(utab2.saldo_dk * (-1), 0) AS amount,
'' AS text1,
'' AS text2

FROM 
kundenkto 
LEFT OUTER JOIN (SELECT SUM(IST_SOLL - IST_HABEN) AS saldo_dk, konto FROM akdk_umsaetze WHERE 1 = 1 AND TO_DATE(ADD_MONTHS(TO_DATE(CONCAT(CONCAT(CONCAT('01.', TO_CHAR(CASE WHEN TO_NUMBER(akdk_umsaetze.fiscal_bumo) > 12 THEN '12' ELSE CASE WHEN TO_NUMBER(akdk_umsaetze.fiscal_bumo) < 1 THEN '01' ELSE akdk_umsaetze.fiscal_bumo END END)), '.'), TO_CHAR(akdk_umsaetze.kalenderjahr))), 1)) - 1 <= '31.03.2022' AND tk_partnerart = 'DARLK' AND (akdk_umsaetze.sammelkonto_haben = '2300' OR akdk_umsaetze.sammelkonto_soll = '2300') GROUP BY konto) utab2 ON utab2.konto = kundenkto.konto

WHERE 
1 = 1 
AND NVL(austritt_dat, '31.12.9999') > '31.03.2022'
AND SUBSTR(kundenkto.KONTO, 1, 1) = 'D'
--AND kundenkto.konto = 'DK-005870'
AND NVL(utab2.saldo_dk * (-1), 0) != 0
