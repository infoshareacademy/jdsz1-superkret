-- SK-JDSZ1SK-34
--Liczba wniosków w zależności od dnia tygodnia i kanału


SELECT
  to_char(data_utworzenia, 'day') dzien, kanal,
  count(id) suma_wnioskow,
  sum(count(id)) over(partition by kanal) okno_kanal,
  round(count(id)/sum(count(id)) over(partition by kanal)::numeric,4) proc_kanal, 
-- udział poszczególnych dni tygodnia w kanale (bezpośredni lub pośredni)
  sum(count(id)) over(partition by to_char(data_utworzenia, 'day')) okno_data,
  round(count(id)/sum(count(id)) over(partition by to_char(data_utworzenia, 'day'))::numeric,4) proc_data 
-- udzial poszczegolnych kanalow w konkretnym dniu tygodnia
  --sum(count(id)) over()
FROM wnioski
GROUP BY 1, 2;

