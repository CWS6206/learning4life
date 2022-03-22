/*
####################################################################################################
#                                                                                                  #
#     Informatik-Lehre                                                                             #
#                                                                                                  #
#     SQL Basis                                                                                    #
#                                                                                                  #
#     (C) 2022 Dr. René Bäder, Inf. Ing. EurEta / ETH                                              #
#                                                                                                  #
#     Beispieldatenbank "bene" für MySQL und MariaDB / Schema bene                                 #
#                                                                                                  #
####################################################################################################
*/
/*
Als root auszuführen:

CREATE USER admin IDENTIFIED BY 'admin';
CREATE SCHEMA admin DEFAULT CHARACTER SET latin1 COLLATE latin1_general_ci;
GRANT ALL PRIVILEGES ON admin.* TO 'admin'@'%';

Restliche Anweisungen als root oder admin ausführbar.
*/


CREATE TABLE bene.laender
(	iso char(2),
	bezeichnung varchar(40) NOT NULL,
	bezeichnung_en varchar(40) NOT NULL,
	eu bool NOT NULL,
	euro bool NOT NULL,
    CONSTRAINT pk_laender PRIMARY KEY (iso)
);

CREATE TABLE bene.lager
(	lagnr tinyint NOT NULL,
	bezeichnung varchar(40) NOT NULL,
	CONSTRAINT pk_lager PRIMARY KEY  (lagnr)
);


CREATE TABLE bene.lieferanten
(	liefnr int NOT NULL,
	firma1 varchar(80) NOT NULL,
	firma2 varchar(80),
	strasse varchar(50),
	land char(2),
	plz varchar(10),
	ort varchar(60),
	tel1 varchar(20),
	tel2 varchar(20),
	fax varchar(20),
	ansprechpartner varchar(60),
	email1 varchar(60) NULL,
	email2 varchar(60) NULL,
	web varchar(60),
	skonto decimal(3,1) DEFAULT 0,
	skontotage tinyint DEFAULT 0,
	ziel tinyint DEFAULT 0,
	uidnr varchar(12),
	iban varchar(36),
	bic varchar(11),    
	aktiv bool NOT NULL DEFAULT 1,
	hinweis varchar(300),
	erfasst datetime NOT NULL DEFAULT NOW(),
	CONSTRAINT pk_lieferanten PRIMARY KEY  (liefnr)
);

CREATE TABLE bene.status
(	stid tinyint NOT NULL,
	bezeichnung varchar(20) NOT NULL,
	CONSTRAINT pk_status PRIMARY KEY (stid),
    CONSTRAINT uk_status_bezeichnung UNIQUE (bezeichnung)
);

CREATE TABLE bene.abteilungen
(	abtnr char(2) NOT NULL,
	bezeichnung varchar(50) NOT NULL,
	CONSTRAINT pk_abteilungen PRIMARY KEY (abtnr),
    CONSTRAINT uk_abteilungen_bezeichnung UNIQUE (bezeichnung)
);

CREATE TABLE bene.gehaltstufen
(	stufe char(1) NOT NULL,
	von decimal(10,4) NOT NULL,
	bis decimal(10,4) NOT NULL,
	CONSTRAINT pk_gehaltstufen PRIMARY KEY (stufe)
);

CREATE TABLE bene.anreden
(	anrnr tinyint NOT NULL,
	bezeichnung varchar(20) NOT NULL,
	briefkopf varchar(20),
	briefanrede varchar(40),
	CONSTRAINT pk_anreden PRIMARY KEY (anrnr),
	CONSTRAINT uk_anreden_bezeichnung UNIQUE (bezeichnung)
);

CREATE TABLE bene.artikelgruppen
(	artgr char(2) NOT NULL,
	bezeichnung varchar(50) NOT NULL,
	CONSTRAINT pk_artikelgruppen PRIMARY KEY (artgr),
	CONSTRAINT uk_artikelgruppen_bezeichnung UNIQUE (bezeichnung)
);

CREATE TABLE bene.interessen
(	intcode char(3) NOT NULL,
	bezeichnung varchar(50) NOT NULL,
	CONSTRAINT pk_interessen PRIMARY KEY (intcode),
	CONSTRAINT uk_interessen_bezeichnung UNIQUE (bezeichnung)
);

CREATE TABLE bene.kundeninteressen
(	kdnr int NOT NULL,
	intcode char(3) NOT NULL,
	CONSTRAINT pk_kundeninteressen PRIMARY KEY (kdnr, intcode)
);

CREATE TABLE bene.lagerstand
(	artnr int NOT NULL,
	lagnr tinyint NOT NULL,
	menge int NOT NULL,
	reserviert int NOT NULL DEFAULT 0,
	CONSTRAINT pk_lagerstand PRIMARY KEY (artnr, lagnr)
);


CREATE TABLE bene.bestellungen
(	bestnr int AUTO_INCREMENT NOT NULL,
	datum datetime NOT NULL DEFAULT (CURRENT_DATE),
	lieferant int NOT NULL,
	bearbeiter int NOT NULL,
	bemerkung varchar(300),
	status tinyint NOT NULL DEFAULT 1,
	CONSTRAINT pk_bestellungen PRIMARY KEY (bestnr)
);

CREATE TABLE bene.wareneingang
(	waenr int AUTO_INCREMENT NOT NULL,
	datum datetime NOT NULL DEFAULT NOW(),
	lieferant int NOT NULL,
	lsnr varchar(20),
	bearbeiter int NOT NULL,
	status tinyint NOT NULL DEFAULT 1,
	CONSTRAINT pk_wareneingang PRIMARY KEY (waenr)
);


CREATE TABLE bene.artikel
(	artnr int AUTO_INCREMENT NOT NULL,
	bezeichnung varchar(60) NOT NULL,
	gruppe char(2) NOT NULL,
	vkpreis decimal(10, 4) NOT NULL DEFAULT 0,
	lieferant int NOT NULL,
	ekpreis decimal(10, 4),
	lieferzeit smallint,
	mindbestand int,
	hinweis varchar(300),
	mengebestellt int NOT NULL DEFAULT 0,
	mwst tinyint NOT NULL DEFAULT 19,
	aktiv bool NOT NULL DEFAULT 1,
	inaktivam datetime,
	inaktivvon varchar(30),
	CONSTRAINT pk_artikel PRIMARY KEY (artnr)
);



CREATE TABLE bene.wareneingangspositionen
(	waenr int NOT NULL,
	pos smallint NOT NULL,
	artikel int NOT NULL,
	bezeichnung varchar(100) NOT NULL,
	menge int NOT NULL,
	lager tinyint,
	CONSTRAINT pk_wareneingangspositionen PRIMARY KEY (waenr, pos)
);


CREATE TABLE bene.personal
(	persnr int NOT NULL,
	nachname varchar(50) NOT NULL,
	vorname varchar(50) NOT NULL,
	titel varchar(15),
	akad varchar(15) NULL,
    akad2 varchar(15) NULL,
	geschlecht tinyint NOT NULL,
	abtlg char(2) NOT NULL,
	vorgesetzter int,
	sozversnr char(4),
	gebdatum date,
	famstand tinyint,
	strasse varchar(50),
	land char(2) DEFAULT 'DE',
	plz varchar(10),
	ort varchar(60) ,
	telefon varchar(20),
	mobil varchar(20),
	iban varchar(36),
	bic varchar(11),
	eintritt date DEFAULT (CURRENT_DATE),
	austritt date,
	hinweis varchar(300),
	gehalt DECIMAL(10,4) NOT NULL DEFAULT 0,
	CONSTRAINT pk_personal PRIMARY KEY (persnr)
);

CREATE TABLE bene.bestellpositionen
(	bestnr int NOT NULL,
	pos smallint NOT NULL,
	artikel int NOT NULL,
	bezeichnung varchar(100) NOT NULL,
	menge int NOT NULL DEFAULT 1,
	preis DECIMAL(10,4) NOT NULL,
	rabatt decimal(4, 1) NOT NULL DEFAULT 0,
	CONSTRAINT pk_bestellpositionen PRIMARY KEY (bestnr, pos)
);

CREATE TABLE bene.kunden
(	kdnr int NOT NULL,
	nachname varchar(50),
	vorname varchar(50),
	titel varchar(15),
	akad varchar(15),
    akad2 varchar(15),
	firma1 varchar(80),
	firma2 varchar(80),
	geschlecht tinyint NOT NULL,
	strasse varchar(50) NOT NULL,
	land varchar(2) NOT NULL,
	plz varchar(10),
	ort varchar(50),
	telefon varchar(20),
	fax varchar(20),
	mobil varchar(20),
	email varchar(60),
	web varchar(60),
	erfasst datetime NOT NULL DEFAULT NOW(),
	skonto decimal(3, 1) NOT NULL DEFAULT 0,
	skontotage tinyint NOT NULL DEFAULT 0,
	ziel tinyint NOT NULL DEFAULT 0,
	lieferschein bool NOT NULL DEFAULT 0,
	gesperrt bool NOT NULL DEFAULT 0,
	hinweis varchar(300),
	CONSTRAINT pk_kunden PRIMARY KEY (kdnr)
);



CREATE TABLE bene.setartikel
(	setartnr int NOT NULL,
	teilartnr int NOT NULL,
	menge int NOT NULL DEFAULT 1,
	CONSTRAINT pk_setartikel PRIMARY KEY (setartnr, teilartnr)
);

CREATE TABLE bene.gruppen1
(	id char(2) NOT NULL,
	bezeichnung varchar(50) NOT NULL,
	CONSTRAINT pk_gruppen1 PRIMARY KEY  (id)
);

CREATE TABLE bene.gruppen2
(	id char(2) NOT NULL,
	bezeichnung varchar(50) NOT NULL,
	CONSTRAINT pk_gruppen2 PRIMARY KEY  (id)
);

CREATE TABLE bene.liketest
(	bezeichnung varchar(50)
);

CREATE INDEX ix_artikel_bezeichnung ON bene.artikel(bezeichnung);
CREATE INDEX ix_kunden_nachname ON bene.kunden(nachname);


ALTER TABLE bene.artikel ADD CONSTRAINT fk_artikel_artikelgruppen FOREIGN KEY(gruppe)
REFERENCES bene.artikelgruppen (artgr);

ALTER TABLE bene.artikel ADD CONSTRAINT fk_artikel_lieferanten FOREIGN KEY(lieferant)
REFERENCES bene.lieferanten (liefnr);

ALTER TABLE bene.bestellungen ADD CONSTRAINT fk_bestellungen_lieferanten FOREIGN KEY(lieferant)
REFERENCES bene.lieferanten (liefnr);

ALTER TABLE bene.bestellungen ADD CONSTRAINT fk_bestellungen_personal FOREIGN KEY(bearbeiter)
REFERENCES bene.personal (persnr);

ALTER TABLE bene.bestellungen ADD CONSTRAINT fk_bestellungen_status FOREIGN KEY(status)
REFERENCES bene.status (stid);

ALTER TABLE bene.bestellpositionen ADD CONSTRAINT fk_bestellpositionen_artikel FOREIGN KEY(artikel)
REFERENCES bene.artikel (artnr);

ALTER TABLE bene.bestellpositionen ADD CONSTRAINT fk_bestellpositionen_bestellungen FOREIGN KEY(bestnr)
REFERENCES bene.bestellungen (bestnr);

ALTER TABLE bene.kunden ADD CONSTRAINT fk_kunden_anreden FOREIGN KEY(geschlecht)
REFERENCES bene.anreden (anrnr);

ALTER TABLE bene.kunden ADD CONSTRAINT fk_kunden_laender FOREIGN KEY(land)
REFERENCES bene.laender (iso);

ALTER TABLE bene.kundeninteressen ADD CONSTRAINT fk_kundeninteressen_interessen FOREIGN KEY(intcode)
REFERENCES bene.interessen (intcode);

ALTER TABLE bene.kundeninteressen ADD CONSTRAINT fk_kundeninteressen_kunden FOREIGN KEY(kdnr)
REFERENCES bene.kunden (kdnr);

ALTER TABLE bene.lagerstand ADD CONSTRAINT fk_lagerstand_artikel FOREIGN KEY(artnr)
REFERENCES bene.artikel (artnr);

ALTER TABLE bene.lagerstand ADD CONSTRAINT fk_lagerstand_lager FOREIGN KEY(lagnr)
REFERENCES bene.lager (lagnr);

ALTER TABLE bene.personal ADD CONSTRAINT fk_personal_abteilungen FOREIGN KEY(abtlg)
REFERENCES bene.abteilungen (abtnr);

ALTER TABLE bene.personal ADD CONSTRAINT fk_personal_anreden FOREIGN KEY(geschlecht)
REFERENCES bene.anreden (anrnr);

ALTER TABLE bene.personal ADD CONSTRAINT fk_personal_laender FOREIGN KEY(land)
REFERENCES bene.laender (iso);

ALTER TABLE bene.setartikel ADD CONSTRAINT fk_setartikel_artikel FOREIGN KEY(setartnr)
REFERENCES bene.artikel (artnr);

ALTER TABLE bene.setartikel ADD CONSTRAINT fk_setartikel_artikel1 FOREIGN KEY(teilartnr)
REFERENCES bene.artikel (artnr);

ALTER TABLE bene.wareneingang ADD CONSTRAINT fk_wareneingang_lieferanten FOREIGN KEY(lieferant)
REFERENCES bene.lieferanten (liefnr);

ALTER TABLE bene.wareneingang ADD CONSTRAINT fk_wareneingang_personal FOREIGN KEY(bearbeiter)
REFERENCES bene.personal (persnr);

ALTER TABLE bene.wareneingang ADD CONSTRAINT fk_wareneingang_status FOREIGN KEY(status)
REFERENCES bene.status (stid);

ALTER TABLE bene.wareneingangspositionen ADD CONSTRAINT fk_wareneingangspositionen_artikel FOREIGN KEY(artikel)
REFERENCES bene.artikel (artnr);

ALTER TABLE bene.wareneingangspositionen ADD CONSTRAINT fk_wareneingangspositionen_wareneingang FOREIGN KEY(waenr)
REFERENCES bene.wareneingang (waenr);

ALTER TABLE bene.wareneingangspositionen ADD CONSTRAINT fk_wareneingangspositionen_lager FOREIGN KEY(lager)
REFERENCES bene.lager (lagnr);

ALTER TABLE bene.lieferanten ADD CONSTRAINT fk_lieferanten_laender FOREIGN KEY(land)
REFERENCES bene.laender (iso);




-- Daten eintragen

INSERT INTO bene.status( stid, bezeichnung) VALUES(1, 'erfasst');
INSERT INTO bene.status( stid, bezeichnung) VALUES(2, 'abgeschlossen');
INSERT INTO bene.status( stid, bezeichnung) VALUES(3, 'verrechnet');
INSERT INTO bene.status( stid, bezeichnung) VALUES(4, 'bezahlt');
INSERT INTO bene.status( stid, bezeichnung) VALUES(9, 'storniert');

-- SELECT * FROM bene.status ORDER BY stid;

INSERT INTO bene.abteilungen(abtnr, bezeichnung) VALUES('EK', 'Einkauf');
INSERT INTO bene.abteilungen(abtnr, bezeichnung) VALUES('VK', 'Verkauf');
INSERT INTO bene.abteilungen(abtnr, bezeichnung) VALUES('MA', 'Marketing');
INSERT INTO bene.abteilungen(abtnr, bezeichnung) VALUES('GL', 'Geschäftsleitung');
INSERT INTO bene.abteilungen(abtnr, bezeichnung) VALUES('LA', 'Lager');
INSERT INTO bene.abteilungen(abtnr, bezeichnung) VALUES('FB', 'Finanzbuchhaltung');
INSERT INTO bene.abteilungen(abtnr, bezeichnung) VALUES('CO', 'Controlling');

-- SELECT * FROM bene.abteilungen;

INSERT INTO bene.anreden(anrnr, bezeichnung, briefkopf, briefanrede) VALUES(1, 'Frau', 'Frau', 'Sehr geehrte Frau');
INSERT INTO bene.anreden(anrnr, bezeichnung, briefkopf, briefanrede) VALUES(2, 'Herr', 'Herrn', 'Sehr geehrter Herr');
INSERT INTO bene.anreden(anrnr, bezeichnung, briefkopf, briefanrede) VALUES(3, 'Familie', 'Familie', 'Sehr geehrte Familie');
INSERT INTO bene.anreden(anrnr, bezeichnung, briefkopf, briefanrede) VALUES(4, 'Firma', 'Firma', 'Sehr geehrte Damen und Herren');
INSERT INTO bene.anreden(anrnr, bezeichnung, briefkopf, briefanrede) VALUES(5, 'Institution', 'An', 'Sehr geehrte Damen und Herren');

-- SELECT * FROM bene.anreden;

INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('GE', 'Geschirr');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('BE', 'Besteck');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('KG', 'Küchengeschirr');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('EG', 'Elektrische Geräte');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('GA', 'Garten');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('HH', 'Haushalt');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('HW', 'Heimwerken');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('PC', 'Computer');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('SP', 'Spielwaren');
INSERT INTO bene.artikelgruppen(artgr, bezeichnung) VALUES('BU', 'Bücher');

-- SELECT * FROM bene.artikelgruppen ORDER BY artgr;

INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('GE', 'Geschirr');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('BE', 'Besteck');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('KG', 'Küchengeschirr');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('EG', 'Elektrische Geräte');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('GA', 'Garten');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('HH', 'Haushaltswaren');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('HW', 'Heimwerken');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('PC', 'Computer');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('LM', 'Lebensmittel');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('GT', 'Getränke');
INSERT INTO bene.gruppen1(id, bezeichnung) VALUES('BU', 'Bücher und Zeitschriften');

INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('GE', 'Geschirr');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('BE', 'Besteck');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('KG', 'Küchengeschirr');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('EG', 'Elektrische Geräte');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('GA', 'Garten');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('HH', 'Haushalt');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('HW', 'Heimwerken');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('PC', 'Computer');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('SP', 'Spielwaren');
INSERT INTO bene.gruppen2(id, bezeichnung) VALUES('BU', 'Bücher');


INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('AL', 'Albanien', 'Albania', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('BE', 'Belgien', 'Belgium', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('BA', 'Bosnien und Herzegowina', 'Bosnia and Herzegovina', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('BG', 'Bulgarien', 'Bulgaria', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('DK', 'Dänemark', 'Denmark', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('DE', 'Deutschland', 'Germany', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('EE', 'Estland', 'Estonia', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('FI', 'Finnland', 'Finland', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('FR', 'Frankreich', 'France', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('GI', 'Gibraltar', 'Gibraltar', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('GR', 'Griechenland', 'Greece', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('IE', 'Irland', 'Ireland', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('IS', 'Island', 'Iceland', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('IT', 'Italien', 'Italy', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('HR', 'Kroatien', 'Croatia', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('XK', 'Kosovo', 'Kosovo', 0, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('LV', 'Lettland', 'Latvia', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('LI', 'Liechtenstein', 'Liechtenstein', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('LT', 'Litauen', 'Lithuania', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('LU', 'Luxemburg', 'Luxembourg', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('MT', 'Malta', 'Malta', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('MD', 'Moldawien', 'Moldova', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('ME', 'Montenegro', 'Montenegro', 0, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('NL', 'Niederlande', 'Netherlands', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('MK', 'Nordmazedonien', 'North Macedonia', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('NO', 'Norwegen', 'Norway', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('AT', 'Österreich', 'Austria', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('PL', 'Polen', 'Poland', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('PT', 'Portugal', 'Portugal', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('RO', 'Rumänien', 'Romania', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('SE', 'Schweden', 'Sweden', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('CH', 'Schweiz', 'Switzerland', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('RS', 'Serbien', 'Serbia', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('SK', 'Slowakei', 'Slovakia', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('SI', 'Slowenien', 'Slovenia', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('ES', 'Spanien', 'Spain', 1, 1);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('CZ', 'Tschechien', 'Czech Republic', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('HU', 'Ungarn', 'Hungary', 1, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('GB', 'Vereinigtes Königreich', 'United Kingdom', 0, 0);
INSERT INTO bene.laender (iso, bezeichnung, bezeichnung_en, eu, euro) VALUES ('CY', 'Zypern', 'Cyprus', 1, 1);

-- SELECT * FROM bene.laender ORDER BY bezeichnung;
-- SELECT * FROM bene.laender WHERE eu = 1 ORDER BY bezeichnung;
-- SELECT * FROM bene.laender WHERE euro = 1 ORDER BY bezeichnung;

INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(1001, 'Grazer Besteck- und',	'Haushaltswaren GmbH', 'Löffelgasse 7', 'AT', '8010', 'Graz', '+43 316 123456', NULL, NULL, 'Johanna Löffel', 'verkauf@besteck.at', NULL, 'www.besteck.at', 3, 14, 30, 'ATU19192250', 'AT651700121212345678', 'BFKKAT2K', 1, 'A-Lieferant', '2014-12-16');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(1002, 'Eisenstumpel & Co', 'Metallwaren OEG', 'Stahlstrasse 98', 'AT', '8700', 'Leoben', '+43 3842 112321', '+43 664 1133226', '+43 3842 112321-11', 'Martin Eisen', 'office@eisen.at', NULL, 'www.eisen.at', 4, 7, 20, 'ATU87455401', 'AT651700121212345678', 'BFKKAT2K', 1, NULL, '2015-09-01');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(1003, 'Müller GmbH',	NULL, 'Hubertusallee 6', 'DE', '80798', 'München', '+49 89 1567884', NULL, NULL, NULL, 'mueller@mueller.com', 'service@mueller.com', 'www.mueller.com', 0, 0, 14, 'DE112200881', 'DE220015915915915915', 'HYVEDEMMXXX', 1, NULL, '2015-02-13');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(1008, 'Gardena AG', NULL, 'Schlauchstrasse 77', 'DE', '60547', 'Frankfurt', '+49 69 8874552', '+49 171 4565554', NULL, NULL, 'schlauch@gardena.eu', NULL, 'www.gardena.eu', 0, 0, 14, 'DE987658765', 'DE330003573577775533', 'COBADEFFXXX', 1, NULL, '2015-08-17');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(1020, 'Konrad KG', NULL, 'Bergstrasse 2a', 'DE', '44227', 'Dortmund', '+49 231 1551646', NULL, '+49 231 1551646-88', NULL, 'office@konrad.de', NULL, 'www.konrad.de', 0, 0, 14, 'DE022338871', 'DE440000741074107410', 'DEUTDEBBXXX', 1, NULL, '2016-02-20');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(1130, 'Lutzmann und', 'Partner GmbH & Co KG', 'Parkstrasse 48', 'AT', '1080', 'Wien',     '+43 1 5544993-0', '+43 676 5544999', '+43 1 5544993-99',  'Lutz Lutzmann', 'lutz@lutzmann.at', NULL, 'www.lutzmann.at', 0, 0,  14, 'ATU59482626', 'AT7700007060504030201', 'GIBAATWWXXX', 1, NULL, '2018-04-25');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(1240, 'Haushalt Verlag', NULL,                'Kochtopfweg 13', 'AT', '5020', 'Salzburg', '+43 662 489489-0', NULL,             '+43 662 489489-333', NULL, 'hhv@hauhal.at',    NULL, 'www.hauhal.at',   2, 14, 30, 'ATU46546546', 'AT6405805805812123455', 'BKAUATWW', 1, NULL, '2018-06-17');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, iban, bic, aktiv, hinweis, erfasst) VALUES(2005, 'Obermeier', NULL, 'Fundueweg 34', 'CH', '1209', 'Genf', '+41 22 339494-0', NULL, '+41 22 339494-333', NULL, 'kaese@obermeier.ch', NULL, 'www.obermeier.ch', 2, 14, 30, NULL, 'CH5400540456460000111','UBSWCHZHXXX', 1, NULL, '2019-03-13');
INSERT INTO bene.lieferanten(liefnr, firma1, firma2, strasse, land, plz, ort, tel1, tel2, fax, ansprechpartner, email1, email2, web, skonto, skontotage, ziel, uidnr, aktiv, hinweis, erfasst) VALUES(9999, 'Intern', NULL, 'XXXX', 'DE', 'XXXX', 'XXXX', 'XXXX', NULL, NULL, NULL, NULL, NULL, NULL, 0, 0, 0, NULL, 1, 'Intern/Setartikel', '1900-01-01');

-- SELECT * FROM bene.lieferanten;

INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1716, 'Riess Monika Kasserolle 20 cm', 'KG', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1717, 'Riess Monika Kasserolle 18 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1718, 'Riess Monika Kasserolle 14 cm', 'KG', 19.51, 1001, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1719, 'Riess Monika Fleischtopf 20 cm', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1720, 'Riess Monika Fleischtopf 18 cm', 'KG', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1721, 'Riess Monika Fleischtopf 16 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1722, 'Riess Bunt Einsiedekasserolle 30 cm', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1723, 'Riess Bratpfanne 29 x 18 cm', 'KG', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1724, 'Reparaturset für Schwimmbecken', 'HW', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1725, 'Reibmühle', 'GE', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1726, 'Riess Wasserkessel 2 lt Edelstahl', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1727, 'Riess Streublume Babystielkasserolle 14 cm', 'KG', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1728, 'Riess Streublume Topf 3/8 Liter', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1729, 'Riess Streublume Schnabeltopf 10 cm', 'KG', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1730, 'Riess Streublume Milchkanne 2 lt', 'KG', 36.95, 1001, 14.78, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1731, 'Regenmesser', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1732, 'Reisstrohmatten 6 Stück', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1733, 'Rolliege Helenic Grün', 'GA', 130.59, 1001, 52.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1734, 'Reisschale mit Löffel für Set 526388', 'GE', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1735, 'Rasenmäher', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1736, 'Rosen Rot', 'GA', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1737, 'Riess Thermoskanne 1 lt Dekor Grün Geflammt', 'KG', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1738, 'Riess Thermoskanne 1 lt Dekor Streublumen', 'KG', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1739, 'Riess Springform 26 cm Meisterbäcker', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1740, 'Riess Königskuchenform Meisterbäcker', 'KG', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1741, 'Riess Rehrückenform Meisterbäcker', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1742, 'Riess Gugelhupfform 23 cm Meisterbäcker', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1743, 'Remington Hygiene Clipper', 'EG', 21.69, 1001, 8.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1744, 'Remington Haarschneidemaschine HC 600', 'EG', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1745, 'Riess Doppelbratpfanne PR 32 x 22 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1746, 'Riess Gemüsetopf 5 lt', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1747, 'Reibe Pleasure', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1748, 'Riess Streublumen Schmalztopf 1,75 lt', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1749, 'Riess Streublumen Bauernschüssel 24 cm', 'KG', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1750, 'Riess Streublumen Bauernschüssel 28 cm', 'KG', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1751, 'Reinigungsset 7 tlg.', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1752, 'Rehrückenform 30 cm Weissblech', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1753, 'Riess Braun Topf 1 lt', 'KG', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1754, 'Riess Braun Topf 1,5 lt', 'KG', 13.63, 1001, 5.45, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1755, 'Riess Braun Deckel 18 cm', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1756, 'Riess Braun Deckel 20 cm', 'KG', 11.45, 1001, 4.58, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1757, 'Riess Braun Deckel 22 cm', 'KG', 11.88, 1001, 4.75, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1758, 'Riess Braun Deckel 24 cm', 'KG', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1759, 'Riess Braun Deckel 26 cm', 'KG', 13.63, 1001, 5.45, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1760, 'Riess Bunt Augenpfanne', 'KG', 19.51, 1001, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1761, 'Rohrreinigungswelle 3 Me', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1762, 'Rohrreinigungswelle 5 Me', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1763, 'Rohrreinigungswelle 7 Me', 'HH', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1764, 'Reisstrohmatte', 'HH', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1765, 'Reparaturset für Luftmatratzen', 'HW', 4.91, 1001, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1766, 'Roll-Rocket Expert', 'GA', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1767, 'Rauchrohrbürstenseil 6 Meter mit Gewinde', 'HW', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1768, 'Reibeisen Sechskant', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1769, 'Rohrschraubstock Gr 2', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1770, 'Rattenfalle', 'HH', 2.4, 1001, 0.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1771, 'Partyschirm mit Ständer 3m', 'HH', 88.9, 9999, 47.79, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1772, 'Rohrbürste 40 mm', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1773, 'Rohrbürste 50 mm', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1774, 'Rohrbürste 60 mm', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1775, 'Rohrbürste 70 mm', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1776, 'Rohrbürste 80 mm', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1777, 'Rohrbürste 90 mm', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1778, 'Rauchrohrbürste 130 mit Stiel', 'HW', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1779, 'Rauchrohrbürste 130 mit 1,5 Me Stiel', 'HW', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1780, 'Rauchrohrbürste 130 mit 2 Me Stiel', 'HW', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1781, 'Rosenbogen Monarc Weiss', 'GA', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1782, 'Riess Rührschüsselset 4 tlg.', 'KG', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1783, 'Riess Kuchenset 2 tlg.', 'KG', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1784, 'Riess Holzknechtpfanne 20 cm', 'KG', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1785, 'Riess Holzknechtpfanne 24 cm', 'KG', 19.51, 1001, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1786, 'Riess Holzknechtpfanne 26 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1787, 'Rauchrohrbürstenseil 8 Meter mit Gewinde', 'HW', 94.73, 1001, 37.89, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1788, 'Rückenschwamm SB', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1789, 'Roll-Rocket Ersatzwalze', 'GA', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1790, 'Reparaturset 80 tlg.', 'HW', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1791, 'Soehnle Laufgewichtswaage KW/1401', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1792, 'Schutzhülle für Sitzgruppe 200 cm', 'GA', 38.04, 1001, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1793, 'Strandstuhl Zerlegbar', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1794, 'Spritzschutzdeckel 2 Stk. Packung', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1795, 'Spitzsieb 14 cm', 'KG', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1796, 'Spitzsieb 18 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1797, 'Schüssel Profi 16 cm', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1798, 'Schüssel Profi 20 cm', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1799, 'Schüssel Profi 24 cm', 'GE', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1800, 'Schüssel Profi 28 cm', 'GE', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1801, 'Schneebesen 20 cm', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1802, 'Schneebesen 25 cm', 'GE', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1803, 'Schneebesen 30 cm', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1804, 'Schöpfer 6 cm', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1805, 'Schöpfer 8 cm', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1806, 'Schöpfer 9 cm', 'GE', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1807, 'Schöpfer 10 cm', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1808, 'Sauciere 0,15 lt', 'GE', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1809, 'Sauciere 0,30 lt', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1810, 'Schüssel Profi 32 cm', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1811, 'Severin Trockenhaube', 'EG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1812, 'Severin Joghurt Fix', 'EG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1813, 'Schaschlikspiesse 200 Stk. Packung', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1814, 'Stövchen Atelier', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1815, 'Schüssel 23 cm Atelier', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1816, 'Schüssel 21 cm Atelier', 'GE', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1817, 'Schüssel 16 cm Atelier', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1353, 'Hornhautstift', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1354, 'Heizkörperentlüfter', 'HH', 8.61, 1020, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1355, 'Hecken- und Baumscherenset HS55W + AS71T', 'GA', 32.7, 1001, 13.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1356, 'Holz Kindergarnitur', 'GA', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1357, 'Heckenschere HS52WT', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1358, 'Heissner Pumpe P15', 'GA', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1359, 'Herdabdeckplatte Dekor Hühner', 'HH', 10.68, 1020, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1360, 'Herdabdeckplatte Dekor Vögel', 'HH', 10.68, 1020, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1361, 'Herdabdeckplatte Dekor Gemüse', 'HH', 10.68, 1020, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1362, 'Hosenbügel', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1363, 'Holzliegestuhl mit Fussteil', 'GA', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1364, 'Handkescher', 'GA', 34.88, 1001, 13.95, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1365, 'Handfeger Rosshaar', 'GE', 5.34, 1020, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1366, 'Holzteller mit Saftrille', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1367, 'Hobel Pantha', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1368, 'Heizmatte BWM HTN 150 S', 'GE', 38.04, 1020, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1369, 'Heizkesselbürste 40x80', 'GE', 8.18, 1001, 3.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1370, 'Heizkesselbürste 50x100', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1371, 'Heizkesselbürste 50x120', 'GE', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1372, 'Huhnform 1 lt Weissblech', 'KG', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1373, 'Hasenform 0,5 lt Weissblech', 'GE', 9.7, 1020, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1374, 'Heissner Folie 0,5', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1375, 'Heizkörperreiniger', 'GE', 10.68, 1020, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1376, 'Heizkörperreiniger Flach', 'GE', 7.52, 1020, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1377, 'Handschleiferset mit Schleifpapier', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1378, 'Herdbackblech mit Rührteig', 'GE', 21.58, 1020, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1379, 'Hosenspanner Metall 2 Stk. Packung', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1380, 'Isi Rezeptheft', 'HH', 0, 1001, 0, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1381, 'Isolierkanne 1,9 lt Airpot', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1382, 'Indianer Krapfenform 35,5 x 27 cm', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1383, 'Intensiventkalker 6 Stk. Packung SB', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1384, 'Insektenschutz für Kinderwagen SB', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1385, 'Juwel Folienfrühbeet', 'GA', 65.19, 1020, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1386, 'Jalousetten-Reiniger 2 Stk. Packung SB', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1387, 'Jausenset 30 tlg.', 'GE', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1388, 'Jausenmesser', 'BE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1389, 'Juwel Wäschespinne Novamatic 60 ME', 'HH', 206.03, 1001, 82.41, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1390, 'Jumbo Stapelregal Beige', 'HH', 9.7, 1020, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1391, 'Juwel Wäschespinne Alustar 60 ME', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1392, 'Juwel Wäschespinne Comfort 60 ME', 'HH', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1393, 'Juwel Wäschespinne Brillant 60 ME', 'HH', 147.16, 1001, 58.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1394, 'Juwel Frühbeetkasten', 'GA', 140.62, 1020, 56.25, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1395, 'Juwel Anbausatz 1000', 'GA', 107.92, 1001, 43.17, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1396, 'Juwel Lüftungsautomat', 'HH', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1397, 'Jausenset Bestehend Aus 6 Messer Und 6 Bretter', 'GE', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1398, 'Jumbo Stapelregal 4 Stk.', 'HH', 31.5, 1020, 12.6, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1399, 'Jausenbretter P6', 'GE', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1400, 'Kleiderbügel mit Steg 3 Stk. Packung', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1401, 'Kleiderbügel mit Steg', 'HH', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1402, 'Kaffeelöffel 6 Stk. Packung', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1403, 'Kuchengabel 6 Stk. Packung', 'BE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1404, 'Backformen Set Weissblech', 'KG', 19.9, 9999, 9.94, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1405, 'Kochfeldreiniger mit Schaber Sb', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1406, 'Kasserolle Brillant 14 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1407, 'Kochlöffelset 5 tlg.', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1408, 'Küchenschaufel 3 tlg.', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1409, 'Krups Universal-Zerkleinerer Speedy', 'EG', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1410, 'Kinderrutsche', 'GA', 118.82, 1001, 47.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1411, 'Kaffeekanne Atelier', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1412, 'Kaffeebecher Atelier 6 Stk.-Packung', 'GE', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1413, 'Kaffeebecher Atelier', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1414, 'Kaffeetasse mit Untertasse Atelier', 'GE', 4.58, 1001, 1.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1415, 'Kaffeetasse mit Untertasse Atelier 6 Stk.', 'GE', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1416, 'Kompottschüssel 13 cm Atelier', 'GE', 3.82, 1001, 1.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1417, 'Kompottschüssel 13 cm Atelier 6 Stk.', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1418, 'Kelomat Futura 4 lt Schnellkochtopfset 4 tlg.', 'KG', 130.59, 1001, 52.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1419, 'Karaffe Glas', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1420, 'Kniekissen 2 Stk. Packung', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1421, 'Küchenhacke', 'BE', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1422, 'Küchenreibe', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1423, 'Kaffeeservice Atelier', 'GE', 44.9, 9999, 23.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1424, 'Kelomat Gourmet Pfanne 24 cm', 'KG', 50.04, 1001, 20.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1425, 'Kelomat Gourmet Pfanne 28 cm', 'KG', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1426, 'Kochtopf Universal 8 lt', 'KG', 54.29, 1001, 21.29, 2, 4, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1427, 'Kekspresse Ampia', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1428, 'Kissentasche', 'HH', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1429, 'Krawattenhalter', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1430, 'Kühlbox Hart 20 lt', 'HH', 20.6, 1001, 8.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1431, 'Kelomat Murano Bratentopf 16 cm', 'KG', 93.64, 1001, 37.46, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1432, 'Kelomat Murano Bratentopf 20 cm', 'KG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1433, 'Kelomat Murano Bratentopf 24 cm', 'KG', 141.49, 1001, 56.6, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1434, 'Kelomat Murano Fleischtopf 16 cm', 'KG', 97.89, 1001, 39.16, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1435, 'Kelomat Murano Fleischtopf 20 cm', 'KG', 119.69, 1001, 47.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1436, 'Kelomat Murano Fleischtopf 24 cm', 'KG', 152.39, 1001, 60.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1437, 'Kelomat Murano Milchtopf 16 cm', 'KG', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1438, 'Kelomat Murano Stielkasserolle 16 cm', 'KG', 71.84, 1001, 28.73, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1439, 'Koffertisch', 'HH', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1440, 'Kelomat Grillmeister Pfanne 28 cm', 'KG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1441, 'Kelomat Grillmeister Pfanne 24 cm', 'KG', 97.89, 1001, 39.16, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1442, 'Kaffeebecher Mugs 6 Stk. Packung', 'GE', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1443, 'Kompottgarnitur Caracas 7 tlg.', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1444, 'Küchensieb Rostfrei', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1445, 'Knödelschöpfer Hr Brillant', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1446, 'Königskuchenform 30 cm Progriff', 'KG', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1447, 'Klapphocker', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1448, 'Küchenlöffelset 6 tlg.', 'BE', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1449, 'Kühltasche 16 lt', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1450, 'Kühltasche 26 lt', 'HH', 12.54, 1001, 5.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1451, 'Kinderzahnbürste mit Aufsteller', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1452, 'Kleiderständer', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1453, 'Kehrgarnitur', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1454, 'Komposter Thermo Star', 'GA', 174.2, 1001, 69.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1455, 'Kinder-Holzliegestuhl', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1456, 'Kühlbox Hart 32 lt', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1457, 'Kühlbox 990 SL', 'HH', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1458, 'Klettband 5 Meter Weiss', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1459, 'Knoblauchpresse HR Brillant', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1460, 'Kochlöffelset 3 Stk. Packung', 'KG', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1461, 'Kurzzeitmesser Koch', 'BE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1462, 'Kinderersatzbürste 4 Stk. Packung', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1463, 'Kaffeeset Hallein 18 tlg.', 'GE', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1464, 'Kindergarnitur 3 tlg.', 'GE', 5.45, 1001, 2.18, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1465, 'Kaffeetasse mit Untertasse Rapsodie', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1466, 'Kaffeetasse mit Untertasse Rapsodie', 'GE', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1467, 'Klapptrittleiter', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1468, 'Kaffeetasse mit Untertasse Barkerole', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1469, 'Konturenschneidhilfe', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1470, 'Kaffeebecher Bluete 6 Stk. Packung', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1471, 'Käsebrett 34,5 x 19 cm', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1472, 'Kartoffelstampfer HR Brillant', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1473, 'Krankentrinkschale', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1474, 'Klappbox 48x35 cm', 'HH', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1475, 'Kühlbox Hart 8 lt', 'HH', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1476, 'Kelomat Montana Standardpfanne 20 cm', 'KG', 51.13, 1001, 20.45, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1477, 'Kelomat Montana Standardpfanne 24 cm', 'KG', 63.12, 1001, 25.25, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1478, 'Kelomat Montana Standardpfanne 28 cm', 'KG', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1479, 'Kelomat Glasdeckel 24 cm', 'KG', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1480, 'Kelomat Glasdeckel 28 cm', 'KG', 29.32, 1001, 11.73, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1481, 'Kelomat Universalbräter', 'KG', 174.2, 1001, 69.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1482, 'Kelomat Murano Pfanne mit Deckel 28 cm', 'KG', 119.69, 1001, 47.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1483, 'Kelomat Murano Geschirrset 9 tlg.', 'KG', 325.94, 1001, 130.38, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1484, 'Kaffeeservice 15 tlg. Zwiebelmuster', 'GE', 97.89, 1001, 39.16, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1485, 'Kaffeebecher Jagatee', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1486, 'Kaffeekanne Rio', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1487, 'Kaffeebecher Wien 3 Stk. Packung', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1488, 'Kombiservice Rio 30 tlg.', 'HH', 196, 1001, 78.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1489, 'Kaffeebecher Konfetti für Set', 'GE', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1490, 'Kaffeebecher Konfetti 3 Stk Packung', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1491, 'Kaffeebecher Ilse 6 Stk. Packung', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1492, 'Kinderbesteck 4 tlg.', 'BE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1493, 'Knoblauchtopf für Set', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1494, 'Kelomat Montana Pfanne 24 cm Flach', 'KG', 57.67, 1001, 23.07, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1495, 'Kelomat Montana Pfanne 26 cm Flach', 'KG', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1496, 'Kelomat Montana Pfanne 28 cm Flach', 'KG', 72.93, 1001, 29.17, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1497, 'Kräuterteetasse', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1498, 'Käsefondue 9 tlg.', 'GE', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1499, 'Kochstar Pfanne Primus 20 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1500, 'Kochstar Pfanne Primus 24 cm', 'KG', 29.32, 1001, 11.32, 2, 2, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1501, 'Kochstar Pfanne Primus 28 cm', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1502, 'Kochstar Pfanne Juwel 20 cm', 'KG', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1503, 'Kochstar Pfanne Juwel 24 cm', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1504, 'Kochstar Pfanne Juwel 28 cm', 'KG', 36.95, 1001, 14.78, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1505, 'Kuchen- Und Servierplatte 36 x 17 cm', 'GE', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1506, 'Keksdosenset 3 tlg.', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1507, 'Kinder-Werkzeugset', 'HW', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1508, 'Kaiser Knusperpinsel', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1509, 'Kaiser Backblech Knusperfit', 'KG', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1510, 'Kometen Backform', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1511, 'Krups Kaffeeautomat Espresso Primo', 'EG', 174.2, 1001, 69.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1512, 'Krups Haarfön HH pro Care 1200', 'EG', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1513, 'Kuchenrost 32 cm', 'KG', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1514, 'Korbflasche 3 lt', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1515, 'Kuppelzelt Iglo 240 x 210 cm', 'GA', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1516, 'Krapfentuelle', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1517, 'Kelomat Blitzgrill', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1518, 'Kartoffelpresse', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1519, 'Kaminbürste Rund 160 mm', 'HW', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1520, 'Kaminbürste Rund 180 mm', 'HW', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1521, 'Kaminbürste Rund 200 mm', 'HW', 29.32, 1001, 11.73, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1522, 'Königskuchenform 30 cm Weissblech', 'KG', 6, 1001, 2.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1523, 'Krug 1 lt', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1524, 'Küchenschüsseln 3 tlg.', 'GE', 20.6, 1001, 8.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1525, 'Knickhalme 40 Stk.', 'GE', 1.09, 1001, 0.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1526, 'Knickhalme 80 Stk.', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1527, 'Königskuchenform 35 cm Weissblech', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1528, 'Kasserolle Brillant 16 cm', 'KG', 30.41, 1001, 12.17, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1529, 'Kasserolle Brillant 20 cm', 'KG', 34.77, 1001, 13.91, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1530, 'Kasserolle Brillant 24 cm', 'KG', 45.67, 1001, 18.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1531, 'Kochtopf Brillant 16 cm', 'KG', 30.41, 1001, 12.17, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1532, 'Kochtopf Brillant 20 cm', 'KG', 38.04, 1001, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1533, 'Kochtopf Brillant 24 cm', 'KG', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1534, 'Kochplattenreiniger', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1535, 'Krapfenausstecher 2 Stk. Packung', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1536, 'Krapfenausstecher 7 cm', 'KG', 1.74, 1001, 0.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1537, 'Krapfenausstecher 6 cm', 'KG', 1.74, 1001, 0.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1538, 'Kinderbügel 3 Stk. Packung', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1539, 'Klammernbügel 40 cm 2 Stk. Packung', 'HH', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1540, 'Kasserolle Brillant 18 cm', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1541, 'Kochtopf Brillant 18 cm', 'KG', 34.77, 1001, 13.91, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1542, 'Kaffeebecher Almspruch', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1543, 'Kartoffelstampfer', 'KG', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1544, 'Kelomat Töpfeset Murano 5tlg.', 'KG', 399, 9999, 224.61, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1545, 'Lampe mit Öl', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1546, 'Limolöffel 6 Stk. Packung', 'BE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1547, 'Leifheit Rollenhalter Perfect', 'HH', 41.31, 1001, 16.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1548, 'Leifheit Einfülltrichter', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1549, 'Leifheit Knoblauchpresse Creativ', 'HH', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1550, 'Leifheit Dosenöffner Creativ', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1551, 'Leifheit Bügeltischbezug 110 x 32 cm', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1552, 'Leifheit Bügeltisch Carolin', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1553, 'Leifheit Bügeltischbezug 115 x 35 cm', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1554, 'Leifheit Ärmelbrett', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1555, 'Leifheit Korkenzieher Vino', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1556, 'Leifheit Bodenwischer Hausrein', 'HH', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1557, 'Leifheit Überzug Nass Hausrein', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1558, 'Leiterwagen', 'GA', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1559, 'Leifheit Überzug Trocken Hausrein', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1560, 'Lebkuchenausstecher Schaukelpferd', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1561, 'Leifheit Bodenwischer', 'HH', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1562, 'Leifheit Ersatzbodentuch für Bodenwischer', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1563, 'Leifheit Eierschneider', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1564, 'Leifheit Allzweckreibe', 'KG', 21.69, 1001, 8.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1565, 'Lampenöl 0,75 lt', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1566, 'Liegematte Sortiert 170 x 50 x 2 cm', 'GA', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1567, 'Leifheit Deckelöffner', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1568, 'Lammform 0,5 lt Weissblech', 'KG', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1569, 'Luftmatratzenset PVC 2 Stk. Packung', 'GA', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1570, 'Latzhose Blau 46', 'HW', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1571, 'Latzhose Blau 48', 'HW', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1572, 'Latzhose Blau 50', 'HW', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1573, 'Latzhose Blau 52', 'HW', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1574, 'Latzhose Blau 54', 'HW', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1575, 'Latzhose Blau 56', 'HW', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1576, 'Lackierpinselset 5 tlg. reine Chinaborste', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1577, 'Luftmatratze Komfort Doppelbett 198 x 150 cm', 'GA', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1578, 'Luftmatratze Komfort Einzelbett 190 x 98 cm', 'GA', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1579, 'Liegematte Isoliermatte 8 Mm, 185 x 50 cm', 'GA', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1580, 'Leifheit Ersatzschrubber', 'HH', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1581, 'Leifheit Garnierspritze', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1582, 'Moulinex Friteuse A08', 'EG', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1583, 'Mole Stop', 'GA', 195.13, 1001, 78.05, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1001, 'Abdeckbänderset 4 tlg.', 'HH', 10.68, 1001, 4.27, 5, NULL, NULL, 21, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1002, 'Abflussieb PVC rund HR 4 Stk. Packung SB', 'KG', 7.52, 1001, 3.01, 2, NULL, NULL, 11, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1003, 'Abfallsack 110 lt', 'HH', 3.16, 1001, 1.26, 3, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1004, 'Abfallsack 60 lt', 'HH', 2.07, 1001, 0.83, 3, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1005, 'Abgiesser', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1006, 'Ausgiesser Gihale 6 Stk. Packung', 'GE', 8, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1007, 'Aquafit Erstausrüstungs-Set für Schwimmbad', 'GA', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1008, 'Alu-Spiralstab 170 cm P60', 'HH', 6.43, 1002, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1009, 'Alu-Spiralstab 200 cm P60', 'HH', 7.52, 1002, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1010, 'Abdeckplane für Stahl- Rohrbecken 165x165 cm', 'HW', 19.51, 1002, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1011, 'Abdeckplane 360 cm für Schwimmbecken', 'GA', 163.3, 1002, 65.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1012, 'Apfelreibe', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1013, 'Arzneischrank Weiss 35 x 45 x 15 cm', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1014, 'Arzneischrank Beige 35 x 45 x 15 cm', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1015, 'Abdeckplane für Stahl- Rohrbecken 250 x 165 cm', 'HW', 21.58, 1002, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2013, 'Werit Blumenschale Kreta Steingrau', 'GA', 38.04, 1001, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2014, 'Werit Blumenschale Samos Steingrau', 'GA', 46.76, 1001, 18.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2015, 'Werit Blumentrog Milos Steingrau', 'GA', 50.04, 1001, 20.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2016, 'Wespenfalle', 'GA', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2017, 'Wespen-Lockstoff 0,5 lt', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2018, 'Wühlmausfalle 2 Stk. Packung', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2019, 'Wiegemesser 26 cm', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2020, 'Wolf Rasenmäher mit Box 2.42 TL', 'GA', 511.25, 1001, 204.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2021, 'Wasserschlauch Tristar 25 me 1/2"', 'GA', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2022, 'Wasserschlauch Tristar 50 me 1/2"', 'GA', 64.21, 1001, 25.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2023, 'Wasserschlauch Tristar 25 me 3/4"', 'GA', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2024, 'Wasserschlauch Tristar 50 me 3/4"', 'GA', 107.81, 1001, 43.12, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2025, 'Wäschenetz 5 kg', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2026, 'Wäschenetz 3 kg', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2027, 'Wc-Kombihalter', 'HH', 29.32, 1001, 11.73, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2028, 'Wagner Spritzpistole W 60', 'EG', 80.56, 1001, 32.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2029, 'Wecker Uhr Quarz', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2030, 'Wäscheleine Ausziehbar', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2031, 'Werit Blumenschale Samos Weiss', 'GA', 46.76, 1001, 18.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2032, 'Werit Blumenschale Kreta Weiss', 'GA', 38.04, 1001, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2033, 'Werit Blumentrog Milos Weiss', 'GA', 50.04, 1001, 20.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2034, 'Wetterhahn Schwarz', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2035, 'Windschutz 600 x 140 cm', 'GA', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2036, 'Wurst Und Brot Box', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2037, 'Wecker Uhr Mechanisch Weiss', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2038, 'Wecker Uhr Mechanisch Rot', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2039, 'Weissbierglas', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2040, 'Wagner Rollgerät W 1800', 'EG', 80.67, 1001, 32.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2041, 'Wagner Rollgerät W 2200e', 'EG', 118.82, 1001, 47.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2042, 'Wasserkanister 10 lt', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2043, 'Wasserkanister 20 lt', 'HH', 11.99, 1001, 4.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2044, 'Wagner Netzgerätstecker', 'EG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2045, 'Wasserkessel Email Zwiebelmuster', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2046, 'Wanduhr Schwarz', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2047, 'Wanduhr Weiss', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2048, 'Weinkühler', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2049, 'Wetterstation', 'GA', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2050, 'Weihnachtsbaum Backform 25 cm', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2051, 'Weihnachtsbackset 6 tlg.', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2052, 'Wenko Tischdecke Rot', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2053, 'Wenko Tischdecke Blau', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2054, 'Wenko Tischdecke Blumen', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2055, 'Wäscheklammer 100 Stk. Packung', 'HH', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2056, 'Wäschebox Weiss', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2057, 'Wäschebox Blau', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2058, 'Wäscheleine PVC 20 Me', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2059, 'Wäscheleine PVC 30 Me', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2060, 'Werit Blumenzwiebelkorb 30 cm 3 Stk. Packung', 'GA', 4.91, 1001, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2061, 'Werit Untersetzer PVC 60 cm Quarz', 'GA', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2062, 'Werit Untersetzer PVC 80 cm Quarz', 'GA', 3.6, 1001, 1.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2063, 'Werit Untersetzer PVC 100 cm Quarz', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2064, 'Wolf RI-T Handgrasschere mit Antihaftbeschichtung', 'GA', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2065, 'Wagner Spritzpistole W 200', 'EG', 184.23, 1001, 73.69, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2066, 'Windschutz 400 x 140 cm', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2067, 'Wäscheleine PVC 60 me für Wäschespinne', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2068, 'Werit Blumenkasten Jumbo 80 cm Braun', 'GA', 3.6, 1001, 1.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2069, 'Werit Blumenkasten Jumbo 80 cm Grün', 'GA', 3.6, 1001, 1.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2070, 'Werit Blumenkasten Jumbo 100 cm Braun', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2071, 'Werit Blumenkasten Jumbo 100 cm Grün', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2072, 'Werit Untersatz Jumbo 80 cm Braun', 'GA', 3.6, 1001, 1.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2073, 'Werit Untersatz Jumbo 80 cm Grün', 'GA', 3.6, 1001, 1.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2074, 'Werit Untersatz Jumbo 100 cm Braun', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2075, 'Werit Untersatz Jumbo 100 cm Grün', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2076, 'Werit Blumenkasten Jumbo 40 cm Braun', 'GA', 1.64, 1001, 0.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2077, 'Werit Blumenkasten Jumbo 40 cm Grün', 'GA', 1.64, 1001, 0.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2078, 'Werit Untersatz Jumbo 40 cm Braun', 'GA', 1.64, 1001, 0.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2079, 'Werit Untersatz Jumbo 40 cm Grün', 'GA', 1.64, 1001, 0.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2080, 'Werit Blumenkasten Jumbo 60 cm Braun', 'GA', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2081, 'Werit Blumenkasten Jumbo 60 cm Grün', 'GA', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2082, 'Werit  Untersatz Jumbo 60 cm Braun', 'GE', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2083, 'Werit Untersatz Jumbo 60 cm Grün', 'GA', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2084, 'Wandregal Weiss Sb', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2085, 'Waschbeckendusche', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2086, 'Wollflusenkiller', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2087, 'Wolf Gartenschere RS 19', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2088, 'Wolf Gartenschere RS 22', 'GA', 29.32, 1001, 11.73, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2089, 'Wäschetrockner für Heizkörper 2 Stk.', 'HH', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2090, 'Wühlmauskegel Bromet 4 Stk. Packung', 'GA', 20.6, 1001, 8.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2091, 'Wühlmauskegel Bromet 2 Stk. Packung', 'GA', 10.36, 1001, 4.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2092, 'Weinkanne 0,25 lt', 'GE', 1.85, 1001, 0.74, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2093, 'Zyliss Knoblauchpresse Antihaft Super', 'KG', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2094, 'Zyliss Dosenöffner', 'KG', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2095, 'Zuckerdose Atelier', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2096, 'Zubehör Set 60 Mm für Plus 1000', 'HH', 63.12, 1001, 25.25, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2097, 'Zyliss Gemüsereibe', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2098, 'Zyliss Clip-Timer', 'KG', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2099, 'Zaunblende 100 cm x 10 Meter', 'GA', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2100, 'Zaunblende 120 cm x 10 Meter', 'GA', 76.2, 1001, 30.48, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2101, 'Zaunblende 150 cm x 10 Meter', 'GA', 97.89, 1001, 39.16, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2102, 'Zuckerdose Rapsodie für Set 623292', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2103, 'Zuckerdose Barkerole', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2104, 'Zelt Bornholm 3', 'GA', 173.32, 1001, 69.33, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2105, 'Zyliss Zwiebelhacker', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2106, 'Zwiebeltopf', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2107, 'Zackenschere Mundial', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2108, 'Zelt Mini Pack', 'GA', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2109, 'Zyliss Pommes-Schneider', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2110, 'Zyliss Fleischwolf', 'KG', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2111, 'Ziergitter mit Blumentopf', 'GA', 26.05, 1001, 10.42, 2, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2112, 'Kochstar Juwel Pfannenset', 'KG', 64.99, 1001, NULL, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1584, 'Moulinex Fleischwolf', 'EG', 217.8, 1001, 87.12, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1585, 'Moulinex Passiermaschine Gross', 'EG', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1586, 'Milchkanne 0,6 lt', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1587, 'Milchkanne 1 lt', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1588, 'Moulinex Zitruspresse', 'EG', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1589, 'Menage 3 tlg. Metall', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1590, 'Mikrowellen Eierkocher 2 Stk. Packung', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1591, 'Mosquito Stop Twinny', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1592, 'Moccatasse mit Untertasse Atelier', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1593, 'Moccatasse mit Untertasse Atelier', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1594, 'Mouse Trap 3+1', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1595, 'Mole Stop Solar', 'GA', 234.37, 1001, 93.75, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1596, 'Mikrowellen Reiskocher', 'GE', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1597, 'Melitta Folienschlauch 2 Stk. Packung', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1598, 'Metall-Schirmständer Dreifuss', 'HH', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1599, 'Moulinex Haarfön Infrasoft 1200 Watt', 'EG', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1600, 'Moulinex Haarfön Infrasoft', 'EG', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1601, 'Mandelreibe', 'KG', 19.51, 1001, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1602, 'Messerblock 6 tlg.', 'GE', 21.8, 1001, 8.72, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1603, 'Moulinex Dampfbügeleisen Ultimate', 'EG', 97.89, 1001, 39.16, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1604, 'Moulinex Handmixer Trio 160 Watt', 'EG', 59.85, 1001, 23.94, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1605, 'Milchgiesser Rapsodie', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1606, 'Menagen Rapsodie', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1607, 'Menage 4 tlg.', 'GE', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1608, 'Melitta Schnellentkalker 4 Stk. Packung', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1609, 'Moulinex Kaffeautomat', 'EG', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1610, 'Moulinex Filterset für Crystall', 'EG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1611, 'Musikglocke mit 24 Melodien', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1612, 'Milchtopf Aktion 14 cm', 'KG', 5.45, 1001, 2.18, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1613, 'Moulinex Dampfbügeleisen Optimate 80', 'EG', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1614, 'Mosquito Stop 40', 'HH', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1615, 'Mücken-Stop Pocket', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1616, 'Marktschirm-Ständer', 'GA', 29.32, 1001, 11.73, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1617, 'Motorhacke Meppy', 'HW', 543.96, 1001, 217.58, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1618, 'Mehlsieb Edelstahl', 'KG', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1619, 'Multifunktions- Scheinwerfer Halo 4', 'HW', 174.2, 1001, 69.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1620, 'Moulinex Küchenmaschine Jeanette E12', 'EG', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1621, 'Melitta Schnellentkalker 2 Stk. Packung', 'HH', 1.64, 1001, 0.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1622, 'Melitta Folienschlauch', 'HH', 2.17, 1001, 0.87, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1623, 'Melitta Müllbeutel bis 35 lt', 'HH', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1624, 'Milchkanne 2 lt Kunststoff', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1625, 'Moulinex Passiermaschine Baby', 'EG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1626, 'Möbelregal Holz 170 x 80 x 30 cm', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1627, 'Mausfalle 2 Stk. Packung', 'HH', 2.18, 1001, 0.87, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1628, 'Mehlsieb und Puderzucker- Streuer 2 tlg.', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1629, 'Messerset 6 tlg.', 'GE', 21.8, 1001, 8.72, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1630, 'Milchtopf Brillant 14 cm', 'KG', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1631, 'Moulinex Kaffeemühle', 'EG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1632, 'Moulinex Dampfbügeleisen AX2 Chronomate', 'EG', 38.15, 1001, 15.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1633, 'Metallschaufel', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1634, 'Nackenstütze', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1635, 'Nussknacker Sieger', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1636, 'Nachfüllpackung für Feuchtigkeitskiller', 'HH', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1637, 'Oetker Puddingformen 10 Stk. Packung', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1638, 'Ofenthermometer', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1639, 'Obstkorb Weide', 'GE', 11.99, 1001, 4.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1640, 'Pinselset 15 tlg. HR', 'HW', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1641, 'Pfannenwender Flonal', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1642, 'Philips Gesichtsbräuner HP170', 'EG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1643, 'Pralinenförmchen Papier 150 Stk. Packung', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1644, 'Papierförmchen 200 Stk. Packung', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1645, 'Pfanne mit Deckel Brillant 28 cm', 'KG', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1646, 'Pflanzspalier Holz 50 x 200 cm', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1647, 'Pflanzspalier Holz 200 x 100', 'GA', 28.23, 1001, 11.29, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1648, 'Platte 33 cm Atelier Oval', 'GE', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1649, 'Platte 29 cm Atelier Oval', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1650, 'Platte 26 cm Atelier Oval', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1651, 'Platte 22 cm Atelier Oval', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1652, 'Puppen Buggy', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1653, 'Patentflasche 2 lt', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1654, 'Passiermaschine Rostfrei 20 cm', 'KG', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1655, 'Pinty Anstreich Set', 'HW', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1656, 'Pfanne 28 cm', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1657, 'Pfanne 24 cm', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1658, 'Pfanne 20 cm', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1659, 'Philips Gesichtssauna', 'EG', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1660, 'Pastabrenner', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1661, 'Philips Dampfbügeleisen Azur HI 510', 'EG', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1662, 'Planschbecken Stahlrohr 250 x 165 x 50 cm', 'GA', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1663, 'Palatschinkenpfanne HR', 'KG', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1664, 'Philips Staubsauger Hand', 'EG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1665, 'Pavillon 3 x 3 me', 'GA', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1666, 'Platte Rapsodie Oval', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1667, 'Platte 23 cm Barkerole Oval', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1668, 'Picknick-Korb', 'GA', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1669, 'Pavillon 3 x 3 Meter Grün-Weiss', 'GA', 215.84, 1001, 86.34, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1670, 'Pavillon-Seitenteil Grün-Weiss', 'GA', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1671, 'Planschbecken Stahlrohr 320 x 165 x 50 cm', 'GA', 130.59, 1001, 52.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1672, 'Puppenwagen und Puppe', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1673, 'Pfeffermühle Glas', 'GE', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1674, 'Philips Eismaschine Delizia 1,2 lt', 'EG', 163.3, 1001, 65.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1675, 'Passiermaschine rostfrei 24 cm', 'KG', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1676, 'Philips Rasierer HQ 3425', 'EG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1677, 'Pflanzstab 180 cm P25', 'GA', 2.18, 1001, 0.87, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1678, 'Pflanzstab 90 cm P50', 'GA', 0.87, 1001, 0.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1679, 'Pflanzstab 120 cm P50', 'GA', 1.09, 1001, 0.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1680, 'Pflanzstab 150 cm P50', 'GA', 1.64, 1001, 0.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1681, 'Pflanzstab 210 cm P25', 'GA', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1682, 'Petroleumlampe mit Spiegel', 'GA', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1683, 'Partyschirm 3 me', 'HH', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1684, 'Partyschirmständer', 'HH', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1685, 'Planschbecken Stahlrohr 165 x 165 x 50 cm', 'GA', 97.89, 1001, 39.16, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1686, 'Poncho Grau S', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1687, 'Poncho Grau M', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1688, 'Poncho Grau L', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1689, 'Poncho Rot S', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1690, 'Poncho Rot M', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1691, 'Poncho Rot L', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1692, 'Planschbecken 100 cm', 'GA', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1693, 'Planschbecken 120 cm', 'GA', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1694, 'Planschbecken 140 cm', 'GA', 19.51, 1001, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1695, 'Planschbecken 170 cm', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1696, 'Pfanne mit Glasdeckel 24 cm', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1697, 'Pfanne mit Glasdeckel 28 cm', 'KG', 36.95, 1001, 14.78, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1698, 'Pfanne mit Deckel Brillant 24 cm', 'KG', 47.86, 1001, 19.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1699, 'Panierset 3 tlg.', 'KG', 5.45, 1001, 2.18, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1700, 'Pullover Trockner', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1701, 'Pflanzschalen Weiss 40 cm 2 Stk. Packung', 'GA', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1702, 'Pflanzschale Weiss 42 cm', 'GA', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1703, 'Quirl Draht 33 cm', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1704, 'Riess Braun Kasserolle 5 lt', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1705, 'Rasenkante 15 cm', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1706, 'Riess Seiherset 2 tlg. Hartkunststoff', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1707, 'Riess Trichterset 3 tlg.', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1708, 'Reisschale mit Löffel 6 Stk. Packung', 'GE', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1709, 'Rutsche Kunststoff', 'GA', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1710, 'Rank Netz 10 x 2 me', 'GE', 10.36, 1001, 4.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1711, 'Riess Monika Bratpfanne 36 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1712, 'Riess Monika Weitling 28 cm', 'KG', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1713, 'Riess Monika Schnabeltopf 12 cm', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1714, 'Riess Monika Babystielkasserolle 14 cm', 'KG', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1715, 'Riess Monika Milchtopf 14 cm', 'KG', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1134, 'Blumenkistenträger zum Schrauben Schwarz', 'GA', 3.49, 1001, 1.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1135, 'Baueimer mit NB 12 lt', 'HW', 2.4, 1001, 0.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1136, 'Bräunungsboxmatratze Solar-Box Matratze', 'HH', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1137, 'Boot Blasebalg Gross', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1138, 'Bay Kresse Igel', 'HH', 10.68, 1002, 4.27, NULL, NULL, NULL, 721, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1139, 'Bügeleisenfolie', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1140, 'Baumsäge mit Blatt 40 cm', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1141, 'Bürstenstiel 1 me für Rohr Und Kesselbürsten', 'HW', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1142, 'Backformenset 5 tlg. Weissblech HR', 'KG', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1143, 'Bundesheergürtel 95 cm', 'HW', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1144, 'Bundesheergürtel 115 cm', 'HW', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1145, 'Bundesheergürtel 125 cm', 'HW', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1146, 'Bügeleisenstift HR', 'HH', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1147, 'Bananensplit Gourmande 3 Stk. Packung', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1148, 'Badewannenabdichtband HR', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1149, 'Bosch Allesschneider 8500', 'HW', 217.8, 1001, 87.12, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1150, 'Baueimerset 5 tlg.', 'HW', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1151, 'Backbrett 68 x 48 cm', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1152, 'Besen mit Stiel Rosshaar', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1153, 'Brennpaste 3 Stk. Packung', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1154, 'Backschaufel', 'KG', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1155, 'Campingdusche Solar 20 lt', 'GA', 18.42, 1130, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1156, 'Crepes Pfannenset 3 tlg.', 'GE', 21.58, 1003, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1157, 'Camping-Klappsessel Unica Tnt', 'GA', 15.15, 1130, 6.06, NULL, NULL, NULL, 1041, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1158, 'Claber Schlauchwagen Aqua Caddy', 'GE', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1159, 'Chrysal Mehltauspray 250 ml', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1160, 'Duftlampenöl 3x250 ml', 'HH', 9.27, 1001, 3.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1161, 'Degupa Popcorn Automat', 'EG', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1162, 'Drehascher', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1163, 'Duschboard Weiss 4-fach', 'HH', 15.15, 1130, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1164, 'Duschboard Beige 4-fach', 'HH', 15.15, 1130, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1165, 'Dauerbackfolie', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1166, 'Dreirad Speedy', 'GA', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1167, 'Dunstfettfilter 2 Stk. Packung', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1168, 'Dreirad mit Schubstange', 'GA', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1169, 'Deckelöffner Brillant', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1170, 'Dariol Form', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1171, 'Drehkarussel 9 tlg.', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1172, 'Dressiergarnitur', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1173, 'Dosenöffner Credo', 'KG', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1174, 'Doppelhubpumpe', 'HW', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1175, 'Dressiersack Grösse 4', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1176, 'Dressiersack Grösse 5', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1177, 'Essmesser 6 Stk. Packung', 'BE', 18.42, 1003, 7.37, NULL, NULL, NULL, 481, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1178, 'Essgabel 6 Stk. Packung', 'BE', 9.7, 1003, 3.88, NULL, NULL, NULL, 481, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1179, 'Esslöffel 6 Stk. Packung', 'BE', 9.7, 1003, 3.88, NULL, NULL, NULL, 481, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1180, 'Eislöffel 6 Stk. Packung', 'BE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1181, 'Einkochtopf mit Einlegerost', 'KG', 62.03, 1001, 24.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1182, 'Eierteiler-Kunststoff', 'KG', 2.07, 1003, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1183, 'Eierbecher Atelier 3 Stk. Packung', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1184, 'Eierbecher Atelier', 'KG', 3.82, 1003, 1.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1185, 'Einkochtopf', 'KG', 52.22, 1001, 20.89, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1186, 'Ersatzlampe für Mosquito Stop Twinny', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1187, 'Eisschirmchen 12 Stk.', 'HH', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1188, 'Eisschirmchen 24 Stk. Packung', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1189, 'Emaille-Fix Und Rostkiller', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1190, 'Ersatzkissen für Pinty Deckenbürste', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1191, 'Ersatzkissen für Pinty Standardbürste', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1192, 'Eierpfanne 18 cm', 'KG', 10.68, 1003, 4.27, NULL, NULL, NULL, 169, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1193, 'Entsafteraufsatz mit Passring', 'KG', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1194, 'Electro Cat Mäusevertreiber', 'EG', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1195, 'Ersatzlampe für Insektenkiller', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1196, 'Elektro Kochtopf Partytime', 'KG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1197, 'Edelstahlgeschirrset Gold 7 tlg.', 'KG', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1198, 'Ersatz-Bügelpolster', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1199, 'Eimer mit Deckel 9 lt Beige-Quarz', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1200, 'Ersatz Dörretagen 2 Stk. Packung', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1201, 'Eierbecher Barkerole', 'GE', 3.16, 1003, 1.26, NULL, NULL, NULL, 1441, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1202, 'Eckregal Weiss', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1203, 'Eisschale Maldives 6 Stk. Packung', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1204, 'Ersatzlampe für Mosquito Stop 40', 'HH', 28.23, 1001, 11.29, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1205, 'Eiswürfelbereiter', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1206, 'Einkochglas 3 lt', 'KG', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1207, 'Edelstahlgeschirrset Magnum 20 tlg.', 'KG', 217.8, 1001, 87.12, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1208, 'Espressomaschine 4 Tassen', 'EG', 50.04, 1003, 20.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1209, 'Einlegerost', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1210, 'Epoca Spritze 1,25 lt', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1211, 'Ersatzfedern für Vertikutiermesser', 'GA', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1212, 'Einkochthermometer', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1213, 'Eisportionierer Rostfrei', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1214, 'Einkochautomat mit Zeitschaltuhr', 'EG', 174.2, 1001, 69.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1215, 'Elastikmop', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1216, 'Fissler Edelstahlpflege 2 Stk. Packung', 'KG', 14.06, 1020, 5.62, NULL, NULL, NULL, 4001, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1217, 'Felco-Ersatzsägeblatt', 'HW', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1218, 'Fleischklopfer Holz', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1219, 'Flaschenregale 4 Stk. Packung', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1220, 'Fleischwolf Nr. 5', 'KG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1221, 'Fleischgabel Profi', 'BE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1222, 'Freizeitjacke M Olivgrün', 'GA', 54.29, 1130, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1223, 'Freizeitjacke L Olivgrün', 'GA', 54.29, 1130, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1224, 'Freizeitjacke XL Olivgrün', 'GA', 54.29, 1130, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1225, 'Freizeitjacke XXL Olivgrün', 'GA', 54.29, 1130, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1226, 'Fondügarnitur 28 tlg.', 'GE', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1227, 'Fixiermesser mit Etui', 'BE', 17.33, 1020, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1228, 'Fiskars Schere 2 Stk. Packung', 'BE', 21.58, 1020, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1229, 'Flaschenträger', 'HH', 4.25, 1020, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1230, 'Fruchtentsafter 9 lt Hackmann Edelstahl', 'KG', 152.39, 1001, 60.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1231, 'Fussball Super-Cup', 'GA', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1232, 'Fly Stop 100 x 100 cm Weiss', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1233, 'Fly Stop 100 x 100 cm Grau', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1234, 'Fly Stop 130 x 150 cm Weiss', 'HH', 10.79, 1001, 4.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1235, 'Fly Stop 130 x 150 cm Grau', 'HH', 10.79, 1001, 4.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1236, 'Fly Stop Tür Weiss 2 x 60 x 210 cm', 'HH', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1237, 'Fly Stop Tür Grau 2 x 60 x 210 cm', 'HH', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1238, 'Fisch Pfanne 36 cm', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1239, 'Frischhaltedose 3,45 lt Eckig', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1240, 'Frischhaltedose 2,45 lt Eckig', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1241, 'Frischhaltedose 1,65 lt Eckig', 'KG', 3.82, 1001, 1.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1242, 'Frischhaltedose 0,65 lt Eckig', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1243, 'Frischhaltedose 0,35 lt Eckig', 'KG', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1244, 'Frischhaltedose 3 lt Rund', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1245, 'Frischhaltedose 1,5 lt Rund', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1246, 'Frischhaltedose 0,75 lt Rund', 'KG', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1247, 'Federball Garnitur', 'GA', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1248, 'Federbälle 6 Stk. Packung', 'GA', 2.18, 1001, 0.87, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1249, 'Frischhaltebox 40 x 19 x 14 cm', 'KG', 8.61, 1130, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1250, 'Festtagskuchenform', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1251, 'Fabro Wachsende Folie 7,15  x 1,4 Me', 'KG', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1252, 'Fleischhammer Robusto', 'BE', 14.06, 1020, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1253, 'Felco Gartenschere 2', 'GA', 59.85, 1001, 23.94, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1254, 'Fleischwalze', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1255, 'Fissler Edelstahlpflege', 'KG', 7.52, 1020, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1256, 'Fugenweiss HR', 'HW', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1257, 'Faltwasserkanister 20 lt', 'HW', 10.79, 1001, 4.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1258, 'Feldhemd 36', 'HW', 60.94, 1130, 24.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1259, 'Feldhemd 37/38', 'HW', 65.19, 1130, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1260, 'Feldhemd 39/40', 'HW', 65.19, 1130, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1261, 'Feldhemd 41/42', 'HW', 65.19, 1130, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1262, 'Feuchtigkeitskiller', 'HW', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1263, 'Felco Baumsäge 60', 'HW', 34.77, 1001, 13.91, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1264, 'Fiskars Messerschärfer', 'HW', 15.15, 1020, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1265, 'Feldsocken', 'HW', 17.33, 1130, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1266, 'Frischhaltedosenset 10 tlg.', 'KG', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1267, 'Farbbecher mit Deckel, Pinselhalter und 9 Pinsel', 'HW', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1268, 'Feldhemd 43/44', 'HW', 65.19, 1130, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1269, 'Feldhose 66', 'HW', 76.09, 1130, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1270, 'Feldhose 62', 'HW', 76.09, 1130, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1271, 'Feldhose 58', 'HW', 76.09, 1130, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1272, 'Feldhose 54', 'HW', 76.09, 1130, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1273, 'Feldhose 50', 'HW', 76.09, 1130, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1274, 'Feldhose 46', 'HW', 76.09, 1130, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1275, 'Gardena Schlauchset 4586-20', 'GA', 38.04, 1008, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1276, 'Gardena Gartendusche 956', 'GA', 53.31, 1008, 21.32, NULL, NULL, NULL, 49, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1277, 'Gaz Kocher Bleuet S 206', 'GA', 38.04, 1001, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1278, 'Gaz Lampe Lumogaz T206', 'GA', 50.04, 1001, 20.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1279, 'Gaz Kartusche CV 470', 'GA', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1280, 'Gaz Kartusche C 206', 'GA', 1.96, 1001, 0.78, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1281, 'Gaz Kocher Azur L', 'GA', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1282, 'Gaz Regler 50 mbar Ca-Gaz', 'GA', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1283, 'Giesser Atelier 0,15 lt', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1284, 'Gurkenhobel Rostfrei', 'KG', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1285, 'Gummiring 400 Stk. Packung', 'HH', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1286, 'GAZ Campingset XXL', 'GA', 98.5, 1001, 44.55, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1287, 'Gesundheitsliege Sylt Gelb/Weiss', 'GA', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1288, 'Gesundheitsliege Sylt Blau/Weiss', 'GA', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1289, 'Gewürzreibe', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1290, 'Garten-Vlies 10 x 1,5 me', 'GA', 10.79, 1001, 4.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1291, 'Grundausstattung 5 tlg.', 'GE', 5.45, 1020, 2.18, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1292, 'Gardena Schlauchwagen 2610', 'GA', 50.04, 1001, 20.04, 5, 2, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1293, 'Gartenlaube Wörthersee', 'GA', 434.95, 1001, 173.98, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1294, 'Gugelhupfform Glas', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1295, 'Gugelhupfform 22 cm Progriff', 'KG', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1296, 'Gardena Baumschere 302', 'GA', 48.95, 1008, 19.58, NULL, NULL, NULL, 2401, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1297, 'Gardena Fächerbesen mit Stiel 3102+3703', 'HW', 21.69, 1008, 8.68, NULL, NULL, NULL, 1, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1298, 'Gardena Turbinenregner 830', 'GA', 32.48, 1008, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1299, 'Gardena Wandschlauch- Träger 2650', 'GA', 64.21, 1008, 25.68, NULL, NULL, NULL, 801, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1300, 'Gardena 2-Wege-Verteiler', 'GA', 20.6, 1008, 8.24, NULL, NULL, NULL, 201, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1301, 'Gartenschaukel mit Kissen', 'GA', 206.03, 1001, 82.41, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1302, 'Gartentisch Berlin Grün', 'GA', 54.29, 1008, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1303, 'Gewebeluftmatratze', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1304, 'Giesser Barkerole', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1305, 'Gemüsehobel Holz', 'GE', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1306, 'Gardena Pumpsprüher 1 lt 847-20', 'GA', 7.52, 1008, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1307, 'Gardena Drucksprüher 867 3 lt', 'GA', 53.96, 1008, 21.58, NULL, NULL, NULL, 161, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1308, 'Gardena Drucksprüher 869 5 lt', 'GA', 62.03, 1008, 24.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1309, 'Gartentisch Berlin Weiss', 'GA', 43.39, 1008, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1310, 'Garnierspritze', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1311, 'Gewebe Box Luftmatratze', 'GA', 24.96, 1020, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1312, 'Gewebe Doppelbox Luftmatratze', 'GA', 50.04, 1001, 20.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1313, 'Gläserset Bali 18 Stk. Packung', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1314, 'Glasset 18 tlg.', 'GE', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 0, '2019-05-05', 'Einkauf');
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1315, 'Germteigschüssel 3 Stk. Packung', 'KG', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1316, 'Gardena Stubenbesen Mischung 3631', 'GA', 14.72, 1008, 5.89, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1317, 'Gardena Schrubber 3640', 'GA', 10.79, 1008, 4.32, NULL, NULL, NULL, 321, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1318, 'Gardena Regner 807', 'GA', 40.22, 1008, 16.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1319, 'Gewebeschlauch 1/2" 25 me Rolle', 'GA', 10.79, 1020, 4.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1320, 'Gewebeschlauch 1/2" 50 me Rolle', 'GA', 21.58, 1020, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1321, 'Gewebeschlauch 3/4" 25 me Rolle', 'GA', 27.14, 1020, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1322, 'Gewebeschlauch 3/4" 50 me Rolle', 'GA', 54.29, 1020, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1323, 'Gloria Prima 5 Druckspritze', 'GE', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1324, 'Gloria Druckspritze 229 S', 'GA', 97.02, 1020, 38.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1325, 'Gloria 176 T Hochleistungsspritze 5 lt', 'GA', 170.05, 1001, 68.02, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1326, 'Gloria 2010 Kolbenrückenspritze 17lt', 'GA', 216.93, 1001, 86.77, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1327, 'Gloria Verlängerung 100 cm', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1328, 'Gartenschirm Aktion Tnt 180 cm', 'GA', 14.06, 1008, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1329, 'Gardena Handrasenmäher 30 cm', 'GA', 87.1, 1008, 34.84, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1330, 'Grillteller mit Rille 6 Stk. Packung', 'GE', 10.9, 1020, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1331, 'Grillspiesse Rostfrei 6 Stk. Packung', 'GE', 6.43, 1020, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1332, 'Geflügelschere', 'BE', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1333, 'Gloria 172 Rt Hochleistungsspritze 10lt', 'GA', 216.93, 1001, 86.77, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1334, 'Geschirrtücher Baumwolle P3', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1335, 'Gardena Teleskopstiel 3711', 'GA', 36.95, 1008, 14.78, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1336, 'Gardena Teleskopstiel 3712', 'GA', 47.42, 1008, 18.97, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1337, 'Geschirrtücher 9 Stk.', 'GE', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1338, 'Gugelhupfform 22 cm Weissblech', 'KG', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1339, 'Gardena Obstpflücker 3110', 'GA', 16.9, 1008, 6.76, NULL, NULL, NULL, 1801, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1340, 'Gardena Druckspritze 875', 'GA', 43.39, 1008, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1341, 'Garnierausstecher 6 Stk. Packung', 'GE', 3.82, 1001, 1.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1342, 'Gardena Dachrinnen-Reiniger 3650', 'GA', 20.6, 1008, 8.24, NULL, NULL, NULL, 41, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1343, 'Gardena CS Winkelbesen 3633', 'GA', 19.51, 1008, 7.81, NULL, NULL, NULL, 1, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1344, 'Glasflasche 1 lt', 'HH', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1345, 'Gewürzei SB', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1346, 'Holzschutzstreicherset 3 tlg.', 'HW', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1347, 'Hauszelt Colorado 360 x 240 x 180 cm', 'GA', 217.8, 1001, 87.12, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1348, 'Herzformenset 2 tlg.', 'GE', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1349, 'Haushaltsschnur 6 Rollen', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1350, 'Hängematte Aloha', 'GA', 54.29, 1020, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1351, 'Gardena Schlauchset GA12', 'GA', 99.9, 9999, 53.48, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1352, 'Haushaltsschere', 'HW', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1818, 'Suppentasse Atelier 3 Stk. Packung', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1819, 'Suppentasse Atelier', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1820, 'Serviettenhalter', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1821, 'Stieleisform 4 Stk. Packung', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1822, 'Schüttdose 0,75 lt 6 Stk. Packung', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1823, 'Söhnle Küchenwaage KW1180 Wand', 'KG', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1824, 'Schüttdosen 0,25 lt 6 Stk. Packung', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1825, 'Staubmagnet Ausziehbar', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1826, 'Staubsauger-Deo 10 Stk. Packung', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1827, 'Severin Haarfön Profi', 'EG', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1828, 'Swimming Pool 360 cm Komplettset mit', 'GA', 434.95, 1001, 173.98, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1829, 'Schuhabtropftassen 4 Stk. Packung', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1830, 'Suppentasse 6 Stk. Packung', 'GE', 19.51, 1001, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1831, 'Speiseschirm', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1832, 'Schneckenfalle Snail-Trap 2 Stk. Packung', 'GA', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1833, 'Schulpinselset 12 tlg.', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1834, 'Schöpfer 8 cm Brillant Hr', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1835, 'Springform 26 cm Progriff', 'KG', 29.32, 1001, 11.73, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1836, 'Schaumrollenformen 12,5 cm x 2,5 cm', 'KG', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1837, 'Schuhspanner Herren 2 Stk. Packung', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1838, 'Schuhspanner Damen 2 Stk. Packung', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1839, 'Strumpf- und Sockenhord', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1840, 'Staubsauger-Deo 20 Stk. Packung', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1841, 'Super Jumbo Pool 270 x 165 x 51 cm', 'GA', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1842, 'Sitz-Liege Matratze Nylon', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1843, 'Staubsack Philips HR 6182 10 Stk. Packung', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1844, 'Schuhständer', 'HH', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1845, 'Scherenset 4 tlg.', 'GE', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1846, 'Schirmhülle für Party- Und Marktschirm', 'GA', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1847, 'Sparschäler Brillant', 'BE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1848, 'Söhnle Diätwaage 8622', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1849, 'Suppentopf Rapsodie', 'GE', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1850, 'Sauciere Rapsodie', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1851, 'Schüssel Rapsodie 3 Stk. Packung', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1852, 'Schüssel Rapsodie 13 cm für Set 623247', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1853, 'Schüssel Rapsodie 23 cm', 'GE', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1854, 'Severin Warmluft Lockenstab', 'EG', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1855, 'Schuhständer 2er', 'HH', 29.9, 9999, 14.74, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1856, 'Sitz-Liege Matratze Gewebe', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1857, 'Suppentasse mit Untertasse Barkerole', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1858, 'Schüssel 21 cm Barkerole', 'GE', 12.97, 1001, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1859, 'Schüssel 13 cm Barkerole', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1860, 'Suppentassen mit Untertassen', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1861, 'Schüssel Rapsodie 26 cm', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1862, 'Speiseservice Hallein 15 tlg.', 'GE', 59.85, 1001, 23.94, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1863, 'Stamperl Dublino 6 Stk. Packung', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1864, 'Schneidbrett 35 x 25 cm', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1865, 'Schneidbrett 45,5x29 cm', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1866, 'Stielkasserolle Aktion 14 cm', 'GE', 5.45, 1001, 2.18, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1867, 'Sessel Marina Grün', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1868, 'Stapelstuhl Vienna Weiss', 'HH', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1869, 'Super Jumbo Pool 330 x 170 x 51 cm', 'GA', 152.39, 1001, 60.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1870, 'Sandkasten Holz 120x120', 'GA', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1871, 'Sitzgarnitur', 'HH', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1872, 'Schöberform 6 Stk. Packung', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1873, 'Schuhlöffel 58 cm', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1874, 'Salzmühle Glas', 'GE', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1875, 'Speiseservice 15 tlg. Zwiebelmuster', 'GE', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1876, 'Suppenterrine Zwiebelmuster', 'GE', 39.13, 1001, 15.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1877, 'Suppentopf Rio', 'GE', 40.22, 1001, 16.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1878, 'Streudose 2 lt', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1879, 'Streudose 1 lt', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1880, 'Streudose 0,5 lt', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1881, 'Sitz- Und Rückenkissen für Bank Floris', 'HH', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1882, 'Schüssel Rondo 14 cm', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1883, 'Schaukelrutscher Dalmatiner', 'GA', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 0, '2017-02-01', 'Artikelwartung');
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1884, 'Söhnle Küchenwaage 1203 Ideal', 'KG', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1885, 'Söhnle Küchenwaage 131605 Fresh', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1886, 'Söhnle Küchenwaage 1317 Extra', 'KG', 23.87, 1001, 9.55, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1887, 'Söhnle Küchenwaage 1208 Rot', 'KG', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1888, 'Spagatkrapfenzange Doppelt', 'KG', 28.23, 1001, 11.29, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1889, 'Spagatkrapfenzange Einfach', 'KG', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1890, 'Sprungball', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1891, 'Sitzkissen', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1892, 'Schaukelbrett', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1893, 'Schirmständer Weiss PVC', 'GA', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1894, 'Schutzhülle Dekor für Gartenschaukel', 'GA', 59.85, 1001, 23.94, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1895, 'Schüssel Stapelbar 17 cm', 'GE', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1896, 'Springform 18 cm Weissblech', 'KG', 4.91, 1001, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1897, 'Springform 20 cm Weissblech', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1898, 'Springform 22 cm Weissblech', 'KG', 6, 1001, 2.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1899, 'Springform 24 cm Weissblech', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1900, 'Springform 26 cm Weissblech', 'KG', 7.09, 1001, 2.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1901, 'Springform 28 cm Weissblech', 'KG', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1902, 'Springform 30 cm Weissblech', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1903, 'Spätzlehobel Rostfrei', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1904, 'Spick- Und Rouladennadel 11 Stk. Packung', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1905, 'Schüssel Stapelbar 12 cm', 'GE', 1.64, 1001, 0.65, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1906, 'Schüssel Stapelbar 14 cm', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1907, 'Schäler', 'KG', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1908, 'Streifenvorhang bunt 90 x 200 cm', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1909, 'Standseiher 24 cm', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1910, 'Schaumrollenformen 12,5cm 5 Stk. Packung', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1911, 'Schwingdeckeleimer 15 lt', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1912, 'Schutzhülle Dekor für Stapelsessel', 'GA', 18.42, 1001, 7.37, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1913, 'Schutzhülle für Gartenschirme', 'GA', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1914, 'Steakmesser', 'BE', 0.76, 1001, 0.31, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1915, 'Stielkasserolle Brillant 16 cm', 'GE', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1916, 'Schnabeltopfset Rostfrei 3 tlg.', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1917, 'Stielkasserollenset 3 tlg. Rostfrei', 'GE', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1918, 'Schöpferset 3 tlg.', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1919, 'Sichtschutzfolie SB', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1920, 'Schneekessel Rostfrei', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 0, '2018-09-04', 'n/a');
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1921, 'Severin Rotlicht', 'EG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1922, 'Schnellkochtopfset Kelomat Super 4 tlg.', 'KG', 206.9, 1001, 82.76, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1923, 'Skateboard Fun', 'GA', 20.6, 1001, 8.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1924, 'Schaumrollenformen Mini 10 Stk. Packung', 'KG', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1925, 'Spaghettilöffel', 'BE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1926, 'Schaumlöffel', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1927, 'Schöpfer', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1928, 'Saucenschöpfer', 'BE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1929, 'Strickleiter', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1930, 'Torftöpfe 6 cm 96 Stk. Packung', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1931, 'Textilbürste SB', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1932, 'Tortenspitzen 12 Stk. Packung', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1933, 'Terrassenbesen mit Stiel', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1934, 'Teetasse mit Untertasse Atelier 6 Stk. Packung', 'GE', 28.23, 1001, 11.29, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1935, 'Teetasse mit Untertasse Atelier', 'GE', 4.91, 1001, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1936, 'Teekanne Atelier', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1937, 'Teller Dessert Atelier', 'GE', 3.82, 1001, 1.53, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1938, 'Teller Dessert Atelier 6 Stk. Packung', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1939, 'Teller Flach Atelier', 'GE', 4.91, 1001, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1940, 'Teller Flach Atelier 6 Stk. Packung', 'GE', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1941, 'Teller Tief Atelier', 'GE', 4.91, 1001, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1942, 'Teller Tief Atelier 6 Stk. Packung', 'GE', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1943, 'Taschenfeitel', 'HH', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1944, 'Tee-Ei', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1945, 'Teefilter', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1946, 'Tefal Dampfbügeleisen Aquagliss Turbo 300', 'HH', 141.49, 1001, 56.6, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1947, 'Traktor Frontlader', 'GA', 216.93, 1001, 86.77, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1948, 'Tefal Kontaktgrill', 'HH', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1949, 'Turnset', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1950, 'Thermometer für Schwimmbad', 'GA', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1951, 'Tee-Ei Kugel', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1952, 'Terrassenausstecher 18 tlg.', 'KG', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1953, 'Textilroller Gross', 'HH', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1954, 'Tür- und Fensterstopper', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1955, 'Tortenring Universal', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1956, 'Teller Dessert Rapsodie 6 Stk. Packung', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1957, 'Teller Dessert Rapsodie', 'GE', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1958, 'Teller Tief Rapsodie 6 Stk. Packung', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1959, 'Teller Tief Rapsodie', 'GE', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1960, 'Teller Flach Rapsodie 6 Stk. Packung', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1961, 'Teller Flach Rapsodie', 'GE', 2.73, 1001, 1.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1962, 'Tablett Chrom', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1963, 'Tefal Antikalkkassette 2 Stk. Packung', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1964, 'Türmatte 61 x 36 cm', 'HH', 5.45, 1001, 2.18, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1965, 'Teller Dessert Barkerole', 'GE', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1966, 'Teller Flach Barkerole', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1967, 'Teller Tief Barkerole', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1968, 'Teetasse mit Untertasse Barkerole', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1969, 'Topf Untersatz', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1970, 'Teppichklopfer', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1971, 'Tablett 40 x 30 cm', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1972, 'Teeservice Katze 6 tlg.', 'GE', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1973, 'Tontopfset 2tlg. Knoblauch Zwiebel', 'GE', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1974, 'Tiefkühlthermometer', 'HH', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1975, 'Tomatenschneider Pleasure', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1976, 'Teeglas Oslo 3 Stk. Packung', 'GE', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1977, 'Teeglas Ceylon 2 Stk. Packung', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1978, 'Teelicht Glas 26 tlg.', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1979, 'Tefal Kaffeeautomat Performa 1500', 'HH', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1980, 'Tomatenhaube 1,25x0,65 me 5 Stk. Packung', 'GE', 11.88, 1001, 4.75, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1981, 'Torftöpfe 6 cm 24 Stk. Packung', 'GA', 2.94, 1001, 1.18, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1982, 'Tauchset für Jugendliche', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1983, 'Teigroller Holz drehbar', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1984, 'Teelicht Alu 25 Stk. Packung', 'GE', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1985, 'Teko Flaschenregal Beige', 'HH', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1986, 'Teleskopverlängerung zu Roll-Rocket Expert', 'HH', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1987, 'Untersetzer Rund', 'HH', 1.31, 1001, 0.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1988, 'Untersetzer Rund 5 Stk. Packung', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1989, 'Untersetzer Eckig', 'HH', 1.31, 1001, 0.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1990, 'Untersetzer Eckig 5 Stk. Packung', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1991, 'Universalreibe Rostfrei', 'KG', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1992, 'Universalbräter Edelstahl', 'KG', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1993, 'Untertassen Wien 3 Stk. Packung', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1994, 'Universalzange Pleasure', 'KG', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1995, 'Verschluss Propper 2 Stk. Packung', 'HH', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1996, 'Verschluss Propper 2 lt', 'HH', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1997, 'Vielzweckstäbe', 'HH', 7.52, 1001, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1998, 'Vitroflam Backform Eckig 35 x 22 cm', 'GE', 26.05, 1001, 10.42, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1999, 'Vitroflam Backform Oval', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2000, 'Vorratsdose 0,25 lt rund', 'HH', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2001, 'Vorratsdose 0,50 lt rund', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2002, 'Vorratsdose 1 lt rund', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2003, 'Vorratsdose 1,10 lt eckig', 'HH', 4.91, 1001, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2004, 'Vorratsdose 1,60 lt eckig', 'HH', 6, 1001, 2.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2005, 'Vase Blau', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2006, 'Vertikutierzusatz für Rasenmäher', 'GA', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2007, 'Wolf Rasenmäher mit Korb 2.42 TA', 'GA', 761.97, 1001, 304.79, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2008, 'Wäscheleine Drahtseil 30 me', 'HH', 8.61, 1001, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2009, 'Wäscheklammer Holz 50 Stk. Packung', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2010, 'Wäschetrockner Ready 60 cm', 'HH', 38.04, 1001, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2011, 'Wäschetrockner Ready 80 cm', 'HH', 40.22, 1001, 16.09, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2012, 'Wäschetrockner Ready 100 cm', 'HH', 47.86, 1001, 19.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1016, 'Alu-Marktschirm 3,2 me', 'GA', 152.39, 1001, 60.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1017, 'Allesschneider', 'HW', 185.1, 1001, 74.04, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1018, 'ABC Dörrautomat', 'KG', 130.59, 1001, 52.24, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1019, 'Anti-Rutsch Teppichband', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1020, 'Abfalleimer Metall', 'HH', 9.7, 1001, 3.88, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1021, 'Abdeckplane für Stahl- Rohrbecken 320 x 165 cm', 'HW', 27.14, 1002, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1022, 'Apfelausstecher', 'KG', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1023, 'Astschere 460', 'GA', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1024, 'Adlus Rasenrechen 60 cm', 'GA', 12.97, 1002, 5.19, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1025, 'Adlus Laubbesen Variabel ohne Stiel', 'GA', 14.06, 1002, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1026, 'Adlus Damenhandschuhe', 'GA', 4.25, 1002, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1027, 'Adlus Herrenhandschuhe', 'GA', 4.91, 1002, 1.96, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1028, 'Adlus Gartenrechen 14 Zinken', 'GA', 6.43, 1002, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1029, 'Adlus Gartenhäckchen 2 Zack Herzform', 'GA', 7.52, 1002, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1030, 'Adlus Blumenkralle 5 Zack', 'GA', 5.34, 1002, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1031, 'Adlus Stiel 150 cm', 'GA', 7.52, 1002, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1032, 'Adlus Stiel 180 cm', 'GA', 8.61, 1002, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1033, 'Adlus Schaufel Klein', 'GA', 5.34, 1002, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1034, 'Alu Haushaltsleiter 3 Stufen ÖNorm', 'HH', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1035, 'Alu Haushaltsleiter 4 Stufen ÖNorm', 'HH', 50.04, 1001, 20.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1036, 'Alu Haushaltsleiter 5 Stufen ÖNorm', 'HH', 62.03, 1001, 24.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1037, 'Alu Haushaltsleiter 6 Stufen ÖNorm', 'HH', 81.65, 1001, 32.66, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1038, 'Alu Haushaltsleiter 7 Stufen ÖNorm', 'HH', 97.02, 1001, 38.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1039, 'Airstop-Reparaturset', 'HW', 4.25, 1001, 1.7, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1040, 'Angelgarnitur', 'GA', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1041, 'Adlus Spitzschaufel', 'GA', 8.61, 1002, 3.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1042, 'Adlus Rechen', 'GA', 7.52, 1002, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1043, 'Adlus Laubbesen', 'GA', 8.61, 1002, 3.44, NULL, NULL, NULL, 81, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1044, 'Ausgiesser Gihale', 'HH', 1.09, 1001, 0.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1045, 'Ascher Meteor 14 cm Glas', 'HH', 3.16, 1001, 1.26, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1046, 'Ausstecher Linzer 4,8 cm mit Auswerfer', 'KG', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1047, 'Aschensauger Ash-Clean Staubsaugerzusatzgerät', 'GE', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1048, 'Adlus Vertikutierroller', 'GA', 38.04, 1002, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1049, 'Arbeitsmantel Blau 46', 'HW', 27.14, 1130, 10.86, NULL, NULL, NULL, 401, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1050, 'Arbeitsmantel Blau 48', 'HW', 27.14, 1130, 10.86, NULL, NULL, NULL, 241, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1051, 'Arbeitsmantel Blau 50', 'HW', 27.14, 1130, 10.86, NULL, NULL, NULL, 391, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1052, 'Arbeitsmantel Blau 52', 'HW', 27.14, 1130, 10.86, NULL, NULL, NULL, 391, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1053, 'Arbeitsmantel Blau 54', 'HW', 27.14, 1130, 10.86, NULL, NULL, NULL, 361, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1054, 'Arbeitsmantel Blau 56', 'HW', 27.14, 1130, 10.86, NULL, NULL, NULL, 401, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1055, 'Astsäge 2702', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 1, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1056, 'Adlus Pflanzholz', 'GA', 6.43, 1002, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1057, 'Alpin Pullover 46', 'HW', 185.1, 1130, 74.04, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1058, 'Alpin Pullover 48', 'HW', 185.1, 1130, 74.04, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1059, 'Alpin Pullover 50', 'HW', 185.1, 1130, 74.04, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1060, 'Alpin Pullover 52', 'HW', 196, 1130, 78.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1061, 'Alpin Pullover 54', 'HW', 196, 1130, 78.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1062, 'Alles-Dichter-Spray Sb', 'HW', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1063, 'Adlus Häckchen', 'GA', 7.52, 1002, 3.01, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1064, 'Bügelzubehörhalter SB', 'HH', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1065, 'Besen-Boy SB', 'HH', 10.9, 1001, 4.36, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1066, 'Biertulpe Executive 6 Stk. Packung', 'GE', 16.35, 1001, 6.54, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1067, 'Black & Decker Rasentrimmer GL 320', 'GA', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1068, 'Barshaker', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1069, 'Biertulpe Taverne 3 Stk. Packung', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1070, 'Besteckgarnitur Tanja 30 tlg.', 'GE', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1071, 'Bügelschnurhalter', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1072, 'Badezimmer Eckständer Weiss', 'HH', 38.04, 1001, 15.22, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1073, 'Braun Ersatzbürste EBI 5-2 für Plak Control', 'HH', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1074, 'Bosch Heckenschere AHS 600', 'GA', 217.8, 1001, 87.12, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1075, 'Becher nieder 3 Stk. Packung', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1076, 'Becher hoch 3 Stk. Packung', 'GE', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1077, 'Bay Römertopf Kochbuch', 'KG', 7.52, 1002, 3.01, NULL, NULL, NULL, 241, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1078, 'Bodenvase 40 cm Chinadekor', 'HH', 31.5, 1001, 12.6, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1079, 'Beerenriffel', 'GA', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1080, 'Bosch Allesschneider MAS 6108', 'HW', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1081, 'Bodensauger', 'HH', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1082, 'Bankauflage-Gartenlaube 99 x 30 x 3 cm', 'GA', 21.8, 1001, 8.72, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1083, 'Bankauflagen-Set zu Gartenlaube', 'GA', 86.99, 1001, 34.8, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1084, 'Bestecktrockner', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1085, 'Bratkartoffelwender Brillant', 'GE', 6.43, 1001, 2.57, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1086, 'Bräter mit Deckel', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1087, 'Backform 33,5 x 24 cm Progriff', 'KG', 28.23, 1001, 11.29, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1088, 'Brezelausstecher', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1089, 'Bügeltisch 116 x 33 cm', 'HH', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1090, 'Braun Ersatzdüse für ED 5', 'HH', 16.24, 1001, 6.5, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1091, 'Backform Bärentatzen', 'KG', 14.06, 1001, 5.62, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1092, 'Blasebalg', 'HH', 5.34, 1001, 2.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1093, 'Blockhaus', 'GA', 174.2, 1001, 69.68, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1094, 'Buntschneidemesser Victorinox', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1095, 'Besteckordner', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1096, 'Bowlegarnitur Traube 18 tlg.', 'GE', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1097, 'Bratpfanne 31 x 23 cm', 'KG', 17.33, 1001, 6.93, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1098, 'Bosch Reibevorsatz', 'GE', 54.29, 1001, 21.71, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1099, 'Bosch Spritzgebäck-Vorsatz', 'GE', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1100, 'Butterdose Barkerole', 'GE', 28.23, 1001, 11.29, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1101, 'Bay Kartoffelröster', 'KG', 27.14, 1002, 10.86, NULL, NULL, NULL, 1001, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1102, 'Bosch Friteuse Oval', 'KG', 108.79, 1001, 43.52, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1103, 'Backset 5 tlg.', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1104, 'Besteckgarnitur Twist 24 tlg.', 'GE', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1105, 'Braun Zahnbürste Plak Control Timer', 'HH', 141.49, 1001, 56.6, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1106, 'Black & Decker Akku-Rasenmäher GRC 840', 'GA', 762.85, 1001, 305.14, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1107, 'Besteckgarnitur Kiel 24 tlg.', 'GE', 16.35, 1001, 6.54, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1108, 'Besteckgarnitur Nostalgie 24 tlg.', 'GE', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1109, 'Besteckgarnitur 85 tlg. mit Koffer', 'GE', 163.3, 1001, 65.32, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1110, 'Bratenthermometer', 'KG', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1111, 'Balkon-Hängetisch 60 x 40 cm', 'HH', 27.14, 1001, 10.86, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1112, 'Berndes Glasdeckel 24 cm', 'KG', 19.51, 1001, 7.81, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1113, 'Berndes Glasdeckel 28 cm', 'KG', 24.96, 1001, 9.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1114, 'Berndes Pfanne 24 tief Color Cast', 'KG', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1115, 'Berndes Pfanne 28 tief Color Cast', 'KG', 97.89, 1001, 39.16, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1116, 'Berndes Pfanne 24 flach Color Cast', 'KG', 65.3, 1001, 26.12, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1117, 'Berndes Pfanne 20 flach Color Cast', 'KG', 43.49, 1001, 17.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1118, 'Braun Multiquick Control Plus', 'HH', 65.19, 1001, 26.08, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1119, 'Bosch Handmixer MFQ', 'EG', 32.48, 1001, 12.99, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1120, 'Brotdose Dunkel', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1121, 'Brotdose Hell', 'GE', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1122, 'Bärchenbackform', 'KG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1123, 'Bosch Wasserkocher TWK 1201', 'EG', 76.09, 1001, 30.44, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1124, 'Braun Rasierer 5005', 'EG', 141.49, 1001, 56.6, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1125, 'Braun Haarfön Silencio 1100', 'EG', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1126, 'Braun Kaffeeautomat KF 16', 'EG', 43.39, 1001, 17.35, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1127, 'Blitzbügler 130 x 43 cm', 'HH', 15.15, 1001, 6.06, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1128, 'Bügeldecke Blitzbügler 100 x 65 cm', 'HH', 21.58, 1001, 8.63, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1129, 'Bay Römertopf', 'KG', 27.14, 1002, 10.86, NULL, NULL, NULL, 121, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1130, 'Blusenbügel', 'HH', 10.68, 1001, 4.27, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1131, 'Blumenkistenträger zum Hängen Verzinkt', 'GA', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1132, 'Blumenkistenträger zum Schrauben Verzinkt', 'GA', 2.07, 1001, 0.83, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(1133, 'Blumenkistenträger zum Hängen Schwarz', 'GA', 3.49, 1001, 1.4, NULL, NULL, NULL, 0, 19, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2113, 'Kochen - das Einmaleins für Kocheinsteiger und Hobbyköche', 'BU', 29.99, 1240, 15.4, NULL, NULL, NULL, 0, 7, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2114, 'Das Heimwerker-Einmaleins', 'BU', 13.49, 1240, 6.3, NULL, NULL, NULL, 0, 7, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2115, 'Ich baue mein eigenes Haus', 'BU', 17.90, 1240, 7.8, NULL, NULL, NULL, 0, 7, 0, '2019-10-01 17:30', 'Artikelwartung');
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2116, 'Backen für Veganer', 'BU', 24.99, 1240, 13, NULL, NULL, NULL, 0, 7, 1, NULL, NULL);
INSERT INTO bene.artikel(artnr, bezeichnung, gruppe, vkpreis, lieferant, ekpreis, lieferzeit, mindbestand, hinweis, mengebestellt, mwst, aktiv, inaktivam, inaktivvon) VALUES(2117, 'Blumenparadiese auf Balkonen erschaffen', 'BU', 9.99, 1240, 4.7, NULL, NULL, NULL, 0, 7, 1, NULL, NULL);

-- SELECT * FROM bene.artikel ORDER BY artnr;
-- SELECT * FROM bene.artikel WHERE aktiv = 0 ORDER BY artnr;

INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1286, 1277, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1286, 1278, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1286, 1279, 2);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1286, 1280, 2);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1351, 1308, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1351, 1320, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1351, 1292, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1404, 1372, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1404, 1373, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1423, 1411, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1423, 1414, 8);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1544, 1433, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1544, 1436, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1544, 1437, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1544, 1438, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1544, 1482, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1771, 1683, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1771, 1684, 1);
INSERT INTO bene.setartikel (setartnr, teilartnr, menge) VALUES (1855, 1844, 2);

-- SELECT * FROM bene.setartikel;

INSERT INTO bene.lager(lagnr, bezeichnung) VALUES( 1, 'Hauptlager');
INSERT INTO bene.lager(lagnr, bezeichnung) VALUES( 2, 'Geschäftslager');
INSERT INTO bene.lager(lagnr, bezeichnung) VALUES( 3, 'Nebenlager 1');
INSERT INTO bene.lager(lagnr, bezeichnung) VALUES( 4, 'Nebenlager 2');
INSERT INTO bene.lager(lagnr, bezeichnung) VALUES( 5, 'Kaputtteilelager');
INSERT INTO bene.lager(lagnr, bezeichnung) VALUES( 6, 'Reserviertlager');

-- SELECT * FROM bene.lager ORDER BY lagnr;

INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1790, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1791, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1792, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1793, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1794, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1795, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1796, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1797, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1798, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1799, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1801, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1802, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1803, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1804, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1805, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1806, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1807, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1808, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1810, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1811, 1, 12, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1812, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1813, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1814, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1815, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1817, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1818, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1819, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1820, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1821, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1822, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1824, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1825, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1826, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1827, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1828, 3, 19, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1829, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1830, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1831, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1832, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1834, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1835, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1836, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1837, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1838, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1839, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1840, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1842, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1843, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1844, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1845, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1846, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1847, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1848, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1849, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1851, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1852, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1853, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1854, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1856, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1857, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1858, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1859, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1860, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1862, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1863, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1864, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1865, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1866, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1867, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1868, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1869, 2, 16, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1870, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1871, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1872, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1873, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1874, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1875, 1, 12, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1876, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1879, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1880, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1881, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1882, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1883, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1018, 2, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1032, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1047, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1069, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1087, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1105, 3, 15, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1122, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1136, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1156, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1172, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1190, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1209, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1222, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1240, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1258, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1271, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1284, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1300, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1313, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1342, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1360, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1377, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1397, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1420, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1437, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1471, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1486, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1501, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1520, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1536, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1556, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1574, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1589, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1604, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1623, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1641, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1656, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1665, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1679, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1695, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1725, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1738, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1758, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1787, 2, 10, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1809, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1823, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1841, 1, 12, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1861, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1877, 1, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1961, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1985, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1986, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1987, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1988, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1989, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1990, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1991, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1992, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1993, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1994, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1995, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1997, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1998, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1999, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2000, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2001, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2062, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2063, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2064, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2065, 1, 20, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2066, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2067, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2068, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2069, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2070, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2071, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2073, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2074, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2075, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2076, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2077, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2101, 2, 10, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2102, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2103, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2104, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2105, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2106, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2107, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2108, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2109, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2110, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2111, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2112, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2113, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1884, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1885, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1886, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1887, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1888, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1889, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1890, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1891, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1892, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1893, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1894, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1895, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1896, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1897, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1898, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1899, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1900, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1901, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2002, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2003, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2004, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2005, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2006, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2007, 3, 81, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2008, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2009, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2010, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2011, 1, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2012, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2013, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2014, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2015, 2, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2016, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2017, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2018, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2019, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2020, 1, 22, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2021, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2022, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2023, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2024, 3, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2025, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2026, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2027, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2028, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2029, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2030, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2031, 2, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2032, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2033, 2, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2034, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2035, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2036, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2037, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2038, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2039, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2040, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2041, 2, 13, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2042, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2043, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2044, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2045, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2046, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2047, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2048, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2049, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2050, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2051, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2052, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2053, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2054, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2055, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2056, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2057, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2059, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2060, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2061, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2079, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2080, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2081, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2082, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2083, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2084, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2085, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2086, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2087, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2088, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2089, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2090, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2091, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2092, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2093, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2094, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2095, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2096, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2097, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2098, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2099, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (2100, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1902, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1903, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1904, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1905, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1906, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1907, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1909, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1910, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1911, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1912, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1913, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1914, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1915, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1916, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1917, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1918, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1919, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1920, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1921, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1922, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1923, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1924, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1925, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1926, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1927, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1929, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1930, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1931, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1932, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1933, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1934, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1935, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1936, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1937, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1938, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1939, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1940, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1941, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1942, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1943, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1944, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1945, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1946, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1947, 1, 23, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1948, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1949, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1950, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1951, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1952, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1953, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1954, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1955, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1956, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1957, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1958, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1959, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1960, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1962, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1963, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1964, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1965, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1966, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1967, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1968, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1969, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1970, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1971, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1972, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1973, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1974, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1975, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1976, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1977, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1978, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1979, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1980, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1981, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1982, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1983, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1984, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1394, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1395, 3, 12, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1396, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1398, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1399, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1400, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1401, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1403, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1405, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1406, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1407, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1408, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1409, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1410, 2, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1411, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1412, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1413, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1414, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1415, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1416, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1417, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1418, 2, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1419, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1421, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1422, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1424, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1425, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1426, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1427, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1428, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1429, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1430, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1431, 1, 10, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1432, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1433, 3, 15, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1434, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1435, 3, 13, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1436, 2, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1438, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1439, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1440, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1441, 2, 10, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1442, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1443, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1444, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1445, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1446, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1447, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1448, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1449, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1450, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1451, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1452, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1453, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1454, 3, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1455, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1456, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1457, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1458, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1459, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1460, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1461, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1462, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1463, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1464, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1465, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1466, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1467, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1468, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1469, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1470, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1474, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1475, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1476, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1477, 3, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1478, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1479, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1480, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1481, 3, 19, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1482, 3, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1483, 2, 35, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1484, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1485, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1487, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1488, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1489, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1490, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1491, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1492, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1493, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1494, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1495, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1496, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1497, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1498, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1499, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1500, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1502, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1503, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1504, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1506, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1507, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1508, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1509, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1510, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1511, 3, 19, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1512, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1513, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1514, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1515, 1, 12, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1516, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1517, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1518, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1519, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1521, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1522, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1523, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1524, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1525, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1526, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1527, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1528, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1529, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1530, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1531, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1532, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1533, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1534, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1535, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1537, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1538, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1539, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1540, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1541, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1542, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1543, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1545, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1546, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1547, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1548, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1549, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1550, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1551, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1552, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1553, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1554, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1555, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1557, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1558, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1559, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1560, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1561, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1562, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1563, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1564, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1565, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1566, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1567, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1569, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1570, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1571, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1572, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1573, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1575, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1576, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1577, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1578, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1579, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1580, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1581, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1582, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1583, 3, 21, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1584, 2, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1585, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1586, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1587, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1588, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1590, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1591, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1592, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1593, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1594, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1595, 3, 25, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1596, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1597, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1598, 3, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1599, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1600, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1601, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1602, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1603, 2, 10, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1605, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1606, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1607, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1608, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1609, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1610, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1611, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1612, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1613, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1614, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1615, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1616, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1617, 1, 58, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1618, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1619, 3, 19, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1620, 3, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1621, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1622, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1624, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1625, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1626, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1627, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1628, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1629, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1630, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1631, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1632, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1633, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1634, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1635, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1636, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1637, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1638, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1639, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1640, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1642, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1643, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1644, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1645, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1646, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1647, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1648, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1649, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1650, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1651, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1652, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1653, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1654, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1655, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1657, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1659, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1660, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1661, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1662, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1663, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1664, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1666, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1667, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1668, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1669, 3, 23, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1670, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1671, 2, 14, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1672, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1673, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1674, 1, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1675, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1676, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1677, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1678, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1680, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1681, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1682, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1683, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1684, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1685, 2, 10, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1686, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1687, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1688, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1689, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1690, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1691, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1692, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1693, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1694, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1696, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1697, 1, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1698, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1699, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1700, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1701, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1702, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1703, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1704, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1705, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1706, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1707, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1708, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1709, 1, 12, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1711, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1712, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1713, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1714, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1715, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1716, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1717, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1718, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1719, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1720, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1721, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1722, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1723, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1724, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1726, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1727, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1728, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1729, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1730, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1731, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1732, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1733, 2, 14, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1734, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1735, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1736, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1737, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1739, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1740, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1741, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1742, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1743, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1744, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1745, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1746, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1747, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1748, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1749, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1750, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1751, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1752, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1753, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1754, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1755, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1756, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1757, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1759, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1760, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1761, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1762, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1763, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1764, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1765, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1766, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1767, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1768, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1769, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1770, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1772, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1773, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1774, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1775, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1777, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1778, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1779, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1780, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1781, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1782, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1783, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1784, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1785, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1786, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1788, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1789, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1001, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1002, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1003, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1004, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1005, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1006, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1007, 1, 12, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1008, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1009, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1010, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1011, 1, 17, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1012, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1013, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1014, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1015, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1016, 2, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1017, 2, 20, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1019, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1020, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1021, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1022, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1023, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1024, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1025, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1026, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1027, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1028, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1029, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1030, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1031, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1033, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1034, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1035, 2, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1036, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1037, 1, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1038, 1, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1039, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1040, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1041, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1042, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1043, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1044, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1045, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1046, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1048, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1049, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1050, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1051, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1052, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1053, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1054, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1055, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1056, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1057, 2, 20, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1058, 2, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1059, 2, 20, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1060, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1061, 1, 21, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1062, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1063, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1064, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1065, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1066, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1067, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1068, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1070, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1071, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1072, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1073, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1074, 2, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1075, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1076, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1077, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1078, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1079, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1080, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1081, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1082, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1083, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1084, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1085, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1086, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1088, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1089, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1090, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1091, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1093, 3, 19, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1094, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1095, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1096, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1097, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1098, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1099, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1100, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1101, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1102, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1103, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1104, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1106, 1, 33, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1107, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1108, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1109, 1, 17, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1110, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1111, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1112, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1113, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1114, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1115, 2, 10, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1116, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1117, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1118, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1119, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1120, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1121, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1123, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1124, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1125, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1126, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1127, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1128, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1129, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1130, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1131, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1132, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1133, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1134, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1135, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1137, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1138, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1139, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1140, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1141, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1142, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1143, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1144, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1145, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1146, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1147, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1148, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1149, 2, 23, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1150, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1151, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1152, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1153, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1154, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1155, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1157, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1158, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1159, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1160, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1161, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1163, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1164, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1165, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1166, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1167, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1168, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1169, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1170, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1171, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1173, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1174, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1175, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1176, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1177, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1178, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1179, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1180, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1181, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1182, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1183, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1184, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1185, 1, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1186, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1187, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1188, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1189, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1191, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1192, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1193, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1194, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1195, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1196, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1197, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1198, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1199, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1200, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1201, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1202, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1203, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1204, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1205, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1206, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1207, 2, 23, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1208, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1210, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1211, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1212, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1213, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1214, 3, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1215, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1216, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1217, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1219, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1220, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1221, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1223, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1224, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1225, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1226, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1227, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1228, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1229, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1230, 2, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1231, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1232, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1233, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1234, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1235, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1236, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1237, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1238, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1239, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1241, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1242, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1243, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1244, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1245, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1246, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1247, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1248, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1249, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1250, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1251, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1252, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1253, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1254, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1255, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1256, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1257, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1259, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1260, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1261, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1262, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1263, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1264, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1265, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1266, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1267, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1268, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1269, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1270, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1272, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1273, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1274, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1275, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1276, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1277, 2, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1278, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1279, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1280, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1281, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1282, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1283, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1285, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1287, 1, 8, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1288, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1289, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1290, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1291, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1292, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1293, 3, 46, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1294, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1295, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1296, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1297, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1298, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1299, 1, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1301, 2, 22, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1302, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1303, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1304, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1305, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1306, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1307, 3, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1308, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1309, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1311, 1, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1312, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1314, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1315, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1317, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1318, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1319, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1320, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1321, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1322, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1323, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1324, 1, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1325, 2, 18, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1326, 1, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1327, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1328, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1329, 3, 9, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1330, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1331, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1332, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1333, 1, 23, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1334, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1335, 1, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1336, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1337, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1338, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1339, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1340, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1341, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1343, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1344, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1345, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1346, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1347, 2, 23, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1348, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1349, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1350, 3, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1352, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1353, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1354, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1355, 3, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1356, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1357, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1358, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1359, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1361, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1362, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1363, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1364, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1365, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1366, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1367, 1, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1368, 2, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1369, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1370, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1371, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1372, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1373, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1374, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1375, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1376, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1378, 1, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1379, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1380, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1381, 2, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1382, 3, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1383, 3, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1384, 2, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1385, 2, 7, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1386, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1387, 2, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1388, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1389, 2, 22, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1390, 1, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1391, 1, 5, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1392, 3, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1393, 3, 16, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1004, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1155, 5, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1187, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1212, 5, 4, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1301, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1379, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1416, 5, 6, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1491, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1509, 5, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1555, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1661, 5, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1705, 5, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1764, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1860, 5, 2, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1963, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1994, 5, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1817, 4, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1818, 4, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1819, 4, 1, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1820, 4, 21, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1821, 4, 0, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1822, 4, 3, 0);
INSERT INTO bene.lagerstand (artnr, lagnr, menge, reserviert) VALUES (1824, 4, 0, 0);

-- SELECT * FROM bene.lagerstand ORDER BY artnr, lagnr;
-- SELECT lagnr, COUNT(*) FROM bene.lagerstand GROUP BY lagnr;

INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(285, 'EK', 101, 'MEister', 'Lorenz', NULL, 'Mag.', NULL, 2, '7511', '1991-08-15', 2, 'Georgigasse 7', 'AT', '9500', 'Villach', '+43 4242 58864', '+43 664 5864458', 'AT651700187452345678', 'BFKKAT2K', '2017-01-02', NULL, NULL, 2120);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(238, 'EK', 285, 'Hoier', 'Marion', NULL, NULL, NULL, 1, '1224', '1996-07-13', 1, 'Königsstraße 88', 'AT', '8010', 'Graz', '+43 316 554223', '+43 676 1123221', 'AT651700198745612378', 'GIBAATWWXXX', '2019-04-01', NULL, NULL, 2990);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(452, 'EK', 285, 'Kossegg', 'Anita', NULL, 'Dr.', NULL, 1, '8849', '1994-06-20', 2, 'Annenstraße 7', 'AT', '9020', 'Klagenfurt', '+43 463 123222', '+43 664 1121120', 'AT68877554422345678', 'BFKKAT2K', '2017-05-01', NULL, NULL, 2120);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(755, 'CO', 101, 'Prügger', 'Mathias', NULL, NULL, 'MSc', 2, '7445', '1988-06-25', 2, 'Bergstraße 72', 'AT', '8020', 'Graz', '+43 316 123212', '+43 664 4455455', 'AT850004589154545678', 'BKAUATWW', '2018-06-01', NULL, NULL, 3100);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(833, 'CO', 755, 'Holzmann', 'Bernhard', 'Ing.', NULL, NULL, 2, '7598', '1997-08-16', 1, 'Eckertstraße 4', 'DE', '01099', 'Dresden', NULL, '+49 171 5078 555', 'DE410000343400566556', 'COBADEFFXXX', '2018-03-15', NULL, NULL, 2800);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(455, 'FB', 101, 'Pullmeier', 'Eva', NULL, 'Dipl.-Hdl.', NULL, 1, '7854', '1977-03-04', 2, 'Pfarrgasse 13', 'DE', '80539', 'München', NULL, '+49 171 4747 444', 'DE230000332300323000', 'DEUTDEBBXXX', '2018-02-15', NULL, NULL, 1980);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(357, 'FB', 455, 'Austritt', 'Amanda', NULL, NULL, 'BA', 1, '1559', '1996-03-14', 1, 'Seidl-Fort-Weg 33', 'DE', '85737', 'Ismaning', NULL, '+49 172 26695300', 'DE520000662495565990', 'DEUTDEBBXXX', '2017-04-01', '2018-01-31', 'einvernehmlich ausgeschieden', 2150);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(101, 'GL', NULL,'Obermann', 'Gernot', NULL, 'Dr.', NULL, 2, '4587', '2000-08-01', 2, 'Hauseggerstraße 93', 'DE', '40223', 'Düsseldorf', '+49 211 1544 544', '+49 177 15990099',	'DE450000000078441555', 'BYLADEMMXXX', '2020-01-02', NULL, NULL, 8700);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(182, 'GL', 101, 'Hille', 'Bernadette', NULL, NULL, NULL, 1, '7755', '1990-09-11', 2, 'Staudgasse 17', 'DE', '12349', 'Berlin', NULL, '+49 178 1874 4000', 'DE670000046460046464', 'GENODEFFXXX', '2017-08-01', NULL, NULL, 4360);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(115, 'GL', 101, 'Konstantin', 'Martin', NULL, 'Dipl.-Ing.', NULL, 2, '4169', '1979-08-04', 2, 'Augasse 36a', 'AT', '6010', 'Innsbruck', NULL, '+43 660 12332112', 'AT890000545454545454', 'GIBAATWWXXX', '2013-10-01', NULL, NULL, 6550);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(952, 'LA', 115, 'Morillanitsch', 'Manfred', NULL, NULL, NULL, 2, '7566', '2002-07-15', 1, 'Grabenstraße 1c', 'DE', '50765', 'Köln', NULL, '+49 172 77 474 533', 'DE471000010000122212', 'HYVEDEMMXXX', '2015-06-01', NULL, NULL, 1100);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(958, 'LA', 952, 'Huber', 'Ludwig', NULL, NULL, NULL, 2, '9742', '1994-09-23', 2, 'Kahngasse 115', 'AT', '4020', 'Linz', '+43 732 46 50 11', NULL, 'AT651700121212345678', 'STSPAT2G', '2020-02-01', NULL, NULL, 490);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(799, 'LA', 952, 'Schulz', 'Paul', NULL, NULL, NULL, 2, '1579', '1995-01-24', 2, 'Richard-Wagner-Gasse 8', 'AT', '5020', 'Salzburg', NULL, '+43 676 8887811', 'AT150005158151654444', 'BKAUATWW', '2016-07-02', NULL, NULL, 880);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(332, 'MA', 182, 'Ideenreich', 'Anastasia', NULL, 'Mag.', NULL, 1, '1845', '1991-12-07', 1, 'Stenggstraße 41e', 'DE', '80992', 'München', NULL, '+49 177 84516620',	'DE540009517531515888', 'HYVEDEMMXXX', '2016-02-01', NULL, NULL, 2400);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(387, 'MA', 332, 'Mörtl', 'Gerald', 'Ing.', NULL, NULL, 2, '1152', '2001-04-15', 2, 'Apfelgasse 5', 'DE', '20259', 'Hamburg', '+49 40 884254', '+49 172 44881300', 'DE220000871587150010', 'BYLADEMMXXX', '2016-10-01', NULL, NULL, 1650);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(674, 'VK', 115, 'Loderer', 'Hermine', NULL, NULL, NULL, 1, '4412', '1994-06-03', 2, 'Riesstraße 217', 'DE', '30659', 'Hannover', '+49 511 125454', NULL, 'DE340001591597537555', 'DEUTDEBBXXX', '2018-05-01', NULL, NULL, 1100);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(602, 'VK', 674, 'Jurasek', 'Gottfried', NULL, NULL, NULL, 2, '1145', '1988-09-15', 2, 'Sportplatzweg 31', 'AT', '6900', 'Bregenz', NULL, '+43 664 8745455', 'AT880101848354422422', 'GIBAATWWXXX', '2019-11-01', NULL, NULL, 2690);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(691, 'VK', 674, 'Kirschner', 'Edita', NULL, 'Dr.', NULL, 1, '1125', '1990-04-04', 2, 'Pfauengasse 67', 'AT', '8045', 'Graz', NULL, '+43 680 3400870', 'AT771230002300023227', 'BKAUATWW', '2015-08-01', NULL, 'Karenz/Zwillinge', 760);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(657, 'VK', 674, 'Neumann', 'Maria', 'Prof.', 'Dipl.-Hdl.', NULL, 1, '8564', '1969-01-29', 2, 'Herrengasse 5', 'DE', '46499', 'Hamminkeln', '+49 2852 999955', NULL, 'DE840033022034003500', 'COBADEFFXXX', '2019-07-01', NULL, NULL, 1650);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(633, 'VK', 674, 'Kofler', 'Peter', NULL, NULL, 'BSc', 2, '3442', '1997-11-14', 1, 'Mariagrüner Straße 121', 'DE', '28219', 'Bremen', NULL, '+49 171 12110002', 'DE640011880005515000', 'DGZFDEFFXXX', '2019-04-01', NULL, NULL, 2480);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(651, 'VK', 674, 'Nürnberger', 'Klaus', 'Ing.', 'Dipl.-Kfm.', NULL, 2, '1186', '1999-02-14', 2, 'Bogengasse 16c', 'DE', '80796', 'München', NULL, NULL, 'DE450000874155000112', 'HYVEDEMMXXX', '2020-04-01', NULL, NULL, 3100);
INSERT INTO bene.personal(persnr, abtlg, vorgesetzter, nachname, vorname, titel, akad, akad2, geschlecht, sozversnr, gebdatum, famstand, strasse, land, plz, ort, telefon, mobil, iban, bic, eintritt, austritt, hinweis, gehalt) VALUES(700, 'FB', 455, 'O''Brian', 'Mike', NULL, NULL, NULL, 2, '8131', '2001-07-13', 1, 'Ziegelstraße 19e', 'DE', '10707', 'Berlin', NULL, '+49 172 15584200', 'DE410000551384454880', 'DEUTDEBBXXX', '2021-09-01', NULL, NULL, 1635);

ALTER TABLE bene.personal
ADD CONSTRAINT fk_personal_personal FOREIGN KEY (vorgesetzter) REFERENCES bene.personal(persnr);

-- SELECT * FROM bene.personal;

INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1000, '2018-12-05', 1001, 285, NULL, 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1001, '2018-12-07', 1020, 452, NULL, 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1002, '2019-01-04', 1002, 285, NULL, 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1003, '2019-01-05', 1003, 452, NULL, 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1004, '2019-01-10', 1020, 238, NULL, 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1005, '2019-01-14', 1130, 285, NULL, 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1006, '2019-01-15', 1008, 285, 'Dringend!!!', 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1007, '2019-01-20', 1002, 452, NULL, 4);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1008, '2019-01-13', 1002, 452, NULL, 9);
INSERT INTO bene.bestellungen( bestnr, datum, lieferant, bearbeiter, bemerkung, status) VALUES(1009, '2019-02-20', 1020, 799, NULL, 1);

-- SELECT * FROM bene.bestellungen;

INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1000, 1, 1013, 'dummy', 24, 0, 12);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1000, 2, 1014, 'dummy', 24, 0, 12);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1000, 3, 1020, 'dummy', 12, 0, 12);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1000, 4, 1120, 'dummy', 12, 0, 12);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1000, 5, 1121, 'dummy', 36, 0, 12);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1001, 1, 1319, 'dummy', 8, 0, 5);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1001, 2, 1320, 'dummy', 8, 0, 5);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1001, 3, 1321, 'dummy', 12, 0, 5);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1001, 4, 1322, 'dummy', 12, 0, 5);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1002, 1, 1043, 'dummy', 20, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1002, 2, 1031, 'dummy', 35, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1002, 3, 1028, 'dummy', 40, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1003, 1, 1201, 'dummy', 360, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1003, 2, 1192, 'dummy', 42, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1003, 3, 1178, 'dummy', 120, 0, 20);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1003, 4, 1179, 'dummy', 120, 0, 20);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1003, 5, 1177, 'dummy', 120, 0, 20);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1004, 1, 1216, 'dummy', 1000, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1005, 1, 1157, 'dummy', 260, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1005, 2, 1049, 'dummy', 100, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 1, 1300, 'dummy', 50, 0, 15);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 2, 1307, 'dummy', 40, 0, 15);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 3, 1276, 'dummy', 12, 0, 15);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 4, 1317, 'dummy', 80, 0, 10);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 5, 1342, 'dummy', 10, 0, 15);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 6, 1296, 'dummy', 600, 0, 10);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 7, 1339, 'dummy', 450, 0, 10);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1006, 8, 1299, 'dummy', 200, 0, 10);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1007, 1, 1138, 'dummy', 180, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1007, 2, 1129, 'dummy', 30, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1007, 3, 1077, 'dummy', 60, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1007, 4, 1101, 'dummy', 250, 0, 0);
INSERT INTO bene.bestellpositionen(bestnr, pos, artikel, bezeichnung, menge, preis, rabatt) VALUES(1009, 1, 1054, 'dummy', 100, 0, 5);

UPDATE bene.bestellpositionen b
SET b.bezeichnung = (	SELECT a.bezeichnung
						FROM bene.artikel a
						WHERE a.artnr = b.artikel),
	b.preis = (	SELECT a.ekpreis
				FROM bene.artikel a
                WHERE a.artnr = b.artikel)
WHERE bestnr > 0;

-- SELECT * FROM bene.bestellpositionen;

INSERT INTO bene.wareneingang(waenr, datum, lieferant, lsnr, bearbeiter, status) VALUES(2000001, '2019-01-14', 1003, '2000775', 952, 2);
INSERT INTO bene.wareneingang(waenr, datum, lieferant, lsnr, bearbeiter, status) VALUES(2000002, '2019-01-20', 1002, '500003', 952, 2);
INSERT INTO bene.wareneingang(waenr, datum, lieferant, lsnr, bearbeiter, status) VALUES(2000003, '2019-01-25', 1020, '98551', 799, 2);
INSERT INTO bene.wareneingang(waenr, datum, lieferant, lsnr, bearbeiter, status) VALUES(2000004, '2019-01-26', 1008, '1225554', 958, 2);
INSERT INTO bene.wareneingang(waenr, datum, lieferant, lsnr, bearbeiter, status) VALUES(2000005, '2019-02-02', 1130, 'T2000257', 799, 2);
INSERT INTO bene.wareneingang(waenr, datum, lieferant, lsnr, bearbeiter, status) VALUES(2000006, '2019-02-20', 1130, 'T2001785', 958, 2);
INSERT INTO bene.wareneingang(waenr, datum, lieferant, lsnr, bearbeiter, status) VALUES(2000007, '2019-02-21', 1002, '50010', 958, 1);

-- SELECT * FROM bene.wareneingang;

INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000002, 1, 1043, 'dummy', 20, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000002, 2, 1031, 'dummy', 35, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000002, 3, 1028, 'dummy', 40, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000001, 1, 1201, 'dummy', 360, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000001, 2, 1192, 'dummy', 42, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000001, 3, 1178, 'dummy', 120, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000001, 4, 1179, 'dummy', 120, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000001, 5, 1177, 'dummy', 120, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000003, 1, 1216, 'dummy', 1000, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000005, 1, 1157, 'dummy', 260, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000005, 2, 1049, 'dummy', 100, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 1, 1300, 'dummy', 50, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 2, 1307, 'dummy', 40, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 3, 1276, 'dummy', 12, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 4, 1317, 'dummy', 80, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 5, 1342, 'dummy', 10, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 6, 1296, 'dummy', 600, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 7, 1339, 'dummy', 450, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000004, 8, 1299, 'dummy', 200, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000007, 1, 1138, 'dummy', 180, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000007, 2, 1129, 'dummy', 30, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000007, 3, 1077, 'dummy', 60, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000007, 4, 1101, 'dummy', 250, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000006, 1, 1054, 'dummy', 100, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000006, 2, 1053, 'dummy', 120, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000006, 3, 1052, 'dummy', 130, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000006, 4, 1051, 'dummy', 130, 1);
INSERT INTO bene.wareneingangspositionen(waenr, pos, artikel, bezeichnung, menge, lager) VALUES(2000006, 5, 1050, 'dummy', 80, 1);

UPDATE bene.wareneingangspositionen w
SET w.bezeichnung = (	SELECT a.bezeichnung
						FROM bene.artikel a
						WHERE a.artnr = w.artikel)
WHERE waenr > 0;

-- SELECT * FROM bene.wareneingangspositionen;

INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(121, 'Müller', 'Martin', NULL, 'Mag.', NULL, NULL, NULL, 2, 'Humbertstraße 134', 'DE', '80102', 'München', NULL, NULL, NULL, 'martin.mueller@mueller.com', NULL, '2017-05-22', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(122, 'Maier', 'Peter', NULL, NULL, NULL, NULL, NULL, 2, 'Pfingstalle 13', 'DE', '14055', 'Berlin', NULL, NULL, NULL,'pm@office.de', NULL, '2017-09-16', 0, 0, 0, 0, 1, 'Insolvenzverfahren eröffnet');
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(123, 'Berger', 'Markus', NULL, NULL, NULL, NULL, NULL, 2, 'Patrick Eger-Straße 14', 'DE', '04109', 'Leipzig', NULL, NULL, NULL, NULL, NULL, '2017-10-05', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(124, 'Kofler', 'Ulrike', 'Prof.', 'Dr.', NULL, NULL, NULL, 1, 'Frühlingsweg 5', 'AT', '1200', 'Wien', NULL, NULL, NULL, 'ulli@kofler.at', NULL, '2017-10-10', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(125, 'Korbmann', 'Sabina', NULL, NULL, NULL, NULL, NULL, 1, 'Am Damm 7', 'DE', '04109', 'Leipzig', NULL, NULL, NULL, NULL, NULL, '2017-12-18', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(126, 'Lüfterl', 'Brigitte', NULL, NULL, NULL, NULL, NULL, 1, 'Heßgasse 11', 'DE', '14055', 'Berlin', NULL, NULL, NULL, NULL, NULL, '2018-02-02', 0, 0, 14, 1, 1, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(127, 'Thomas', 'Stephanie', NULL, NULL, NULL, NULL, NULL, 1, 'Merolingergasse 89', 'DE', '46357', 'Essen', NULL, NULL, NULL, NULL, NULL, '2018-04-16', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(128, 'Brunner', 'Gerald', NULL, 'Dipl.-Vw.', NULL, NULL, NULL, 2, 'Mondscheingasse 3', 'DE', '70376', 'Stuttgart', NULL, NULL, NULL, NULL, NULL, '2018-06-18', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(129, 'Gruber', 'Ines', NULL, NULL, NULL, NULL, NULL, 1, 'Otto Wagner Straße 89', 'AT', '8045', 'Graz', NULL, NULL, NULL, NULL, NULL, '2018-08-08', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(130, 'Heiser', 'Heimo', NULL, NULL, 'BSc', NULL, NULL, 2, 'Gustolderstraße 4', 'DE', '99091', 'Erfurt', NULL, NULL, NULL, 'heimheis@gmail.com', NULL, '2018-09-09', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(131, 'Meier', 'Michaela', NULL, 'Dipl.-Kfm.', NULL, NULL, NULL, 1, 'Augustusallee 12', 'DE', '80686', 'München', NULL, NULL, NULL, NULL, NULL, '2018-10-04', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(132, 'Saubermann', 'Ursula', NULL, 'Dipl.-Ing.', NULL, NULL, NULL, 1, 'Ulrichstraße 75', 'DE', '90403', 'Nürnberg', NULL, NULL, NULL, NULL, NULL, '2018-11-18', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(133, 'Krischan', 'Gerald', NULL, 'Mag. Dr.', NULL, NULL, NULL, 2, 'Anton Wildgans Weg 46', 'AT', '9020', 'Klagenfurt', NULL, NULL, NULL, NULL, NULL, '2019-01-12', 0, 0, 30, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(134, 'Trummer', 'Michael', NULL, 'Dr.', NULL, NULL, NULL, 2, 'Sonnenweg 4', 'DE', '40225', 'Düsseldorf', NULL, NULL, NULL, NULL, NULL, '2019-02-14', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(135, 'Zimmer', 'Alexandra', NULL, NULL, NULL, NULL, NULL, 1, 'Bürgersteig 12', 'DE', '70376', 'Stuttgart', NULL, NULL, NULL, NULL, NULL, '2019-03-27', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(136, 'Deutschmann', 'Petra', NULL, NULL, 'MSc', NULL, NULL, 1, 'Rosenweg 10', 'DE', '47198', 'Duisburg', NULL, NULL, NULL, 'petra@gmx.de', NULL, '2019-04-04', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(137, 'Weidmann', 'Karin', NULL, 'Mag.', NULL, NULL, NULL, 1, 'Mardornstraße 54', 'AT', '8010', 'Graz', NULL, NULL, NULL, NULL, NULL, '10.05.2019', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(138, 'Schmiedhofer', 'Michael', 'Ing.', NULL, NULL, NULL, NULL, 2, 'Pulitschgasse 54', 'DE', '40225', 'Düsseldorf', NULL, NULL, NULL, NULL, NULL, '2019-06-16', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(139, 'Wolfgruber', 'Erich', NULL, NULL, NULL, NULL, NULL, 2, 'Luftweg 57', 'DE', '70376', 'Stuttgart', NULL, NULL, NULL, NULL, NULL, '2019-08-13', 0, 0, 0, 0, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(140, 'Frisch', 'Michael', NULL, NULL, NULL, NULL, NULL, 2, 'Wittholmstraße 117', 'DE', '78467', 'Konstanz', NULL, NULL, NULL, NULL, NULL, '2019-09-14', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(141, 'Meier', 'Karl', NULL, NULL, NULL, 'Meier''s Kantine', NULL, 4, 'Bahnhofstraße 33', 'AT', '8010', 'Graz', NULL, NULL, NULL, 'kantine@a1.net',  'www.meierskantine.at', '2020-01-08', 0, 0, 14, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(142, 'Wolf', 'Wolfram', NULL, NULL, NULL, 'Magistrat Graz', 'Hochbauamt', 5, 'Herrengasse 7', 'AT', '8010', 'Graz', NULL, NULL, NULL, 'wolfram.wolf@graz.at', NULL, '2020-01-16', 2, 14, 30, 1, 0, NULL);
INSERT INTO bene.kunden( kdnr, nachname, vorname, titel, akad, akad2, firma1, firma2, geschlecht, strasse, land, plz, ort, telefon, fax, mobil, email, web, erfasst, skonto, skontotage, ziel, lieferschein, gesperrt, hinweis) VALUES(143, 'Bucher-Brunner', 'Anna', NULL, NULL, NULL, NULL, NULL, 1, 'Seefeldstraße 177', 'CH', '8008', 'Zürich', NULL, NULL, NULL, 'a.bucherbrunner@gmail.com', NULL, '2020-01-17', 0, 0, 14, 1, 0, NULL);

-- SELECT * FROM bene.kunden;

INSERT INTO bene.interessen(intcode, bezeichnung) VALUES('KUE', 'Küche und Kochen');
INSERT INTO bene.interessen(intcode, bezeichnung) VALUES('HWE', 'Heimwerken');
INSERT INTO bene.interessen(intcode, bezeichnung) VALUES('HUG', 'Haus und Garten');
INSERT INTO bene.interessen(intcode, bezeichnung) VALUES('SPO', 'Sportartikel');
INSERT INTO bene.interessen(intcode, bezeichnung) VALUES('BAU', 'Werk- und Baustoffe');
INSERT INTO bene.interessen(intcode, bezeichnung) VALUES('MUS', 'Musik');
INSERT INTO bene.interessen(intcode, bezeichnung) VALUES('BUE', 'Bücher und Literatur');

-- SELECT * FROM bene.interessen;

INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(121, 'BAU');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(121, 'HWE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(122, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(123, 'HWE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(123, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(123, 'BUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(124, 'HUG');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(125, 'HUG');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(125, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(125, 'SPO');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(126, 'HUG');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(126, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(127, 'BAU');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(128, 'BAU');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(129, 'HUG');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(130, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(131, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(132, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(133, 'HUG');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(134, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(135, 'BAU');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(136, 'HUG');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(137, 'HUG');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(138, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(139, 'HWE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(139, 'KUE');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(140, 'SPO');
INSERT INTO bene.kundeninteressen(kdnr, intcode) VALUES(140, 'BUE');

-- SELECT * FROM bene.kundeninteressen;

INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('A', 0, 500);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('B', 500.0001, 1000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('C', 1000.0001, 1500);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('D', 1500.0001, 2000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('E', 2000.0001, 3000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('F', 3000.0001, 4000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('G', 4000.0001, 5500);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('H', 5500.0001, 7000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('I', 7000.0001, 8500);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('J', 8500.0001, 10000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('K', 10000.0001, 15000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('L', 15000.0001, 20000);
INSERT INTO bene.gehaltstufen(stufe, von, bis) VALUES('M', 20000.0001, 30000);

-- SELECT * FROM bene.gehaltstufen;

INSERT INTO bene.liketest VALUES('testwert');
INSERT INTO bene.liketest VALUES('test_wert');
INSERT INTO bene.liketest VALUES('test%wert');
INSERT INTO bene.liketest VALUES('test wert');
INSERT INTO bene.liketest VALUES('test[wert');

-- SELECT * FROM bene.liketest;


COMMIT;

/*

DROP TABLE bene.wareneingangspositionen;
DROP TABLE bene.wareneingang;
DROP TABLE bene.bestellpositionen;
DROP TABLE bene.bestellungen;
DROP TABLE bene.gehaltstufen;
DROP TABLE bene.setartikel;
DROP TABLE bene.kundeninteressen;
DROP TABLE bene.kunden;
DROP TABLE bene.interessen;
DROP TABLE bene.lagerstand;
DROP TABLE bene.lager;
DROP TABLE bene.personal;
DROP TABLE bene.anreden;
DROP TABLE bene.abteilungen;
DROP TABLE bene.artikel;
DROP TABLE bene.artikelgruppen;
DROP TABLE bene.lieferanten;
DROP TABLE bene.laender;
DROP TABLE bene.status;
DROP TABLE bene.gruppen1;
DROP TABLE bene.gruppen2;
DROP TABLE bene.liketest;

*/

 
