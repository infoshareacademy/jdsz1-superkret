--SK-JDSZ1SK-21
--lista przeterminowanych wniosków > 3 lat
-- nie dodawałam nic nowego ponieważ robilliśmy na zajęciach

select w.id, w.data_utworzenia, s2.data_wyjazdu,
  w.data_utworzenia - s2.data_wyjazdu, extract(days from w.data_utworzenia - s2.data_wyjazdu)
  from wnioski w
join podroze p on w.id = p.id_wniosku
join szczegoly_podrozy s2 on p.id = s2.id_podrozy

WHERE
  czy_zaklocony = true
  and w.data_utworzenia - s2.data_wyjazdu > '3 years'


