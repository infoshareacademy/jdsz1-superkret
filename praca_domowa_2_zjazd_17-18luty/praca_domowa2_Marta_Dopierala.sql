--OBOWIAZKOWE:

--1) Jaka data była 8 dni temu?
SELECT
  now()- interval '8 days' dni_temu_8;

-- 2) Jaki dzień tygodnia był 3 miesiące temu?

select to_char(now()- interval '3 months', 'Day') dzien_tyd;

-- 3) W którym tygodniu roku jest 01 stycznia 2017?

select to_char('2017-01-01'::date, 'WW') tydz_roku;

--4) Podaj listę wniosków z właściwym operatorem (który rzeczywiście przeprowadził trasę)

SELECT
  w2.id,
  case
  when s2.identyfikator_operator_operujacego is null then s2.identyfikator_operatora
  when s2.identyfikator_operator_operujacego <> s2.identyfikator_operatora then s2.identyfikator_operator_operujacego
  when s2.identyfikator_operator_operujacego = s2.identyfikator_operatora then s2.identyfikator_operator_operujacego
    end

FROM wnioski w2
  JOIN podroze p ON w2.id = p.id_wniosku
  JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy;


--5) Przygotuj listę klientów z datą utworzenia ich pierwszego i drugiego wniosku. 3 kolumny: email, data 1wszego wniosku, data 2giego wniosku
with moje_dane AS
(
    select distinct k.email,
first_value(w2.data_utworzenia) over (partition by k.email order by w2.data_utworzenia) pierwszy,
nth_value(w2.data_utworzenia,2) over (partition by k.email order by w2.data_utworzenia) drugi
from klienci k
join wnioski w2 ON k.id_wniosku = w2.id
)

  select *
from moje_dane
where drugi is not null;  --uwzględnia tylko te przypadki kiedy pojawił się drugi wniosek

6) Używając pełen kod do predykcji wniosków, zmień go tak aby uwzględnić kampanię marketingową, która odbędzie się 26 lutego
--  - przewidywana liczba wniosków z niej to 1000

with moje_daty as (select -- to jest odpowiedzialne za wygenerowanie dat z przyszlosci
  generate_series(
      date_trunc('day', '2018-01-20'::date), -- jaki jest pierwszy dzien generowania
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
      coalesce(aw.liczba_wnioskow,0) liczba_wnioskow, -- powiedz ile bylo wnioskow w danym dniu, jesli byl NULL dodajemy coalesce
      sum(aw.liczba_wnioskow) over(order by md.wygenerowana_data) skumulowana_liczba_wnioskow -- laczna liczba wnioskow dzien po dniu
    from moje_daty md
    left join aktualne_wnioski aw on aw.data_wniosku = md.wygenerowana_data --left join dlatego, ze niektore dni nie maja jeszcze wnioskow. wlasnie dla nich bede robil predykcje
    order by 1),
statystyki_dnia as (
    select to_char(wygenerowana_data, 'Day') dzien, round(avg(liczba_wnioskow)) przew_liczba_wnioskow -- round aby nie uzupelniac liczbami zmiennoprzecinkowymi
    from lista_z_wnioskami
      where wygenerowana_data <= '2018-02-09'
    group by 1
    order by 1
    )
select lw.wygenerowana_data, liczba_wnioskow, przew_liczba_wnioskow,
  case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-26' then 1000 + przew_liczba_wnioskow
    else przew_liczba_wnioskow end finalna_liczba_wnioskow, -- dodaje case aby wybrac realna liczbe albo przewidywana w zaleznosci od daty

  sum(case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-26' then 1000 + przew_liczba_wnioskow


    else przew_liczba_wnioskow end) over(order by wygenerowana_data) skumulowana_z_predykcja -- dodaje funkcje okna aby zsumowac wartosci zarowo realne jak i predykcje
from lista_z_wnioskami lw
join statystyki_dnia sd on sd.dzien = to_char(lw.wygenerowana_data, 'Day')
;


--7) Używając pełen kod do predykcji wniosków, zmień go tak aby uwzględnić przymusową przerwę serwisową,
-- w sobotę 24 lutego nie będzie można utworzyć żadnych wniosków

with moje_daty as (select -- to jest odpowiedzialne za wygenerowanie dat z przyszlosci
  generate_series(
      date_trunc('day', '2018-01-20'::date), -- jaki jest pierwszy dzien generowania
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
      coalesce(aw.liczba_wnioskow,0) liczba_wnioskow, -- powiedz ile bylo wnioskow w danym dniu, jesli byl NULL dodajemy coalesce
      sum(aw.liczba_wnioskow) over(order by md.wygenerowana_data) skumulowana_liczba_wnioskow -- laczna liczba wnioskow dzien po dniu
    from moje_daty md
    left join aktualne_wnioski aw on aw.data_wniosku = md.wygenerowana_data --left join dlatego, ze niektore dni nie maja jeszcze wnioskow. wlasnie dla nich bede robil predykcje
    order by 1),
statystyki_dnia as (
    select to_char(wygenerowana_data, 'Day') dzien, round(avg(liczba_wnioskow)) przew_liczba_wnioskow -- round aby nie uzupelniac liczbami zmiennoprzecinkowymi
    from lista_z_wnioskami
      where wygenerowana_data <= '2018-02-09'
    group by 1
    order by 1
    )
select lw.wygenerowana_data, liczba_wnioskow, przew_liczba_wnioskow,
  case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-24' then 0
    else przew_liczba_wnioskow end finalna_liczba_wnioskow, -- dodaje case aby wybrac realna liczbe albo przewidywana w zaleznosci od daty

  sum(case
    when wygenerowana_data <= '2018-02-09' then liczba_wnioskow
    when wygenerowana_data = '2018-02-24' then przew_liczba_wnioskow-1


    else przew_liczba_wnioskow end) over(order by wygenerowana_data) skumulowana_z_predykcja -- dodaje funkcje okna aby zsumowac wartosci zarowo realne jak i predykcje
from lista_z_wnioskami lw
join statystyki_dnia sd on sd.dzien = to_char(lw.wygenerowana_data, 'Day');


--8) Ile (liczbowo) wniosków zostało utworzonych poniżej mediany liczonej z czasu między lotem i wnioskiem?
with mediana as
(
    SELECT
      percentile_cont(0.5)
      WITHIN GROUP (ORDER BY (w.data_utworzenia - s2.data_wyjazdu)) mediana
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy

)

select count (
    CASE when m.mediana > (w.data_utworzenia - s2.data_wyjazdu) then 1 end) l_ponizej_mediany
from wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
join mediana m on 1=1
;

--9) Mając czas od utworzenia wniosku do jego analizy przygotuj statystyke:

-- wnioski join analizy_wnioskow - łączna liczba rekordów 84586 - analizujemy tylko te, które mają rozpoczętą analizę
-- left join 179735
-- 95 149 utworzonych wniosków nie zaczęto analizować
-- pytanie czy wartość skrajną min powinniśmy brać pod uwagę w analizie
-- (analiza teoretycznie nie powinna odbywać się przed złożeniem wniosku- zakładam, że jest to zamierzone działanie)

SELECT
  avg(a.data_utworzenia - w.data_utworzenia) srednia,
  max(a.data_utworzenia - w.data_utworzenia) max,
  min(a.data_utworzenia - w.data_utworzenia) min,
  percentile_cont(0.5)
  WITHIN GROUP (ORDER BY a.data_utworzenia - w.data_utworzenia) AS mediana

      FROM wnioski w
      JOIN analizy_wnioskow a ON w.id = a.id_wniosku

--srednia 0 years 0 mons 1 days 12 hours 21 mins 1.751719 secs
--max 0 years 0 mons 1429 days 16 hours 50 mins 17.863397 secs
--min 0 years 0 mons 0 days -3 hours -24 mins -28.721217 secs
-- mediana 0 years 0 mons 0 days 0 hours 0 mins 3.053096 secs

------------------ile jest wnioskow ponizej p75?
------------------ile jest wnioskow powyzej p25

with moje_dane as
(
    SELECT
      w.id,
      w.data_utworzenia                     data_wniosku,
      a.data_utworzenia                     data_analizy,
      a.data_utworzenia - w.data_utworzenia roznica_czasu
    FROM wnioski w
       JOIN analizy_wnioskow a ON w.id = a.id_wniosku
    GROUP BY 1, 2, 3
),

  p25 as
(select percentile_cont(0.25) within GROUP (ORDER BY roznica_czasu) wartosc_p25
from moje_dane),

  p75 as
(select percentile_cont(0.75) within GROUP (ORDER BY roznica_czasu) wartosc_p25
from moje_dane)

SELECT  count (*)
    FROM moje_dane

--where roznica_czasu < (select * from p75);

where roznica_czasu >(select * from p25);

-- poniżej p75 jest 63439 wnioskow
-- powyżej p25 jest 63439 wnioskow

----------------------------------------------------------------------
-- czy te dane znacząco roznią się jesli rozbijemy je na zaakceptowane i odrzucone? ---

SELECT
  avg(a.data_utworzenia - w.data_utworzenia) srednia,
  max(a.data_utworzenia - w.data_utworzenia) max,
  min(a.data_utworzenia - w.data_utworzenia) min,
  percentile_cont(0.5)
  WITHIN GROUP (ORDER BY a.data_utworzenia - w.data_utworzenia) AS mediana

  FROM wnioski w
      JOIN analizy_wnioskow a ON w.id = a.id_wniosku

where status = 'zaakceptowany';

----------- dla zaakceptowanych

--średnia  0 years 0 mons 1 days 11 hours 55 mins 11.89215 secs
--mediana 0 years 0 mons 0 days 0 hours 0 mins 2.333273 secs
-- where status = 'odrzucony';

-------------- dla odrzuconych
--średnia 0 years 0 mons 1 days 17 hours 32 mins 25.943935 secs
--mediana 0 years 0 mons 0 days 1 hours 0 mins 53.606726 secs


--ile jest wnioskow ponizej p75?
--ile jest wnioskow powyzej p25

with moje_dane as
(
    SELECT
      w.id,
      w.data_utworzenia                     data_wniosku,
      a.data_utworzenia                     data_analizy,
      a.data_utworzenia - w.data_utworzenia roznica_czasu
    FROM wnioski w
       JOIN analizy_wnioskow a ON w.id = a.id_wniosku
 -- where status = 'odrzucony'
  where status = 'zaakceptowany'
    GROUP BY 1, 2, 3

),

  p25 as
(select percentile_cont(0.25) within GROUP (ORDER BY roznica_czasu) wartosc_p25
from moje_dane),

  p75 as
(select percentile_cont(0.75) within GROUP (ORDER BY roznica_czasu) wartosc_p75
from moje_dane)


SELECT  count (*)
    FROM moje_dane

  where roznica_czasu < (select * from p75);
--where roznica_czasu >(select * from p25);

------------- status odrzucony
-- liczba wnioskow ponizej p75  4859
-- liczba wnioskow powyzej p25 4859

-------------status zaakceptowany

-- liczba wnioskow ponizej p75 58580
-- liczba wnioskow powyzej p25 58580



10) Chcę bardziej spersonalizować naszą stronę internetową pod wymagania klientów.
Aby to zrobić potrzebuję analizy dotyczącej języków używanych przez klientów:
Jakich języków używają klienci? (kolumny: jezyk, liczba klientow, % klientow)

;
SELECT
  jezyk,
  count(k.email) liczba_klientow,
  round(count(k.email)/sum(count(k.email)) over (), 4) proc_klientow

FROM wnioski w
  LEFT JOIN klienci k ON w.id = k.id_wniosku
GROUP BY 1
ORDER BY 2 DESC;

--Jak często klient zmienia język (przeglądarki)? (kolumny: email, liczba zmian, czy ostatni jezyk wniosku zgadza sie z pierwszym jezykiem wniosku)

-- sprawdzam jaką liczbę wniosków złożyli poszczególni klienci
-- ponieważ tylko jeden klient złożył więcej niż 1 wniosek analizuję tylko ten przypadek
-- sprawdzam jak zmieniał się język wniosków w stosunku do poprzednio złożonego - funkcja lag()

  ------------------zmiana jezyka czy tak

with liczba_zmian AS
(
select k.email,
      CASE when lag (w.jezyk) over (partition by k.email order by w.data_utworzenia) <>jezyk then 1
        end ile_zmian
from wnioski w
join klienci k ON w.id = k.id_wniosku
WHERE email = 'kl_email1231344@ids.com'),

--------------------- czy jezyk 1 i ostatniego wniosku taki sam

pierwszy_ostatni AS
  (
select distinct k.email,
case when first_value(w.jezyk) over (partition by k.email order by w.data_utworzenia)=
first_value(w.jezyk) over (partition by k.email order by w.data_utworzenia desc) then true else false end ten_sam_jezyk
from klienci k
join wnioski w ON k.id_wniosku = w.id
WHERE email = 'kl_email1231344@ids.com'
  )

---------------------
select l.email, sum(l.ile_zmian) l_zmian, p.ten_sam_jezyk
from liczba_zmian l
join pierwszy_ostatni p on l.email = p.email
group by 1,3



DODATKOWE:
1) Analogicznie do przewidywania wniosków: wykonaj predykcję liczby leadów (także na aktualny miesiąc, predykcja do końca miesiąca)
2) Analogicznie do przewidywania wniosków: wykonaj predykcję liczby zanalizowanych wniosków (także na aktualny miesiąc, predykcja do końca miesiąca)
3) Analogicznie do przewidywania wniosków: wykonaj predykcję liczby wysłanych maili w kampaniach (także na aktualny miesiąc, predykcja do końca miesiąca)
