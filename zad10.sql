USE DB23_KOZAK;

-- Baza danych salonu samochodowego.
-- Stworzony system bazodanowy musi umożliwiać zamówienie samochodu
-- (spośród różnych typów) z wybranymi przez klienta dodatkami i typem silnika.
-- System będzie naliczał rabat, który będzie zależny od liczby dodatków.

CREATE TABLE KlienciSalon (
    klient_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    firma VARCHAR(255),
    miasto VARCHAR(255),
    ulica VARCHAR(255),
    numer_budynku VARCHAR(10),
    kod_pocztowy VARCHAR(15),
    kraj VARCHAR(255),
    telefon VARCHAR(20),
    email VARCHAR(255),
    uwagi VARCHAR(255),
    PRIMARY KEY (klient_id)
);

CREATE TABLE PracownicySalon (
    pracownik_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    stanowisko VARCHAR(50),
    data_urodzenia DATE,
    data_zatrudnienia DATE,
    miasto VARCHAR(255),
    ulica VARCHAR(255),
    numer_budynku VARCHAR(10),
    kod_pocztowy VARCHAR(15),
    kraj VARCHAR(255),
    telefon VARCHAR(20),
    email VARCHAR(255),
    placa DECIMAL(10, 2),
    aktywny BOOL,
    uwagi VARCHAR(255),
    PRIMARY KEY (pracownik_id)
);

CREATE TABLE SilnikiSpalinowe (
    silnik_spalinowy_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    moc VARCHAR(50),
    pojemnosc FLOAT,
    liczba_cylindrow INT,
    rodzaj_paliwa VARCHAR(50),
    zuzycie FLOAT,
    producent VARCHAR(255),
    PRIMARY KEY (silnik_spalinowy_id)
);

CREATE TABLE SilnikiElektryczne (
    silnik_elektryczny_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    moc VARCHAR(50),
    pojemnosc_baterii FLOAT,
    zasieg_elektryczny FLOAT,
    zuzycie FLOAT,
    czas_ladowania FLOAT,
    producent VARCHAR(255),
    PRIMARY KEY (silnik_elektryczny_id)
);

CREATE TABLE Samochody (
    samochod_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    silnik_spalinowy_id INT UNSIGNED,
    silnik_elektryczny_id INT UNSIGNED,
    model VARCHAR(255),
    typ VARCHAR(50),
    emisja DECIMAL(5, 2),
    przyspieszenie DECIMAL(5, 2),
    skrzynia_biegow VARCHAR(50),
    lakier VARCHAR(50),
    rok DATE,
    cena DECIMAL(10, 2),
    na_sprzedaz BOOL,
    PRIMARY KEY (samochod_id),
    FOREIGN KEY (silnik_spalinowy_id) REFERENCES SilnikiSpalinowe(silnik_spalinowy_id),
    FOREIGN KEY (silnik_elektryczny_id) REFERENCES SilnikiElektryczne(silnik_elektryczny_id)
);

CREATE TABLE Dodatki (
    dodatek_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(50),
    cena DECIMAL(10, 2),
    dostepny BOOL,
    PRIMARY KEY (dodatek_id)
);

CREATE TABLE Rabaty (
    rabat_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    dodatki_min INT,
    dodatki_max INT,
    procent_rabatu DECIMAL(5, 2),
    PRIMARY KEY (rabat_id)
);

CREATE TABLE Zamowienia (
    zamowienie_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    klient_id INT UNSIGNED,
    samochod_id INT UNSIGNED,
    pracownik_id INT UNSIGNED,
    rabat_id INT UNSIGNED,
    data_zamowienia DATE,
    data_realizacji DATE,
    liczba_dodatkow INT,
    zaplacone BOOL,
    status_zamowienia VARCHAR(255),
    cena DECIMAL(10, 2),
    uwagi VARCHAR(255),
    PRIMARY KEY (zamowienie_id),
    FOREIGN KEY (pracownik_id) REFERENCES PracownicySalon(pracownik_id),
    FOREIGN KEY (klient_id) REFERENCES KlienciSalon(klient_id),
    FOREIGN KEY (rabat_id) REFERENCES Rabaty(rabat_id),
    FOREIGN KEY (samochod_id) REFERENCES Samochody(samochod_id)
);

CREATE TABLE ZamowienieDodatki (
    zamowienie_dodatki_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    zamowienie_id INT UNSIGNED,
    dodatek_id INT UNSIGNED,
    PRIMARY KEY (zamowienie_dodatki_id),
    FOREIGN KEY (zamowienie_id) REFERENCES Zamowienia(zamowienie_id) ON DELETE CASCADE,
    FOREIGN KEY (dodatek_id) REFERENCES Dodatki(dodatek_id)
);

CREATE TRIGGER update_dodatki_ZamowienieDodatki
AFTER INSERT ON ZamowienieDodatki
FOR EACH ROW
UPDATE Zamowienia
SET liczba_dodatkow = (
    SELECT COUNT(*)
    FROM ZamowienieDodatki
    WHERE zamowienie_id = NEW.zamowienie_id
)
WHERE Zamowienia.zamowienie_id = NEW.zamowienie_id;

CREATE TRIGGER calc_rabat_Zamowienia
AFTER UPDATE ON Zamowienia
FOR EACH ROW
UPDATE Zamowienia
SET rabat_id = (
    SELECT rabat_id
    FROM Rabaty
    WHERE NEW.liczba_dodatkow >= dodatki_min AND NEW.liczba_dodatkow <= dodatki_max
    ORDER BY dodatki_max DESC
    LIMIT 1
);



DELIMITER //
CREATE PROCEDURE ObliczCeneZamowienia(IN zamowienie_id INT)
BEGIN
    DECLARE cena_samochodu DECIMAL(10, 2);
    DECLARE cena_dodatkow DECIMAL(10, 2);
    DECLARE rabat_procent DECIMAL(5, 2);
    DECLARE rabat_kwota DECIMAL(10, 2);
    DECLARE cena_zamowienia DECIMAL(10, 2);

    SELECT cena INTO cena_samochodu
    FROM Samochody
    WHERE samochod_id = (SELECT samochod_id FROM Zamowienia WHERE zamowienie_id = zamowienie_id);

    SELECT SUM(cena) INTO cena_dodatkow
    FROM Dodatki
    WHERE dodatek_id IN (SELECT dodatek_id FROM ZamowienieDodatki WHERE zamowienie_id = zamowienie_id);

    SELECT procent_rabatu INTO rabat_procent
    FROM Rabaty
    WHERE rabat_id = (SELECT rabat_id FROM Zamowienia WHERE zamowienie_id = zamowienie_id);

    SET rabat_kwota = cena_dodatkow * rabat_procent;

    SET cena_zamowienia = cena_samochodu + cena_dodatkow - rabat_kwota;

    UPDATE Zamowienia
    SET cena = cena_zamowienia
    WHERE zamowienie_id = zamowienie_id;
END //
DELIMITER ;



DELIMITER //
CREATE FUNCTION LiczbaSprzedazyPracownika(pracownik_id INT, rok INT, miesiac INT) RETURNS INT
BEGIN
    DECLARE liczba_sprzedazy INT DEFAULT 0;

    SELECT COUNT(*)
    INTO liczba_sprzedazy
    FROM Zamowienia
    WHERE pracownik_id = pracownik_id
        AND YEAR(data_realizacji) = rok
        AND MONTH(data_realizacji) = miesiac;

    RETURN liczba_sprzedazy;
END //
DELIMITER ;