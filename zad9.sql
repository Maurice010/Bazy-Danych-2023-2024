USE DB23_KOZAK;

-- Baza danych ukladow gwiezdnych i planet
CREATE TABLE UkladyGwiezdne (
    uklad_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    nazwa VARCHAR(255),
    liczba_planet INT UNSIGNED DEFAULT 0,
    liczba_gwiazd INT UNSIGNED DEFAULT 1,
    PRIMARY KEY (uklad_id)
);

CREATE TABLE Gwiazdy (
    gwiazda_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    uklad_id INT UNSIGNED,
    nazwa VARCHAR(255),
    typ VARCHAR(255),
    PRIMARY KEY (gwiazda_id),
    FOREIGN KEY (uklad_id) REFERENCES UkladyGwiezdne(uklad_id)
);

CREATE TABLE CialaNiebieskie (
    cialo_id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    uklad_id INT UNSIGNED,
    nazwa VARCHAR(255),
    data_dodania TIMESTAMP,
    typ VARCHAR(255),
    PRIMARY KEY (cialo_id),
    FOREIGN KEY (uklad_id) REFERENCES UkladyGwiezdne(uklad_id)
);

-- 1) po dodaniu nowego układu gwiezdnego dodawana jest jedna gwiazda w tym układzie
DELIMITER //
CREATE TRIGGER dodanie_ukladu
AFTER INSERT ON UkladyGwiezdne
FOR EACH ROW
BEGIN
    INSERT INTO Gwiazdy(uklad_id, nazwa) VALUES (NEW.uklad_id, 'TempName');
END //
DELIMITER ;

-- 2) przy dodawaniu planet należy wstawić datę umieszczenia rekordu w bazie jako obecna chwila czasu
DELIMITER //
CREATE TRIGGER data_cialaniebieskie
BEFORE INSERT ON CialaNiebieskie
FOR EACH ROW
BEGIN
    SET NEW.data_dodania = NOW();
END //
DELIMITER ;

-- DODATKOWE
DELIMITER //
CREATE TRIGGER add_liczba_cial
AFTER INSERT ON CialaNiebieskie
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM UkladyGwiezdne WHERE uklad_id = NEW.uklad_id) AND LOWER(NEW.typ) = 'planeta' THEN
        UPDATE UkladyGwiezdne
        SET liczba_planet = liczba_planet + 1
        WHERE uklad_id = NEW.uklad_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER add_liczba_gwiazd
AFTER INSERT ON Gwiazdy
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM UkladyGwiezdne WHERE uklad_id = NEW.uklad_id) AND NEW.nazwa != 'TempName' THEN
        UPDATE UkladyGwiezdne
        SET liczba_gwiazd = liczba_gwiazd + 1
        WHERE uklad_id = NEW.uklad_id;
    END IF;
END //
DELIMITER ;

-- 3) dowolny wyzwalacz działający z innym poleceniem niż insert
DELIMITER //
CREATE TRIGGER del_liczba_planet
AFTER DELETE ON CialaNiebieskie
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM UkladyGwiezdne WHERE uklad_id = OLD.uklad_id) AND LOWER(OLD.typ) = 'planeta' THEN
        UPDATE UkladyGwiezdne
        SET liczba_planet = liczba_planet - 1
        WHERE uklad_id = OLD.uklad_id;
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE TRIGGER del_liczba_gwiazd
AFTER DELETE ON Gwiazdy
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM UkladyGwiezdne WHERE uklad_id = OLD.uklad_id) THEN
        UPDATE UkladyGwiezdne
        SET liczba_gwiazd = liczba_gwiazd - 1
        WHERE uklad_id = OLD.uklad_id;
    END IF;
END //
DELIMITER ;