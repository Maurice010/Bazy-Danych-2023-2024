USE DB23_KOZAK;

-- 1) Proszę dodać przy pomocy procedur przynajmniej 3 samoloty, 15 pasażerów, wybranych członków załogi oraz 3 loty.
DELIMITER //
CREATE PROCEDURE DodajLotnisko(
    IN nazwa VARCHAR(255),
    IN miejscowosc VARCHAR(100),
    IN kraj VARCHAR(255),
    IN aktywne BOOL
)
BEGIN
    INSERT INTO Lotniska (nazwa, miejscowosc, kraj, aktywne)
    VALUES (nazwa, miejscowosc, kraj, aktywne);
END //
DELIMITER ;

CALL DodajLotnisko('John F. Kennedy International Airport', 'New York', 'USA', TRUE);

DELIMITER //
CREATE PROCEDURE DodajSamolot(
    IN nazwa VARCHAR(255),
    IN nr_rejestracyjny VARCHAR(255),
    IN ekon_ilosc INT UNSIGNED,
    IN biznes_ilosc INT UNSIGNED,
    IN pierwsza_ilosc INT UNSIGNED,
    IN zasieg FLOAT(2) UNSIGNED,
    IN linia_lotnicza VARCHAR(255),
    IN aktywny BOOL
)
BEGIN
    INSERT INTO Samoloty (nazwa, nr_rejestracyjny, ekon_ilosc, biznes_ilosc, pierwsza_ilosc, zasieg, linia_lotnicza, aktywny)
    VALUES (nazwa, nr_rejestracyjny, ekon_ilosc, biznes_ilosc, pierwsza_ilosc, zasieg, linia_lotnicza, aktywny);
END //
DELIMITER ;

CALL DodajSamolot('Boeing 787 Dreamliner', 'A3', 180, 30, 20, 10000, 'Ryanair', TRUE);
CALL DodajSamolot('McDonnell Douglas DC-10', 'A4', 190, 35, 20, 10220, 'Ryanair', TRUE);
CALL DodajSamolot('Boeing 787 Dreamliner', 'A5', 210, 60, 30, 8800, 'Ryanair', TRUE);

DELIMITER //
CREATE PROCEDURE DodajPracownika(
    IN imie VARCHAR(50),
    IN nazwisko VARCHAR(50),
    IN stanowisko VARCHAR(50),
    IN firma VARCHAR(255),
    IN data_urodzenia DATE,
    IN data_zatrudnienia DATE,
    IN miasto VARCHAR(255),
    IN ulica VARCHAR(255),
    IN numer_budynku VARCHAR(10),
    IN kod_pocztowy VARCHAR(15),
    IN kraj VARCHAR(255),
    IN telefon VARCHAR(20),
    IN email VARCHAR(255),
    IN aktywny BOOL
)
BEGIN
    INSERT INTO Pracownicy (imie, nazwisko, stanowisko, firma, data_urodzenia, data_zatrudnienia, miasto, ulica, numer_budynku, kod_pocztowy, kraj, telefon, email, aktywny)
    VALUES (imie, nazwisko, stanowisko, firma, data_urodzenia, data_zatrudnienia, miasto, ulica, numer_budynku, kod_pocztowy, kraj, telefon, email, aktywny);
END //
DELIMITER ;

CALL DodajPracownika('Andrzej', 'Lotnik', 'Pilot', 'Ryanair', '1982-05-15', '2018-03-10', 'Warszawa', 'Lotnicza', '133', '00-001', 'Polska', '133-436-789', 'flyer@gmail.com', TRUE);

DELIMITER //
CREATE PROCEDURE DodajTrase(
    IN lok_poczatkowa INT UNSIGNED,
    IN cel INT UNSIGNED,
    IN dlugosc_trasy FLOAT(2)
)
BEGIN
    INSERT INTO Trasy (lok_poczatkowa, cel, dlugosc_trasy)
    VALUES (lok_poczatkowa, cel, dlugosc_trasy);
END //
DELIMITER ;

CALL DodajTrase(1, 4, 7015);

DELIMITER //
CREATE PROCEDURE DodajLot(
    IN samolot_id INT UNSIGNED,
    IN bagaz_id INT UNSIGNED,
    IN trasa_id INT UNSIGNED,
    IN typ VARCHAR(255),
    IN postoje INT,
    IN linia_lotnicza VARCHAR(255),
    IN czas_przybycia DATETIME(0),
    IN czas_odlotu DATETIME(0),
    IN czas_przylotu DATETIME(0),
    IN dlugosc_lotu TIME(0),
    IN opoznienie TIME(0),
    IN status_lotu VARCHAR(255)
)
BEGIN
    INSERT INTO Loty (samolot_id, bagaz_id, trasa_id, typ, postoje, linia_lotnicza, czas_przybycia, czas_odlotu, czas_przylotu, dlugosc_lotu, opoznienie, status_lotu)
    VALUES (samolot_id, bagaz_id, trasa_id, typ, postoje, linia_lotnicza, czas_przybycia, czas_odlotu, czas_przylotu, dlugosc_lotu, opoznienie, status_lotu);
END //
DELIMITER ;

CALL DodajLot(3, 2, 4, 'Pasażerski', 0, 'Ryanair', '2024-01-03 12:20:00', '2024-01-03 13:00:00', '2024-01-03 21:35:00', '08:35:00', NULL, 'Na czas');
CALL DodajLot(4, 2, 4, 'Pasażerski', 0, 'Ryanair', '2024-01-15 12:20:00', '2024-01-15 13:00:00', '2024-01-15 21:35:00', '08:35:00', NULL, 'Na czas');
CALL DodajLot(5, 2, 4, 'Pasażerski', 0, 'Ryanair', '2024-02-03 12:20:00', '2024-02-03 13:00:00', '2024-02-03 21:35:00', '08:35:00', NULL, 'Na czas');

DELIMITER //
CREATE PROCEDURE DodajPasazera(
    IN imie VARCHAR(50),
    IN nazwisko VARCHAR(50),
    IN plec VARCHAR(255),
    IN miasto VARCHAR(255),
    IN ulica VARCHAR(255),
    IN numer_budynku VARCHAR(10),
    IN kod_pocztowy VARCHAR(15),
    IN kraj VARCHAR(255),
    IN telefon VARCHAR(20),
    IN email VARCHAR(255),
    IN paszport VARCHAR(50)
)
BEGIN
    INSERT INTO Pasazerowie (imie, nazwisko, plec, miasto, ulica, numer_budynku, kod_pocztowy, kraj, telefon, email, paszport)
    VALUES (imie, nazwisko, plec, miasto, ulica, numer_budynku, kod_pocztowy, kraj, telefon, email, paszport);
END //
DELIMITER ;

CALL DodajPasazera('Anna', 'Zielińska', 'Kobieta', 'Wrocław', 'Słoneczna', '34', '50-123', 'Polska', '555-333-888', 'anna.zielinska@gmail.com', 'DEF123456');
CALL DodajPasazera('Marek', 'Jankowski', 'Mężczyzna', 'Poznań', 'Radosna', '78', '60-456', 'Polska', '666-777-999', 'marek.jankowski@gmail.com', 'JKL789012');
CALL DodajPasazera('Ewa', 'Michalska', 'Kobieta', 'Szczecin', 'Morska', '23', '70-789', 'Polska', '777-888-111', 'ewa.michalska@gmail.com', 'MNO123456');
CALL DodajPasazera('Tomasz', 'Lewandowski', 'Mężczyzna', 'Katowice', 'Długa', '56', '40-234', 'Polska', '999-111-222', 'tomasz.lewandowski@gmail.com', 'PQR789012');
CALL DodajPasazera('Karolina', 'Kowalczyk', 'Kobieta', 'Łódź', 'Sportowa', '12', '90-567', 'Polska', '111-222-333', 'karolina.kowalczyk@gmail.com', 'STU123456');
CALL DodajPasazera('Paweł', 'Nowicki', 'Mężczyzna', 'Gdynia', 'Baltycka', '45', '81-123', 'Polska', '333-444-555', 'pawel.nowicki@gmail.com', 'VWX789012');
CALL DodajPasazera('Agnieszka', 'Szymańska', 'Kobieta', 'Rzeszów', 'Leśna', '67', '35-456', 'Polska', '666-999-888', 'agnieszka.szymanska@gmail.com', 'YZA123456');
CALL DodajPasazera('Robert', 'Duda', 'Mężczyzna', 'Olsztyn', 'Kopernika', '89', '10-789', 'Polska', '111-333-666', 'robert.duda@gmail.com', 'BCD789012');
CALL DodajPasazera('Kinga', 'Lisowska', 'Kobieta', 'Bydgoszcz', 'Słowiańska', '34', '85-234', 'Polska', '222-555-444', 'kinga.lisowska@gmail.com', 'EFG123456');
CALL DodajPasazera('Mariusz', 'Wojciechowski', 'Mężczyzna', 'Częstochowa', 'Mickiewicza', '56', '42-567', 'Polska', '777-222-111', 'mariusz.wojciechowski@gmail.com', 'HIJ789012');
CALL DodajPasazera('Sylwia', 'Krajewska', 'Kobieta', 'Lublin', 'Narutowicza', '78', '20-123', 'Polska', '888-333-555', 'sylwia.krajewska@gmail.com', 'KLM123456');
CALL DodajPasazera('Krzysztof', 'Piotrowski', 'Mężczyzna', 'Zakopane', 'Królewska', '12', '34-456', 'Polska', '999-444-222', 'krzysztof.piotrowski@gmail.com', 'NOP789012');
CALL DodajPasazera('Natalia', 'Mazur', 'Kobieta', 'Suwałki', 'Sienkiewicza', '45', '22-789', 'Polska', '111-555-333', 'natalia.mazur@gmail.com', 'QRS123456');
CALL DodajPasazera('Adam', 'Witkowski', 'Mężczyzna', 'Kielce', 'Paderewskiego', '67', '25-234', 'Polska', '555-111-777', 'adam.witkowski@gmail.com', 'TUV789012');
CALL DodajPasazera('Katarzyna', 'Kowal', 'Kobieta', 'Gorzów Wielkopolski', 'Reymonta', '89', '76-567', 'Polska', '888-222-555', 'katarzyna.kowal@gmail.com', 'WXYZ123456');


DELIMITER //
CREATE PROCEDURE DodajZaloge(
    IN lot_id INT UNSIGNED,
    IN pracownik_id INT UNSIGNED
)
BEGIN
    INSERT INTO Zaloga (lot_id, pracownik_id)
    VALUES (lot_id, pracownik_id);
END //
DELIMITER ;

CALL DodajZaloge(4, 5);
CALL DodajZaloge(4, 2);

CALL DodajZaloge(5, 5);
CALL DodajZaloge(5, 3);

CALL DodajZaloge(6, 1);
CALL DodajZaloge(6, 2);

-- 2) Proszę napisać następujące procedury:
-- Procedura a)
DELIMITER //
CREATE PROCEDURE DodajSamolotyDoLotow(IN lot_id_var INT UNSIGNED, IN samolot_id_var INT UNSIGNED)
BEGIN
    DECLARE trasa_id_var INT UNSIGNED;
    DECLARE postoje_var INT;
    DECLARE samolot_zasieg FLOAT(2);

    SELECT trasa_id, postoje
    INTO trasa_id_var, postoje_var
    FROM Loty
    WHERE lot_id = lot_id_var;

    SELECT zasieg INTO samolot_zasieg
    FROM Samoloty
    WHERE samolot_id = samolot_id_var AND aktywny = TRUE;

    IF postoje_var IS NULL OR postoje_var = 0 THEN  
        IF samolot_zasieg >= (SELECT dlugosc_trasy FROM Trasy WHERE trasa_id = trasa_id_var) THEN
            UPDATE Loty SET samolot_id = samolot_id_var WHERE lot_id = lot_id_var;
        END IF;
    ELSE
        UPDATE Loty SET samolot_id = samolot_id_var WHERE lot_id = lot_id_var;
    END IF;
END //
DELIMITER ;

-- Procedura b)
DELIMITER //
CREATE PROCEDURE UpdateZalogaDlugieLoty(IN zaloga_id_var INT UNSIGNED)
BEGIN
    DECLARE lot_id_var INT UNSIGNED;
    DECLARE trasa_id_var INT UNSIGNED;
    DECLARE dlugosc_trasy_var FLOAT(2);
    DECLARE ilosc_czlonkow INT;

    SELECT lot_id, trasa_id, dlugosc_trasy
    INTO lot_id_var, trasa_id_var, dlugosc_trasy_var
    FROM Loty JOIN Trasy ON Loty.trasa_id = Trasy.trasa_id
    WHERE Loty.lot_id = (SELECT lot_id FROM Zaloga WHERE zaloga_id = zaloga_id_var);

    SET ilosc_czlonkow = (dlugosc_trasy_var - 5000) / 1000;

    INSERT INTO Zaloga (lot_id, pracownik_id)
    SELECT lot_id_var, pracownik_id
    FROM Pracownicy
    WHERE stanowisko LIKE 'Steward%' AND aktywny = TRUE AND pracownik_id NOT IN (
        SELECT pracownik_id
        FROM Zaloga
        WHERE lot_id = lot_id_var
    )
    ORDER BY RAND()
    LIMIT ilosc_czlonkow;
END //
DELIMITER ;

-- Procedura c)
DELIMITER //
CREATE PROCEDURE UpdatePilotDlugieLoty()
BEGIN
    DECLARE pilot INT UNSIGNED;
    DECLARE done INT DEFAULT FALSE;
    DECLARE lot_id_var INT UNSIGNED;
    DECLARE trasa_id_var INT UNSIGNED;

    DECLARE cur CURSOR FOR
    SELECT l.lot_id, l.trasa_id
    FROM Loty l JOIN Trasy tr ON l.trasa_id = tr.trasa_id
    WHERE tr.dlugosc_trasy > 7000;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;

    petla: LOOP
        FETCH cur INTO lot_id_var, trasa_id_var;

        IF done THEN
            LEAVE petla;
        END IF;

        SELECT pracownik_id INTO pilot
        FROM Pracownicy
        WHERE stanowisko LIKE 'Pilot' AND aktywny = TRUE AND pracownik_id NOT IN (
            SELECT pracownik_id
            FROM Zaloga
            WHERE lot_id = lot_id_var
        )
        ORDER BY RAND()
        LIMIT 1;

        INSERT INTO Zaloga (lot_id, pracownik_id)
        VALUES (lot_id_var, pilot);
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

-- Procedura d)
DELIMITER //
CREATE PROCEDURE DodajBiletyDlaPasazerow(IN lot_numer INT UNSIGNED)
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE pasazer_id_var INT UNSIGNED;
    DECLARE cur CURSOR FOR SELECT pasazer_id FROM Pasazerowie ORDER BY nazwisko;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    petla: LOOP
        FETCH cur INTO pasazer_id_var;

        IF done THEN
            LEAVE petla;
        END IF;

        INSERT INTO Bilety (lot_id, pasazer_id, data_zamowienia, status_biletu)
        VALUES (lot_numer, pasazer_id_var, NOW(), 'Oplacony');
    END LOOP;

    CLOSE cur;
END //
DELIMITER ;

-- 3) Funkcja:
DELIMITER //
CREATE FUNCTION LotInfo()
RETURNS TEXT DETERMINISTIC
BEGIN
    DECLARE wynik TEXT;

    SELECT GROUP_CONCAT(CONCAT('Pasazer: ', pas.nazwisko, ', Klasa: ', b.klasa) SEPARATOR '\n')
    INTO wynik
    FROM Bilety b
    JOIN Pasazerowie pas ON b.pasazer_id = pas.pasazer_id;

    RETURN wynik;
END; //
DELIMITER ;

SELECT LotInfo();

DELETE FROM Samoloty WHERE samolot_id = 1;
DELETE FROM Loty WHERE lot_id = 1;

SELECT LotInfo();