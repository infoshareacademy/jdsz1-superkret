---GRUPA SUPER KRET---



--Dodanie tabeli o pracownikach:
create TABLE pracownicy(
  id_pracownik CHARACTER VARYING(3) NOT NULL PRIMARY KEY,
  imie CHARACTER VARYING(30) NOT NULL ,
  nazwisko CHARACTER VARYING(50) NOT NULL ,
  dzial CHARACTER VARYING (30) NOT NULL ,
  telefon CHARACTER VARYING(9),
  email text
)

--Dodanie tabeli o dostawcach:
CREATE TABLE dostawcy (
  id_dostawcy character varying(40) NOT NULL PRIMARY KEY,
  adres_ulica text,
  adres_miasto text,
  nip CHARACTER VARYING(10),
  osoba_kontakt text,
  telefon character varying(10),
  branza text
)


--Dodanie tabeli o prototypach:
CREATE TABLE prototyp (
  id_prototyp CHARACTER VARYING(100) NOT NULL PRIMARY KEY,
  wersja      CHARACTER VARYING(100) NOT NULL,
  data_start  date,
  data_end    date,
  cena        NUMERIC
)


--Dodanie tabeli o przeprowadzonych testach:
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


  --Dodanie tabeli o zamowionych czesciach:
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


  --Dodanie tabeli o klientach planujacych zakup:
CREATE TABLE klient
(
  id_klient      SERIAL PRIMARY KEY NOT NULL,
  imie           TEXT,
  nazwisko       TEXT,
  adres_zamowien INTEGER NOT NULL,
  telefon        VARCHAR(10) NOT NULL,
  email          TEXT
)


--Dodanie tabeli o zamowieniach:
create table zamowienie
(id serial primary key,
id_prototyp CHARACTER VARYING (100) NOT NULL,
id_klient INTEGER NOT NULL,
FOREIGN KEY (id_prototyp) REFERENCES prototyp,
foreign KEY (id_klient) references klient)


--Dodanie tabeli o zestawach czesci do prototypow:
CREATE TABLE proto_zestaw(
  Id serial PRIMARY KEY ,
  id_prototyp CHARACTER VARYING (100) NOT NULL,
  id_czesci CHARACTER VARYING(100) NOT NULL,
FOREIGN KEY (id_prototyp) REFERENCES prototyp,
FOREIGN KEY (id_czesci) REFERENCES katalog_czesci);
