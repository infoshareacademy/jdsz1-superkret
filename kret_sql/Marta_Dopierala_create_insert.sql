create table klient_1
(id serial primary key,
    id_klient INTEGER,
  imie text not NULL,
nazwisko CHARACTER VARYING (40) not null,
adres_miasto CHARACTER varying (30) not null,
adres_ulica character VARYING (40) not null,
telefon CHARACTER VARYING (15),
email text not null)

insert into klient_1
(id_klient, imie, nazwisko, adres_miasto, adres_ulica, telefon, email)
values (1, 'Joanna', 'Blumflower', 'Rokitnica Wielka', 'Hrynka', 809342134, 'asblu@gmail.com');
insert into klient_1 (id_klient, imie, nazwisko, adres_miasto, adres_ulica, telefon, email)
values (2, 'Maria', 'Romanska', 'Rumia', 'Rumska', '+48 456789023', 'marom@wp.pl');
insert into klient_1
(id_klient, imie, nazwisko, adres_miasto, adres_ulica, telefon, email)
values (3, 'Maciej', 'Matkowski', 'Morawa', 'Mostowa 4', 7977778273, 'macma@interia.pl');

create TABLE dostawcy_1
(id serial PRIMARY KEY,
id_dostawcy character VARYING (40),
adres_ulica character varying (40),
adres_miasto text,
nip character varying (10),
osoba_kontaktowa text not NULL,
telefon character varying not null,
branża text)


insert into dostawcy_1
(id_dostawcy, adres_ulica, adres_miasto, nip, osoba_kontaktowa, telefon, branża)
values ('zze.1', 'Maszynowa', 'Gdynia', 789746823, 'M.Zen', '24892634823964', 'M');

insert into dostawcy_1
(id_dostawcy, adres_ulica, adres_miasto, nip, osoba_kontaktowa, telefon, branża) VALUES
  ('ui.3', 'Elektryczna', 'Krakow', '4297429472', 'W.Ricky', 242424242, 'E');

insert into dostawcy_1
(id_dostawcy, adres_ulica, adres_miasto, nip, osoba_kontaktowa, telefon, branża) VALUES
  ('fi.3', 'Trynitowa', 'Frombork', 246483764, 'Q.Zonk', 32428244, 'E');

create table czesci_dostawcy_1
(id serial primary key,
id_czesci character varying (40),
data_przyj_mag timestamp,
data_zam timestamp,
id_dostawcy character varying (40),
dostawcy_id INTEGER,
foreign key (dostawcy_id) REFERENCES dostawcy)

insert into czesci_dostawcy_1 (id_czesci, data_przyj_mag, data_zam, id_dostawcy, dostawcy_id) VALUES
  (1, '2017-02-01', '2017-01-20', 'fi.3', 3);

insert into czesci_dostawcy_1 (id_czesci, data_przyj_mag, data_zam, id_dostawcy, dostawcy_id) VALUES
  (20, '2018-02-02', '2018-02-06', 'ui.3', 2);


create TABLE katalog_czesci_1
(id serial primary key,
id_czesci character VARYING (40),
kategoria character varying (10),
name character varying (40),
cena NUMERIC,
dostawcy_id INTEGER,
FOREIGN KEY (dostawcy_id) references dostawcy)

insert into katalog_czesci_1 (id_czesci, kategoria, name, cena, dostawcy_id) VALUES
  ('2a', 'M', 'turbosprężarka', 23000, 2);
insert into katalog_czesci_1 (id_czesci, kategoria, name, cena, dostawcy_id) VALUES
  ('3z', 'E', 'podzespoły', 10000, 1);


