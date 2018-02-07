INSERT into dostawcy (id_dostawcy, adres_ulica, adres_miasto, nip, osoba_kontakt, telefon, branza) VALUES
  ('kraby', 'essastreet', 'Miasto_Super', 3452678976, 'Zdzislaw',765432567, 'blotna'),
  ('szybcy dostawcy', 'błotna', 'Dobre Miasto', 3425167893, 'Miecio', 345678908, 'elektryczna');


INSERT INTO pracownicy (id_pracownik, imie, nazwisko, dzial, telefon, email) VALUES
  ('WSI', 'Wiesław', 'Wszywka', 'Testowanie', 876543234, 'wiesiowszywkanapiszdomnie@niepodam.pl'),
  ('WPU', 'Władek', 'Putinowski', 'Kontrola jakosci', 234567890, 'mamczerwonyprzycisk@niepisz.pl');

INSERT INTO prototyp (id_prototyp, wersja, data_start, data_end, cena) VALUES
  ('PROTO1', 'super', '2017-09-23', '2020-09-19', 20000),
  ('PROTO2', 'exclusive', '2017-09-19', '2018-10-20', 80000);


INSERT INTO monitoring (id_mod, numer_test, kod_error, data_test_start, data_test_end, wynik_testu, id_pracownik, id_prototyp)
VALUES (1, 1, 'er1', '2017-10-10', '2020-09-18', '1', 'WSI', 'PROTO1'),
  (2, 3,'op2', '2017-09-20', '2018-10-19', '0', 'WPU', 'PROTO2');

INSERT INTO katalog_czesci(id_czesci, kategoria, name, cena, data_przyj_mag, data_zam, id_dostawcy)
VALUES ('czesc1', 'drążące', 'świder', 1000, '2017-09-01', '2017-06-23', 'kraby' ),
  ('czesc2','karoseria', 'kabina', 450, '2017-09-15', '2017-03-20', 'szybcy dostawcy');

INSERT INTO proto_zestaw (id_prototyp, id_czesci)
VALUES ('PROTO1', 'czesc1'),
  ('PROTO1', 'czesc2'),
  ('PROTO2', 'czesc1'),
  ('PROTO2', 'czesc2');

INSERT INTO klient ( imie, nazwisko, adres_zamowien, telefon, email)
VALUES ( 'Burżuj', 'Bogaczewski', 1, '4352678904', 'burzujjedenzbogaczewa@sknerus.pl'),
  ( 'Bill', 'Bramy', '2', '7453678923', 'billbramowy@malysoft.ch');

INSERT INTO zamowienie (id_prototyp, id_klient)
    VALUES ('PROTO1', 1),
      ('PROTO2', 2);