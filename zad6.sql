USE DB23_KOZAK;

-- Tabela Lotniska
CREATE TABLE Lotniska(
    lotnisko_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(255),
    miejscowosc VARCHAR(100),
    kraj VARCHAR(255),
    aktywne BOOL,
    PRIMARY KEY (lotnisko_id)
);

INSERT INTO Lotniska (nazwa, miejscowosc, kraj, aktywne)
VALUES 
    ('Międzynarodowy Port Lotniczy im. Jana Pawła II Kraków-Balice', 'Balice', 'Polska', TRUE),
    ('Aeroport Internacional de Barcelona', 'El Prat de Llobregat', 'Hiszpania', TRUE),
    ('Lotnisko Chopina w Warszawie', 'Warszawa', 'Polska', TRUE);

-- Tabela Bagaze
CREATE TABLE Bagaze(
    bagaz_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    waga_glowny FLOAT(2) UNSIGNED,
    waga_podreczny FLOAT(2) UNSIGNED,
    waga_nadbagaz FLOAT(2) UNSIGNED,
    cena_glowny DECIMAL(10, 2) UNSIGNED,
    cena_podreczny DECIMAL(10, 2) UNSIGNED,
    cena_nadbagaz DECIMAL(10, 2) UNSIGNED,
    PRIMARY KEY (bagaz_id)
);

INSERT INTO Bagaze (waga_glowny, waga_podreczny, waga_nadbagaz, cena_glowny, cena_podreczny, cena_nadbagaz)
VALUES 
    (20.0, 6.0, 32.0, 0.00, 0.00, 80.00),
    (15.0, 12.0, 32.0, 0.00, 0.00, 100.00);

-- Tabela Samoloty
CREATE TABLE Samoloty(
    samolot_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(255),
    nr_rejestracyjny VARCHAR(255),
    ekon_ilosc INT UNSIGNED,
    biznes_ilosc INT UNSIGNED,
    pierwsza_ilosc INT UNSIGNED,
    zasieg FLOAT(2) UNSIGNED,
    linia_lotnicza VARCHAR(255),
    aktywny BOOL,
    PRIMARY KEY (samolot_id)
);

INSERT INTO Samoloty (nazwa, nr_rejestracyjny, ekon_ilosc, biznes_ilosc, pierwsza_ilosc, zasieg, linia_lotnicza, aktywny)
VALUES 
    ('Boeing 737', 'A1', 150, 20, 10, 3440, 'Ryanair', TRUE),
    ('Airbus A320', 'A2', 180, 30, 15, 5700, 'WizzAir', TRUE);

-- Tabela Pracownicy
CREATE TABLE Pracownicy(
    pracownik_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    stanowisko VARCHAR(50),
    firma VARCHAR(255),
    data_urodzenia DATE,
    data_zatrudnienia DATE,
    miasto VARCHAR(255),
    ulica VARCHAR(255),
    numer_budynku VARCHAR(10),
    kod_pocztowy VARCHAR(15),
    kraj VARCHAR(255),
    telefon VARCHAR(20),
    email VARCHAR(255),
    aktywny BOOL,
    uwagi VARCHAR(255),
    PRIMARY KEY (pracownik_id)
);

INSERT INTO Pracownicy (imie, nazwisko, stanowisko, firma, data_urodzenia, data_zatrudnienia, miasto, ulica, numer_budynku, kod_pocztowy, kraj, telefon, email, aktywny)
VALUES
    ('Jan', 'Kowalski', 'Pilot', 'Ryanair', '1980-05-15', '2018-03-10', 'Warszawa', 'Lotnicza', '123', '00-001', 'Polska', '123-456-789', 'jan.kowalski@gmail.com', TRUE),
    ('Anna', 'Nowak', 'Stewardessa', 'Ryanair', '1995-08-22', '2015-06-20', 'Kraków', 'Szybka', '45', '30-123', 'Polska', '987-654-321', 'anna.nowak@gmail.com', TRUE),
    ('Piotr', 'Wójcik', 'Steward', 'Ryanair', '1995-12-03', '2019-11-05', 'Gdańsk', 'Techniczna', '78', '80-456', 'Polska', '555-333-111', 'piotr.wojcik@gmail.com', TRUE),
    ('Karol', 'Lis', 'Pilot', 'Ryanair', '1985-06-18', '2012-09-15', 'Łódź', 'Szybka', '56', '90-789', 'Polska', '111-222-333', 'karol.lis@gmail.com', TRUE);


-- Tabela Trasy
CREATE TABLE Trasy(
    trasa_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    lok_poczatkowa INT UNSIGNED,
    cel INT UNSIGNED,
    dlugosc_trasy FLOAT(2),
    PRIMARY KEY (trasa_id),
    FOREIGN KEY (lok_poczatkowa) REFERENCES Lotniska(lotnisko_id),
    FOREIGN KEY (cel) REFERENCES Lotniska(lotnisko_id)
);

INSERT INTO Trasy (lok_poczatkowa, cel, dlugosc_trasy)
VALUES
    (1, 2, 1681),
    (2, 3, 1873),
    (3, 1, 246);

-- Tabela Loty
CREATE TABLE Loty(
    lot_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    samolot_id INT UNSIGNED,
    bagaz_id INT UNSIGNED,
    trasa_id INT UNSIGNED,
    typ VARCHAR(255),
    postoje INT,
    linia_lotnicza VARCHAR(255),
    czas_przybycia DATETIME(0),
    czas_odlotu DATETIME(0),
    czas_przylotu DATETIME(0),
    dlugosc_lotu TIME(0),
    opoznienie TIME(0),
    status_lotu VARCHAR(255),
    PRIMARY KEY (lot_id),
    FOREIGN KEY (samolot_id) REFERENCES Samoloty(samolot_id),
    FOREIGN KEY (bagaz_id) REFERENCES Bagaze(bagaz_id),
    FOREIGN KEY (trasa_id) REFERENCES Trasy(trasa_id)
);

INSERT INTO Loty (samolot_id, bagaz_id, trasa_id, typ, postoje, linia_lotnicza, czas_przybycia, czas_odlotu, czas_przylotu, dlugosc_lotu, opoznienie, status_lotu)
VALUES
    (1, 1, 1, 'Pasażerski', 0, 'Ryanair', '2023-12-01 08:20:00', '2023-12-01 09:00:00', '2023-12-01 12:15:00', '03:15:00', '00:15:00', 'Opóźniony'),
    (1, 2, 2, 'Pasażerski', 0, 'Ryanair', '2023-12-03 12:20:00', '2023-12-03 13:00:00', '2023-12-02 16:00:00', '03:00:00', NULL, 'Na czas'),
    (1, NULL, 3, 'Cargo', 0, 'Ryanair', '2023-12-05 18:00:00', '2023-12-05 19:00:00', '2023-12-03 20:00:00', '01:00:00', NULL, 'Na czas');

-- Tabela Pasazerowie
CREATE TABLE Pasazerowie(
    pasazer_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    plec VARCHAR(255),
    miasto VARCHAR(255),
    ulica VARCHAR(255),
    numer_budynku VARCHAR(10),
    kod_pocztowy VARCHAR(15),
    kraj VARCHAR(255),
    telefon VARCHAR(20),
    email VARCHAR(255),
    paszport VARCHAR(50),
    PRIMARY KEY (pasazer_id)
);

INSERT INTO Pasazerowie (imie, nazwisko, plec, miasto, ulica, numer_budynku, kod_pocztowy, kraj, telefon, email, paszport)
VALUES
    ('Martyna', 'Kowalska', 'Kobieta', 'Warszawa', '3 Maja', '45', '00-123', 'Polska', '555-111-222', 'martyna.kowalska@gmail.com', 'ABC123456'),
    ('Jan', 'Nowak', 'Mężczyzna', 'Kraków', 'Szybka', '12', '30-456', 'Polska', '777-222-333', 'jan.nowak@gmail.com', 'XYZ789012'),
    ('Monika', 'Wójcik', 'Kobieta', 'Gdańsk', 'Uliczna', '78', '80-789', 'Polska', '888-333-444', 'monika.wojcik@gmail.com', '123DEF456'),
    ('Maciej', 'Kot', 'Mężczyzna', 'Kraków', 'Wolna', '56', '31-234', 'Polska', '999-444-555', 'maciej.kot@gmail.com', '456GHI789');


-- Tabela Bilety
CREATE TABLE Bilety(
    bilet_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    lot_id INT UNSIGNED,
    pasazer_id INT UNSIGNED,
    data_zamowienia DATETIME(0),
    data_anulowania DATETIME(0),
    status_biletu VARCHAR(255),
    brama VARCHAR(10),
    klasa VARCHAR(255),
    siedzenie VARCHAR(10),
    bagaz_glowny BOOL,
    bagaz_podreczny BOOL,
    nadbagaz BOOL,
    cena_suma DECIMAL(10, 2),
    PRIMARY KEY (bilet_id),
    FOREIGN KEY (lot_id) REFERENCES Loty(lot_id),
    FOREIGN KEY (pasazer_id) REFERENCES Pasazerowie(pasazer_id)
);

INSERT INTO Bilety (lot_id, pasazer_id, data_zamowienia, data_anulowania, status_biletu, brama, klasa, siedzenie, bagaz_glowny, bagaz_podreczny, nadbagaz, cena_suma)
VALUES
    (1, 1, '2023-10-30 15:01:05', NULL, 'Oplacony', 'B2', 'Ekonomiczna', '12A', TRUE, TRUE, FALSE, 120.00),
    (2, 2, '2023-11-24 10:34:00', NULL, 'Oplacony', 'C1', 'Biznesowa', '3C', TRUE, TRUE, TRUE, 250.00),
    (1, 3, '2023-09-28 08:45:42', '2023-11-29 09:30:00', 'Anulowany', 'B2', 'Ekonomiczna', '10A', TRUE, TRUE, FALSE, 90.00),
    (2, 4, '2023-11-07 10:45:02', NULL, 'Oplacony', 'C4', 'Pierwsza Klasa', '1A', TRUE, TRUE, FALSE, 400.00);


-- Tabela Zaloga
CREATE TABLE Zaloga(
    zaloga_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    lot_id INT UNSIGNED,
    pracownik_id INT UNSIGNED,
    PRIMARY KEY (zaloga_id),
    FOREIGN KEY (lot_id) REFERENCES Loty(lot_id),
    FOREIGN KEY (pracownik_id) REFERENCES Pracownicy(pracownik_id)
);

INSERT INTO Zaloga (lot_id, pracownik_id)
VALUES
    (1, 1),
    (1, 4),
    (1, 2),
    (1, 3),
    (2, 1),
    (2, 4),
    (2, 2),
    (2, 3),
    (3, 1),
    (3, 4);

-- Procedury
DELIMITER //
CREATE PROCEDURE SelectAllLotniska()
BEGIN
    SELECT * FROM Lotniska;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllBagaze()
BEGIN
    SELECT * FROM Bagaze;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllSamoloty()
BEGIN
    SELECT * FROM Samoloty;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllPracownicy()
BEGIN
    SELECT * FROM Pracownicy;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllTrasy()
BEGIN
    SELECT * FROM Trasy;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllLoty()
BEGIN
    SELECT * FROM Loty;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllPasazerowie()
BEGIN
    SELECT * FROM Pasazerowie;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllBilety()
BEGIN
    SELECT * FROM Bilety;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE SelectAllZaloga()
BEGIN
    SELECT * FROM Zaloga;
END //
DELIMITER ;