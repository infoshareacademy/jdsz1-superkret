-- 1. Z którego kraju mamy najwięcej wniosków?

-- poprawione
select kod_kraju, count(1) as liczba_wnioskow
from wnioski
group by 1
order by 2 DESC
limit 1


-- 2. Z którego języka mamy najwięcej wniosków?

--poprawione
select jezyk, count(1) as liczba_wnioskow
  from wnioski
    group by 1
order by 2 DESC 
limit 1



-- 3. Ile % procent klientów podróżowało w celach biznesowych a ilu w celach prywatnych?
-- Dwie opcje - uwzględniająca i nieuwzględniająca null

select typ_podrozy, count(1) liczba_pasazerow,
round(count(1)/sum(count(1)) over()::numeric, 4) procent_wszystkich
from wnioski
-- where typ_podrozy is not null
group by 1


--  4. Jak procentowo rozkładają się źródła polecenia? Dwie opcje - uwzględniająca i nieuwzględniająca null

select zrodlo_polecenia, count(1) liczba_polecen,
round(count(1)/sum(count(1)) over ():: numeric, 4) procent_wszystkich
from wnioski
-- where zrodlo_polecenia is not null
group by 1
order by 2 DESC


--  5. Ile podróży to trasy złożone z jednego / dwóch / trzech / więcej tras?


-- przy założeniu, że analizujemy każdą trasę nawet bez identyfikatora podrozy
-- lub przy założeniu że istnieje indentyfikator

with TRASY as (
    select id_podrozy, count(1) liczba_tras
FROM szczegoly_podrozy
--where identyfikator_podrozy not like '%--%'
group by 1
order by 2 desc)

select
  count(case when liczba_tras = 1 then 1 end) pojedyncza_trasa,
  count(case when liczba_tras = 2 then 1 end) podwojna_trasa,
  count (case when liczba_tras = 3 then 1 end) potrojna_trasa,
  count(case when liczba_tras > 3 then 1 end) wiecej_tras

from TRASY;


--  6.  Na które konto otrzymaliśmy najwięcej / najmniej rekompensaty?

-- poprawione
-- tabela z kwotami rekompensat na poszczególne konta w tym max i min

select konto, sum(kwota) sumy
from szczegoly_rekompensat
group by 1

--  7.Który dzień jest rekordowym w firmie w kwestii utworzonych wniosków?

-- poprawione
select to_char (data_utworzenia, 'YYYY-MM-DD') as data, count(*) nowe_wnioski
from wnioski
group by 1
order by 2 DESC
limit 1


-- 8. Który dzień jest rekordowym w firmie w kwestii otrzymanych rekompensat?

--poprawione
select to_char (data_utworzenia, 'yyyy-mm-dd') as data, sum(kwota) suma
from szczegoly_rekompensat
group by 1
order by 2 desc
limit 1

-- 9. Jaka jest dystrubucja tygodniowa wniosków według kanałów? (liczba wniosków w danym tygodniu w każdym kanale

select TO_CHAR(data_utworzenia, 'YYYY-WW'), KANAL, COUNT(KANAL) liczba_wnioskow
from wnioski
GROUP BY 1, 2
order by 1

--10.Lista wniosków przeterminowanych (przeterminowany = utworzony w naszej firmie powyżej 3 lat od daty podróży

-- odpuszczam dziś

select w.id,
  w.data_utworzenia::date,
  s.data_wyjazdu,
  (w.data_utworzenia-s.data_wyjazdu) roznica
from wnioski w
join podroze p on w.id=p.id_wniosku
  left join szczegoly_podrozy s ON p.id = s.id_podrozy
where (w.data_utworzenia-s.data_wyjazdu) > '3 year'




