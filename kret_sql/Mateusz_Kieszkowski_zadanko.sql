CREATE TABLE dostawcy
(
  id_dostawcy SERIAL PRIMARY KEY NOT NULL,
  adres_ulica   VARCHAR(100),
  adres_miasto  TEXT,
  nip           VARCHAR(10),
  osoba_kontakt TEXT,
  telefon       VARCHAR(10),
  branza        TEXT
);

INSERT INTO dostawcy (id_dostawcy, adres_ulica, adres_miasto, nip, osoba_kontakt, telefon, branza)
    VALUES (1, 'Mickiewicza','Gliwice','5503020100','Zenek','500400300','Silniki');
INSERT INTO dostawcy (id_dostawcy, adres_ulica, adres_miasto, nip, osoba_kontakt, telefon, branza)
 VALUES  (2, 'Grunwaldzka', 'Gdynia','4422775599','Martyniuk','800400100','IT');

CREATE TABLE dostawcy_czesci
(
  id_czesci_dostawcy SERIAL NOT NULL PRIMARY KEY,
  id_czesci          INTEGER,
  data_przyj_mag     TIMESTAMP,
  data_zam           TIMESTAMP,
  id_dostawcy        INTEGER,
  FOREIGN KEY (id_czesci) REFERENCES katalog_czesci,
  FOREIGN KEY (id_dostawcy) REFERENCES dostawcy);

INSERT INTO dostawcy_czesci (id_czesci_dostawcy,id_czesci, data_przyj_mag, data_zam, id_dostawcy)
    VALUES (1,2,'2017-02-02','2017-02-01',2)
INSERT INTO dostawcy_czesci (id_czesci_dostawcy,id_czesci, data_przyj_mag, data_zam, id_dostawcy)
    VALUES (2,1,'2018-04-04','2018-03-01',1)

INSERT INTO katalog_czesci(id_czesci, kategoria, name, cena, id_dostawcy)
    VALUES(1,'Hamulec','Reczny',999,2);
INSERT INTO katalog_czesci(id_czesci, kategoria, name, cena, id_dostawcy)
    VALUES(2,'Akcesoria','Mikser',30,2);