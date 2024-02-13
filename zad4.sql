USE DB23_KOZAK;

ALTER TABLE Produkty ADD jednostka_miary VARCHAR(20);
ALTER TABLE ZamowieniaDoSklepu ADD faktura_nr VARCHAR(20);
ALTER TABLE ZamowieniaDoSklepu ADD cena_jednostkowa DECIMAL(10, 2);
ALTER TABLE ZamowieniaKlienci ADD faktura_nr VARCHAR(20);
ALTER TABLE ZamowieniaKlienci ADD cena_jednostkowa DECIMAL(10, 2);


-- FakturaZakup:
-- Produkty
INSERT INTO Produkty (nazwa, typ, jednostka_miary, ilosc_dostepna)
VALUES ('Zeszyt A4 101 kartek', 'Zeszyt', 'szt.', 10),
       ('Pióro Pen2000', 'Pióro', 'szt', 20);

-- Dostawcy
INSERT INTO Dostawcy (nazwa, miasto, ulica, kod_pocztowy, kraj)
VALUES ('Firma papiernicza "Papier"', 'Warszawa', 'Papiernicza 100', '00-001', 'Polska');

-- ZamowieniaDoSklepu
INSERT INTO ZamowieniaDoSklepu (faktura_nr, produkt_id, dostawca_id, data_zamowienia, zaplacone, zrealizowane, data_realizacji, ilosc, cena_jednostkowa, cena_suma)
VALUES ('1/1/2190', 1, 1, '2190-01-01', TRUE, TRUE, '2190-01-01', 10, 5, 50);
INSERT INTO ZamowieniaDoSklepu (faktura_nr, produkt_id, dostawca_id, data_zamowienia, zaplacone, zrealizowane, data_realizacji, ilosc, cena_jednostkowa, cena_suma, kwota_obnizki)
VALUES ('1/1/2190', 2, 1, '2190-01-01', TRUE, TRUE, '2190-01-01', 20, 200, 2000, 2000);


-- FakturaSprzedaż:
-- Produkty
INSERT INTO Produkty (nazwa, typ, jednostka_miary)
VALUES ('Zeszyt A2 21 kartek', 'Zeszyt', 'szt.'),
       ('Pióro Pen100000', 'Pióro', 'szt.'),
       ('Flamaster Pisak102', 'Flamaster', 'szt.'),
       ('Atrament Kałamarz niebieski', 'Atrament', 'litr');

-- Klienci
INSERT INTO Klienci (nazwa_firmy, miasto, ulica, kod_pocztowy, kraj)
VALUES ('Firma "ABCDE"', 'Kraków', 'Zeszytowa 100', '10-001', 'Polska');

-- ZamowieniaKlienci
INSERT INTO ZamowieniaKlienci (faktura_nr, produkt_id, klient_id, data_zamowienia, zaplacone, zrealizowane, data_realizacji, ilosc, cena_jednostkowa, cena_suma)
VALUES ('1/1/2190', 3, 1, '2190-01-01', TRUE, TRUE, '2190-01-01', 100, 15, 1500),
       ('1/1/2190', 4, 1, '2190-01-01', TRUE, TRUE, '2190-01-01', 10, 400, 4000),
       ('1/1/2190', 5, 1, '2190-01-01', TRUE, TRUE, '2190-01-01', 15, 10, 150),
       ('1/1/2190', 6, 1, '2190-01-01', TRUE, TRUE, '2190-01-01', 5, 8, 40);