/*
Praktikums Nr.2 Aufgabe 3
*/


/* Erstmal alle löschen */
DROP TABLE Kunde CASCADE CONSTRAINTS;
DROP TABLE Stadt CASCADE CONSTRAINTS;
DROP TABLE Buchung CASCADE CONSTRAINTS;
DROP TABLE Reisezeit CASCADE CONSTRAINTS;
DROP TABLE Hotel CASCADE CONSTRAINTS;

DROP SEQUENCE BUCHUNG_SEQ;
DROP SEQUENCE HOTEL_SEQ;
DROP SEQUENCE KUNDE_SEQ;
DROP SEQUENCE REISEZEIT_SEQ;
DROP SEQUENCE STADT_SEQ;


/* Erstellen der Tablellen */

/* Kunde */
CREATE TABLE Kunde (

  Kunden_id INTEGER PRIMARY KEY,
  Vorname VARCHAR2(255) NOT NULL,
  Nachname VARCHAR2(255) NOT NULL,
  Adresse VARCHAR2(255) NOT NULL

);

CREATE SEQUENCE kunde_seq;

/* Stadt */
CREATE TABLE Stadt (

    Stadt_id INTEGER PRIMARY KEY,
    Stadtname VARCHAR(255) NOT NULL,
    Land VARCHAR(255) NOT NULL,
    Flughafen VARCHAR(255) NULL

);

CREATE SEQUENCE stadt_seq;

CREATE INDEX Stadt_index ON Stadt (Stadtname);

/* Hotel */
CREATE TABLE Hotel (

    Hotel_id INTEGER PRIMARY KEY,
    Hotelname VARCHAR2(50) NOT NULL,
    Klasse NUMBER(5) NOT NULL ,
    Adresse VARCHAR(50) NOT NULL,
    AnzahleEZ NUMBER(4) NOT NULL,
    AnzaldDZ NUMBER(4) NOT NULL,
    PreisEZ NUMBER(4) NOT NULL,
    PreisDZ NUMBER(4) NOT NULL,
    Stadt_id INTEGER NOT NULL,
    CONSTRAINT abc CHECK (Klasse BETWEEN 1 AND 5)
);

ALTER TABLE Hotel
    ADD FOREIGN KEY (Stadt_id)
    REFERENCES Stadt(Stadt_id) INITIALLY DEFERRED;

CREATE SEQUENCE hotel_seq;

CREATE INDEX Hotel_index ON Hotel (Hotelname);

/* Buchung */
CREATE TABLE Buchung (

    Buchungs_id INTEGER PRIMARY KEY,
    Anreisedatum DATE NOT NULL ,
    Abreisedatum DATE NOT NULL,
    GebuchtEZ  NUMBER CHECK ( GebuchtEZ >= 0 ),
    GebuchtDZ NUMBER CHECK ( GebuchtDZ >= 0 ),
    Hotel_id INTEGER NOT NULL,
    Kunden_id INTEGER NOT NULL,
    CONSTRAINT ch_da CHECK ( Anreisedatum < Abreisedatum ) INITIALLY DEFERRED

);

ALTER TABLE Buchung
    ADD FOREIGN KEY (Hotel_id)
    REFERENCES Hotel(Hotel_id) INITIALLY DEFERRED;

ALTER TABLE Buchung
    ADD FOREIGN KEY(Kunden_id)
        REFERENCES Kunde(Kunden_id) ON DELETE CASCADE INITIALLY DEFERRED;

CREATE SEQUENCE buchung_seq;

/* Reisezeit */
CREATE TABLE Reisezeit (

    Zeit_id INTEGER PRIMARY KEY,

    Reisezeit_ NUMBER(4) NOT NULL,

    Buchungs_id INTEGER NOT NULL,
    Von_Stadt INTEGER NOT NULL,
    nach_Stadt INTEGER NOT NULL

);

ALTER TABLE Reisezeit
    ADD FOREIGN KEY (Buchungs_id)
    REFERENCES Buchung(Buchungs_id) INITIALLY DEFERRED;

ALTER TABLE Reisezeit
    ADD FOREIGN KEY (Von_Stadt)
    REFERENCES Stadt(Stadt_id) INITIALLY DEFERRED;

ALTER TABLE Reisezeit
    ADD FOREIGN KEY (nach_Stadt)
    REFERENCES Stadt(Stadt_id) INITIALLY DEFERRED;

CREATE SEQUENCE reisezeit_seq;

/* Don't Ban me lol */
Commit;
