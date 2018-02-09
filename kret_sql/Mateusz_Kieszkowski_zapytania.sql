SELECT d.id_dostawcy , dc.id_czesci
FROM dostawcy_czesci as dc, dostawcy as d
WHERE dc.id_dostawcy = d.id_dostawcy
AND id_czesci IS NULL

SELECT id_dostawcy, COUNT(id_czesci)
FROM dostawcy_czesci
GROUP BY id_dostawcy
ORDER BY COUNT(id_czesci) DESC

SELECT d.id_dostawcy
FROM dostawcy d, dostawcy_czesci dc
WHERE d.id_dostawcy = dc.id_dostawcy
AND data_zam IS NULL

SELECT AVG(data_przyj_mag - data_zam) AS avg_time
FROM dostawcy_czesci