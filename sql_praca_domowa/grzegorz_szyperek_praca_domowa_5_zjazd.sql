--
--
-- OBOWIAZKOWE:
-- 1) Jaka data była 8 dni temu?

SELECT now()::date -INTERVAL '8 days';

-- 2) Jaki dzień tygodnia był 3 miesiące temu?

SELECT now()::date -INTERVAL '3 months';

-- 3) W którym tygodniu roku jest 01 stycznia 2017?

SELECT to_char('2017-01-01'::date, 'WW') numer_tygodnia;

-- 4) Podaj liczbę wniosków z właściwym operatorem (który rzeczywiście przeprowadził trasę)

SELECT count(w.id), --liczę liczbę wniosków
coalesce(identyfikator_operator_operujacego, identyfikator_operatora) operat_pkp --wybieram własciwego operatora który wiózł pasażera
FROM wnioski w --przywołuję tabelę wniosków
JOIN podroze p ON w.id = p.id_wniosku
JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
GROUP BY 2; --grupuję po operatorach

-- 5) Przygotuj listę klientów z datą utworzenia ich pierwszego i drugiego wniosku. 3 kolumny: email, data 1wszego wniosku, data 2giego wniosku

---drugi sposob----
WITH moje_dane as (
    SELECT
      kl.email,
      w.data_utworzenia as pierwszy_wniosek

    FROM klienci kl
      JOIN wnioski w ON kl.id_wniosku = w.id
GROUP BY 1, 2
  ORDER BY 2
)
SELECT *, lead(pierwszy_wniosek) OVER () drugi_wniosek
FROM moje_dane
LIMIT 1


-- 6) Używając pełen kod do predykcji wniosków, zmień go tak aby uwzględnić kampanię marketingową, która odbędzie się 26 lutego - przewidywana liczba wniosków z niej to 1000

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

SELECT lw.wygenerowana_data,liczba_wnioskow,  przewidywana_liczba_wnioskow,
  CASE
  WHEN  wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    WHEN wygenerowana_data = '2018-02-26' then 1000
  ELSE przewidywana_liczba_wnioskow
  END final_l_wnios,
  sum(
      CASE
  WHEN  wygenerowana_data <= '2018-02-09' then liczba_wnioskow
         WHEN wygenerowana_data = '2018-02-26' then 1000
  ELSE przewidywana_liczba_wnioskow
      END) OVER (ORDER BY wygenerowana_data) kumulacja_lotto


FROM lista_z_wnioskami lw
JOIN statystyki_dnia sd ON sd.dzien =to_char(lw.wygenerowana_data, 'Day')   ---do listy z wnioksmai chcę dodać dane takie jak nazwy dni tygodnia oraz dodać liczbę wniosków
;

-- 7) Używając pełen kod do predykcji wniosków, zmień go tak aby uwzględnić przymusową przerwę serwisową, w sobotę 24 lutego nie będzie można utworzyć żadnych wniosków

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

SELECT lw.wygenerowana_data,liczba_wnioskow,  przewidywana_liczba_wnioskow,
  CASE
  WHEN  wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    WHEN wygenerowana_data = '2018-02-24' then 0 --przerwa serwisowa
    WHEN wygenerowana_data = '2018-02-26' then 1000
  ELSE przewidywana_liczba_wnioskow
  END final_l_wnios,
  sum(
      CASE
  WHEN  wygenerowana_data <= '2018-02-09' then liczba_wnioskow
        WHEN wygenerowana_data = '2018-02-24' then 0
         WHEN wygenerowana_data = '2018-02-26' then 1000
  ELSE przewidywana_liczba_wnioskow
      END) OVER (ORDER BY wygenerowana_data) kumulacja_lotto


FROM lista_z_wnioskami lw
JOIN statystyki_dnia sd ON sd.dzien =to_char(lw.wygenerowana_data, 'Day')
;


-- 8) Ile (liczbowo) wniosków zostało utworzonych poniżej mediany liczonej z czasu między lotem i wnioskiem?

WITH moje_dane as (
  ---najpierw wyliczam roznice w dniach miedzy utworzeniem wniosku a lotem
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
  --nastepnie wyliczam mediany i je klasyfikuje
percentyl as (
  SELECt percentile_cont(0.5) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach)
  FROM moje_dane
)
SELECT *
from percentyl;

WITH moje_dane AS (
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
percentyl as (
  SELECt percentile_cont(0.5) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach asc) percyl
  FROM moje_dane
)
SELECT count(1) wnioski_poniżej_mediany
FROM moje_dane
WHERE czas_miedzy_wnioskiem_a_lotem_w_dniach <
      (SELECT percyl
       FROM percentyl);

---count = 197795 bez porownania dat
---count = 30465 przy porownaniu data_utw we wenioskach i data_utw ze szczegolu podrozy

---ODP---98563 wnioskow bylo ponizej mediany


-- 9) Mając czas od utworzenia wniosku do jego analizy przygotuj statystyke:
--
--     jaka jest mediana czasu?

WITH moje_dane as (
  ---najpierw wyliczam roznice w dniach miedzy utworzeniem wniosku a lotem
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
  --nastepnie wyliczam mediany i je klasyfikuje
percentyl as (
  SELECt percentile_cont(0.5) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach)
  FROM moje_dane
)
SELECT *
from percentyl;

WITH moje_dane AS (
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
)
  SELECt percentile_cont(0.5) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach asc) mediana_czasu
  FROM moje_dane

---ODP---Medaiana wynosi 20 dni.

--     jaka jest srednia czasu?

WITH moje_dane as (
  ---najpierw wyliczam roznice w dniach miedzy utworzeniem wniosku a lotem
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
  --nastepnie wyliczam mediany i je klasyfikuje
percentyl as (
  SELECt percentile_cont(0.5) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach)
  FROM moje_dane
)
SELECT *
from percentyl;

WITH moje_dane AS (
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
)
  SELECt avg(czas_miedzy_wnioskiem_a_lotem_w_dniach) srednia_ilosc_dni_od_lotu_do_utworzenia_wniosku
  FROM moje_dane
---ODP---Srednia wynosi 133 dni.

--     jakie mamy wartości odstające?

WITH moje_dane AS (
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
)
  SELECT
    min(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    max(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    avg(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    percentile_cont(0.25) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p25,
    percentile_cont(0.50) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p50,
    percentile_cont(0.75) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p75,
    percentile_cont(0.90) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p90,
    percentile_cont(0.95) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p95,
    percentile_cont(0.99) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p99,
    percentile_cont(0.9999) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p9999
FROM moje_dane;

---ODP---wartości odstające wynikają z błędów w zapisie dat i braku zabezpieczenia takich błędów użytkowników. Wartość minimalna wynosi -1732591 co świadczy o błędnym zapisie daty który mówi że wnioske powstał jeszcze przed podróżą :P


--     ile jest wnioskow ponizej p75?

WITH moje_dane as (
  ---najpierw wyliczam roznice w dniach miedzy utworzeniem wniosku a lotem
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
  --nastepnie wyliczam mediany i je klasyfikuje
percentyl as (
  SELECt percentile_cont(0.5) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach)
  FROM moje_dane
)
SELECT *
from percentyl;

WITH moje_dane AS (
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
percentyl as (
  SELECt percentile_cont(0.75) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach asc) percyl
  FROM moje_dane
)
SELECT count(1) wnioski_powyzej_p75
FROM moje_dane
WHERE czas_miedzy_wnioskiem_a_lotem_w_dniach >
      (SELECT percyl
       FROM percentyl);
---ODP---Istnieje 49218 wniosków powyżej p75

--     ile jest wnioskow powyzej p25?

WITH moje_dane as (
  ---najpierw wyliczam roznice w dniach miedzy utworzeniem wniosku a lotem
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
  --nastepnie wyliczam mediany i je klasyfikuje
percentyl as (
  SELECt percentile_cont(0.5) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach)
  FROM moje_dane
)
SELECT *
from percentyl;

WITH moje_dane AS (
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
),
percentyl as (
  SELECt percentile_cont(0.25) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach asc) percyl
  FROM moje_dane
)
SELECT count(1) wnioski_poniżej_p25
FROM moje_dane
WHERE czas_miedzy_wnioskiem_a_lotem_w_dniach <
      (SELECT percyl
       FROM percentyl);
---ODP---istnieje 48064 wniosków powyżej p25


--     czy te dane znacząco roznią się jesli rozbijemy je na zaakceptowane i odrzucone?


-------------------------------------ROZBICIE NA STATUSY----------------------------------------------
WITH moje_dane AS (
    SELECT
      status,
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w

      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
  JOIN analizy_wnioskow a ON w.id = a.id_wniosku
),
    moje_dane_bez_analiz AS (
    SELECT
      w.id,
      (w.data_utworzenia :: DATE - s2.data_wyjazdu :: DATE) czas_miedzy_wnioskiem_a_lotem_w_dniach,
      w.data_utworzenia :: DATE,
      data_wyjazdu
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy

),
  roznice_statusy as (
  SELECT
    status,
    min(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    max(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    avg(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    percentile_cont(0.25) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p25,
    percentile_cont(0.50) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p50,
    percentile_cont(0.75) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p75,
    percentile_cont(0.90) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p90,
    percentile_cont(0.95) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p95,
    percentile_cont(0.99) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p99,
    percentile_cont(0.9999) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p9999
FROM moje_dane
GROUP BY 1)
SELECT *
FROM roznice_statusy
UNION
  SELECT 'calosc wnioskow',
    min(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    max(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    avg(czas_miedzy_wnioskiem_a_lotem_w_dniach),
    percentile_cont(0.25) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p25,
    percentile_cont(0.50) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p50,
    percentile_cont(0.75) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p75,
    percentile_cont(0.90) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p90,
    percentile_cont(0.95) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p95,
    percentile_cont(0.99) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p99,
    percentile_cont(0.9999) WITHIN GROUP ( ORDER BY czas_miedzy_wnioskiem_a_lotem_w_dniach) p9999
FROM moje_dane_bez_analiz
ORDER BY 1;

---ODP---Bez odfiltrowania joinem przy pomocy tabeli analizy_wniosków pokazuje wszystkie wnioski które nawet nie przeszły etapu analizy - co poszerza zakres wyników i dodaje do bazy analizowanej.
-- Różnica jest ogromna jendak co ciekawe na poziomie średniej nie jest aż tak duża.




--
-- 10) Chcę bardziej spersonalizować naszą stronę internetową pod wymagania klientów. Aby to zrobić potrzebuję analizy dotyczącej języków używanych przez klientów:
--     Jakich języków używają klienci? (kolumny: jezyk, liczba klientow, % klientow)

SELECT jezyk,
  count(k.id),
  count(k.id)/sum(count(k.id)) OVER ()
FROM wnioski
JOIN klienci k ON wnioski.id = k.id_wniosku
GROUP BY 1
ORDER BY 2 DESC;

--     Jak często klient zmienia język (przeglądarki)? (kolumny: email, liczba zmian, czy ostatni jezyk wniosku zgadza sie z pierwszym jezykiem wniosku)

WITH zmiany_jezykow as (
    SELECT
      DISTINCT
      email,
      count(jezyk)
      OVER (
        PARTITION BY email ) liczba_zmian,
      first_value(jezyk)
      OVER (
        PARTITION BY email ) pierwszy_jezyk,
      last_value(jezyk)
      OVER (
        PARTITION BY email ) ostatni_jezyk

    FROM wnioski w
      JOIN klienci k ON w.id = k.id_wniosku
    GROUP BY 1, jezyk
    ORDER BY 2 DESC
)
SELECT email,liczba_zmian, (ostatni_jezyk = pierwszy_jezyk)ostatni_jezyk_zgadza_sie_z_pierwszym
FROM zmiany_jezykow;





--
-- DODATKOWE:
-- 1) Analogicznie do przewidywania wniosków: wykonaj predykcję liczby leadów (także na aktualny miesiąc, predykcja do końca miesiąca)
-- 2) Analogicznie do przewidywania wniosków: wykonaj predykcję liczby zanalizowanych wniosków (także na aktualny miesiąc, predykcja do końca miesiąca)
-- 3) Analogicznie do przewidywania wniosków: wykonaj predykcję liczby wysłanych maili w kampaniach (także na aktualny miesiąc, predykcja do końca miesiąca)
