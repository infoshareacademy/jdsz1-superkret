-- liczba wniosków w zależności od kanału i czasu


SELECT to_char(data_utworzenia,'YYYY-MM') as data, kanal,
  count(id) suma_wnioskow,
 sum(count(id)) OVER (PARTITION BY to_char(data_utworzenia,'YYYY-MM')) okno_daty,
ROUND(count(id) / sum(count(1)) OVER (PARTITION BY to_char(data_utworzenia,'YYYY-MM'))::NUMERIC * 100,3) procent_daty,
 sum(count(id)) OVER (PARTITION BY kanal) okno_kanalu,
ROUND(count(id) / sum(count(1)) OVER (PARTITION BY kanal)::NUMERIC * 100,3) procent_kanalu

FROM wnioski
GROUP BY 2,1
ORDER BY 1,2;

--dodałam aliasy i zależności od kanału (okno_kanalu i procent_kanalu)

