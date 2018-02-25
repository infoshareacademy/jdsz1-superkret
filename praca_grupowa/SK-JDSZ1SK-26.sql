SELECT to_char(data_utworzenia,'YYYY-MM'),kanal, count(1),
  sum(count(1)) OVER (PARTITION BY to_char(data_utworzenia,'YYYY-MM')),
  ROUND(count(1) / sum(count(1)) OVER (PARTITION BY to_char(data_utworzenia,'YYYY-MM'))::NUMERIC * 100,3) procent_z_sumy
FROM wnioski
GROUP BY 1,2
ORDER BY 1,2