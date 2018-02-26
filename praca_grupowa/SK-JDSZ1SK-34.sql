-- SK-JDSZ1SK-34
--Liczba wniosków w zależności od dnia tygodnia i kanału

with moje_dane as ( --Dodaję WITH by posortować dane
    SELECT
      to_char(data_utworzenia, 'D'),
      to_char(data_utworzenia, 'day') dzien,
      kanal,
      count(id) suma_wnioskow,
      sum(count(id))
      OVER (
        PARTITION BY kanal ) okno_kanal,
      round(count(id) / sum(count(id))
      OVER (
        PARTITION BY kanal ) :: NUMERIC, 4)  proc_kanal, -- udział poszczególnych dni tygodnia w kanale (bezpośredni lub pośredni)
      sum(count(id)) OVER (PARTITION BY to_char(data_utworzenia, 'day') ) okno_data,
      round(count(id) / sum(count(id)) OVER (PARTITION BY to_char(data_utworzenia, 'day') ) :: NUMERIC, 4) proc_data -- udzial poszczegolnych kanalow w konkretnym dniu tygodnia
    --wykasowałem wykomentowane linijki
    FROM wnioski
    GROUP BY 1,2, 3
    --dodaję sortowanie bo dane są nieuporządkowane
    ORDER BY 1
)
SELECT dzien, suma_wnioskow, okno_kanal, proc_kanal, okno_data, proc_data  --selekcjonuję dane które były w WITH ale już uporządkowane
FROM moje_dane;

