--ZADANIE 1
select to_char(now()-interval '8 days','YYYY-MM-DD Day');
--ZADANIE 2
select to_char(now()-INTERVAL '3 months','YYYY-MM-DD Day');
--ZADANIE 3
select floor((extract(day from '2011-01-01'::date)-1)/7)+1 tydzien_roku; -- rozwiazanie z internetu
select ceiling(date_part('doy', date '2017-01-01') /7) tydzien_roku; --rozwiazanie wlasne

--ZADANIE 4
with przypadki AS (
    SELECT
      p.id_wniosku,
      sp.identyfikator_operatora,
      sp.identyfikator_operator_operujacego,
      CASE
      WHEN identyfikator_operatora = identyfikator_operator_operujacego
        THEN 'taki_sam_operator'
      WHEN identyfikator_operatora != identyfikator_operator_operujacego
        THEN 'inny_operator'
      ELSE 'brakdanych' END rodzajprzypadku
    FROM szczegoly_podrozy sp
      JOIN podroze p ON sp.id_podrozy = p.id
)

SELECT rodzajprzypadku,COUNT(id_wniosku),
  SUM(COUNT(id_wniosku)) OVER (),
  round(COUNT (id_wniosku) / SUM(COUNT(id_wniosku)) OVER ()::NUMERIC *100,2) procent
FROM przypadki
GROUP BY rodzajprzypadku;

--ZADANIE 5
with pierwszy_wniosek AS (
    SELECT
      DISTINCT email,
      first_value(w.data_utworzenia) OVER ( PARTITION BY email ORDER BY w.data_utworzenia) pierwszywniosek,
      NTH_VALUE(w.data_utworzenia,2) over (PARTITION BY email ORDER BY  w.data_utworzenia ) drugiwniosek
    FROM wnioski w
      JOIN klienci k ON w.id = k.id_wniosku
)
SELECT *
FROM pierwszy_wniosek
  WHERE pierwszywniosek !=drugiwniosek
;

--ZADANIE 6 DO ZROBIENIA

with moje_daty as (select -- to jest odpowiedzialne za wygenerowanie dat z przyszlosci
  generate_series(
      date_trunc('day', '2018-01-20'::date),-- jaki jest pierwszy dzien generowania

      date_trunc('month', now())+interval '1 month'-interval '1 day', -- koncowy dzien generowania
      '1 day')::date  as wygenerowana_data --interwał, co ile dni/miesiecy/tygodni dodawac kolejne rekordy
   ),
  mojedaty_bez_24 as(
    select * from moje_daty
    WHERE wygenerowana_data !='2018-02-24'
  ),
aktualne_wnioski as ( -- to jest kawalek odpowiedzialny za aktualna liczba wnioskow
    select to_char(data_utworzenia, 'YYYY-MM-DD')::date data_wniosku, count(1) liczba_wnioskow
    from wnioski
    group by 1
  ),
lista_z_wnioskami as (
    select md.wygenerowana_data, -- dla danej daty
      coalesce(aw.liczba_wnioskow,0) liczba_wnioskow, -- powiedz ile bylo wnioskow w danym dniu, jesli byl NULL dodajemy coalesce
      sum(aw.liczba_wnioskow) over(order by md.wygenerowana_data) skumulowana_liczba_wnioskow -- laczna liczba wnioskow dzien po dniu
    from moje_daty md
    left join aktualne_wnioski aw on aw.data_wniosku = md.wygenerowana_data --left join dlatego, ze niektore dni nie maja jeszcze wnioskow. wlasnie dla nich bede robil predykcje
    order by 1),
statystyki_dnia as (
    select to_char(wygenerowana_data, 'Day') dzien,
      round(avg(liczba_wnioskow)) przew_liczba_wnioskow -- round aby nie uzupelniac liczbami zmiennoprzecinkowymi

    from lista_z_wnioskami
      where wygenerowana_data <= '2018-02-09'
    group by 1
    order by 1
    )
select lw.wygenerowana_data, liczba_wnioskow, przew_liczba_wnioskow,
  case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    WHEN wygenerowana_data  = '2018-02-26' then  '1000'
    else przew_liczba_wnioskow end finalna_liczba_wnioskow, -- dodaje case aby wybrac realna liczbe albo przewidywana w zaleznosci od daty

  sum(case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    WHEN wygenerowana_data  = '2018-02-26' then  '1000'
    else przew_liczba_wnioskow end) over(order by wygenerowana_data) skumulowana_z_predykcja -- dodaje funkcje okna aby zsumowac wartosci zarowo realne jak i predykcje
from lista_z_wnioskami lw
join statystyki_dnia sd on sd.dzien = to_char(lw.wygenerowana_data, 'Day')
;

-- zadanie 7
with moje_daty as (select -- to jest odpowiedzialne za wygenerowanie dat z przyszlosci
  generate_series(
      date_trunc('day', '2018-01-20'::date),-- jaki jest pierwszy dzien generowania

      date_trunc('month', now())+interval '1 month'-interval '1 day', -- koncowy dzien generowania
      '1 day')::date  as wygenerowana_data --interwał, co ile dni/miesiecy/tygodni dodawac kolejne rekordy
   ),
  mojedaty_bez_24 as(
    select * from moje_daty
    WHERE wygenerowana_data !='2018-02-24'
  ),
aktualne_wnioski as ( -- to jest kawalek odpowiedzialny za aktualna liczba wnioskow
    select to_char(data_utworzenia, 'YYYY-MM-DD')::date data_wniosku, count(1) liczba_wnioskow
    from wnioski
    group by 1
  ),
lista_z_wnioskami as (
    select md.wygenerowana_data, -- dla danej daty
      coalesce(aw.liczba_wnioskow,0) liczba_wnioskow, -- powiedz ile bylo wnioskow w danym dniu, jesli byl NULL dodajemy coalesce
      sum(aw.liczba_wnioskow) over(order by md.wygenerowana_data) skumulowana_liczba_wnioskow -- laczna liczba wnioskow dzien po dniu
    from moje_daty md
    left join aktualne_wnioski aw on aw.data_wniosku = md.wygenerowana_data --left join dlatego, ze niektore dni nie maja jeszcze wnioskow. wlasnie dla nich bede robil predykcje
    order by 1),
statystyki_dnia as (
    select to_char(wygenerowana_data, 'Day') dzien,
      round(avg(liczba_wnioskow)) przew_liczba_wnioskow -- round aby nie uzupelniac liczbami zmiennoprzecinkowymi

    from lista_z_wnioskami
      where wygenerowana_data <= '2018-02-09'
    group by 1
    order by 1
    )
select lw.wygenerowana_data, liczba_wnioskow, przew_liczba_wnioskow,
  case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    WHEN wygenerowana_data  = '2018-02-24' then  '0'
    else przew_liczba_wnioskow end finalna_liczba_wnioskow, -- dodaje case aby wybrac realna liczbe albo przewidywana w zaleznosci od daty

  sum(case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    WHEN wygenerowana_data  = '2018-02-24' then  '0'
    else przew_liczba_wnioskow end) over(order by wygenerowana_data) skumulowana_z_predykcja -- dodaje funkcje okna aby zsumowac wartosci zarowo realne jak i predykcje
from lista_z_wnioskami lw
join statystyki_dnia sd on sd.dzien = to_char(lw.wygenerowana_data, 'Day')
;

--zadanie 8(nieskonczone)
with roznica as(
SELECT
  w.id,
  (w.data_utworzenia - sp.data_wyjazdu) roznica_lot_a_wniosek
from wnioski w
join podroze p ON w.id = p.id_wniosku
join szczegoly_podrozy sp ON p.id = sp.id_podrozy

),
  mediana_roznica as(
  SELECT
  percentile_cont(0.5) WITHIN GROUP (ORDER BY roznica_lot_a_wniosek) mediana_roznicy
  from roznica
  )
SELECT * FROM mediana_roznica






--ZADANIE 9
--mediana czasu
    SELECT
      status,
      to_char(percentile_cont(0.5) WITHIN GROUP (ORDER BY a.data_utworzenia - w.data_utworzenia),'ss') mediana_sekundy,
      to_char(avg(a.data_utworzenia - w.data_utworzenia),'DD-HH')sredni_czas,
      to_char(percentile_cont(0.95) WITHIN GROUP (ORDER BY a.data_utworzenia - w.data_utworzenia),'DD-HH')wart_odst1,
      to_char(percentile_cont(0.05) WITHIN GROUP (ORDER BY a.data_utworzenia - w.data_utworzenia),'DD-HH') wart_odst2,
      to_char(percentile_cont(0.75) WITHIN GROUP (ORDER BY a.data_utworzenia - w.data_utworzenia),'DD-HH') trzeci_kwartyl,
      TO_CHAR(percentile_cont(0.25) WITHIN GROUP (ORDER BY a.data_utworzenia - w.data_utworzenia),'DD-HH') pierwszy_kwartyl

    FROM wnioski w
      JOIN analizy_wnioskow a ON w.id = a.id_wniosku
    GROUP BY 1


--zadanie 10
    SELECT
      jezyk,
      count(1)suma_wnioskow_jezyk,
      sum(count(1))OVER ()suma_wszystkich,
      round(count(1) / sum(count(1)) OVER () * 100, 2) procent
    FROM wnioski
    GROUP BY 1
    ORDER BY 1
--podpunkt 2
with jezykiklienta AS (
    SELECT
      email,
      first_value(jezyk) OVER (PARTITION BY email ORDER BY w.data_utworzenia ) pierwszyjezyk,
      last_value(jezyk) OVER (PARTITION BY email ORDER BY w.data_utworzenia ) ostatnijezyk
    FROM wnioski w
      JOIN klienci k ON w.id = k.id_wniosku
),
  badaniezmiany AS (
  SELECT email, pierwszyjezyk, ostatnijezyk,
  CASE
  WHEN pierwszyjezyk = ostatnijezyk THEN 'nie'
  ELSE 'tak' END czy_była_zmiana
  FROM jezykiklienta
  )
SELECT email,czy_była_zmiana,COUNT(czy_była_zmiana) liczba_zmian
FROM badaniezmiany
GROUP BY 1,2
HAVING count(czy_była_zmiana) >1
