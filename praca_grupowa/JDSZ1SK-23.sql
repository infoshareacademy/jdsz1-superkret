
--------------------Jakie są czasy przetarzania wszystkich etapów? zagadnienie 23-----------
/*założenia od Piotra
left join
1) od utworzenia wniosku do akceptacji na etapie analizy wniosku
2) od utworzenia wniosku do odrzucenia na etapie analizy wniosku
3) od zaakceptowania na etapie analizy wniosku do otrzymania odpowiedzi "zaakceptowany"
4) od zaakceptowania na etapie analizy wniosku do otrzymania odpowiedzi "odrzucony nieslusznie" (edited)
5) od zaakceptowania na etapie analizy wniosku do otrzymania odpowiedzi "odrzucony slusznie"
6) od odrzucenia do rozpoczecia analizy prawnej
7) od rozpoczecia do wyslania do sadu w analizie prawnej
8 ) od wyslania do sadu do odpowiedzi sadu w analizie prawnej*/

with dane AS
(
    SELECT

      CASE      -- czas od utworzenia wniosku do odrzucenia na etapie analizy wniosku
      WHEN aw.status = 'odrzucony' and w.data_utworzenia< aw.data_zakonczenia
        THEN aw.data_zakonczenia - w.data_utworzenia END  odrzucone_an_wniosku,
      CASE      -- czas od utworzenia wniosku do akceptacji na etapie analizy wniosku
      WHEN aw.status = 'zaakceptowany' and w.data_utworzenia<aw.data_zakonczenia
        THEN aw.data_zakonczenia - w.data_utworzenia END  zaakcept_an_wniosku,
      CASE      -- czas od zakończenia analizy wniosku do akceptacji przez operatora
      WHEN ao.status_odp = 'zaakceptowany' and aw.data_zakonczenia<ao.data_odpowiedzi
        THEN ao.data_odpowiedzi - aw.data_zakonczenia END zaakc_an_oper,
      CASE      -- czas od zakończenia analizy wniosku do otrzymania odpowiedzi 'odrzucony słusznie'
      WHEN ao.status_odp = 'odrzucony slusznie' and aw.data_zakonczenia<ao.data_odpowiedzi
        THEN ao.data_odpowiedzi - aw.data_zakonczenia END odrz_slusz_oper,
      CASE      -- czas od zakończenia analizy wniosku do otrzymania odpowiedzi 'odrzucony niesłusznie'
      WHEN ao.status_odp = 'odrzucony nieslusznie' and aw.data_zakonczenia< ao.data_odpowiedzi
        THEN ao.data_odpowiedzi - aw.data_zakonczenia end odrz_nieslusz_oper,
      CASE      -- czas od niesłusznego odrzucenia do rozpoczęcia analizy prawnej (przechodzą tylko niesłusznie odrzucone wnioski)
      WHEN aw.data_zakonczenia<ap.data_rozpoczecia
        THEN ap.data_rozpoczecia-aw.data_zakonczenia end an_praw_rozp

     --poniższe etapy pomijam ze względu na nieprawidłowość danych

      --ap.data_wyslania_sad - ap.data_rozpoczecia   wysylka_sad,  -- czas od rozpoczecia analizy do wyslania do sądu
      --ap.data_odp_sad - ap.data_wyslania_sad   odpowiedz_sad  -- czas od wysłąnia do sądu do odpowiedzi sądu w analizie prawnej

    FROM wnioski w
      LEFT JOIN analizy_wnioskow aw ON w.id = aw.id_wniosku
      LEFT JOIN analiza_operatora ao ON w.id = ao.id_wniosku
      LEFT JOIN analiza_prawna ap ON w.id = ap.id_wniosku

)
-- tutaj w zależności od potrzeby określamy średnią, medianę i wartości skrajne

  select
  avg(d.odrzucone_an_wniosku) odrz_po_anal_wniosku,
  avg(d.zaakcept_an_wniosku) zaakc_po_anal_wniosku,
  avg(d.zaakc_an_oper) zaakcep_po_anal_oper,
  avg(d.odrz_slusz_oper) odrz_sluszn_po_anal_oper,
  avg(d.odrz_nieslusz_oper) odrz_niesl_po_anal_oper,
  avg(d.an_praw_rozp) rozp_anal_prawnej

from dane d;
