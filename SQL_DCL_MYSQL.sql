
-- aktuellen Benutzer auslesen
SELECT CURRENT_USER();


-- Erzeugen eines Users
CREATE USER lilearner IDENTIFIED BY 'l€arning4life!';

-- Rolle erstellen
CREATE ROLE learner;


-- Mitgliedschaft in einer Rolle erteilen
GRANT learner TO lilearner;
SET DEFAULT ROLE ALL TO lilearner;

-- Berechtigung zum Lesen einer ganzen Tabelle erteilen
GRANT SELECT ON bene.artikelgruppen TO learner;

/*
SELECT CURRENT_USER() AS ich, CURRENT_ROLE();
SHOW GRANTS FOR lilearner;

-- Zugriffstest - nicht erfolgreich
SELECT * FROM bene.artikelgruppen;


-- neue Rollenmitlgiedschaft in Session aktivieren
SET ROLE DEFAULT;
SELECT CURRENT_USER() AS ich, CURRENT_ROLE();

-- Zugriffstest - nun erfolgreich
SELECT * FROM bene.artikelgruppen;

SELECT CURRENT_USER() AS ich, CURRENT_ROLE();
SET ROLE DEFAULT;
*/





-- Mehrere Berechtigungen erteilen
GRANT INSERT, UPDATE, DELETE ON bene.artikelgruppen TO learner;

-- Berechtigungen für Spalten erteilen
GRANT SELECT, UPDATE(ekpreis, vkpreis, lieferant) ON bene.artikel TO learner;


-- Entziehen von Berechtigungen
REVOKE INSERT, DELETE ON bene.artikelgruppen FROM learner;

-- Passwort ändern
ALTER USER lilearner IDENTIFIED BY 'l€arning4life!+more:-)';

-- Mitgliedschaft, Rolle und Benutzer löschen
REVOKE learner FROM lilearner;

DROP ROLE learner;

DROP USER lilearner;


