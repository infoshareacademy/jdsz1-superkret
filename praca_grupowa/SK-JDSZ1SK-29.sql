/*
JDSZ1SK-29

Krótkofalowa (aktualny miesiąc) predykcja wniosków

Posiadając minimalną liczbę wniosków na każdy miesiąc, chcemy monitorować ich przyrost, tak aby wykonać niezbędne minimum na koniec miesiąca.
potrzebna analiza dzienna pokazująca trend "gdzie będziemy idąc takim tempem jak teraz"
*/

SELECT *
FROM wnioski;

with moje_daty as (select -- to jest odpowiedzialne za wygenerowanie dat z przyszlosci
 generate_series(
     date_trunc('day', '2018-01-20'::date), -- jaki jest pierwszy dzien generowania - jest DAY bo chcemy wygnereować od konkretnego dnia na nie miesiąca czy roku
     date_trunc('month', now())+interval '1 month'-interval '1 day', -- koncowy dzien generowania
     '1 day')::date as wygenerowana_data --interwał, co ile dni/miesiecy/tygodni dodawac kolejne rekordy
 ),

aktualne_wnioski as ( -- to jest kawalek odpowiedzialny za aktualna liczba wnioskow
   select to_char(data_utworzenia, 'YYYY-MM-DD')::date data_wniosku, count(1) liczba_wnioskow
   from wnioski
   group by 1
 ),

lista_z_wnioskami as (
select md.wygenerowana_data, -- dla danej daty
  coalesce(liczba_wnioskow, 0) liczba_wnioskow,-- powiedz ile bylo wnioskow w danym dniu
 sum(aw.liczba_wnioskow) over(order by md.wygenerowana_data) skumulowana_liczba_wnioskow -- laczna liczba wnioskow dzien po dniu
from moje_daty md
left join aktualne_wnioski aw on aw.data_wniosku = md.wygenerowana_data --left join dlatego, ze niektore dni nie maja jeszcze wnioskow. wlasnie dla nich bede robil predykcje
order by 1
  ),

statystyki_dnia AS (
      SELECT
        to_char(wygenerowana_data, 'Day') dzien,
        round(avg(liczba_wnioskow)) przewidywana_liczba_wnioskow --zaokrąglenie  ---zmieniona nazwa by była odpowiadająca do naszej predykcji
      FROM lista_z_wnioskami
      WHERE wygenerowana_data <= '2018-02-09'
      GROUP BY 1
      ORDER BY 1
  )

SELECT lw.wygenerowana_data,
  CASE
  WHEN  wygenerowana_data <= '2018-02-09' then liczba_wnioskow
  ELSE przewidywana_liczba_wnioskow END final_l_wnios,
  sum(CASE
  WHEN  wygenerowana_data <= '2018-02-09' then liczba_wnioskow
  ELSE przewidywana_liczba_wnioskow END) OVER (ORDER BY wygenerowana_data) skumulowana_l_wnioskow


FROM lista_z_wnioskami lw
JOIN statystyki_dnia sd ON sd.dzien =to_char(lw.wygenerowana_data, 'Day')   ---do listy z wnioksmai chcę dodać dane takie jak nazwy dni tygodnia oraz dodać liczbę wniosków
;