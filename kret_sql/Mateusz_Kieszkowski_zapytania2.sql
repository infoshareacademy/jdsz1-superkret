-- Zadanie 1
SELECT kod_kraju, count(1)
FROM wnioski
GROUP BY 1
ORDER BY 2 DESC
-- Najwięcej wniosków  z nieokreślonego kraju ZZ. Można domniemywać,
--że rozkłada się na wszystkie pozostałe kraje. Natomiast najwięcej wniosków jest z Irandii bo prawie 48 tys


--Zadanie 2
SELECT jezyk, count(1)
FROM wnioski
GROUP BY 1
ORDER BY 2 DESC
-- 145 tysięcy wniosków dotyczy krajów Anglojęzycznych,

--Zadanie 3
SELECT typ_podrozy, count(1),
  COUNT(1) / SUM(COUNT(1)) OVER ()::NUMERIC as procent_podrozy
from wnioski
GROUP BY 1
ORDER BY 1
-- blisko 94 % podróżujących nie określiło typu podrózy, pozostałe 4,6% podróżowało w celach biznesowych oraz 1,4% w celach prywatnych

--Zadanie 4
SELECT zrodlo_polecenia, count(1),
  COUNT(1) / SUM(COUNT(1)) OVER ()::NUMERIC as procent_polecenia
from wnioski
GROUP BY 1
ORDER BY 1
-- na 97,7 % wniosków nie wskazano źródła polecenia, 1,2% osób wskazało na przyjaciół,0,7% na wyszukiwarki oraz 0,4% na fb/twitter

Zadanie 5
-- Nie wiem jak zrobić to zadanie przy obecnej bazie danych

--ZADANIE 6
select konto, min(kwota),max(kwota)
from szczegoly_rekompensat
GROUP BY 1
ORDER BY 1 DESC
LIMIT 1

-- na konto PKO PLN wpłynęła zarówno najmniejsza kwota 0,01 zł jak i największa kwota 5400 zł

SELECT to_char(data_utworzenia, 'YYYY-MM-DD') , count(1)
FROM wnioski
GROUP BY 1
  ORDER BY 2 DESC
LIMIT 1

-- najwięcej wniosków zostało utworzonych w dniu 16-11-2017 ich liczba wyniosła wtedy 1264 wnioski


--ZADANIE 8
SELECT data_otrzymania, sum(kwota)
from szczegoly_rekompensat
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
--rekordowym dniem w kwestii rekompensat jest 30.10.2015 z suma wpłat w wysokości 60500

--ZADANIE 9

select kanal,count(id) as liczba_wnioskow, date_trunc('week', data_utworzenia) as week
FROM wnioski
GROUP BY 3,1;

ZADANIE 10


    SELECT
      w2.id,
      sp.data_wyjazdu,
      sp.data_utworzenia,
      DATE_PART('days', sp.data_utworzenia-sp.data_wyjazdu) roznica_wdniach
    FROM szczegoly_podrozy sp
      JOIN podroze p ON sp.id_podrozy = p.id
      JOIN wnioski w2 ON p.id_wniosku = w2.id
      WHERE DATE_PART('days', sp.data_utworzenia-sp.data_wyjazdu) >= 1095
    ORDER BY 4 DESC ;
-- w bazie istnieją 244 przeterminowane wnioski