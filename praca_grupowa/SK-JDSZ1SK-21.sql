--SK-JDSZ1SK-21
--lista przeterminowanych wniosków > 3 lat
-- nie dodawałam nic nowego ponieważ robilliśmy na zajęciach

select w.id, w.data_utworzenia, s2.data_wyjazdu,
  w.data_utworzenia - s2.data_wyjazdu roznica_czasu, extract(days from w.data_utworzenia - s2.data_wyjazdu) czas_w_dniach
  from wnioski w
join podroze p on w.id = p.id_wniosku
join szczegoly_podrozy s2 on p.id = s2.id_podrozy

WHERE
  czy_zaklocony = true
  and w.data_utworzenia - s2.data_wyjazdu > '3 years' and w.id <> 37074



---testing---

--ja ja gut gut ja wohl!

--przydałby sie odpowiednie aliasy kolumn by tester nie musial się przemęczać :P

--- test 2 --- wyrzuciłam rekord, w którym czas podróży datowany był na 1012 r. :)
