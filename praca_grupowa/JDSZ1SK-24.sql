/*-JDSZ1SK-24--Funnel: jakie są % przejścia pomiędzy pozczególnymi etapami?
przykład:
1) nowy: 100%
2) analiza
- zaakceptowany: 80%
- odrzucony 10%
- drop off: 10%
3) odpowiedź linii:
- akceptacja 40% (z wszystkich które przeszły z poprzedniego etapu), 32% (z wszystkich)
- odrzucenie 50% (z wszystkich które przeszły z poprzedniego etapu), 40% (z wszystkich)
- drop off 10%  (z wszystkich które przeszły z poprzedniego etapu), 8% (z wszystkich)

4) odpowiedź po analizie prawnej:
założenia jw

*/


select
  --to jest podpunkt 1)
  count(w.id) nowe, ---to nasze 100%

  --to jest podpunkt 2)
  count(case when a.status = 'zaakceptowany' then a.id end)/count(w.id)::numeric proc_zaakceptowanych_analiza, -- procent zaakceptowanych z analizy
  count(case when a.status = 'odrzucony' then a.id end)/count(w.id)::numeric proc_odrzuconych_analiza, -- procent odrzuconych z analizy
  (count(w.id)-count(a.id))/count(w.id)::numeric proc_drop_off_analiza, --dropp off czyli procent który nie przeszedł z liczby wszystkich wniosków

  --podpunkt 3)
  count(case when status_odp = 'zaakceptowany' then o.id end)/count(a.id)::numeric proc_zaakceptowanych_odp_operator, -- procent zaakceptowanych z odpowiedzi operatora
  count(case when status_
odp LIKE 'odrzuco%' then o.id end)/count(a.id)::numeric proc_odrzuconych_odp_operator, -- procent odrzuconych z odpowiedzi operatora
  (count(a.id)-count(o.id))/count(a.id)::numeric proc_drop_off_odp_operator  --dropp off czyli procent króty nie przeszedł z analizy

-- podpunkt 4)
  count(case when ap.status = 'zaakceptowany' then ap.id end)/count(o.id)::numeric proc_zaakceptowanych_analiza_sadowa, -- procent zaakceptowanych po analizie prawnej
  count(case when ap.status LIKE 'odrzucony' then ap.id end)/count(o.id)::numeric proc_odrzuconych_analiza_sadowa, -- procent odrzuconych po analizie
  (count(o.id)-count(ap.id))/count(o.id)::numeric proc_drop_off_odp_operator  --dropp off czyli procent króry ma inny status odpowiedzi

from wnioski w
left join analizy_wnioskow a ON w.id = a.id_wniosku  --łaczenie tabeli z analizą by wyłuskać pierwszy funnel
LEFT JOIN analiza_operatora o on w.id = o.id_wniosku --łaczenie tabeli z odpowiedzią operatora by wyliczyć drugi funnel
left join analiza_prawna ap on w.id=ap.id_wniosku; -- trzeci funnel

