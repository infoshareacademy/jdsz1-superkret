-- liczba odrzuconych / zaakceptowanych / wniosków
with wniosekagenta as(
select id_agenta,
  count(CASE WHEN aw.status = 'odrzucony' then w.id END ) wnioski_odrzucone,
  count(CASE WHEN aw.status = 'zaakceptowany' then w.id END ) wnioski_zaakceptowane
from wnioski w
JOIN analizy_wnioskow aw ON w.id = aw.id_wniosku
GROUP BY 1
),
  --liczba zapytañ o dokumenty
  dokumentyagenta as(
  SELECT agent_id, count(1) oczekiwane_dokumenty
  FROM dokumenty
    GROUP BY 1
  ),
  --- liczba przeprocesowanych odpowiedzi linii
  procesowanelinie AS (
  SELECT agent_id,
    count(CASE WHEN status_odp='zaakceptowany' then id_wniosku end) odpowiedz_pozytywna,
    count(CASE WHEN status_odp='odrzucony nieslusznie' then id_wniosku end) odpowiedz_odrz_niesl,
    count(CASE WHEN status_odp='odrzucony slusznie' then id_wniosku end) odpowiedz_odrz_slusz
    from analiza_operatora
    GROUP BY 1
  ),
  -- liczba analiz prawniczych
  analizyprawnicze AS (
  SELECT agent_id,
    COUNT(CASE WHEN status_sad='zaakceptowany' then id_wniosku end) zaakceptowanesad,
    COUNT(CASE WHEN status_sad='przegrany' then id_wniosku end) przegranesad
    FROM analiza_prawna
    GROUP BY 1
  )

--wyswietlenie wszystkich wymaganych kolumn,laczenie podzapytan
select wa.*,da.oczekiwane_dokumenty,odpowiedz_pozytywna,odpowiedz_odrz_niesl,odpowiedz_odrz_slusz,
  zaakceptowanesad,przegranesad
from wniosekagenta wa
LEFT JOIN dokumentyagenta da on da.agent_id=wa.id_agenta
LEFT JOIN procesowanelinie pl on pl.agent_id=wa.id_agenta
LEFT JOIN analizyprawnicze ap on ap.agent_id=wa.id_agenta