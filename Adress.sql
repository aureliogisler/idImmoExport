--Adress.sql

SELECT 
partner.partner_id + 100,
CASE WHEN partner.vorname1 IS NULL THEN partner.name1 ELSE partner.nachname1 END AS name,
partner.vorname1,
SUBSTR(partner.such, 0, 16) AS kurzname,
adresse.tk_staat AS land,
CASE WHEN natuerliche_person.tk_anrede = '01' THEN 2 ELSE CASE WHEN natuerliche_person.tk_anrede = '02' THEN 1 ELSE 3 END END AS anrede,
CASE WHEN partner.vorname1 IS NULL THEN partner.name1 ELSE partner.nachname1 END AS anredename,
adresse.plz,
adresse.ort,
adresse.tk_sprache,
TRIM(SUBSTR(adresse.strasse, 0, LENGTH(TRIM(adresse.strasse)) - INSTR(REVERSE(TRIM(adresse.strasse)), ' '))) AS strasse,
TRIM(SUBSTR(adresse.strasse, LENGTH(TRIM(adresse.strasse)) - INSTR(REVERSE(TRIM(adresse.strasse)), ' ') + 1)) AS hausnummer,
NVL(adresse.postfach, '') AS postfach,
NVL(tel_privat.phone, '') AS telefonPrivat,
NVL(tel_geschaeft.phone, '') AS telefonGeschaeftlich,
NVL(mobil_privat.phone, '') AS mobilPrivat,
NVL(mobil_geschaeft.phone, '') AS mobilGeschaeft,
NVL(partner_email.email, '') AS email,
NVL(url.url, '') AS webseite,
NVL(CASE WHEN partner.vorname1 IS NULL THEN 2 ELSE 1 END, '') AS adressTyp,
'' AS gueltigAb,
'' AS bemerkung,
NVL(natuerliche_person.tk_nationalitaet, '') AS nationalitaet,
NVL(natuerliche_person.gebort, '') AS heimatort,
NVL(TO_CHAR(natuerliche_person.gebdatum, 'DD.MM.YYYY'), '') AS geburtsdatum,
NVL(CASE WHEN natuerliche_person.tk_geschlecht = '01' THEN 'w' ELSE 'm' END, '') AS geschlecht,
'' AS aufenthaltsbewilligung,
'' AS konfession,
NVL(CASE WHEN natuerliche_person.tk_famstand = '01' THEN 'ledig' ELSE CASE WHEN natuerliche_person.tk_famstand = '02' THEN 'verheiratet' ELSE CASE WHEN natuerliche_person.tk_famstand = '03' THEN 'getrennt' ELSE CASE WHEN natuerliche_person.tk_famstand = '04' THEN 'geschieden' ELSE CASE WHEN natuerliche_person.tk_famstand = '05' THEN 'verwitwet' ELSE '' END END END END END, '') AS zivilstand,
'' AS zivilstandAb,
NVL(natuerliche_person.beruf, '') AS berufsbezeichnung,
'' AS arbeitgeber,
'' AS arbeitgeber_ort,
'' AS versicherung,
'' AS policenNr,
partner.zusatzname || ' - ' || adresse.zusatz AS zusatzbemerkgung,
'' AS notizen

FROM 
partner 
LEFT OUTER JOIN (SELECT MAX(adresse.gdat) AS max_gueltig, partner_id FROM adresse GROUP By partner_id) utab1 ON utab1.partner_id = partner.partner_id 
INNER JOIN adresse ON adresse.partner_id = partner.partner_id AND adresse.gdat = utab1.max_gueltig 
LEFT OUTER JOIN (SELECT partner_id, LISTAGG(partner_tel.vorw_land || ' ' || partner_tel.vorw || ' ' || partner_tel.nr, ', ') WITHIN GROUP (ORDER BY partner_tel.partner_id) AS phone FROM partner_tel WHERE partner_tel.tk_telart = '02' AND partner_tel.vorw != '01' GROUP BY partner_id) tel_privat ON tel_privat.partner_id = partner.partner_id 
LEFT OUTER JOIN (SELECT partner_id, LISTAGG(partner_tel.vorw_land || ' ' || partner_tel.vorw || ' ' || partner_tel.nr, ', ') WITHIN GROUP (ORDER BY partner_tel.partner_id) AS phone FROM partner_tel WHERE partner_tel.tk_telart = '10' AND partner_tel.vorw != '01' GROUP BY partner_id) mobil_privat ON mobil_privat.partner_id = partner.partner_id 
LEFT OUTER JOIN (SELECT partner_id, LISTAGG(partner_tel.vorw_land || ' ' || partner_tel.vorw || ' ' || partner_tel.nr, ', ') WITHIN GROUP (ORDER BY partner_tel.partner_id) AS phone FROM partner_tel WHERE partner_tel.tk_telart = '01' AND partner_tel.vorw != '01' GROUP BY partner_id) tel_geschaeft ON tel_geschaeft.partner_id = partner.partner_id 
LEFT OUTER JOIN (SELECT partner_id, LISTAGG(partner_tel.vorw_land || ' ' || partner_tel.vorw || ' ' || partner_tel.nr, ', ') WITHIN GROUP (ORDER BY partner_tel.partner_id) AS phone FROM partner_tel WHERE partner_tel.tk_telart = '05' AND partner_tel.vorw != '01' GROUP BY partner_id) mobil_geschaeft ON mobil_geschaeft.partner_id = partner.partner_id 
LEFT OUTER JOIN (SELECT partner_id, LISTAGG(partner_tel.vorw_land || ' ' || partner_tel.vorw || ' ' || partner_tel.nr, ', ') WITHIN GROUP (ORDER BY partner_tel.partner_id) AS phone FROM partner_tel WHERE partner_tel.tk_telart = '20' AND partner_tel.vorw != '01' GROUP BY partner_id) fax_geschaeft ON fax_geschaeft.partner_id = partner.partner_id 
LEFT OUTER JOIN partner_email ON partner_email.partner_id = partner.partner_id 
LEFT OUTER JOIN partner_firma ON partner_firma.partner_id = partner.partner_id 
LEFT OUTER JOIN natuerliche_person ON natuerliche_person.partner_id = partner.partner_id 
LEFT OUTER JOIN url ON url.partner_id = partner.partner_id 
--LEFT OUTER JOIN kundenkto ON kundenkto.partner_id = partner.partner_id 
--LEFT OUTER JOIN mv mv_partner ON mv_partner.partner_id = partner.partner_id 
--LEFT OUTER JOIN mv mv_i_partner ON mv_i_partner.i_partner_id = partner.partner_id 
--LEFT OUTER JOIN mv mv_j_i_partner ON mv_j_i_partner.j_i_partner_id = partner.partner_id 
--LEFT OUTER JOIN solidarmieter ON solidarmieter.mv = mv_partner.mv AND solidarmieter.mv != '000'


WHERE 
1 = 1 
--AND partner.gueltig_bis is null 
AND (
    partner.partner_id IN (SELECT partner_id FROM kundenkto WHERE NVL(austritt_dat, '31.12.9999') > SYSDATE) 
    OR partner.partner_id IN (SELECT partner_id FROM mv WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE)
    --OR partner.partner_id IN (SELECT i_partner_id FROM mv WHERE endedat IS NULL) -- Wenn ich diese ausschliesse, habe ich keine Banken
    OR partner.partner_id IN (SELECT j_i_partner_id FROM mv WHERE endedat IS NULL)
    OR partner.partner_id IN (SELECT solidarmieter.partner_id FROM solidarmieter INNER JOIN mv ON mv.mv = solidarmieter.mv  AND mv.partner_id = solidarmieter.partner_id WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE)
    OR partner.partner_id IN (SELECT solidarmieter.i_partner_id FROM solidarmieter INNER JOIN mv ON mv.mv = solidarmieter.mv  AND mv.partner_id = solidarmieter.partner_id WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE)
    OR partner.partner_id IN (SELECT vertragsobjekt.partner_id FROM vertragsobjekt INNER JOIN mv ON mv.mv = vertragsobjekt.mv AND mv.partner_id = vertragsobjekt.partner_id WHERE NVL(mv.endedat, '31.12.9999') > SYSDATE) -- 
)
AND partner.partner_id <> '000001'
--AND tk_famstand NOT IN ('02','03','04','05')
--AND partner.partner_id IN (SELECT i_partner_id FROM mv WHERE endedat IS NULL)
--AND partner.partner_id NOT IN (SELECT partner_id FROM mv WHERE endedat IS NULL)
--AND partner.partner_id = '011051'
--TK_TELART: 10 = Mobil, 02 = , 01 = 
--AND CASE WHEN partner.vorname1 IS NULL THEN partner.name1 ELSE partner.nachname1 END LIKE '%UBS%'

ORDER BY 
partner.partner_id 

