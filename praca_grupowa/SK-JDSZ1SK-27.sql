---------------Liczba wniosków w zależności od operatora i czasu ---------------
-- Liczba wniosków w zależności od operatora (operator ale i operator operujący
-- UWAGA by nie wziąć operatora operującego w momencie gdy nie matakiego np NULL bedzie)
-- i czasu (najlepiej po miesiącach np. w styczniu sprzedaliśmy N wniosków od regio)---------------



---Obliczam liczbe wnioskow---

---Wynik liczbowy wnioskow wg operatora ---
  SELECT count(w.id),
  coalesce(identyfikator_operator_operujacego, identyfikator_operatora) operat_pkp
FROM wnioski w
JOIN podroze p ON w.id = p.id_wniosku
JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
GROUP BY 2;
---------------------------------------------


---Rozkład procentowy wg. mieisęcy i operatora---

WITH operator_czas as (   ----dajemy WITH by ładnie sobie wyświetlić wartości po miesiącach
SELECT to_char(w.data_utworzenia, 'YYYY-MM') miesiecznie, --wybieram daty po miesiącach i latach (numerycznie) tego nie będzie w finałowej wersji
  to_char(w.data_utworzenia, 'YYYY Month') rok_miesiac,--wybieram daty po miesiącach (nazwy miesięcy słownie) i latach (numerycznie) co będzie służyło finalnie w tabeli finalnej
    coalesce(identyfikator_operator_operujacego, identyfikator_operatora) operat_pkp, --scalam kolemnę w ten sposób by IOO(identyfikator_operator_operujacego) jest operatorem który wiezie pasażerów a IO(identyfikator_operatora) nie zawsze jest operatorem wożącym pasażerów.
    count(w.id) liczba_w, --liczę wnioski
  sum(count(4)) OVER (PARTITION BY to_char(w.data_utworzenia, 'YYYY-MM')) suma_mieieczna, --tu mam sumę wniosków tylko by sobie sprawdzić
  count(4)/sum(count(4)) OVER (PARTITION BY to_char(w.data_utworzenia, 'YYYY-MM'))procent_miesiecznie --wartość procentowa rozkłądu wnjiosków operatora na miesiąc
FROM wnioski w
JOIN podroze p ON w.id = p.id_wniosku
JOIN szczegoly_podrozy s2 ON p.id = s2.id_podrozy
GROUP BY 1, 2, 3
ORDER BY 1)
  SELECT rok_miesiac, operat_pkp, liczba_w, procent_miesiecznie --wyświetlam tabelkę finalną bez pól które nie są obowiżakowe
FROM operator_czas;
-------------------------------------------------