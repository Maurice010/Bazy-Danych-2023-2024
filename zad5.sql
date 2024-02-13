USE DB23_KOZAK;
-- 1. Postanowilem wczesniej wpisywac cale nazwy firm razem z ich typem co komplikuje wyszukiwanie. Sytuacje ulatwiloby, przy zalozeniu checi zostawienia opisowej czesci,
-- dodanie kolumny na nazwe opisowa i ta wlasciwa (teraz wpisuje 'czesc opisowa "nazwa"').
-- 2. Obecnie przechowuje wszystkie dane o fakturach w tabelach ZamowieniaKlienci i ZamowieniaDoSklepu. Lepiej byloby utworzyc nowa tabele Faktury z kolumnami:
-- numer_faktury, klient_id, dostawca_id i suma (modyfikujac odpowiednio poprzednie tabele i laczac z nowa).

-- ### ZADANIA ###
-- 1. Wszystkie dane ze wszystkich tabel
SELECT * FROM Produkty;
SELECT * FROM Klienci;
SELECT * FROM Dostawcy;
SELECT * FROM Pracownicy;
SELECT * FROM ZamowieniaKlienci;
SELECT * FROM ZamowieniaDoSklepu;

-- 2. Wszystkie firmy, których nazwa to 'ABCDE'
SELECT * FROM Klienci WHERE nazwa_firmy LIKE '%"ABCDE"%';
SELECT * FROM Dostawcy WHERE nazwa LIKE '%"ABCDE"%';

-- 3. Nazwy wszystkich firm w kolejności alfabetycznej
SELECT DISTINCT nazwa_firmy FROM (
    SELECT nazwa_firmy FROM Klienci
    UNION
    SELECT nazwa FROM Dostawcy
) AS ans
ORDER BY SUBSTRING_INDEX(SUBSTRING_INDEX(ans.nazwa_firmy, '"', -2), '"', 1) ASC;

-- 4. Faktury sprzedaży oraz nazwy firm (dla których wystawiono fakturę), których kwota zapłaty jest wyższa niż 100 zł.
SELECT
    zk.faktura_nr,
    kl.nazwa_firmy,
    SUM(zk.cena_suma) AS suma 
FROM ZamowieniaKlienci zk JOIN Klienci kl ON zk.klient_id = kl.klient_id
GROUP BY zk.faktura_nr, kl.nazwa_firmy
HAVING suma > 100;

-- 5. 10 najdroższych faktur zakupu (w kolejności od najdroższej; wyniki nie mogą się powtarzać) 
SELECT DISTINCT faktura_nr, SUM(cena_suma) AS suma FROM ZamowieniaDoSklepu GROUP BY faktura_nr ORDER BY suma DESC LIMIT 10;

-- 6. 20 kolejnych faktur zakupu po 10 najdroższych (w kolejności od najdroższej; wyniki nie mogą się powtarzać)
SELECT DISTINCT faktura_nr, SUM(cena_suma) AS suma FROM ZamowieniaDoSklepu GROUP BY faktura_nr ORDER BY suma DESC LIMIT 10, 20;