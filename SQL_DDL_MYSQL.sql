
-- ****************************************************************************************************
-- *                                                                                                  *
-- *     Version für MySQL                                                                            *
-- *                                                                                                  *
-- ****************************************************************************************************


-- ****************************************************************************************************
-- *                                                                                                  *
-- *     Die Data Definition Language (DDL)                                               *
-- *                                                                                                  *
-- ****************************************************************************************************

/*
https://dev.mysql.com/doc/refman/8.0/en/
https://dev.mysql.com/doc/refman/8.0/en/data-types.html
*/



-- Erstellen eines Schemas

CREATE SCHEMA train DEFAULT CHARACTER SET latin1 COLLATE latin1_general_ci;

DROP SCHEMA train;








-- Erstellen einer Tabelle: CREATE TABLE

CREATE TABLE train.schulung
(	id int NOT NULL,
	bezeichnung varchar(100) NOT NULL,
	kategorie char(2) NOT NULL,
	dauer tinyint NOT NULL,
	-- verfuegbar datetime DEFAULT NOW(),
    verfuegbar date DEFAULT (CURDATE()),
	preis decimal(9,4),
	aktuell bool DEFAULT 1 NOT NULL 
);

DESC bene.schulung;

SELECT @@version;

SELECT CURDATE();
SELECT CURTIME();
SELECT NOW();
SELECT CAST(NOW() AS date);
SELECT SYSDATE();

SELECT UTC_DATE();
SELECT UTC_TIME();
SELECT UTC_TIMESTAMP();


-- DROP TABLE train.schulung;

INSERT INTO train.schulung
VALUES (1, 'SQL Grundlagen', 'IT', 24, '20210901', 960, 1);

INSERT INTO train.schulung (id, bezeichnung, kategorie, dauer, preis)
VALUES (2, 'SQL Workshop', 'IT', 32, 1250);


SELECT * FROM train.schulung;

COMMIT;



-- Tabelle über ein SELECT erstellen


CREATE TABLE bene.besteck
AS
    SELECT *
    FROM bene.artikel
    WHERE gruppe = 'BE';
    
    
SELECT * FROM bene.besteck;

-- nur Struktur:
CREATE TABLE bene.garten
AS
    SELECT *
    FROM bene.artikel
    WHERE gruppe = 'XX';
    
    
SELECT * FROM bene.garten;    







-- "Abschneiden" (=Leeren) einer Tabelle: TRUNCATE
-- Löschen einer Tabelle DROP:

SELECT * FROM train.schulung;

DELETE FROM train.schulung;

ROLLBACK;

-- > DDL
TRUNCATE TABLE train.schulung;

TRUNCATE TABLE bene.besteck;

TRUNCATE TABLE bene.artikel;


-- Löschen
DROP TABLE train.schulung;








-- Einer Tabelle neue Spalten hinzufügen

-- DROP TABLE bene.kategorien;

CREATE TABLE bene.kategorien
(   kat char(2),
    bezeichnung varchar(30) NOT NULL,
    CONSTRAINT pk_kategorien PRIMARY KEY (kat)
);

INSERT INTO bene.kategorien
VALUES  ('IT', 'Informationstechnologie'),
        ('MA', 'Marketing'),
        ('VT', 'Vertrieb');		

ALTER TABLE bene.kategorien
ADD neue_spalte1 varchar(20);

ALTER TABLE bene.kategorien
ADD neue_spalte2 int NOT NULL DEFAULT 0;

ALTER TABLE bene.kategorien
ADD neue_spalte3 varchar(20) NOT NULL;	-- > wird erstellt und mit Leerstring befüllt

SELECT * FROM bene.kategorien;



-- Spalten einer Tabelle löschen


CREATE TABLE bene.test_tab
(   sp1 varchar(20),
    sp2 varchar(20),
    sp3 varchar(20),
    sp4 varchar(20),
    sp5 varchar(20)
);


INSERT INTO bene.test_tab VALUES ('Dies','ist','ein','kleiner','Test.');

SELECT * FROM bene.test_tab;

ALTER TABLE bene.test_tab
DROP COLUMN sp4;


-- DROP TABLE bene.test_tab;





-- Datentyp einer Spalte ändern
-- DROP TABLE bene.patienten;

CREATE TABLE bene.patienten
(	id int NOT NULL,
	nachname varchar(40) NOT NULL,
	vorname varchar(40) NOT NULL,
	geschlecht char(1),
	svnr char(4) NOT NULL,
	gebdatum date NOT NULL
);

-- Datentyp ändern
ALTER TABLE bene.patienten
MODIFY geschlecht tinyint;   -- Oder: MODIFY COLUMN

DESC bene.patienten;

-- NOT NULL ergänzen ...
ALTER TABLE bene.patienten
MODIFY geschlecht tinyint NOT NULL;

-- NOT NULL entfernen ...
ALTER TABLE bene.patienten
MODIFY geschlecht tinyint;

-- Datentyp ändern
ALTER TABLE bene.patienten
MODIFY geschlecht char(1);


INSERT INTO bene.patienten (id, nachname, vorname, geschlecht, svnr, gebdatum)
VALUES (1, 'Gesund', 'Elfriede', 'w', '1513', '1990-05-30');

INSERT INTO bene.patienten (id, nachname, vorname, geschlecht, svnr, gebdatum)
VALUES (2, 'Kränklich', 'Gerd', 'm', '1515', '1989-09-04');


-- Datentyp ändern
ALTER TABLE bene.patienten
MODIFY geschlecht varchar(100);

ALTER TABLE bene.patienten
MODIFY geschlecht tinyint;











-- Tabelle mit PRIMARY KEY erstellen


-- einfache Syntax
-- DROP TABLE bene.schulung;

CREATE TABLE bene.schulung
(   id int PRIMARY KEY,
    bezeichnung varchar(100) NOT NULL,
    kategorie char(2) NOT NULL,
    dauer tinyint NOT NULL,
    verfuegbar date DEFAULT (CURDATE()),
    preis decimal(9,4),
    aktuell bool DEFAULT 1 NOT NULL
);

INSERT INTO bene.schulung
VALUES (1, 'SQL Grundlagen', 'IT', 24, '2021-09-01', 960, 1);

SELECT * FROM bene.schulung;

DROP TABLE bene.schulung;



-- Automatische Nummerierung: AUTO_INCREMENT


CREATE TABLE bene.schulung
(   id int AUTO_INCREMENT PRIMARY KEY,
    bezeichnung varchar(100) NOT NULL,
    kategorie char(2) NOT NULL,
    dauer tinyint NOT NULL,
    verfuegbar date DEFAULT (CURDATE()),
    preis decimal(9,4),
    aktuell bool DEFAULT 1 NOT NULL
);

INSERT INTO bene.schulung
VALUES (1, 'SQL Grundlagen', 'IT', 24, '2021-09-01', 960, 1);

INSERT INTO bene.schulung (bezeichnung, kategorie, dauer, preis)
VALUES ('SQL Workshop', 'IT', 32, 1250);

SELECT * FROM bene.schulung;


-- Startwert festlegen / explizites Einfügen von Werten

-- Dummywert mit 1 darunter einfügen ...
INSERT INTO bene.schulung (id, bezeichnung, kategorie, dauer, preis)
VALUES (99, 'Dummy für AUTO_INCREMENT --> 100', 'IT', 24, 0);
-- ... und danach zurückrollen oder löschen
ROLLBACK;

-- erster echter Eintrag ...
INSERT INTO bene.schulung (bezeichnung, kategorie, dauer, verfuegbar, preis, aktuell)
VALUES ('SQL Grundlagen', 'IT', 24, '2021-09-01', 960, 1);

SELECT * FROM bene.schulung;

COMMIT;



-- Lücken durch Rollback

INSERT INTO bene.schulung (bezeichnung, kategorie, dauer, preis)
VALUES ('Trigger mit MySQL programmieren', 'IT', 32, 1790);

SELECT * FROM bene.schulung;

ROLLBACK;
COMMIT;

-- keine Lücken durch Fehler bei MySQL

INSERT INTO bene.schulung (bezeichnung, kategorie)
VALUES ('Stored Procedures mit MySQL nutzen', 'IT');

INSERT INTO bene.schulung (bezeichnung, kategorie, dauer, preis)
VALUES ('Stored Procedures mit MySQL nutzen', 'IT', 40, 1880);

SELECT * FROM bene.schulung;

COMMIT;


-- Letzter eingefügter Wert:
SELECT LAST_INSERT_ID() AS letzter;


-- Zurücksetzen von AUTO_INCREMENT
TRUNCATE TABLE bene.schulung;

INSERT INTO bene.schulung (bezeichnung, kategorie, dauer, preis)
VALUES ('Stored Procedures mit MySQL nutzen', 'IT', 40, 1880);

SELECT * FROM bene.schulung;


DROP TABLE bene.schulung;









-- auf Tabellenebene definiert
CREATE TABLE bene.schulung
(   id int AUTO_INCREMENT,
    bezeichnung varchar(100) NOT NULL,
    kategorie char(2) NOT NULL,
    dauer tinyint NOT NULL,
    verfuegbar date DEFAULT (CURDATE()),
    preis decimal(9,4),
    aktuell bool DEFAULT 1 NOT NULL,
    CONSTRAINT pk_schulung PRIMARY KEY (id)
);



-- Eindeutigkeit mit einem UNIQUE KEY erzwingen

-- > Österr. SVNr. aus vierstelliger Nummer und Geburtsdatum

-- DROP TABLE bene.patienten;

CREATE TABLE bene.patienten
(   id int AUTO_INCREMENT,
    nachname varchar(40) NOT NULL,
    vorname varchar(40) NOT NULL,
    geschlecht char(1) NOT NULL,
    svnr decimal(4) NOT NULL,
    gebdatum date NOT NULL,
    CONSTRAINT pk_patienten PRIMARY KEY (id),
    CONSTRAINT uk_patienten_svnr UNIQUE (svnr, gebdatum)
);

INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Gesund', 'Elfriede', 'w', 1515 , '1990-05-30');

INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Kränklich', 'Gerd', 'm', 1515, '1989-09-04');

-- Fehler
INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Doppelt', 'Max', 'm', 1515, '1989-09-04');

SELECT * FROM bene.patienten;

DROP TABLE bene.patienten;




-- Einfache Geschäftsregeln implementieren: CHECK-Constraints
-- DROP TABLE bene.patienten;

CREATE TABLE bene.patienten
(   id int AUTO_INCREMENT,
    nachname varchar(40) NOT NULL,
    vorname varchar(40) NOT NULL,
    geschlecht char(1) NOT NULL,
    svnr decimal(4) NOT NULL,
    gebdatum date NOT NULL,
    CONSTRAINT pk_patienten PRIMARY KEY (id),
    CONSTRAINT uk_patienten_svnr UNIQUE (svnr, gebdatum),
	CONSTRAINT ck_patienten_geschlecht CHECK (geschlecht IN('M','W','D')),
	CONSTRAINT ck_patienten_svnr CHECK (svnr >= 1000)
);

-- Fehler 1
INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Gesund', 'Elfriede', 'x', 1513, '1990-05-30');

-- Fehler 2
INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Gesund', 'Elfriede', 'w', 151, '1990-05-30');

INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Gesund', 'Elfriede', 'w', 15151, '1990-05-30');

-- ok ...
INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Gesund', 'Elfriede', 'w', 1513, '1980-05-30');

INSERT INTO bene.patienten (nachname, vorname, geschlecht, svnr, gebdatum)
VALUES ('Kränklich', 'Gerd', 'm', 1515, '1979-05-30');

SELECT * FROM bene.patienten;

DROP TABLE bene.patienten;








-- Beziehung zwischen zwei Tabellen erzeugen: FOREIGEN KEY

-- Schulungen und deren Kategorien
-- DROP TABLE bene.kategorien


CREATE TABLE bene.kategorien
(   kat char(2),
    bezeichnung varchar(30) NOT NULL,
    CONSTRAINT pk_kategorien PRIMARY KEY (kat)
);

INSERT INTO bene.kategorien 
VALUES	('IT', 'Informationstechnologie'),
		('MA', 'Marketing'),
		('VT', 'Vertrieb');


-- DROP TABLE bene.schulung;

CREATE TABLE bene.schulung
(   id int AUTO_INCREMENT,
    bezeichnung varchar(100) NOT NULL,
    kategorie char(2) NOT NULL,
    dauer tinyint NOT NULL,
    verfuegbar date DEFAULT (CURDATE()),
    preis decimal(9,4),
    aktuell bool DEFAULT 1 NOT NULL,
    CONSTRAINT pk_schulung PRIMARY KEY (id),
    CONSTRAINT fk_schulung_kategorien FOREIGN KEY (kategorie) 
    REFERENCES bene.kategorien (kat)
    ON UPDATE CASCADE 
);

-- Korrekt
INSERT INTO bene.schulung(bezeichnung, kategorie, dauer, verfuegbar, preis, aktuell)
VALUES	('SQL Grundlagen', 'IT', 24, '2021-09-01', 960, 1);

-- Fehler:
INSERT INTO bene.schulung(bezeichnung, kategorie, dauer, verfuegbar, preis, aktuell)
VALUES ('Suppenkochen', 'KO', 16, '2021-09-01', 200, 1);



-- Änderungsweitergabe
UPDATE bene.kategorien
SET kat = 'PC'
WHERE kat = 'IT';

SELECT * FROM bene.schulung;
SELECT * FROM bene.kategorien;





-- Constraints zu einer bestehenden Tabelle hinzufügen
-- DROP TABLE bene.patienten;

CREATE TABLE bene.patienten
(   id int,
    nachname varchar(40) NOT NULL,
    vorname varchar(40) NOT NULL,
    geschlecht char(1) NOT NULL,
    svnr char(4) NOT NULL,
    gebdatum date NOT NULL
);


-- CHECK-Constraint ergänzen  
ALTER TABLE bene.patienten
ADD CONSTRAINT ck_patienten_geschlecht CHECK (geschlecht IN('m','w','d'));

INSERT INTO bene.patienten (id, nachname, vorname, geschlecht, svnr, gebdatum)
VALUES (1, 'Gesund', 'Elfriede', '?', 1515, '1990-05-30');

INSERT INTO bene.patienten (id, nachname, vorname, geschlecht, svnr, gebdatum)
VALUES (1, 'Gesund', 'Elfriede', 'w', 1515, '1990-05-30');


-- Primärschlüssel ergänzen
ALTER TABLE bene.patienten
ADD CONSTRAINT pk_patienten PRIMARY KEY (id);

-- Unique Key ergänzen
ALTER TABLE bene.patienten
ADD CONSTRAINT uk_patienten_svnr UNIQUE (svnr, gebdatum);





-- Entfernen von Constraints


-- DROP TABLE bene.patienten;

CREATE TABLE bene.patienten
(   id int,
    nachname varchar(40),
    vorname varchar(40),
    geschlecht char(1),
    svnr decimal(4) NOT NULL,
    gebdatum date NOT NULL,
    CONSTRAINT pk_patienten PRIMARY KEY (id),
    CONSTRAINT uk_patienten_svnr UNIQUE (svnr, gebdatum)
);

-- Primärschlüssel löschen
ALTER TABLE bene.patienten
DROP PRIMARY KEY;

-- Unique Key Löschen
ALTER TABLE bene.patienten
DROP INDEX uk_patienten_svnr;






-- DROP TABLE bene.schulung;
-- DROP TABLE bene.kategorien;

CREATE TABLE bene.kategorien
(   kat char(2),
    bezeichnung varchar(30) NOT NULL,
    CONSTRAINT pk_kategorien PRIMARY KEY (kat)
);

CREATE TABLE bene.schulung
(   id int,
    bezeichnung varchar(100) NOT NULL,
    kategorie char(2) NOT NULL,
    dauer tinyint NOT NULL,
    verfuegbar date,
    preis decimal(9,4),
    aktuell bool DEFAULT 1 NOT NULL,
    CONSTRAINT ck_schulung_preis CHECK (preis >= 0),
    CONSTRAINT pk_schulung PRIMARY KEY (id),
    CONSTRAINT fk_schulung_kategorien FOREIGN KEY (kategorie) 
    REFERENCES bene.kategorien (kat)
);

ALTER TABLE bene.schulung DROP CONSTRAINT ck_schulung_preis;
ALTER TABLE bene.schulung DROP PRIMARY KEY;
ALTER TABLE bene.schulung DROP CONSTRAINT fk_schulung_kategorien;



DROP TABLE bene.produkte;








-- Einen Index für eine Tabelle erstellen

CREATE TABLE bene.produkte
AS
  SELECT artnr, bezeichnung, gruppe, ekpreis, vkpreis 
  FROM bene.artikel;

SELECT * FROM bene.produkte;

CREATE INDEX ix_produkte_bezeichnung ON bene.produkte(bezeichnung);
CREATE INDEX ix_produkte_bez_gr_vk ON bene.produkte(bezeichnung, gruppe, vkpreis);


-- Index aus der Datenbank entfernen

DROP INDEX ix_produkte_bezeichnung ON bene.produkte;
DROP INDEX ix_produkte_bez_gr_vk ON bene.produkte;   

DROP TABLE bene.produkte;






-- Indexverwendung

CREATE TABLE bene.produkte
AS
  SELECT artnr, bezeichnung, gruppe, ekpreis, vkpreis 
  FROM bene.artikel;

SELECT * FROM bene.produkte;
SELECT * FROM bene.produkte WHERE artnr = 1234;			-- > Strg-Alt-X

CREATE INDEX ix_produkte_artnr ON bene.produkte(artnr);
CREATE INDEX ix_produkte_bez_gr_vk ON bene.produkte(bezeichnung, gruppe, vkpreis);


-- Suche ohne Index / mit Index
SELECT * FROM  bene.produkte WHERE artnr = 1544;

SELECT artnr FROM  bene.produkte WHERE artnr = 1544;


-- Grenze der Indexverwendung (Trefferanzahl)
SELECT * FROM  bene.produkte WHERE artnr <= 1900;
SELECT * FROM  bene.produkte WHERE artnr <= 1400;
SELECT * FROM  bene.produkte WHERE artnr <= 1330;
SELECT * FROM  bene.produkte WHERE artnr <= 1329;

-- zusammengesetzter Index
SELECT * FROM  bene.produkte WHERE bezeichnung LIKE 'gardena%';
SELECT * FROM  bene.produkte WHERE bezeichnung LIKE 'wecker%';

SELECT gruppe, bezeichnung, vkpreis
FROM  bene.produkte 
WHERE bezeichnung LIKE 'gardena%';



















DROP TABLE bene.garten;
DROP VIEW bene.garten;



-- Erzeugen von Sichten


CREATE VIEW bene.garten
AS
    SELECT  artnr, bezeichnung, lieferant, ekpreis, 
            vkpreis, ROUND(vkpreis / (100 + mwst) * 100, 2) AS vk_netto,
			mwst
    FROM bene.artikel
    WHERE gruppe = 'GA';


-- Verwenden einer View
SELECT *
FROM bene.garten;


DROP VIEW bene.garten;







-- Alisanamen bei einer View

CREATE VIEW bene.garten
AS
    SELECT  artnr AS nr, bezeichnung AS produkt, lieferant, ekpreis, 
            vkpreis, ROUND(vkpreis / (100 + mwst) * 100, 2) AS vk_netto,
			mwst
    FROM bene.artikel
    WHERE gruppe = 'GA';



SELECT nr, produkt, vk_netto
FROM bene.garten;


DROP VIEW bene.garten;





-- Alisanamen bei einer View für alle Spalten

CREATE VIEW bene.garten
    (nr, produkt, lief_nr, ek, vk_brutto, vk_netto, ust)
AS
    SELECT  artnr, bezeichnung, lieferant, ekpreis, 
            vkpreis, ROUND(vkpreis / (100 + mwst) * 100, 2) AS vk_netto,
			mwst
    FROM bene.artikel
    WHERE gruppe = 'GA';
    

SELECT * FROM bene.garten;

DROP VIEW bene.garten;

    
    
    
-- Ändern von Sichten

CREATE VIEW bene.garten
    (nr, produkt, lief_nr, ek, vk_brutto, vk_netto, ust)
AS
    SELECT  artnr, bezeichnung, lieferant, ekpreis, 
            vkpreis, ROUND(vkpreis / (100 + mwst) * 100, 2) AS vk_netto,
			mwst
    FROM bene.artikel
    WHERE gruppe = 'GA';


SELECT * FROM bene.garten;
    
-- Ändern: komplett neu definiert, nicht Delta (überschrieben)    
    
CREATE OR REPLACE VIEW bene.garten
    (nr, bezeichnung, lieferant, ek, vk_brutto, vk_netto, mwst, db, aktiv)
AS
    SELECT  artnr, bezeichnung, lieferant, ekpreis, 
            vkpreis, ROUND(vkpreis / (100 + mwst) * 100, 2),  
			mwst, 
			ROUND(vkpreis / (100 + mwst) * 100 - ekpreis, 2), 
			aktiv
    FROM bene.artikel
    WHERE gruppe = 'GA';


SELECT * FROM bene.garten;

    
    
    
-- DML mit einer View


CREATE VIEW bene.haushalt
AS
    SELECT  artnr, bezeichnung, lieferant, ekpreis, vkpreis AS vk_brutto, 
			ROUND(vkpreis / (100 + mwst) * 100, 2) AS vk_netto,
			mwst, aktiv
    FROM bene.artikel
    WHERE gruppe = 'HH';



SELECT * FROM bene.haushalt ORDER BY artnr;

UPDATE bene.artikel
SET vkpreis = 15
WHERE artnr = 1001;

UPDATE bene.haushalt
SET vk_brutto = 16
WHERE artnr = 1001;

SELECT * FROM bene.artikel
WHERE artnr = 1001;




CREATE VIEW bene.mitarbeiterzahlen
AS
	SELECT  a.bezeichnung AS abteilung, 
			COUNT(CASE WHEN p.geschlecht = 1 THEN 'X' END) AS damen,
			COUNT(CASE WHEN p.geschlecht = 2 THEN 'X' END) AS herren,
			COUNT(*) AS gesamt
	FROM bene.personal p
	INNER JOIN bene.abteilungen a ON p.abtlg = a.abtnr
	GROUP BY a.bezeichnung;
	

SELECT *
FROM bene.mitarbeiterzahlen
ORDER BY abteilung;

UPDATE bene.mitarbeiterzahlen
SET damen = 2
WHERE abteilung = 'Controlling';




-- Löschen über eine View

SELECT * FROM bene.haushalt;

DELETE FROM bene.lagerstand WHERE artnr = 1838;
DELETE FROM bene.haushalt WHERE artnr = 1838;

SELECT * FROM bene.artikel WHERE artnr = 1838;



CREATE OR REPLACE VIEW bene.haushalt
AS
    SELECT  artnr, bezeichnung, lieferant, 
			gruppe,
			ekpreis, vkpreis AS vk_brutto, 
			-- ROUND(vkpreis / (100 + mwst) * 100, 2) AS vk_netto,
			mwst, aktiv
    FROM bene.artikel
    WHERE gruppe = 'HH';
    
    
    
-- Löschen aus der View
 
UPDATE bene.haushalt 
SET gruppe = 'BE'
WHERE artnr = 1003;

SELECT *
FROM bene.haushalt 
WHERE artnr = 1003;

 
-- INSERT über eine VIEW

INSERT INTO bene.haushalt (bezeichnung, lieferant, ekpreis, vk_brutto, aktiv, gruppe)
VALUES ('Testartikel', 1002, 5, 6, 1, 'HH');

SELECT *
FROM bene.artikel 
ORDER BY artnr DESC;

