
-- Welche Religionen haben einen Namen, der mit C anfängt?
SELECT NAME FROM welt.country
WHERE NAME LIKE 'C%'

-- Welche Städte haben zwischen 5.000.000 und 10.000.000 Einwohner? Ausgabe: city, country
SELECT NAME,POPULATION FROM welt.country
WHERE POPULATION BETWEEN 5000000 AND 10000000
ORDER BY POPULATION

-- Für welche Städte fehlt der Wert Population in der Tabelle city?
-- Geben Sie alle Spalten aus!
SELECT * FROM welt.city
WHERE POPULATION IS NULL

-- An welche Länder grenzt Frankreich (Country = ‘F‘)?
-- Geben Sie diese Länder (Spalte Country1 und Country2) und die Grenzlänge (length) aus!
-- In welchen Spalten kann das Länder Kürzel ‘F‘ in borders stehen?
SELECT * FROM welt.borders
WHERE COUNTRY1 LIKE 'F' OR COUNTRY2 LIKE 'F'

-- Für die Knobler unter Ihnen: Wie müssen Sie den SELECT verändern,
-- wenn man auch die Namen der Nachbarländer Frankreichs ausgeben möchte?

-- Wie viele Länder grenzen an Frankreich?
SELECT COUNT(*) AS X
FROM welt.borders
WHERE COUNTRY1 LIKE 'F' OR COUNTRY2 LIKE 'F'


-- Welche Länder grenzen an mehr als fünf Staaten?
-- Tabellen: Borders, Country.
-- Geben Sie neben der Anzahl auch die Spalten Country und Name aus
-- und ordnen Sie absteigend nach der Anzahl!
SELECT COUNTRY, NAME, ANZAHL FROM (
    SELECT NAME, COUNTRY, (COUNT(*)) AS Anzahl
    FROM (
        SELECT COUNTRY1, COUNTRY2, NAME, COUNTRY
        FROM welt.borders
        JOIN welt.country
            ON country.COUNTRY = borders.Country1 OR
                country.COUNTRY = borders.Country2
        GROUP BY COUNTRY1, COUNTRY2, NAME, COUNTRY )
    GROUP BY COUNTRY, NAME )
WHERE Anzahl > 5
GROUP BY ANZAHL, COUNTRY, NAME
ORDER BY Anzahl DESC;

-- Welche Religionen gibt es in den Ländern Europas?
-- Geben Sie die Spalten Country, Name aus Country
-- und die Spalten religion aus der Tabelle religion aus

SELECT NAME, EUcountry, Religion FROM
    (SELECT country.country AS EUcountry, NAME FROM welt.encompasses
        JOIN welt.country
            ON country.country = encompasses.country AND encompasses.continent = 'Europe')
    JOIN welt.religion
        on EUcountry = religion.country

-- Welche Religionen gibt es nicht in Europa?
-- Geben Sie diese Religionen alphabetisch aufsteigend aus!

SELECT religion FROM
    (SELECT religion, COUNT(*)
    FROM welt.religion
    GROUP BY religion)
WHERE religion NOT IN(
    SELECT religion FROM
        (SELECT religion, count(*) FROM
            (SELECT NAME, EUcountry, Religion FROM
                (SELECT country.country AS EUcountry, NAME FROM welt.encompasses
                    JOIN welt.country
                        ON country.country = encompasses.country AND encompasses.continent = 'Europe')
                JOIN welt.religion
                    on EUcountry = religion.country)
        GROUP BY religion)
    )
ORDER BY RELIGION ASC


-- In welchen Ländern Europas kommen die meisten Religionen vor?
SELECT NAME, COUNT(*) AS mycounter FROM
    (SELECT NAME, EUcountry, Religion FROM
        (SELECT country.country AS EUcountry, NAME FROM welt.encompasses
            JOIN welt.country
                ON country.country = encompasses.country AND encompasses.continent = 'Europe')
        JOIN welt.religion
            on EUcountry = religion.country)
GROUP BY NAME
HAVING count(*) = (
SELECT MAX(mycounter) FROM
(SELECT NAME, COUNT(*) AS mycounter FROM
    (SELECT NAME, EUcountry, Religion FROM
        (SELECT country.country AS EUcountry, NAME FROM welt.encompasses
            JOIN welt.country
                ON country.country = encompasses.country AND encompasses.continent = 'Europe')
        JOIN welt.religion
            on EUcountry = religion.country)
GROUP BY NAME))


-- Welche europäischen Länder sind nicht Mitglieder der NATO?
-- Hinweis: Spalte ismember,appreviation = ‘NATO‘ und Tabelle encompasses berücksichtigen!
SELECT XYZ, ABC FROM
    (SELECT country.country AS XYZ, NAME AS ABC
        FROM welt.encompasses
            JOIN welt.country
                ON country.country = encompasses.country AND encompasses.continent = 'Europe')
MINUS (
    SELECT XYZ, ABC FROM
        (SELECT XYZ, NAME AS ABC, ABBREVIATION FROM
                (SELECT country.country AS XYZ, NAME FROM welt.encompasses
                        JOIN welt.country
                            ON country.country = encompasses.country AND encompasses.continent = 'Europe')
                JOIN welt.isMember
                    ON XYZ = isMember.country
            WHERE ABBREVIATION = 'NATO')
    )


---- ---- ---- AUFGABE 3 ---- ---- ----

-- Schreiben Sie eine View, die alle Hauptstädte der Welt enthält!
-- (Spalten: Country, capital, aus der Tabelle Country, population aus der Tabelle City,
-- Continent aus der Tabelle encompasses.
CREATE VIEW BelibigeView AS
    SELECT Continent, NAME, count, capital, population FROM
        (SELECT encompasses.Continent AS Continent, capital, country.country AS count, NAME FROM welt.encompasses
                            JOIN welt.country
                                ON country.country = encompasses.country)
        JOIN welt.city
            ON count = city.country AND capital = city.city

-- Vergeben Sie Lese-Rechte auf Ihrer View Hauptstädte für jeden in der Datenbank registrieren User!
GRANT SELECT ON BelibigeView TO PUBLIC

-- Schreiben Sie einen Select-Befehl auf Ihrer View, der alle europäischen Hauptstädte selektiert!
SELECT * FROM BelibigeView
WHERE Continent  = 'Europe'

----  ---- ---- AUFGABE 4 ---- ---- ----

-- Legen Sie die Tabelle Hierarchie mit den entsprechenden Datensätzen in der Datenbank an!
DROP TABLE Mitarbeiter;

CREATE TABLE Mitarbeiter (
    Vorgesetzter VARCHAR2(255),
    Angestellter VARCHAR2(255)
);

INSERT INTO Mitarbeiter(Angestellter) VALUES('Schulz');

INSERT INTO Mitarbeiter VALUES('Schulz', 'Maier');
INSERT INTO Mitarbeiter VALUES('Schulz', 'Schmidt');
INSERT INTO Mitarbeiter VALUES('Maier', 'Müller');
INSERT INTO Mitarbeiter VALUES('Müller','Tulpe');
INSERT INTO Mitarbeiter VALUES('Müller','Taris');
INSERT INTO Mitarbeiter VALUES('Tulpe','Real');

INSERT INTO Mitarbeiter(Vorgesetzter) VALUES('Real');
INSERT INTO Mitarbeiter(Vorgesetzter) VALUES('Taris');
INSERT INTO Mitarbeiter(Vorgesetzter) VALUES('Schmidt');

Commit;

SELECT * FROM Mitarbeiter;

-- Welche Vorgesetzten hat der Angestellte Müller?
-- Geben Sie dabei auch die indirekten Vorgesetzten und das Level aus!
SELECT Angestellter,Vorgesetzter, LEVEL
FROM Mitarbeiter
start with Angestellter = 'Müller'
connect by prior Vorgesetzter = Angestellter
ORDER BY LEVEL

-- Welche Mitarbeiter hat der Angestellte Müller?
-- Geben Sie dabei auch die indirekten Untergebenen und das Level aus!
SELECT Angestellter,Vorgesetzter, LEVEL
FROM Mitarbeiter
start with Vorgesetzter = 'Müller'
connect by Vorgesetzter = prior Angestellter
ORDER BY LEVEL

-- Welche Angestellten haben keine Mitarbeiter, sind also nicht selber Vorgesetzter?
SELECT * FROM MITARBEITER
WHERE Angestellter IS NULL

-- Welche Angestellten haben keine Vorgesetzen?
SELECT * FROM MITARBEITER
WHERE Vorgesetzter IS NULL
