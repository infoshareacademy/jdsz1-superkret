-- --
--
-- OBOWIĄZKOWE
-- Eksploracja danych
--
--     Z którego kraju mamy najwięcej wniosków?
select kod_kraju, count(1)
from wnioski
GROUP BY 1
ORDER BY 2 DESC;
--ODP--Najwięcej wniosków spłynęło z kraju oznaczonego kodem ZZ co oznacza Unknown, możliwy błąd zapisu lub określenia loklaizacji np. wniosek dotyczył trasy międzykrajowej, kraj z którego jest najwięcej wniosków i jest poprawnie wybranym krajem oznaczonym kodem IE czyli Irlandia.

--     Z którego języka mamy najwięcej wniosków?

SELECT jezyk, count(1)
FROM wnioski
GROUP BY 1
ORDER BY count(1)DESC;
--ODP--Najliczniejszą grupą językową która wnioskuje jest grupa anglojęzyczna.

--     Ile % procent klientów podróżowało w celach biznesowych a ilu w celach prywatnych?
SELECT typ_podrozy,
  count(id) as l_wnioskow,
  sum(count(id)) OVER (PARTITION BY typ_podrozy)/sum(count(id)) OVER ()::NUMERIC proc_typ_podroz
from wnioski
GROUP BY typ_podrozy
ORDER BY 2 asc;
--ODP-- Tylko 1,4% podróży było biznesowych, w celach prywatnych podróżowało ok 4,6%, Pozostałe ok 94% miało niesprecyzowane cele podróży.


--     Jak procentowo rozkładają się źródła polecenia?

SELECT zrodlo_polecenia,
  count(id) as l_wnioskow,
  sum(count(id)) OVER (PARTITION BY zrodlo_polecenia)/sum(count(id)) OVER ()::NUMERIC proc_zr_pol
from wnioski
GROUP BY 1
ORDER BY 2 desc;
--ODP-- Najmniej skuteczne okazuje się takie źródło jak FB/Twitter jako źródło polecenia, następne w kolei jest reklam w wyszukiwarkach lub sposób pozycjonowania w wyszukiwarkach. Przyjaciele Mają drugą pozycję pod względem ilości natomiast najwięcej wniosków nie posiada wskaznageo żródła polecenia.

--     Ile podróży to trasy złożone z jednego / dwóch / trzech / więcej tras?

SELECT *
FROM szczegoly_podrozy
WHERE identyfikator_podrozy NOT LIKE '%--%';

WITH liczba_przesiadek AS (
SELECT w.id,
  count(w.id) l_przesiadek
FROM szczegoly_podrozy s2
      JOIN podroze p ON s2.id_podrozy = p.id
      JOIN wnioski w ON p.id_wniosku = w.id
WHERE identyfikator_podrozy NOT LIKE '%--%'
GROUP BY 1
ORDER BY 2 DESC),

przes as (SELECT
    CASE
      WHEN l_przesiadek =4 THEN count(id)
      WHEN l_przesiadek =3 THEN count(id)
      WHEN l_przesiadek =2 THEN count(id)
      WHEN l_przesiadek =1 THEN count(id)
      END as przesiad
FROM liczba_przesiadek
GROUP BY przesiad)

SELECT *
FROM przes
;




with moje_dane AS (
    SELECT
      w.id,
      s2.identyfikator_podrozy,
    w.data_utworzenia
    FROM wnioski w
      JOIN podroze p ON w.id = p.id_wniosku
      JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
    WHERE s2.identyfikator_podrozy NOT LIKE '%--%'
    ORDER BY 1
)

SELECT *--, count(md_nowe.id)
FROM moje_dane md_nowe
  JOIN moje_dane md_wyplacone on md_wyplacone.identyfikator_podrozy =md_nowe.identyfikator_podrozy
Where md_nowe.id=md_wyplacone.id

;

SELECT *
FROM podroze;



--     Na które konto otrzymaliśmy najwięcej / najmniej rekompensaty?
SELECT konto,
  CASE
  WHEN konto LIKE '%PLN' then sum(kwota)
  WHEN konto LIKE '%EUR' THEN (sum(kwota))*4
  END as wynik_w_PLN
FROM szczegoly_rekompensat
GROUP BY konto
ORDER BY 2 DESC ;
--ODP--Największą sumę uzyskalismy na koncie PKO w walucie PLN wyniosła 11310467.22, natomiast najmniej rekompensaty otrzymalo Pekao SA z wynikiem w PLN 292036

--     Który dzień jest rekordowym w firmie w kwestii utworzonych wniosków?

SELECT to_char(data_utworzenia, 'YYYY-MM-DD'), count(data_utworzenia)
FROM wnioski
GROUP BY 1
ORDER BY 2 DESC;
--ODP--rekordowym dniem jest dzień 2017-11-16 kiedy wpłynęło 28 wniosków.

--     Który dzień jest rekordowym w firmie w kwestii otrzymanych rekompensat?


WITH kasa AS (
  SELECT
  CASE
WHEN konto LIKE '%PLN' then sum(kwota)
WHEN konto LIKE '%EUR' THEN (sum(kwota))*4
END wynik_pln
  FROM szczegoly_rekompensat
  GROUP BY konto
),
  daty as (
      SELECT to_char(data_otrzymania, 'YYYY-MM-DD') as dat_ot
    FROM szczegoly_rekompensat

  )
SELECT dat_ot, sum(wynik_pln)
FROM kasa, daty
GROUP BY dat_ot
ORDER BY 2 DESC;
--ODP--rekordowym dniem pod względem otrzymanych wpłat jest dzień 2017-11-14 w kwocie


---inny sposób---
SELECT to_char(data_otrzymania, 'YYYY-MM-DD') as dat_ot,
konto,
CASE
WHEN konto LIKE '%PLN' then sum(kwota)
WHEN konto LIKE '%EUR' THEN (sum(kwota))*4
END wynik_pln
FROM szczegoly_rekompensat
GROUP BY 1, 2
ORDER BY 3 DESC


--
--     Jaka jest dystrubucja tygodniowa wniosków według kanałów? (liczba wniosków w danym tygodniu w każdym kanale)

SELECT to_char(data_utworzenia, 'YYYY-WW'), kanal, count(data_utworzenia)
FROM wnioski
GROUP BY 1, 2
ORDER BY 1,3;
--ODP--jak w tabeli


--     Lista wniosków przeterminowanych (przeterminowany = utworzony w naszej firmie powyżej 3 lat od daty podróży)

SELECT w.id,id_wniosku, w.data_utworzenia,  s2.data_wyjazdu, (((cast(w.data_utworzenia as date))-s2.data_wyjazdu)/365) as rozn_lata
from wnioski w
LEFT JOIN szczegoly_podrozy sp on w.id=sp.id
JOIN podroze p ON w.id = p.id_wniosku
LEFT JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
  WHERE w.data_utworzenia >= s2.data_wyjazdu and (((cast(w.data_utworzenia as date))-s2.data_wyjazdu)/365) >=3
ORDER BY 5 desc;


--
-- Badanie powracających klientów
--
--     Firmie zależy na tym, aby klienci do nas wracali.
--     Jaka część naszych klientów to powracające osoby?

--liczba wystąpień klientów więcej niż raz
SELECT count(id), email
FROM klienci
GROUP BY email
HAVING count(id)>1
ORDER BY 1 DESC
;

--jaka to jest czesc klientow?
SELECT count(id), email,
  sum(1) OVER () as suma_wszystkich_wnioskow,
  count(id)/sum(1) OVER ()::NUMERIC * 100 as procent
FROM klienci
GROUP BY email
--HAVING count(id)>1
ORDER BY 1 DESC
;

--ODP--tylko jeden klient posiada więcej niż jedno zgłoszenie i jest to liczba 618 wniosków. Jest to ok 0.35 % wszystkich wniosków. Możliwe oszustwo.

--     Jaka część naszych współpasażerów to osoby, które już wcześniej pojawiły się na jakimś wniosku?


--żle
WITH kl_email as(
select id_wniosku ,trim(LEADING 'kl_' FROM email) email
FROM wspolpasazerowie
Where email not like 'wsp_%'
),
    wsp_email as (
    select id_wniosku, trim(LEADING 'wsp_' FROM email) email
FROM wspolpasazerowie
    Where email not like 'kl_%')
)

SELECT *
FROM wspolpasazerowie;
---



---jeszcze inaczej ale w dobrym kierunku
SELECT --id,
  CASE
  when email like 'kl_%' THEN trim(LEADING 'kl_' FROM email)
  WHEN email like 'wsp_%' THEN trim(LEADING 'wsp_' FROM email)
    end email_czysty,
  count(1)
    FROM wspolpasazerowie
GROUP BY 1
ORDER BY 2 DESC ;

---wyliczone czesci
SELECT --id,
  CASE
  when email like 'kl_%' THEN trim(LEADING 'kl_' FROM email)
  WHEN email like 'wsp_%' THEN trim(LEADING 'wsp_' FROM email)
    end email_czysty,
  count(1),
  count(1)/sum(1) OVER ()::NUMERIC*100 procentowy_udzial
    FROM wspolpasazerowie
GROUP BY 1
ORDER BY 2 DESC ;

--- Te trzy osoby pojawiły się najczęsciej we wnioskach email_534535@ids.com=1,9%, email21320@ids.com=1,9%, email1231344@ids.com = 1,8% całości liczby wniosków.



--     Jaka część klientów pojawiła się na innych wnioskach jako współpasażer?


SELECT
  CASE
    WHEN email like 'wsp_%' then 'wspolpasazer'
    WHEN email LIKE 'kl_%' THEN  'klient'
    END rodzaj_osoby,
  count(email) l_osob,
  sum(count(email)) OVER (),
  count(email)/sum(count(email)) OVER ()*100 procent_calosci

FROM wspolpasazerowie
GROUP BY 1;

---ODP---wspolpasazerowie stanowia 95 % wszystkich osob.


--     Czy jako nowy klient mający kilka zakłóceń, od razu składasz kilka wniosków? Jaki jest czas od złożenia pierwszego do kolejnego wniosku?
SELECT *
FROM wnioski w
     left join analizy_wnioskow a on w.id = a.id_wniosku
  left JOIN podroze p ON w.id = p.id_wniosku
  left join szczegoly_podrozy s2 ON p.id = s2.id_podrozy
where pogoda_ok is TRUE and brak_strajku is TRUE AND atak_terr_ok is TRUE AND zaklocenie_ok is TRUE
--GROUP BY

-- DODATKOWE:
-- Wyłudzenia
--
--     Jako data scientist jesteś także zobowiązany/a do sprawdzania danych pod kątem wyłudzeń (ten sam lot, ta sama osoba).
--     Znajdź listę współpasażerów próbujących stworzyć własny odrębny wniosek (na ten sam identifikator_podrozy), pomimo istnienia jako współpasażer na innym wniosku
--
-- Odrzucone wnioski
--
--     Chcemy przyjrzeć się odrzuconym wnioskom, które mają inny podobny (ten sam identifikator_podrozy) wniosek, który jest wypłacony przed utworzeniem odrzuconego wniosku. Przygotuj listę takich wniosków
--
