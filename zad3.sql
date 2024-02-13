USE DB23_KOZAK;

-- Tabela Produkty
CREATE TABLE Produkty(
    produkt_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(255),
    typ VARCHAR(100),
    producent VARCHAR(255),
    cena DECIMAL(10, 2),
    ilosc_dostepna INT,
    sprzedawane BOOL,
    uwagi VARCHAR(255),
    PRIMARY KEY (produkt_id)
);

-- Tabela Klienci
CREATE TABLE Klienci(
    klient_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    imie VARCHAR(50),
    nazwisko VARCHAR(50),
    nazwa_firmy VARCHAR(255),
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

-- Tabela Pracownicy
CREATE TABLE Pracownicy(
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
    uwagi VARCHAR(255),
    PRIMARY KEY (pracownik_id)
);

-- Tabela Dostawcy
CREATE TABLE Dostawcy(
    dostawca_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(50),
    miasto VARCHAR(255),
    ulica VARCHAR(255),
    numer_budynku VARCHAR(10),
    kod_pocztowy VARCHAR(15),
    kraj VARCHAR(255),
    telefon VARCHAR(20),
    email VARCHAR(255),
    uwagi VARCHAR(255),
    PRIMARY KEY (dostawca_id)
);

-- Tabela ZamowieniaKlienci
CREATE TABLE ZamowieniaKlienci(
    zamowienie_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    klient_id INT UNSIGNED,
    produkt_id INT UNSIGNED,
    data_zamowienia DATE,
    zaplacone BOOL,
    sposob_dostarczenia VARCHAR(255),
    data_wysylki DATE,
    zrealizowane BOOL,
    data_realizacji DATE,
    ilosc INT,
    cena_suma DECIMAL(10, 2),
    kwota_obnizki DECIMAL(10, 2),
    tytul_obnizki VARCHAR(255),
    uwagi VARCHAR(255),
    PRIMARY KEY (zamowienie_id),
    FOREIGN KEY (klient_id) REFERENCES Klienci(klient_id),
    FOREIGN KEY (produkt_id) REFERENCES Produkty(produkt_id)
);

-- Tabela ZamowieniaDoSklepu
CREATE TABLE ZamowieniaDoSklepu(
    zamowienie_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    produkt_id INT UNSIGNED,
    dostawca_id INT UNSIGNED,
    data_zamowienia DATE,
    zaplacone BOOL,
    data_wysylki DATE,
    zrealizowane BOOL,
    data_realizacji DATE,
    ilosc INT,
    cena_suma DECIMAL(10, 2),
    kwota_obnizki DECIMAL(10, 2),
    tytul_obnizki VARCHAR(255),
    uwagi VARCHAR(255),
    PRIMARY KEY (zamowienie_id),
    FOREIGN KEY (produkt_id) REFERENCES Produkty(produkt_id),
    FOREIGN KEY (dostawca_id) REFERENCES Dostawcy(dostawca_id)
);