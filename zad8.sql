USE DB23_KOZAK;

-- Baza danych klientów banku
CREATE TABLE KlienciBank(
    klient_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
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
    aktywny BOOL,
    PRIMARY KEY (klient_id)
);

CREATE TABLE KontaBank(
    konto_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    klient_id INT UNSIGNED,
    saldo DECIMAL(10, 2),
    typ_konta VARCHAR(50),
    aktywne BOOL,
    PRIMARY KEY (konto_id),
    FOREIGN KEY (klient_id) REFERENCES KlienciBank(klient_id)
);

CREATE TABLE TransakcjeBank (
    transakcja_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    id_konta_od INT UNSIGNED,
    id_konta_do INT UNSIGNED,
    kwota DECIMAL(10, 2),
    tytul_transakcji VARCHAR(255),
    typ_transakcji VARCHAR(50),
    data_transakcji TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_transakcji BOOL,
    PRIMARY KEY (transakcja_id),
    FOREIGN KEY (id_konta_od) REFERENCES KontaBank(konto_id),
    FOREIGN KEY (id_konta_do) REFERENCES KontaBank(konto_id)
);

-- Dodanie danych
INSERT INTO KlienciBank (imie, nazwisko, plec, miasto, ulica, numer_budynku, kod_pocztowy, kraj, telefon, email, aktywny)
VALUES
    ('Martyna', 'Kowalska', 'Kobieta', 'Warszawa', '3 Maja', '45', '00-123', 'Polska', '555-111-222', 'martyna.kowalska@gmail.com', TRUE),
    ('Jan', 'Nowak', 'Mężczyzna', 'Kraków', 'Szybka', '12', '30-456', 'Polska', '777-222-333', 'jan.nowak@gmail.com', TRUE);

INSERT INTO KontaBank (klient_id, saldo, typ_konta, aktywne)
VALUES
    (1, 1000.00, 'Osobiste', TRUE),
    (1, 800.00, 'Osobiste', TRUE),
    (2, 800.00, 'Walutowe', TRUE),
    (2, 500.00, 'Osobiste', TRUE);


-- Procedury z transakcjami
DELIMITER //
CREATE PROCEDURE Przelew(
        IN wykonawca_konto_id INT UNSIGNED,
        IN odbiorca_konto_id INT UNSIGNED,
        IN kwota_przelewu DECIMAL(10, 2),
        IN tytul_transakcji VARCHAR(255),
        IN typ_transakcji VARCHAR(50)
    )
BEGIN
    DECLARE saldo_wykonawca DECIMAL(10, 2);

    START TRANSACTION;
    IF odbiorca_konto_id != wykonawca_konto_id AND EXISTS (SELECT 1 FROM KontaBank WHERE konto_id = wykonawca_konto_id AND aktywne = TRUE) AND
       EXISTS (SELECT 1 FROM KontaBank WHERE konto_id = odbiorca_konto_id AND aktywne = TRUE) THEN 

        SELECT saldo INTO saldo_wykonawca FROM KontaBank WHERE konto_id = wykonawca_konto_id;
        IF saldo_wykonawca >= kwota_przelewu AND kwota_przelewu > 0 THEN
            UPDATE KontaBank SET saldo = saldo - kwota_przelewu WHERE konto_id = wykonawca_konto_id;
            UPDATE KontaBank SET saldo = saldo + kwota_przelewu WHERE konto_id = odbiorca_konto_id;
            INSERT INTO TransakcjeBank (id_konta_od, id_konta_do, kwota, tytul_transakcji, typ_transakcji, status_transakcji)
            VALUES (wykonawca_konto_id, odbiorca_konto_id, kwota_przelewu, tytul_transakcji, typ_transakcji, TRUE);
            COMMIT;
        ELSE
            ROLLBACK;
        END IF;
    ELSE
        ROLLBACK;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DodajOdsetki(
        IN odbiorca_konto_id INT UNSIGNED,
        IN stopa_odsetki DECIMAL(10, 2)
    )
BEGIN
    DECLARE saldo_odbiorca DECIMAL(10, 2);

    START TRANSACTION;
    IF EXISTS (SELECT 1 FROM KontaBank WHERE konto_id = odbiorca_konto_id AND aktywne = TRUE) THEN
        SELECT saldo INTO saldo_odbiorca FROM KontaBank WHERE konto_id = odbiorca_konto_id;
        UPDATE KontaBank SET saldo = saldo + saldo * stopa_odsetki / 100  WHERE konto_id = odbiorca_konto_id;
        INSERT INTO TransakcjeBank (id_konta_do, kwota, tytul_transakcji, typ_transakcji, status_transakcji)
        VALUES (odbiorca_konto_id, saldo_odbiorca * stopa_odsetki / 100, 'Naliczenie odsetek', 'Odsetki', TRUE);
        COMMIT;
    ELSE
        ROLLBACK;
    END IF;
END //
DELIMITER ;

-- 1) Przelew pomiędzy kontami różnych właścicieli
CALL Przelew(1, 4, 150.00, 'Tytul przelewu', 'Przelew');
-- 2) Naliczenie (i dodanie) odsetek do konta walutowego
CALL DodajOdsetki(3, 2.5);
-- 3) Transfer środków pomiędzy kontami tego samego właściciela
CALL Przelew(1, 2, 300.00, 'Tytul transferu', 'Przelew');