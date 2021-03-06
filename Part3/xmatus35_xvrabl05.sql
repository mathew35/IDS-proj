-------- DROP TABLES --------

DROP TABLE terminal CASCADE CONSTRAINT;
DROP TABLE gate CASCADE CONSTRAINT;
DROP TABLE let CASCADE CONSTRAINT;
DROP TABLE vstupenka CASCADE CONSTRAINT;
DROP TABLE typ_lietadla CASCADE CONSTRAINT;
DROP TABLE gate_typ CASCADE CONSTRAINT;
DROP TABLE lietadlo CASCADE CONSTRAINT;
DROP TABLE sedadlo CASCADE CONSTRAINT;
DROP TABLE trieda CASCADE CONSTRAINT;
DROP TABLE turisticka CASCADE CONSTRAINT;
DROP TABLE bussines CASCADE CONSTRAINT;
DROP TABLE prva CASCADE CONSTRAINT;

-------- CREATE TABLES --------

CREATE TABLE terminal(
    letter varchar(1),
    ID_terminal NUMBER(1) PRIMARY KEY
);

CREATE TABLE gate(
    ID_gate NUMBER(2) PRIMARY KEY,
    ID_terminal NUMBER,
    ID_typu_lietadla VARCHAR(20)
);
 CREATE TABLE let(
    ID_let NUMBER(8) PRIMARY KEY,
    cas_odletu VARCHAR(8),
    doba_letu VARCHAR(8),
    ID_gate NUMBER,
    ID_lietadlo NUMBER(10)
);

CREATE TABLE vstupenka(
    ID_let NUMBER NOT NULL,
    ID_sedadlo NUMBER NOT NULL
);

CREATE TABLE typ_lietadla(
    ID_typu_lietadla VARCHAR(20) PRIMARY KEY,
    vyrobca VARCHAR(20),
    pocet_clenov_posadky NUMBER(3),
    ID_gate NUMBER(2)
);

CREATE TABLE gate_typ (
  ID_gate NUMBER NOT NULL, 
  ID_typu_lietadla VARCHAR(20) NOT NULL,
  FOREIGN KEY (ID_gate) REFERENCES gate(ID_gate),
  FOREIGN KEY (ID_typu_lietadla) REFERENCES typ_lietadla(ID_typu_lietadla)
);

CREATE TABLE lietadlo(
    ID_lietadlo NUMBER(10) PRIMARY KEY,
    datum_vyroby DATE,
    datum_revizie DATE,
    ID_typu_lietadla VARCHAR(20)
);

CREATE TABLE sedadlo(
    ID_sedadlo NUMBER(5) PRIMARY KEY,
    cislo_sedadla VARCHAR(15),
    umiestnenie VARCHAR(10),
    ID_lietadlo NUMBER(10),
    ID_trieda NUMBER
);

CREATE TABLE trieda(
    ID_trieda NUMBER GENERATED BY DEFAULT AS IDENTITY PRIMARY KEY,
    priplatok NUMBER(5,2)
);

CREATE TABLE turisticka(
    ID_trieda NUMBER PRIMARY KEY
);

CREATE TABLE bussines(
    ID_trieda NUMBER PRIMARY KEY,
    obcerstvenie VARCHAR(32)
);

CREATE TABLE prva(
    ID_trieda NUMBER PRIMARY KEY,
    obcerstvenie VARCHAR(32),
    filmy VARCHAR(32)
);

-------- KEYS --------

ALTER TABLE vstupenka ADD CONSTRAINT pk_vstupenka PRIMARY KEY (ID_let, ID_sedadlo);
ALTER TABLE gate_typ ADD CONSTRAINT pk_gate_typ PRIMARY KEY (ID_gate);

ALTER TABLE vstupenka ADD CONSTRAINT sedadlo FOREIGN KEY (ID_sedadlo) REFERENCES sedadlo(ID_sedadlo);
ALTER TABLE gate ADD CONSTRAINT fk_terminal FOREIGN KEY (ID_terminal) REFERENCES terminal(ID_terminal);
ALTER TABLE let ADD CONSTRAINT fk_gate FOREIGN KEY (ID_gate) REFERENCES gate(ID_gate);
ALTER TABLE vstupenka ADD CONSTRAINT fk_let FOREIGN KEY (ID_let) REFERENCES let(ID_let);
--ALTER TABLE gate ADD CONSTRAINT fk_typ_gate FOREIGN KEY (ID_typu_lietadla) REFERENCES typ_lietadla(ID_typu_lietadla);
--ALTER TABLE typ_lietadla ADD CONSTRAINT fk_gate_typ FOREIGN KEY (ID_gate) REFERENCES gate(ID_gate);
ALTER TABLE lietadlo ADD CONSTRAINT fk_typ_lietadla FOREIGN KEY (ID_typu_lietadla) REFERENCES typ_lietadla(ID_typu_lietadla);
ALTER TABLE let ADD CONSTRAINT fk_lietadlo FOREIGN KEY (ID_lietadlo) REFERENCES lietadlo(ID_lietadlo);
ALTER TABLE sedadlo ADD CONSTRAINT fk_lietadlo_sedadlo FOREIGN KEY (ID_lietadlo) REFERENCES lietadlo(ID_lietadlo);
ALTER TABLE sedadlo ADD CONSTRAINT fk_trieda FOREIGN KEY (ID_trieda) REFERENCES trieda(ID_trieda);
ALTER TABLE turisticka ADD CONSTRAINT fk_trieda_1 FOREIGN KEY (ID_trieda) REFERENCES trieda(ID_trieda);
ALTER TABLE bussines ADD CONSTRAINT fk_trieda_2 FOREIGN KEY (ID_trieda) REFERENCES trieda(ID_trieda);
ALTER TABLE prva ADD CONSTRAINT fk_trieda_3 FOREIGN KEY (ID_trieda) REFERENCES trieda(ID_trieda);

-------- CHECK CONTROL --------
ALTER TABLE let ADD CONSTRAINT check_id_letu CHECK (cas_odletu IS NOT NULL AND doba_letu IS NOT NULL AND ID_gate IS NOT NULL AND ID_lietadlo IS NOT NULL);
ALTER TABLE gate ADD CONSTRAINT check_id_terminal CHECK (ID_terminal IS NOT NULL);
ALTER TABLE lietadlo ADD CONSTRAINT check_id_typu_lietadla CHECK (ID_typu_lietadla IS NOT NULL AND datum_vyroby IS NOT NULL);
ALTER TABLE sedadlo ADD CONSTRAINT check_sedadlo CHECK (ID_lietadlo IS NOT NULL AND cislo_sedadla IS NOT NULL);
ALTER TABLE terminal ADD CONSTRAINT check_terminal CHECK (letter IS NOT NULL);
ALTER TABLE typ_lietadla ADD CONSTRAINT check_vyrobca CHECK (vyrobca IS NOT NULL AND pocet_clenov_posadky >= 2);

-------- INSERT INTO TABLES --------

INSERT INTO terminal VALUES ('A', '1');
INSERT INTO terminal VALUES ('B', '2');
INSERT INTO terminal VALUES ('C', '3');

INSERT INTO gate VALUES ('01', '1', 'BOEING-749');
INSERT INTO gate VALUES ('02', '3', 'BOEING-747');
INSERT INTO gate VALUES ('03', '2', 'BOEING-747');
INSERT INTO gate VALUES ('04', '1', 'BOEING-748');

INSERT INTO typ_lietadla VALUES ('BOEING-747', 'CHINA', '9', '02');
INSERT INTO typ_lietadla VALUES ('BOEING-748', 'TAIWAN', '7', '04');
INSERT INTO typ_lietadla VALUES ('BOEING-749', 'USA', '12', '01');

INSERT INTO gate_typ VALUES ('01', 'BOEING-749');
INSERT INTO gate_typ VALUES ('02', 'BOEING-747');
INSERT INTO gate_typ VALUES ('03', 'BOEING-747');
INSERT INTO gate_typ VALUES ('04', 'BOEING-748');

INSERT INTO lietadlo VALUES ('2050861329', date '2017-07-30', date '2020-12-23', 'BOEING-749');
INSERT INTO lietadlo VALUES ('5154453146', date '2018-09-23', date '2020-10-03', 'BOEING-749');
INSERT INTO lietadlo VALUES ('8978912316', date '2019-01-13', date '2020-08-14', 'BOEING-748');
INSERT INTO lietadlo VALUES ('9876548521', date '2020-11-02', date '2021-02-11', 'BOEING-747');

INSERT INTO let VALUES ('01654785', '12:40:00', '00:30:00', '01', '2050861329');
INSERT INTO let VALUES ('74685351', '15:20:30', '01:15:05', '04', '8978912316');
INSERT INTO let VALUES ('32165066', '19:05:00', '02:39:00', '02', '9876548521');

INSERT INTO trieda VALUES ('5', '10.50');
INSERT INTO turisticka VALUES ('5');

INSERT INTO trieda VALUES ('17', '45.90');
INSERT INTO bussines VALUES ('17', 'HALUSKY');

INSERT INTO trieda VALUES ('95', '120.99');
INSERT INTO prva VALUES ('95', 'KAVIAR', 'JUMANJI');

INSERT INTO sedadlo VALUES ('12', 'A20', 'OKNO', '9876548521', '5');
INSERT INTO sedadlo VALUES ('32', 'C22', 'ULICKA', '2050861329', '95');
INSERT INTO sedadlo VALUES ('27', 'F14', 'STRED', '8978912316', '17');
INSERT INTO sedadlo VALUES ('04', 'H36', 'STRED', '5154453146', '5');
INSERT INTO sedadlo VALUES ('18', 'K19', 'ULICKA', '9876548521', '17');
INSERT INTO sedadlo VALUES ('39', 'D07', 'OKNO', '8978912316', '95');

INSERT INTO vstupenka VALUES ('01654785', '32');
INSERT INTO vstupenka VALUES ('74685351', '27');
INSERT INTO vstupenka VALUES ('32165066', '18');
INSERT INTO vstupenka VALUES ('74685351', '39');
INSERT INTO vstupenka VALUES ('32165066', '12');

-------- SELECT FROM TABLES --------
-- 2x spojenie 2 tabuliek
-- vypise ID gate-ov k terminalu 1
SELECT G.ID_gate
FROM terminal T, gate G
WHERE G.ID_terminal = T.ID_terminal AND T.ID_terminal = 1;
--vypise id lietadliel a ich vyrobcov 
SELECT L.ID_lietadlo, TL.vyrobca
FROM typ_lietadla TL, lietadlo L
WHERE TL.ID_typu_lietadla = L.ID_typu_lietadla;

-- 1x spojenie 3 tabuliek
--vypise sedadla v triede bussines
SELECT S.cislo_sedadla
FROM sedadlo S, trieda T, bussines B
WHERE S.ID_trieda = T.ID_trieda AND T.ID_trieda = B.ID_trieda AND B.ID_trieda = 17;

-- 2x GROUP BY s agregacnou funkciou
--vypise vsetkych vyrobcov lietadiel v systeme a ich pocetnost
SELECT TL.vyrobca, count(TL.vyrobca)
FROM typ_lietadla TL, lietadlo L
WHERE TL.ID_typu_lietadla = L.ID_typu_lietadla
GROUP BY TL.vyrobca;
--vypise vsetky typy lietadiel v systeme a najvysie ID lietadla z daneho typu
SELECT L.ID_typu_lietadla, max(L.ID_lietadlo)
FROM typ_lietadla TL, lietadlo L
WHERE TL.ID_typu_lietadla = L.ID_typu_lietadla
GROUP BY L.ID_typu_lietadla;

-- 1x EXISTS
-- Vypise ID triedy ktore maju priplatok > 40.00
SELECT T.ID_trieda
FROM trieda T
WHERE EXISTS
(
  SELECT *
  FROM bussines B, prva P, turisticka TR
  WHERE (((T.priplatok > 40.00 AND TR.ID_trieda = T.ID_trieda) OR (T.priplatok > 40.00 AND B.ID_trieda = T.ID_trieda)) OR (T.priplatok > 40.00 AND P.ID_trieda = T.ID_trieda))
);

-- 1x IN s vnorenym selectom
-- Vypise ID lietadiel, ktore boli vyrobene v USA
SELECT L.ID_lietadlo
FROM lietadlo L
WHERE L.ID_typu_lietadla
IN
(
  SELECT TL.ID_typu_lietadla
  FROM typ_lietadla TL
  WHERE TL.vyrobca = 'USA'
);