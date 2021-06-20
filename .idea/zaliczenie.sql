-- ==========================
--    SCHEMAT SKRYPTU
-- =========================

-- -------------------------
-- Tworzenie bazy danych
-- Zakomentuj fragment od USE master do USE MojaBaza, 
-- jeśli uruchamiasz skrypt na serwerze wydziałowym MSSQL.
-- -------------------------
USE master
GO

IF DB_ID('helpdesk') IS NULL
CREATE DATABASE helpdesk
GO

USE helpdesk

-- ------------------------------------------------------
-- Usuwanie tabel (w odwrotnej kolejności do tworzenia!)
-- ------------------------------------------------------

IF OBJECT_ID('Komentarze','U') IS NOT NULL
DROP TABLE Komentarze
IF OBJECT_ID('Zgloszenia','U') IS NOT NULL
DROP TABLE Zgloszenia
IF OBJECT_ID('Uzytkownicy','U') IS NOT NULL
DROP TABLE Uzytkownicy
IF OBJECT_ID('Firmy','U') IS NOT NULL
DROP TABLE Firmy
IF OBJECT_ID('Stawki','U') IS NOT NULL
DROP TABLE Stawki
IF OBJECT_ID('Aplikacje','U') IS NOT NULL
DROP TABLE Aplikacje
GO

-- --------------------------------
-- Tworzenie tabel
-- --------------------------------

/* Aplikacje */
IF OBJECT_ID('Aplikacje','U') IS NULL
CREATE TABLE Aplikacje (
ID_Aplikacji int identity(1,1),
Nazwa varchar(100),
Producent varchar(100),
Jezyk varchar(100),
Aktywny varchar(100),
PRIMARY KEY (ID_Aplikacji),
)

/* Stawki */
IF OBJECT_ID('Stawki','U') IS NULL
CREATE TABLE Stawki (
ID_Stawki int identity(1,1),
Krytyczna float,
Wysoka float,
Srednia float,
Niska float,
PRIMARY KEY (ID_Stawki),
)

/* Firmy */
IF OBJECT_ID('Firmy','U') IS NULL
CREATE TABLE Firmy (
ID_Firmy int identity(1,1),
Nazwa varchar(100),
Siedziba varchar(100),
Ulica varchar(100),
Poczta varchar(20),
Wojewodztwo varchar(100),
Kraj varchar(100),
Bank varchar(100),
Konto varchar(50),
NIP varchar(20),
REGON varchar(20),
ID_Stawka int,
Czy_Aktywny smallint,
PRIMARY KEY (ID_Firmy),
FOREIGN KEY (ID_Stawka) REFERENCES Stawki,
)

/* Uzytkownicy */
IF OBJECT_ID('Uzytkownicy','U') IS NULL
CREATE TABLE Uzytkownicy (
ID_Uzytkownika int identity(1,1),
Imie varchar(50),
Nazwisko varchar(50),
Email varchar(60),
Haslo varchar(100),
Telefon varchar(20),
ID_Firmy int,
Uprawnienia smallint,
Data_Utworzenia datetime,
Nazwa_Uzytkownika varchar (20),
Ostatnia_Modyfikacja datetime,
Czy_Aktywny smallint,
PRIMARY KEY (ID_Uzytkownika),
FOREIGN KEY (ID_Firmy) REFERENCES Firmy,
)

/* Zgloszenia */
IF OBJECT_ID('Zgloszenia','U') IS NULL
CREATE TABLE Zgloszenia (
ID_Zgloszenia int identity(1,1),
ID_Klienta int,
ID_Serwisanta int,
ID_Aplikacji int,
Data_Utworzenia datetime,
Data_Zamkniecia datetime,
Wersja_Aplikacji varchar (30),
Status_Zgloszenia smallint,
Tresc varchar(max),
Priorytet smallint,
Przewidywany_Czas time,
Faktyczny_Czas time,
Czy_Aktywne smallint,
PRIMARY KEY (ID_Zgloszenia),
FOREIGN KEY (ID_Klienta) REFERENCES Uzytkownicy,
FOREIGN KEY (ID_Serwisanta) REFERENCES Uzytkownicy,
FOREIGN KEY (ID_Aplikacji) REFERENCES Aplikacje,
)

/* Komentarze */
IF OBJECT_ID('Komentarze','U') IS NULL
CREATE TABLE Komentarze (
ID_Komentarza int identity(1,1),
ID_Uzytkownika int,
ID_Zgloszenia int,
Data_Utworzenia datetime,
Tresc varchar(max),
PRIMARY KEY (ID_Komentarza),
FOREIGN KEY (ID_Uzytkownika) REFERENCES Uzytkownicy,
FOREIGN KEY (ID_Zgloszenia) REFERENCES Zgloszenia,
)
GO
-- ---------------------------------
-- Wstawianie wartości do tabel
-- Uwaga: warto wstawiać do tabel wiersze w partiach np. po 50 wierszy;
--        po wstawieniu każdej partii (po INSERT) wywołać GO, co zwolni pamięć.
-- ---------------------------------


INSERT INTO 
Aplikacje(Nazwa,Producent,Jezyk,Aktywny) 
VALUES 
        ('Banana App','Software Studio','Polski',1),
        ('Twój Sklep','Impicode','Polski',1),
        ('Call Me Maybe','Visual Media','Angielski',1),
        ('Tulip','Go Apps','Polski',1),
        ('Crazy water','Code Agency','Angielski',1),
        ('Eau Folle','IT Media','Fransuski',0),
        ('Agua Loca','Software Studio','Hiszpański',0),
        ('Oprawka Sklep','Craft Apps','Polski',1)
GO

INSERT INTO 
Stawki(Krytyczna,Wysoka,Srednia,Niska) 
VALUES 
        (130.4,125.66,110.66,100.5),
        (135.66,110.33,100.22,92.33),
        (140.31,135.44,114,85.9),
        (125.33,115.22,100.1,95.36),
        (144.51,120.95,109.41,90.22)
GO	

INSERT INTO
Firmy (Nazwa,Siedziba,Ulica,Poczta,Wojewodztwo,Kraj,Bank,Konto,NIP,REGON,ID_Stawka,Czy_Aktywny)
VALUES
        ('Kwiaciarnia Coco Sp. z o. o.','Warszawa','Poznań 25A','00-003','Mazowieckie','Polska','Powszechna Kasa Oszczędmności Bank Polski Spółka Akcyjna','PL40124010249699101918494040','5773058599','109690807',3,1),
        ('Eau Avec Du Sable S. A.','Paryż','Rue Blanche 11','75-009','Ill-deFrance','Francja','Grupa Credit Agricole','PL64194012104273792723511096','2276350249','105698290',5,1),
        ('Infozilla S. C.','Kraków', 'Piękna 23','31-435','Małopolskie','Polska','Bank Pekao S.A.','PL46109011151315797315943843','5768410390','105692502',1,1),
        ('Adventure Sp. z o. o.','Poznań', 'Gen. St. Maczka 18','60-651','Wielkopolskie','Polska','mBank','PL76114010810048068164472344','6338906031','186232602',4,1),
        ('Wolna Wola S. A.','Suwałki','E. Plater 54','16-400','Podlaskie','Polska','Santander Bank Polska SA','PL76101011402425377707354432','5490879484','204412791',2,1),
        ('Travel Spot S. C.','Suwałki','1 Maja 6/4','16-400','Podlaskie','Polska','Bank Handlowy w Warszawie','PL06154000046302125877194652','6864458135',NULL,1,0)
GO

INSERT INTO
Uzytkownicy (Imie,Nazwisko,Email,Haslo,Telefon,ID_Firmy,Uprawnienia,Data_Utworzenia,Nazwa_Uzytkownika,Ostatnia_Modyfikacja,Czy_Aktywny)
VALUES
        ('Bartłomiej','Zalewski','Zalewskibartek@yahoo.com','09a0d15c0c216d3f24f3ab75c1e77dbb','089-85-4398',1,1,'2020-11-27',NULL,NULL,1),
        ('Andrea ','Zalewska','Zalewskaandrea9504@gmail.com','4299ad3d2c3964f6da8cf642926efcd1','289-30-3719',3,0,'2017-01-19','kasjer1','2021-04-05',1),
        ('Konstanty','Sokołowski','solokowskikonstantyn222@wp.pl','a577f04a0d7664e018a05a7ab93d539d','019-34-3272',2,1,'2020-09-03','kwiacarnia01',NULL,1),
        ('Dawid','Wróblewski','wroblewski.dawid@gmail.com','f61331f146fb0cca212d14f119aade64','924-91-0349',1,3,'2018-11-30','wrobelek22',NULL,1),
        ('Adrian','Woźniak','adisss@wp.pl','03b8d056ff570af0e78c238efec28167','221-15-1432',2,0,'2020-01-09','adam1',NULL,1),
        ('Klementyna','Walczak','klemcia55@gmail.com','95c5a3b9b30ca81d52700ba0ff2d4c56','325-36-9787',1,2,'2020-12-08',NULL,'2021-04-26',1),
        ('Mirosław','Kaczmaryk','kaczmyr@onet.pl','96922a6432ae7b9aa96c47995643b7fc','462-96-3998',5,0,'2017-06-09',NULL,NULL,1),
        ('Maurycy','Wanilewski','maurycyw@wp.pl','d17303ad44f58b4e3260ae10a486fa72','201-32-7461',1,0,'2020-12-23',NULL,NULL,1),
        ('Dariusz','Andrzejewski','szalonydarek88@gmail.com','ae97a234b6aace1c95cb1b89e8240d07','049-68-5654',2,0,'2017-11-20','andrzejewski','2020-05-26',1),
        ('Olaf','Jaworski','jawor55@wp.pl','81c03bccb816d0094e6807d892a884eb','778-81-5197',5,0,'2018-02-22','jawor',NULL,1),
        ('Malwina','Kołodziej','kolodziejmaliwna00111@gmail.com','9c25899f81d6e70438d88613c2ca1a59','499-68-5075',1,0,'2020-01-04','malwincia21','2020-08-25',1),
        ('Ewa','Wyoscka','wysocka888@onet.pl','b5c80cc936be423b23da4270cd3ac1f4','592-00-2368',6,0,'2017-08-25',NULL,NULL,0),
        ('Natan ','Kucharski','natankuchar@wp.pl','e1220d5769b903f3dfc6b51c47c2dd51','008-38-5817',2,0,'2021-02-01','natan123',NULL,1),
        ('Daniela','Krupa','danielakrupa88@gmail.pl','0ffca48c77ebff879b8c39234e62a3e4','853-74-4254',1,1,'2021-03-17','krupa85',NULL,1),
        ('Łukasz','Baran','baran99@wp.pl','aee2435a3c7ce38c8c5ca122f03f47d6','908-10-9436',6,0,'2018-06-07',NULL,'2020-04-24',0),
        ('Bartosz','Prusinowski','prusinowksi@gmail.com','865ea67b71d9818c9038b900f1e91877','673-50-1193',2,0,'2021-02-04','prusin',NULL,0),
        ('Mirosława ','Krajwska','krajewska99881@wp.pl','74cad2d265f1dc257666d6b27f4b6f92','136-05-6090',1,0,'2018-05-18',NULL,NULL,1)
GO

INSERT INTO
Zgloszenia(ID_Klienta,ID_Serwisanta,ID_Aplikacji,Data_Utworzenia,Data_Zamkniecia,Wersja_aplikacji,Status_Zgloszenia,Tresc,Priorytet,Przewidywany_Czas,Faktyczny_Czas)
VALUES
        (5,1,1,'2020-11-28','2020-11-28',NULL,2,'Zgłoszenie testowe - szkolenie.',1,NULL,NULL), 
        (2,3,2,'2018-12-28','2018-12-28','14.2.5.6',-1,'Zgłoszenie przykładowe - ze szkolenia.',4,NULL,NULL),
        (7,6,4,'2021-02-01','2021-02-02',NULL,2,'Cześć, nie działa nam skaner, wszystkie kody musimy wprowadzać ręcznie. Proszę o szybką pomoc.',2,NULL,'02:00'),
        (12,1,6,'2019-06-20',NULL,'1212.12.6h',1,'Bonjour, toutes les caisses sont bloquées. Nous ne pouvons pas vendre.',1,NULL,NULL),
        (9,14,4,'2018-05-19',NULL,NULL,0,'Hej, nie działa terminal przy kasie numer trzy, wyskakuje jakiś dziwny błąd, zadzwońcie jak będziecie mieć chwilę. ',4,'01:00',NULL),
        (15,3,2,'2020-01-20','2020-01-20','655.234.234.2',2,'Program do sprzedaży nie znajduje kodów na produkty. Nie możemy zrobić zamówienia na dużą kwotę.',1,'02:30','02:00'),
        (10,14,3,'2019-10-23','2019-10-25','234ad.234.01a',2,'Komputer wyłącza się po włączeniu waszej aplikacji, liczę na szybkie rozwiązanie problemu.',2,'05:00','08:00'),
        (15,1,1,'2019-01-17','2019-01-17','04.45.8',1,'Na dwóch komputerach przeznaczonych do sprzedaży ratalnej wyskoczył niebieski ekran. Klienci się wkurzają, ratunku!',1, NULL, NULL),
        (17,3,5,'2021-05-23','2021-05-23',NULL,2,'Aplikacja na trzecim stanowisku nie chce się włączyć, wyrzuca błąd nr 404. Proszę o kontakt.',3,'03:00','00:30'),
        (6,14,1,'2021-03-21',NULL,NULL,0,'Program wyrzuca błąd podczas wchodzenia w raport sprzedaży.',3,NULL,NULL),
        (4,1,1,'2018-03-19',NULL,NULL,0,'Nie możemy wydrukować raportu dobowego. Pilne.',2,'01:30',NULL),
        (5,14,5,'2020-03-20',NULL,NULL,-1,'Zgłoszenie testowe - szkolenie.',4,NULL,NULL),
        (15,1,4,'2020-07-30',NULL,NULL,1,'Czesc, kasa nr 5 szaleje, produkty wbijają się po dwa razy. Czekam na telefon.',3,'04:00',NULL),
        (11,3,1,'2020-02-18',NULL,NULL,1,'Hej, raport sprzedaży miesięcznej drukuje się jako tygodniowy, a tygodniowy jako miesięczny. Zróbcie z tym coś jak możecie.',3,'02:00',NULL),
        (2,1,3,'2019-06-30','2019-06-30','234.22.12a',-1,'Zgłoszenie testowe - szkolenie.',3,NULL,NULL),
        (9,14,2,'2019-06-25','2019-06-25','a21.1234.a22',-1,'Zgłoszenie testowe - szkolenie.',4,NULL,NULL),
        (8,1,4,'2018-02-22','2018-02-22','1.123.1275.0',-1,'Zgłoszenie testowe - szkolenie.',2,NULL,NULL)
GO

INSERT INTO
Komentarze(ID_Uzytkownika,ID_Zgloszenia,Data_Utworzenia,Tresc)
VALUES
	    (6,3,'2020-11-28' ,'Zgłoszenie zostało rozwiązane.'),
        (1,4,'2019-02-06','Le probl?me lié au droit fiscal. Nous attendons des informations '),
        (14,5,'2018-05-21','Terminal został wysłany do producenta - gwarancja'),
        (9,5,'2018-05-23','Wiadomo co z terminalem?'),
        (14,5,'2018-05-23','Wciąż oczekujemy na informację od producenta'),
        (3,6,'2020-01-20','Wystąpił problem z połączneniem z bazą danych - został on już rozwiązany.'),
        (14,7,'2019-10-25','Wystąpił problem z apliakcją - po reinstalacji problem już nie występuje'),
        (1,8,'2019-01-17','Po odinstalowaniu aplikacji zainstalowanej przez kasjera, problem już nie występuje'),
        (14,10,'2021-03-21','Problem zgłoszono do producenta aplikacji - oczekujemy na informację'),
        (1,11,'2018-03-19','Zgłoszenie rozwiązane - oczekujemy na potwierdzenie po stronie klienta'),
        (1,13,'2020-07-30','Pojawił się problem ze skanerem kodów kreskowych - oczekujemy na informację czy problem został rozwiązany po wymianie baterii'),
        (3,14,'2020-02-19','Problem z apliakcją - zgłoszono do producenta')
GO

-- ---------------------------------
-- Usuwanie i tworzenie widoków
-- ---------------------------------
IF OBJECT_ID('Ranking','V') IS NOT NULL
DROP VIEW Ranking
GO

CREATE VIEW Ranking AS (
	SELECT f.Nazwa, [Ilosc_zgloszen] = COUNT(z.ID_Zgloszenia) FROM Zgloszenia z 
	INNER JOIN Uzytkownicy u ON z.ID_Klienta = u.ID_Uzytkownika
	INNER JOIN Firmy f ON u.ID_Firmy = f.ID_Firmy
	GROUP BY f.Nazwa 
)
GO

----------------
--- Wywołanie---
----------------
SELECT * FROM Ranking
ORDER BY 'Ilosc_zgloszen' DESC

IF OBJECT_ID('Rozwiazane_zgloszenia','V') IS NOT NULL
DROP VIEW Rozwiazane_zgloszenia
GO

CREATE VIEW Rozwiazane_zgloszenia AS (
	SELECT u.Imie, u.Nazwisko, [Ilosc_rozwiazanych_zgloszen]= COUNT(z.ID_Zgloszenia) FROM Zgloszenia z 
	INNER JOIN Uzytkownicy u ON z.ID_Serwisanta = u.ID_Uzytkownika
	WHERE z.Status_Zgloszenia = 2
	GROUP BY u.Imie, u.Nazwisko
)
GO
----------------
--- Wywołanie---
----------------
SELECT * FROM Rozwiazane_zgloszenia
ORDER BY 'Ilosc_rozwiazanych_zgloszen' DESC

IF OBJECT_ID('Status_zgloszen','V') IS NOT NULL
DROP VIEW Status_zgloszen
GO

CREATE VIEW Status_zgloszen AS (
	SELECT 
	[Status_Zgloszenia]=
	(CASE Status_Zgloszenia
		WHEN -1 THEN 'Usunięte'
		WHEN 0 THEN 'Przyjęte'
		WHEN 1 THEN 'Otwarte'
		WHEN 2 THEN 'Rozwiązane'
	END),
	[Ilosc_zgloszen] = COUNT(ID_Zgloszenia) 
	FROM Zgloszenia
	GROUP BY Status_Zgloszenia
)
GO

IF OBJECT_ID('Zgloszenia_firmy','P') IS NOT NULL
DROP PROCEDURE Zgloszenia_firmy
GO

CREATE PROCEDURE Zgloszenia_firmy @firma nvarchar(30)
AS
SELECT z.Data_Utworzenia, z.Data_Zamkniecia, z.Tresc FROM Zgloszenia z
INNER JOIN Uzytkownicy u ON z.ID_Klienta = u.ID_Uzytkownika
INNER JOIN Firmy f ON u.ID_Firmy = f.ID_Firmy
WHERE f.Nazwa = @firma
GO

IF OBJECT_ID('Kiedy_dodane','P') IS NOT NULL
DROP PROCEDURE Kiedy_dodane
GO

CREATE PROCEDURE Kiedy_dodane @data_rozpoczecia DATE, @data_zakonczenia DATE
AS
SELECT u.Imie + ' ' + u.Nazwisko, z.Data_Utworzenia, z.Data_Zamkniecia, z.Tresc FROM Zgloszenia z
INNER JOIN Uzytkownicy u ON z.ID_Klienta = u.ID_Uzytkownika
WHERE z.Data_Utworzenia BETWEEN @data_rozpoczecia AND @data_zakonczenia
GO