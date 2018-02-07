create TABLE pracownicy(
  id_pracownik CHARACTER VARYING(3) NOT NULL PRIMARY KEY,
  imie CHARACTER VARYING(30) NOT NULL ,
  nazwisko CHARACTER VARYING(50) NOT NULL ,
  dzial CHARACTER VARYING (30) NOT NULL ,
  telefon CHARACTER VARYING(9),
  email text
)

CREATE TABLE dostawcy (
  id_dostawcy character varying(40) NOT NULL PRIMARY KEY,
  adres_ulica text,
  adres_miasto text,
  nip CHARACTER VARYING(10),
  osoba_kontakt text,
  telefon character varying(10),
  branza text
)

CREATE TABLE prototyp (
  id_prototyp CHARACTER VARYING(100) NOT NULL PRIMARY KEY,
  wersja      CHARACTER VARYING(100) NOT NULL,
  data_start  date,
  data_end    date,
  cena        NUMERIC
)

create TABLE  monitoring(
    id_mod INTEGER NOT NULL PRIMARY KEY,
    numer_test INTEGER NOT NULL,
    kod_error CHARACTER VARYING(3),
    data_test_start date,
    data_test_end date,
    wynik_testu BOOLEAN NOT NULL,
    id_pracownik CHARACTER VARYING(3) NOT NULL,
    id_prototyp CHARACTER VARYING(100) NOT NULL,
    FOREIGN KEY (id_pracownik) REFERENCES pracownicy,
    FOREIGN KEY (id_prototyp) REFERENCES prototyp
  )

create TABLE katalog_czesci
(
id_czesci CHARACTER VARYING(100) PRIMARY KEY NOT NULL,
kategoria CHARACTER VARYING (50),
name CHARACTER VARYING (30),
cena numeric,
data_przyj_mag date,
data_zam date,
id_dostawcy character varying(40) NOT NULL,
foreign key (id_dostawcy) REFERENCES dostawcy)

CREATE TABLE klient
(
  id_klient      SERIAL PRIMARY KEY NOT NULL,
  imie           TEXT,
  nazwisko       TEXT,
  adres_zamowien INTEGER NOT NULL,
  telefon        VARCHAR(10) NOT NULL,
  email          TEXT
)

create table zamowienie
(id serial primary key,
id_prototyp CHARACTER VARYING (100) NOT NULL,
id_klient INTEGER NOT NULL,
FOREIGN KEY (id_prototyp) REFERENCES prototyp,
foreign KEY (id_klient) references klient)




CREATE TABLE proto_zestaw(
  Id serial PRIMARY KEY ,
  id_prototyp CHARACTER VARYING (100) NOT NULL,
  id_czesci CHARACTER VARYING(100) NOT NULL,
FOREIGN KEY (id_prototyp) REFERENCES prototyp,
FOREIGN KEY (id_czesci) REFERENCES katalog_czesci);


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