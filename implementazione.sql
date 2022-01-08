--DEFINIZIONE DEI DOMINII
--Dominio per il formato della traccia
CREATE DOMAIN Type_Formato as varchar(4)
CHECK (value = 'MP3' or value = 'WAV' or value = 'FLAC');

--Dominio per la qualità della traccia
CREATE DOMAIN Type_Qualita as integer 
CHECK (value = 128 or value = 256 or value = 512);

--Dominio per l'email dell'utente
CREATE DOMAIN Type_Email as varchar(100) 
CHECK (value LIKE '_%@_%._%');

--Dominio per il sesso dell'utente
CREATE DOMAIN Type_Sesso as varchar(15)
CHECK (value = 'Uomo' or value = 'Donna' or value = 'Altro' or value = 'Transgender'or value = 'Lampadina' or value = 'Unicorno');

--Dominio per la fascia oraria dell'ascolto
CREATE DOMAIN Type_Fascia as integer
CHECK (value >= 1 and value <= 6);

--Dominio per il voto dato dall'utente
CREATE DOMAIN Type_Voto integer
CHECK (value >= 0 and value <= 10);

--DEFINIZIONE DELLE TABELLE
--ALBUM
CREATE TABLE ALBUM (
	CodA SERIAL,
	Titolo VARCHAR(50) NOT NULL,
	AnnoU INTEGER NOT NULL,
	Durata TIME DEFAULT '00:00:00',
	Ntracce INTEGER DEFAULT 0,
	Etichetta VARCHAR(20) DEFAULT NULL,
	Voto NUMERIC(2,2) DEFAULT 0,
	
	PRIMARY KEY (CodA)
);

--TRACCIA
CREATE TABLE TRACCIA (
	CodT SERIAL,
	Titolo VARCHAR(50) NOT NULL,
	Durata TIME NOT NULL,
	Etichetta VARCHAR(20) DEFAULT NULL,
	AnnoU INTEGER,
	IsCover BOOLEAN DEFAULT FALSE,
	IsRemastered BOOLEAN DEFAULT FALSE,
	Genere VARCHAR(30) NOT NULL,
	Link VARCHAR(300),
	Formato Type_Formato DEFAULT 'MP3',
	Voto NUMERIC(2,2) DEFAULT 0,
	Qualita Type_Qualita DEFAULT 128,
	CodA INTEGER DEFAULT 0,
	CodTR INTEGER DEFAULT 0,
	CodTC INTEGER DEFAULT 0,
	
	UNIQUE(Titolo, AnnoU, CodA,Formato),
	PRIMARY KEY (CodT),
	FOREIGN KEY (CodA) REFERENCES Album(CodA)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CodTR) REFERENCES Traccia(CodT)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CodTC) REFERENCES Traccia(CodT)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--UTENTE
CREATE TABLE UTENTE (
	NickName VARCHAR(20),
	Nome VARCHAR(30) NOT NULL,
	Cognome VARCHAR(30) NOT NULL,
	Email Type_Email NOT NULL,
	Password VARCHAR(20) NOT NULL,
	DataN DATE NOT NULL,
	Sesso Type_Sesso NOT NULL,
	Nazionalita VARCHAR(15) DEFAULT NULL,
	Descrizione VARCHAR(100) DEFAULT NULL,
	IsPremium BOOLEAN DEFAULT FALSE,
	IsAdmin BOOLEAN DEFAULT FALSE,

	PRIMARY KEY (NickName),
	
	UNIQUE(Email)
);

--PLAYLIST
CREATE TABLE PLAYLIST(
	CodP SERIAL,
	Titolo VARCHAR(20) NOT NULL,
	Durata TIME DEFAULT '00:00:00',
	NTracce INTEGER DEFAULT 0,
	Visibilita BOOLEAN DEFAULT TRUE,
	NickName VARCHAR(20),
	
	PRIMARY KEY (CodP),
	FOREIGN KEY (NickName) REFERENCES UTENTE(NickName)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--ASCOLTA
CREATE TABLE ASCOLTA (
	Nickname VARCHAR(20),
	CodT INTEGER,
	FasciaOraria Type_Fascia NOT NULL,
	
	FOREIGN KEY (NickName) REFERENCES UTENTE(NickName)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CodT) REFERENCES TRACCIA(CodT)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--VOTA
CREATE TABLE VOTA (
	NickName VARCHAR(20),
	CodT INTEGER,
	Voto Type_Voto NOT NULL,
	
	UNIQUE(NickName, CodT),
	
	FOREIGN KEY (NickName) REFERENCES UTENTE(NickName)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CodT) REFERENCES TRACCIA(CodT)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--CONTIENE
CREATE TABLE CONTIENE (
	CodP INTEGER,
	CodT INTEGER,
	
	UNIQUE(CodP, CodT),
	
	FOREIGN KEY (CodT) REFERENCES TRACCIA(CodT)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CodP) REFERENCES PLAYLIST(CodP)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--ARTISTA
CREATE TABLE ARTISTA (
	NomeArte VARCHAR(30),
	Descrizione VARCHAR(300) DEFAULT NULL,
	Voto NUMERIC(2,2) DEFAULT 0,

	PRIMARY KEY(NomeArte)
);

--INCIDE
CREATE TABLE INCIDE (
	NomeArte VARCHAR(30),
	CodA INTEGER,
	
	UNIQUE(NomeArte, CodA),
	FOREIGN KEY (NomeArte) REFERENCES ARTISTA(NomeArte)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CodA) REFERENCES ALBUM(CodA)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

--PRODUCE
CREATE TABLE PRODUCE (
	NomeArte VARCHAR(30),
	CodT INTEGER,
	
	UNIQUE(NomeArte, CodT),
	FOREIGN KEY (NomeArte) REFERENCES ARTISTA(NomeArte)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (CodT) REFERENCES TRACCIA(CodT)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);


--PROCEDURE E TRIGGER PER LE AUTOMAZIONI
--PROCEDURA 1: All'aggiunta di un voto viene fatta la media in Traccia
CREATE OR REPLACE FUNCTION Edit_Voto_Traccia_INS() RETURNS TRIGGER AS $Voto_Traccia_INS$
BEGIN
	UPDATE TRACCIA
	SET VOTO=(SELECT AVG(V.Voto)
		  FROM VOTA AS V
		  WHERE V.CodT=NEW.CodT 
		  )
	WHERE CodT=NEW.CodT;
	RETURN Null;
END; $Voto_Traccia_INS$ LANGUAGE PLPGSQL;

--TRIGGER 1: aggiorna la media di una Traccia all'inserimento di un voto
CREATE OR REPLACE TRIGGER Voto_Traccia_INS
AFTER INSERT ON VOTA
FOR EACH ROW
EXECUTE PROCEDURE Edit_Voto_Traccia_INS();


-- TRIGGER 1.2: aggiorna il voto di una traccia dopo la modifica di un voto
CREATE OR REPLACE TRIGGER Voto_Traccia_UPD
AFTER UPDATE OF Voto on VOTA
FOR EACH ROW
EXECUTE PROCEDURE Edit_Voto_Traccia_INS();

--PROCEDURA 2: Dopo l'eliminazione di un voto viene aggiornata la media in Traccia
CREATE OR REPLACE FUNCTION Edit_Voto_Traccia_DEL() RETURNS TRIGGER AS $Voto_Traccia_DEL$
BEGIN
	UPDATE TRACCIA
	SET VOTO=(SELECT AVG(V.Voto)
		  FROM VOTA AS V
		  WHERE V.CodT=OLD.CodT 
		  )
	WHERE CodT=OLD.CodT;
	RETURN Null;
END; $Voto_Traccia_DEL$ LANGUAGE PLPGSQL;

--TRIGGER 2: aggiorna la media di una Traccia all'eliminazione di un voto
CREATE OR REPLACE TRIGGER Voto_Traccia_DEL
AFTER DELETE ON VOTA
FOR EACH ROW
EXECUTE PROCEDURE Edit_Voto_Traccia_DEL();

--PROCEDURA 3: Dopo aver aggiornato il voto di una traccia bisogna aggiornare i voti dell'album a cui appartiene
CREATE OR REPLACE FUNCTION Edit_Voto_Album_UPD() RETURNS TRIGGER AS $Voto_Album_UPD$
BEGIN
	UPDATE ALBUM
	SET Voto=(SELECT AVG(T.Voto)
		  FROM TRACCIA as T
		  WHERE T.codA=NEW.codA and T.Voto > 0
		  )
	WHERE CodA=NEW.CodA;
	RETURN Null;
END; $Voto_Album_UPD$ LANGUAGE PLPGSQL;

--TRIGGER 3: modifica il Voto del Album,a fronte della modifica del voto della traccia
CREATE OR REPLACE TRIGGER Voto_Album_UPD
AFTER UPDATE OF Voto ON TRACCIA
FOR EACH ROW
EXECUTE PROCEDURE Edit_Voto_Album_UPD();

-- PROCEDURA 4: Dopo l'eliminazione di una traccia bisogna modificare il numero di tracce, la durata e la media dei voti dell'album a cui apparteneva
CREATE OR REPLACE FUNCTION Ntracce_Durata_Voto_Album_DEL() RETURNS TRIGGER AS $TRIGGER_Ntracce_Durata_Voto_Album_DEL$
BEGIN
	UPDATE ALBUM
	SET Ntracce=Ntracce-1,
	    Durata=(SELECT SUM(Durata)
			     FROM TRACCIA AS T
			     WHERE T.CodA = OLD.CodA),
	    Voto=(SELECT AVG(T.Voto)
		  FROM  TRACCIA AS T
		  WHERE T.CodA=OLD.CodA and T.Voto > 0)
	WHERE CodA=OLD.CodA;
	RETURN NULL;
END;$TRIGGER_Ntracce_Durata_Voto_Album_DEL$ LANGUAGE PLPGSQL;

--TRIGGER 4: modifica il numero delle tracce, il tempo e il voto dell'album a cui apparteneva una traccia eliminata
CREATE OR REPLACE TRIGGER TRIGGER_Ntracce_Durata_Voto_Album_DEL
AFTER DELETE ON Traccia
FOR EACH ROW
EXECUTE PROCEDURE Ntracce_Durata_Voto_Album_DEL();

--PROCEDURA 5: quando viene aggiunta una traccia bisogna aggiornare il numero di tracce e la durata dell'album a cui appartiene 
CREATE OR REPLACE FUNCTION Ntracce_Durata_Album_INS() RETURNS TRIGGER AS $TRIGGER_Ntracce_Durata_Album_INS$
BEGIN
	UPDATE ALBUM
	SET Ntracce=Ntracce + 1,
	    Durata=(SELECT sum(Durata)
			     FROM TRACCIA AS T
			     WHERE T.CodA=NEW.CodA)
	WHERE CodA=NEW.CodA;
	RETURN NULL;
END;$TRIGGER_Ntracce_Durata_Album_INS$ LANGUAGE PLPGSQL;

--TRIGGER 5: modifica numero tracce e durata all'aggiunta di una traccia
CREATE OR REPLACE TRIGGER TRIGGER_Ntracce_Durata_Album_INS
AFTER INSERT ON TRACCIA
FOR EACH ROW
EXECUTE PROCEDURE Ntracce_Durata_Album_INS();

--PROCEDURA 6: Dopo aver aggiornato il voto di una traccia bisogna aggiornare il voto degli artisti che l'hanno prodotta
CREATE OR REPLACE FUNCTION Voto_Artista_UPD() RETURNS TRIGGER AS $TRIGGER_Voto_Artista_UPD$
DECLARE 
	CursorArtistaVoto CURSOR for 
	select NomeArte, avg(voto) AS votoMedio
	from Traccia as T, Produce as P
	where T.Codt = p.CodT and voto > 0
	group by Nomearte; 
	
	ArtistaVoto record;
	
BEGIN 
	open CursorArtistaVoto; 
	loop 
		fetch CursorArtistaVoto into ArtistaVoto;
		exit when not found;
		
		update Artista
		set Voto = ArtistaVoto.votoMedio
		where NomeArte = ArtistaVoto.NomeArte;
		
	end loop;
	
	close CursorArtistaVoto;
	
	return null;
END;$TRIGGER_Voto_Artista_UPD$ LANGUAGE PLPGSQL;

--TRIGGER 6: modifica il Voto del Artista,a fronte della modifica del voto della traccia
CREATE OR REPLACE TRIGGER TRIGGER_Voto_Artista_UPD
AFTER UPDATE OF Voto ON TRACCIA
FOR EACH ROW
EXECUTE PROCEDURE Voto_Artista_UPD();

--PROCEDURA 7: Dopo aver eliminato il voto di una traccia bisogna aggiornare il voto degli artisti che l'hanno prodotta
CREATE OR REPLACE FUNCTION Voto_Artista_DEL() RETURNS TRIGGER AS $TRIGGER_Voto_Artista_DEL$
DECLARE 
	CursorArtistaVoto CURSOR for 
	select NomeArte, avg(voto) AS votoMedio
	from Traccia as T, Produce as P
	where T.Codt = p.CodT and voto > 0
	group by Nomearte; 
	
	CursorArtistaNoProduce CURSOR for 
	select Artista.NomeArte
	from Artista
	where Artista.NomeArte not in (Select NomeArte From Produce);
	
	ArtistaNoProduce record;
	ArtistaVoto record;
	
BEGIN 
	open CursorArtistaVoto; 
	loop 
		fetch CursorArtistaVoto into ArtistaVoto;
		exit when not found;
		
		update Artista
		set Voto = ArtistaVoto.votoMedio
		where NomeArte = ArtistaVoto.NomeArte;
		
	end loop;
	close CursorArtistaVoto;
	
	open CursorArtistaNoProduce;
	loop
		fetch CursorArtistaNoProduce into ArtistaNoProduce;
		exit when not found;
		
		update Artista
		set Voto = 0
		where NomeArte = ArtistaNoProduce.NomeArte;
	end loop;
	close CursorArtistaNoProduce;
	
	return null;
END;$TRIGGER_Voto_Artista_DEL$ LANGUAGE PLPGSQL;

--TRIGGER 7: modifica il Voto del Artista,a fronte della eliminazione di una traccia
CREATE OR REPLACE TRIGGER Trigger_Voto_Artista_DEL
AFTER DELETE ON Produce
FOR EACH ROW
EXECUTE PROCEDURE Voto_Artista_DEL();

--PROCEDURA 8: Creazione della playlist brani preferiti quando viene aggiunto un nuovo utente
CREATE OR REPLACE FUNCTION Playlist_Default() RETURNS TRIGGER AS $Def_Playlist$
BEGIN 
	insert into Playlist(Titolo, NickName)
	values('Brani preferiti', New.NickName);
	RETURN NULL;
END; $Def_Playlist$ LANGUAGE PLPGSQL;

--TRIGGER 8: creazione playlist default
CREATE OR REPLACE TRIGGER Def_Playlist
AFTER INSERT ON UTENTE
FOR EACH ROW
EXECUTE PROCEDURE Playlist_Default();

--PROCEDURA 9: aggiornamento del numero delle tracce e della durata di una playlist quando gli viene aggiunta una traccia
CREATE OR REPLACE FUNCTION Ntracce_durata_Playlist_INS() RETURNS TRIGGER AS $TRIGGER_Ntracce_durata_Playlist_INS$
BEGIN
	UPDATE Playlist
	SET NTracce=NTracce+1,
	    Durata=(SELECT SUM(Durata)
			     FROM TRACCIA AS T, Contiene As C
			     WHERE T.Codt=C.CodT and C.CodP = NEW.CodP)
	    
	WHERE CodP=NEW.CodP; 
	RETURN NULL;
END;$TRIGGER_Ntracce_durata_Playlist_INS$ LANGUAGE PLPGSQL;

--TRIGGER 9: aggiunta di una Traccia in una Playlist
CREATE OR REPLACE TRIGGER TRIGGER_Ntracce_durata_Playlist_INS
AFTER INSERT ON CONTIENE
FOR EACH ROW
EXECUTE PROCEDURE Ntracce_durata_Playlist_INS();

--PROCEDURA 10: aggiornamento numero tracce e durata alla eliminazione di una traccia che è contenuta in playlist
CREATE OR REPLACE FUNCTION Ntracce_durata_Playlist_DEL() RETURNS TRIGGER AS $TRIGGER_Ntracce_durata_Playlist_DEL$
BEGIN
	UPDATE Playlist
	SET NTracce=NTracce-1,
	    Durata=(SELECT SUM(durata)
			     FROM CONTIENE AS C, Traccia as T
			     WHERE C.CodP=OLD.CodP and C.CodT = T.CodT)
	    
	WHERE CodP=OLD.CodP;
	RETURN NULL; 
END;$TRIGGER_Ntracce_durata_Playlist_DEL$ LANGUAGE PLPGSQL;

--TRIGGER 10: aggiornamento numero tracce e durata di una playlist dopo che è stata eliminata una traccia che conteneva
CREATE OR REPLACE TRIGGER TRIGGER_Ntracce_durata_Playlist_DEL
AFTER DELETE ON CONTIENE
FOR EACH ROW
EXECUTE PROCEDURE Ntracce_durata_Playlist_DEL();

--PROCEDURA 11: quando viene eliminato un'artista vengono eliminate le tracce che ha prodotto
CREATE OR REPLACE FUNCTION DEL_Artista_Pro() RETURNS TRIGGER AS $TRIGGER_DEL_Artista_Pro$
DECLARE 
	CursorTracceNoArt CURSOR for
	select CodT 
	from Traccia
	where CodT not in (Select Codt from Produce) and codT <> 0;
	
	TracceNoArt record;
BEGIN
	open CursorTracceNoArt;
	loop
		fetch CursorTracceNoArt into TracceNoArt;
		exit when not found;
		
		delete from traccia where CodT = TracceNoArt.CodT;
	end loop;
	close CursorTracceNoArt;
	
	RETURN NULL; 
END;$TRIGGER_DEL_Artista_Pro$ LANGUAGE PLPGSQL;

--TRIGGER 11: eliminazione delle tracce quando un'artista viene eliminato
CREATE OR REPLACE TRIGGER TRIGGER_DEL_Artista_PRO
AFTER DELETE ON Produce
FOR EACH ROW
EXECUTE PROCEDURE DEL_Artista_PRO();

--PROCEDURA 12: quando viene eliminato un'artista vengono eliminati gli album che ha inciso
CREATE OR REPLACE FUNCTION DEL_Artista_INC() RETURNS TRIGGER AS $TRIGGER_DEL_Artista_INC$
DECLARE 
	CursorAlbumNoArt CURSOR for
	select CodA 
	from Album
	where CodA not in (Select CodA from Incide) and codA <> 0;
	
	AlbumNoArt record;
BEGIN
	open CursorAlbumNoArt;
	loop
		fetch CursorAlbumNoArt into AlbumNoArt;
		exit when not found;
		
		delete from Album where CodA = AlbumNoArt.CodA;
	end loop;
	close CursorAlbumNoArt;
	
	RETURN NULL; 
END;$TRIGGER_DEL_Artista_INC$ LANGUAGE PLPGSQL;

--TRIGGER 12: eliminazione degli album incisi da un artista eliminato
CREATE OR REPLACE TRIGGER TRIGGER_DEL_Artista_INC
AFTER DELETE ON Incide
FOR EACH ROW
EXECUTE PROCEDURE DEL_Artista_INC();

--IMPLEMENTAZIONE VINCOLI PIU' COMPLESSI
--primo vincolo: un utente non premium non può ascoltare tracce di qualità maggiore al 128
--CODICE ERRORE: QLNPR (qualita non premium)
Create or replace Function UtentePremium() returns Trigger as $AscoltiNoPremium$
DECLARE
	Qualita1 Traccia.Qualita%TYPE;
	IsPremium1 Utente.IsPremium%TYPE;
BEGIN
	Select Qualita into Qualita1
	From Traccia
	Where New.CodT = Traccia.CodT;
	
	Select IsPremium into IsPremium1
	From Utente
	Where New.NickName = Utente.NickName;
	
	if(Qualita1 > 128 and not IsPremium1) then
		raise exception using errcode = 'QLNPR';
	end if;
	Return null;

EXCEPTION 
	when SQLSTATE 'QLNPR'then
		raise notice 'ERRORE: qualita della traccia non supportata dal tipo di account';
		Delete From Ascolta Where (Ascolta.CodT = new.CodT and Ascolta.NickName = NEW.NickName);
		RETURN NULL;
END;$AscoltiNoPremium$ Language plpgsql;

--Trigger per il primo vincolo
Create or replace Trigger AscoltiNoPremium 
After Insert on Ascolta
FOR EACH ROW
Execute procedure UtentePremium();

--secondo vincolo: i voti devono essere di utenti premium
--CODICE ERROE: VTNPR (voto no premium)
Create or replace Function VotoUtentePremium() returns Trigger as $VotiNoPremium$
DECLARE
	IsPremium1 Utente.IsPremium%TYPE;
BEGIN
	Select IsPremium into IsPremium1
	From Utente
	Where New.NickName = Utente.NickName;
	
	if(not IsPremium1) then
		raise exception using errcode = 'VTNPR';
	end if;
	Return null;
EXCEPTION 
	when SQLSTATE 'VTNPR'then
		raise notice 'ERRORE: voto dato da un account non premium';
		Delete From Vota Where (Vota.CodT = new.CodT and Vota.NickName = NEW.NickName);
		RETURN NULL;
END;$VotiNoPremium$ Language plpgsql;

--Trigger per il secondo vincolo
Create or replace Trigger VotiNoPremium 
After Insert on Vota
FOR EACH ROW
Execute procedure VotoUtentePremium();

--Terzo vincolo: se una traccia è cover allora deve avere artista diverso dall'originale
--CODICE ERROE: ARTOU (artista originale uguale)
Create or replace Function TracciaCover() returns Trigger as $TracciaCoverTrigger$
DECLARE
	TracciaOr Traccia.CodTC%Type;
	Cover Traccia.IsCover%Type;
	Cursor_ArtistiO refcursor;
	ArtistiO record;
BEGIN
	SELECT Traccia.IsCover into Cover
	FROM Traccia
	where Traccia.CodT = new.Codt;
	
	if(Cover) then
		SELECT Traccia.CodTC into TracciaOr
		FROM Produce, Traccia
		Where Produce.CodT = New.CodT and Traccia.CodT = New.CodT;

		open Cursor_ArtistiO for 
		SELECT Artista.NomeArte 
		FROM Artista
		Where Artista.NomeArte in (Select NomeArte from Produce where codt = TracciaOr);

		loop
			fetch Cursor_ArtistiO into ArtistiO;
			exit when not found;

			if(ArtistiO.NomeArte = New.NomeArte) then
				raise exception using errcode = 'ARTOU';
			end if;
		end loop;

		close Cursor_ArtistiO;
	end if;
	Return null;
	
EXCEPTION 
	when SQLSTATE 'ARTOU'then
		raise notice 'ERRORE: artista originale uguale';
		delete from Traccia where (CodT = New.CodT);
		RETURN NULL;
END;$TracciaCoverTrigger$ Language plpgsql;

--Trigger per il terzo vincolo
Create or replace Trigger TracciaCoverTrigger 
After Insert on Produce
FOR EACH ROW
Execute procedure TracciaCover();

--Quarto vincolo: il formato della remastered deve essere maggiore di quella originale e l'anno deve essere maggiore dell'originale
--CODICE ERRORE: FATRE (Formato anno remastered)
Create or replace Function FormatoAnnoRemastered() returns Trigger as $FormatoAnnoRemasteredTrigger$
DECLARE
	FormatoO Traccia.Formato%Type;
	AnnoO Traccia.AnnoU%Type;
BEGIN
	if(New.IsRemastered) then
		SELECT Traccia.Formato into FormatoO
		FROM Traccia
		Where Traccia.CodT = New.CodTR;

		SELECT Traccia.AnnoU into AnnoO
		FROM Traccia
		Where Traccia.CodT = New.CodTR;

		if(FormatoO = 'MP3' and new.Formato = 'MP3')then
			raise exception using errcode = 'FATRE';
		elseif(FormatoO = 'WAV' and (new.Formato = 'WAV' or new.Formato = 'MP3')) then
			raise exception using errcode = 'FATRE';
		elseif (FormatoO = 'FLAC' and new.Formato <> 'FLAC') then
			raise exception using errcode = 'FATRE';
		end if;

		if(New.AnnoU <= AnnoO) then
			raise exception using errcode = 'FATRE';
		end if;
	end if;
	Return null;
EXCEPTION 
	when SQLSTATE 'FATRE'then
		raise notice 'ERRORE: formato o anno non consistenti';
		delete from Traccia where (CodT = New.CodT);
		RETURN NULL;
END; $FormatoAnnoRemasteredTrigger$ Language plpgsql;

--Trigger per il quarto vincolo
Create or replace Trigger FormatoAnnoRemasteredTrigger 
After Insert on Traccia
FOR EACH ROW
Execute procedure FormatoAnnoRemastered();

--Quinto vincolo: L'anno della cover deve essere maggiore uguale dell'originale e l'album di apparteneza deve essere diverso
--CODICE ERRORE: AANCO (anno cover minore dell'originale)
Create or replace Function AlbumAnnoCover() returns Trigger as $AlbumAnnoCoverTrigger$
DECLARE
	CodAO Traccia.CodA%Type;
	AnnoO Traccia.AnnoU%Type;
	
BEGIN
	if(New.IsCover) then
		SELECT Traccia.CodA into CodAO
		FROM Traccia
		Where Traccia.CodT = New.CodTC;

		SELECT Traccia.AnnoU into AnnoO
		FROM Traccia
		Where Traccia.CodT = New.CodTC;

		if(CodAO = new.CodA or new.AnnoU < AnnoO) then
			raise exception using errcode = 'AANCO';
		end if;
	end if;
	Return null;
	
EXCEPTION 
	when SQLSTATE 'AANCO'then
		raise notice 'ERRORE: Album uguale all originale o anno minore';
		delete from Traccia where (CodT = New.CodT);
		RETURN NULL;
END; $AlbumAnnoCoverTrigger$ Language plpgsql;

--Trigger per il quinto vincolo
Create or replace Trigger AlbumAnnoCoverTrigger 
After Insert on Traccia
FOR EACH ROW
Execute procedure AlbumAnnoCover();

--POPOLAMENTO
--ARTISTI
INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('ColdPlay','Si divertono a creare generi, non aiutandoci a fare questo progetto...',DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Silvio Barra','Se vi interessa sapere di piu ce un sito di cui non ricordo il nome,cercate li',DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('USA for Africa','stanno carichi niente da dire',DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Imagine Dragons','La leggenda narra che un giorno un prescelto sara in grado di determinare il loro genere, ma non oggi',DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Boney M.',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Squallor',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Daft Punk',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Molchat Doma','Neanche loro sanno che ci fanno qui',DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Paul Kalkbrenner','F',DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Yasuha',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('1-800 GIRLS',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Lo straqen',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Randy Newman',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Camille',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('OEL',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Cristina Davena',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Giorgio Vanni',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Maneskin','E senno chi le fa le cover...',DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Odeon Boys',DEFAULT,DEFAULT);

INSERT INTO ARTISTA(NomeArte,Descrizione,Voto)
VALUES ('Artisti Vari','Non mi pagano abbastanza per continuare',DEFAULT);

--ALBUM
INSERT INTO ALBUM (CodA, Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES(0,'Fittizio',2008,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Viva la vida or Death and all his friends',2008,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('We Are The World',1985,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Best of',2022,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Curnutone',1981,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Discovery',2001,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Этажи',2018,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Berling Calling',2013,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Disney&Pixar',2018,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Italia 1',2020,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

INSERT INTO ALBUM (Titolo,AnnoU,Durata,Ntracce,Etichetta,Voto)
VALUES('Fantasy',2023,DEFAULT,DEFAULT,DEFAULT,DEFAULT);

--TRACCE
INSERT INTO TRACCIA(CodT,Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES(0, 'Fittizio','00:02:29',DEFAULT,2008,FALSE,FALSE,'Arte',default,'MP3',DEFAULT,128,0);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Life in Technicolors','00:02:29',DEFAULT,2008,FALSE,FALSE,'Arte','https://open.spotify.com/track/7MT5mNCNNCoW6XP265UkdS?si=0250a49e39c7482a','MP3',DEFAULT,128,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Life in Technicolors','00:02:29',DEFAULT,2008,FALSE,FALSE,'Arte','https://open.spotify.com/track/7MT5mNCNNCoW6XP265UkdS?si=0250a49e39c7482a','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Life in Technicolors','00:02:29',DEFAULT,2009,FALSE,TRUE,'Arte','https://open.spotify.com/track/7MT5mNCNNCoW6XP265UkdS?si=0250a49e39c7482a','FLAC',DEFAULT,512,1,1);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Cemeteries of London','00:03:21',DEFAULT,2008,FALSE,FALSE,'Sbang','https://open.spotify.com/track/7vIY0IXV5FDefLv3RZUq7Q?si=cf766f8b367042e2','MP3',DEFAULT,128,1);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Cemeteries of London','00:03:21',DEFAULT,2008,FALSE,FALSE,'Sbang','https://open.spotify.com/track/7vIY0IXV5FDefLv3RZUq7Q?si=cf766f8b367042e2','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Cemeteries of London','00:03:21',DEFAULT,2010,FALSE,TRUE,'Sbang','https://open.spotify.com/track/7vIY0IXV5FDefLv3RZUq7Q?si=cf766f8b367042e2','FLAC',DEFAULT,512,1,4);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Lost!','00:03:56',DEFAULT,2008,FALSE,FALSE,'Gang','https://open.spotify.com/track/1PdWRsAEovbR8JlpjqqRxm?si=8caf2d8b359d46d8','MP3',DEFAULT,128,1);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Lost!','00:03:56',DEFAULT,2008,FALSE,FALSE,'Gang','https://open.spotify.com/track/1PdWRsAEovbR8JlpjqqRxm?si=8caf2d8b359d46d8','WAV',DEFAULT,256,1);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Lost!','00:03:56',DEFAULT,2009,FALSE,TRUE,'Gang','https://open.spotify.com/track/1PdWRsAEovbR8JlpjqqRxm?si=8caf2d8b359d46d8','FLAC',DEFAULT,512,1,7);



INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('42','00:03:56',DEFAULT,2008,FALSE,FALSE,'Punk','https://open.spotify.com/track/3IL3zHHAFzqu9JkGzMVqsE?si=aa0849e1281944d4','MP3',DEFAULT,128,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('42','00:03:56',DEFAULT,2008,FALSE,FALSE,'Punk','https://open.spotify.com/track/3IL3zHHAFzqu9JkGzMVqsE?si=aa0849e1281944d4','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('42','00:03:56',DEFAULT,2012,FALSE,TRUE,'Punk','https://open.spotify.com/track/3IL3zHHAFzqu9JkGzMVqsE?si=aa0849e1281944d4','FLAC',DEFAULT,512,1,10);



INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Lovers In Japan','00:06:51',DEFAULT,2008,FALSE,FALSE,'Dance','https://open.spotify.com/track/2GkCxLKP04KfDpUYLTmTNl?si=2c683b312db1479f','MP3',DEFAULT,128,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Lovers In Japan','00:06:51',DEFAULT,2008,FALSE,FALSE,'Dance','https://open.spotify.com/track/2GkCxLKP04KfDpUYLTmTNl?si=2c683b312db1479f','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Lovers In Japan','00:06:51',DEFAULT,2012,FALSE,TRUE,'Dance','https://open.spotify.com/track/2GkCxLKP04KfDpUYLTmTNl?si=2c683b312db1479f','FLAC',DEFAULT,512,1,13);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Yes','00:07:06',DEFAULT,2008,FALSE,FALSE,'Pimp','https://open.spotify.com/track/6fw0Ih9M1GQBMi9yqAt1dP?si=d414b661342240ce','MP3',DEFAULT,128,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Yes','00:07:06',DEFAULT,2008,FALSE,FALSE,'Pimp','https://open.spotify.com/track/6fw0Ih9M1GQBMi9yqAt1dP?si=d414b661342240ce','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Yes','00:07:06',DEFAULT,2009,FALSE,TRUE,'Pimp','https://open.spotify.com/track/6fw0Ih9M1GQBMi9yqAt1dP?si=d414b661342240ce','FLAC',DEFAULT,512,1,16);



INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Viva La Vida','00:04:02',DEFAULT,2008,FALSE,FALSE,'Bamb','https://open.spotify.com/track/3Fcfwhm8oRrBvBZ8KGhtea?si=8f157cfb46b2437c','MP3',DEFAULT,128,1);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Viva La Vida','00:04:02',DEFAULT,2008,FALSE,FALSE,'Bamb','https://open.spotify.com/track/3Fcfwhm8oRrBvBZ8KGhtea?si=8f157cfb46b2437c','WAV',DEFAULT,256,1);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Viva La Vida','00:04:02',DEFAULT,2012,FALSE,TRUE,'Bamb','https://open.spotify.com/track/3Fcfwhm8oRrBvBZ8KGhtea?si=8f157cfb46b2437c','FLAC',DEFAULT,512,1,19);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Violet Hill','00:03:42',DEFAULT,2008,FALSE,FALSE,'Bimb','https://open.spotify.com/track/5147DzKnamWyQdZwsYLHEJ?si=e60ef222e1e54eb5','MP3',DEFAULT,128,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Violet Hill','00:03:42',DEFAULT,2008,FALSE,FALSE,'Bimb','https://open.spotify.com/track/5147DzKnamWyQdZwsYLHEJ?si=e60ef222e1e54eb5','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Violet Hill','00:03:42',DEFAULT,2009,FALSE,TRUE,'Bimb','https://open.spotify.com/track/5147DzKnamWyQdZwsYLHEJ?si=e60ef222e1e54eb5','FLAC',DEFAULT,512,1,22);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Strawberry Swing','00:04:09',DEFAULT,2008,FALSE,FALSE,'Bumb','https://open.spotify.com/track/4NmcfahJGawtwaMATGgP0L?si=8d98ed1ba6a24ab9','MP3',DEFAULT,128,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Strawberry Swing','00:04:09',DEFAULT,2008,FALSE,FALSE,'Bumb','https://open.spotify.com/track/4NmcfahJGawtwaMATGgP0L?si=8d98ed1ba6a24ab9','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Strawberry Swing','00:04:09',DEFAULT,2012,FALSE,TRUE,'Bumb','https://open.spotify.com/track/4NmcfahJGawtwaMATGgP0L?si=8d98ed1ba6a24ab9','FLAC',DEFAULT,512,1,25);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Death and Hills','00:06:18',DEFAULT,2008,FALSE,FALSE,'Bomb','https://open.spotify.com/track/36kG5UXshT0PqnZKsgU8c2?si=630215581c6c4476','MP3',DEFAULT,128,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Death and Hills','00:06:18',DEFAULT,2008,FALSE,FALSE,'Bomb','https://open.spotify.com/track/36kG5UXshT0PqnZKsgU8c2?si=630215581c6c4476','WAV',DEFAULT,256,1);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Death and Hills','00:06:18',DEFAULT,2009,FALSE,TRUE,'Bomb','https://open.spotify.com/track/36kG5UXshT0PqnZKsgU8c2?si=630215581c6c4476','FLAC',DEFAULT,512,1,28);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('We Are the World','00:07:07',DEFAULT,1985,FALSE,FALSE,'Pop','https://open.spotify.com/track/3Z2tPWiNiIpg8UMMoowHIk?si=a35cf24db54f4fad','MP3',DEFAULT,128,2);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Gotta go home','00:03:45',DEFAULT,1979,FALSE,FALSE,'Funk','https://open.spotify.com/track/4MvGHDenL4t9JW1RHB4rK2?si=3412cf0a657e4ae2','MP3',DEFAULT,128,3);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Gotta go home','00:03:45',DEFAULT,1979,FALSE,FALSE,'Funk','https://open.spotify.com/track/4MvGHDenL4t9JW1RHB4rK2?si=3412cf0a657e4ae2','WAV',DEFAULT,256,3);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Gotta go home','00:03:45',DEFAULT,1981,FALSE,TRUE,'Funk','https://open.spotify.com/track/4MvGHDenL4t9JW1RHB4rK2?si=3412cf0a657e4ae2','FLAC',DEFAULT,512,3,32);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Ma baker','00:04:36',DEFAULT,1977,FALSE,FALSE,'Funk','https://open.spotify.com/track/1BqnZOkYJbvYLOhN0qPJDm?si=714357878d6f4d77','MP3',DEFAULT,128,3);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Ma baker','00:04:36',DEFAULT,1977,FALSE,FALSE,'Funk','https://open.spotify.com/track/1BqnZOkYJbvYLOhN0qPJDm?si=714357878d6f4d77','WAV',DEFAULT,256,3);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Ma baker','00:04:36',DEFAULT,1979,FALSE,TRUE,'Funk','https://open.spotify.com/track/1BqnZOkYJbvYLOhN0qPJDm?si=714357878d6f4d77','FLAC',DEFAULT,512,3,35);



INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Daddy Cool','00:03:28',DEFAULT,1976,FALSE,FALSE,'Funk','https://open.spotify.com/track/3WMbD1OyfKuwWDWMNbPQ4g?si=c71ff2b628dc4cf7','MP3',DEFAULT,128,3);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Daddy Cool','00:03:28',DEFAULT,1976,FALSE,FALSE,'Funk','https://open.spotify.com/track/3WMbD1OyfKuwWDWMNbPQ4g?si=c71ff2b628dc4cf7','WAV',DEFAULT,256,3);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Daddy Cool','00:03:28',DEFAULT,1979,FALSE,TRUE,'Funk','https://open.spotify.com/track/3WMbD1OyfKuwWDWMNbPQ4g?si=c71ff2b628dc4cf7','FLAC',DEFAULT,512,3,38);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Curnutone','00:04:12',DEFAULT,1981,FALSE,FALSE,'Folk-Nap','https://open.spotify.com/track/5FK9QdVXh9kcxsyj6bMABU?si=847cf1ef6efb4f20','MP3',DEFAULT,128,4);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('O teimp s ne va','00:03:45',DEFAULT,1981,FALSE,FALSE,'Folk-Nap','https://open.spotify.com/track/5YPXVzvnHSsVQptzOzL1E7?si=2aaecb06bde1415f','MP3',DEFAULT,128,4);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('O riccutar Nnamurato','00:03:04',DEFAULT,1981,FALSE,FALSE,'Folk-Nap','https://open.spotify.com/track/6AZELCmg1RWmRmfOEkqyFj?si=08c21217a8864a25','MP3',DEFAULT,128,4);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Something About Us','00:03:52',DEFAULT,2001,FALSE,FALSE,'Elettronica','https://open.spotify.com/track/1NeLwFETswx8Fzxl2AFl91?si=49426af88d574c6b','MP3',DEFAULT,128,5);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Something About Us','00:03:52',DEFAULT,2001,FALSE,FALSE,'Elettronica','https://open.spotify.com/track/1NeLwFETswx8Fzxl2AFl91?si=49426af88d574c6b','WAV',DEFAULT,256,5);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Something About Us','00:03:52',DEFAULT,2003,FALSE,TRUE,'Elettronica','https://open.spotify.com/track/1NeLwFETswx8Fzxl2AFl91?si=49426af88d574c6b','FLAC',DEFAULT,512,5,44);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Giorrgio by Moroder','00:09:04',DEFAULT,2001,FALSE,FALSE,'Elettronica','https://open.spotify.com/track/0oks4FnzhNp5QPTZtoet7c?si=3d577136eb7944a9','MP3',DEFAULT,128,5);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Giorrgio by Moroder','00:09:04',DEFAULT,2001,FALSE,FALSE,'Elettronica','https://open.spotify.com/track/0oks4FnzhNp5QPTZtoet7c?si=3d577136eb7944a9','WAV',DEFAULT,256,5);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Giorrgio by Moroder','00:09:04',DEFAULT,2006,FALSE,TRUE,'Elettronica','https://open.spotify.com/track/0oks4FnzhNp5QPTZtoet7c?si=3d577136eb7944a9','FLAC',DEFAULT,512,5,47);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Loose your self to dance','00:05:53',DEFAULT,2001,FALSE,FALSE,'Elettronica Funk','https://open.spotify.com/track/5CMjjywI0eZMixPeqNd75R?si=9c6255337e62447e','MP3',DEFAULT,128,5);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Loose your self to dance','00:05:53',DEFAULT,2001,FALSE,FALSE,'Elettronica Funk','https://open.spotify.com/track/5CMjjywI0eZMixPeqNd75R?si=9c6255337e62447e','WAV',DEFAULT,256,5);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Loose your self to dance','00:05:53',DEFAULT,2004,FALSE,TRUE,'Elettronica Funk','https://open.spotify.com/track/5CMjjywI0eZMixPeqNd75R?si=9c6255337e62447e','FLAC',DEFAULT,512,5,50);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Sudno','00:02:21',DEFAULT,2018,FALSE,FALSE,'Russian Post-Punk','https://open.spotify.com/track/1SHB1hp6267UK9bJQUxYvO?si=4ea5dfdc865b4531','MP3',DEFAULT,128,6);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Sudno','00:02:21',DEFAULT,2019,FALSE,FALSE,'Russian Post-Punk','https://open.spotify.com/track/1SHB1hp6267UK9bJQUxYvO?si=4ea5dfdc865b4531','WAV',DEFAULT,256,6,53);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Sudno','00:02:21',DEFAULT,2021,FALSE,TRUE,'Russian Post-Punk','https://open.spotify.com/track/1SHB1hp6267UK9bJQUxYvO?si=4ea5dfdc865b4531','FLAC',DEFAULT,512,6,53);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Tanzevat','00:03:22',DEFAULT,2018,FALSE,FALSE,'Russian Post-Punk','https://open.spotify.com/track/782VcXkRqyevFaJlcoIIEz?si=5c4780b13540431f','MP3',DEFAULT,128,6);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Tanzevat','00:03:22',DEFAULT,2020,FALSE,TRUE,'Russian Post-Punk','https://open.spotify.com/track/782VcXkRqyevFaJlcoIIEz?si=5c4780b13540431f','WAV',DEFAULT,256,6,56);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTR)
VALUES('Tanzevat','00:03:22',DEFAULT,2022,FALSE,TRUE,'Russian Post-Punk','https://open.spotify.com/track/782VcXkRqyevFaJlcoIIEz?si=5c4780b13540431f','FLAC',DEFAULT,512,6,56);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Sky and Sand','00:03:50',DEFAULT,2013,FALSE,FALSE,'Tech House','https://open.spotify.com/track/4IsHMzDbRE8q5Z4ALsQj3o?si=25b8b9fe5ae24350','MP3',DEFAULT,128,7);


INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Revolte','00:02:39',DEFAULT,2013,FALSE,FALSE,'Tech House','https://open.spotify.com/track/439ZObTQ35Py7TMGNUJmlp?si=d7c48a1fa15f4b9d','MP3',DEFAULT,128,7);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Train','00:02:48',DEFAULT,2013,FALSE,FALSE,'Tech House','https://open.spotify.com/track/0Tcm3XyhznXJOUoSVlNX7M?si=5aa08fc0349a4f9e','MP3',DEFAULT,128,7);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Monsters Inc','00:02:06',DEFAULT,2001,FALSE,FALSE,'Cartoon','https://open.spotify.com/track/5e0O7MjhNHq9G67qDFM8nR?si=e9748639b7c34b45','MP3',DEFAULT,128,8);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Le Festin','00:02:50',DEFAULT,2007,FALSE,FALSE,'Cartoon','https://open.spotify.com/track/02JIdsrod3BYucThfUFDUX?si=6b4c171e94754988','MP3',DEFAULT,128,8);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('I cavalieri dello Zodiaco','00:02:45',DEFAULT,2009,FALSE,FALSE,'Cartoon','https://open.spotify.com/track/05A9bpJIvKqts4uswSjNla?si=09964b1ed424438c','MP3',DEFAULT,128,9);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Siamo fatti cosi','00:02:50',DEFAULT,2019,FALSE,FALSE,'Cartoon','https://open.spotify.com/track/5pVq1yo6FbpGP20wO6DPIp?si=93fefb2c0abf4e85','MP3',DEFAULT,128,9);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Pokemon','00:03:20',DEFAULT,2014,FALSE,FALSE,'Cartoon','https://open.spotify.com/track/3S7Q5OqgcPyEXQgyrHbvze?si=da1b827e8fba459a','MP3',DEFAULT,128,9);

-- Popolati gli album, creiamo alcune tracce senza album (ed alcune Cover)

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Easter egg','00:01:42',DEFAULT,2021,FALSE,FALSE,'Arte','https://open.spotify.com/track/1dwTG4PVhiWzeu0fUfMMMb?si=8e6406c15b2d42d0','FLAC',DEFAULT,512,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Easter egg2','00:03:51',DEFAULT,2021,FALSE,FALSE,'Sport','https://www.youtube.com/watch?v=aR5BsvCA21s','FLAC',DEFAULT,512,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Napoli','00:03:20',DEFAULT,1998,FALSE,FALSE,'Sport','https://www.youtube.com/watch?v=aR5BsvCA21s','FLAC',DEFAULT,512,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Procida','00:04:34',DEFAULT,2019,FALSE,FALSE,'Blues','https://www.youtube.com/watch?v=4CmXDBm6gZA','FLAC',DEFAULT,512,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Demons','00:02:57',DEFAULT,2012,FALSE,FALSE,'BOH','https://open.spotify.com/track/5qaEfEh1AtSdrdrByCP7qR?si=a4e9be06da044402','MP3',DEFAULT,128,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Flyday','00:03:25',DEFAULT,2021,FALSE,FALSE,'Jap80','https://open.spotify.com/track/5N6lcz1UZJVaX2gFjREz5c?si=2466b2f95a834b13','MP3',DEFAULT,128,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('U me and madonna','00:04:10',DEFAULT,2017,FALSE,FALSE,'House','https://open.spotify.com/track/1tpTQDEv7I3rpT0W816meN?si=4e34ff5cd0d24f01','MP3',DEFAULT,128,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Ecole','00:06:24',DEFAULT,2020,FALSE,FALSE,'House','https://open.spotify.com/track/6ZcN26OG9FY2inZxJwTX6g?si=3d1473829c5941e0','MP3',DEFAULT,256,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Focacine','00:02:20',DEFAULT,2016,FALSE,FALSE,'Trap','https://open.spotify.com/track/7rYlGT75z1srGu5i8wuTwF?si=f230ed80f3ae442b','MP3',DEFAULT,128,DEFAULT);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Dan Dan','00:03:30',DEFAULT,1995,FALSE,FALSE,'Cartoon','https://open.spotify.com/track/6vjNTrHMJuoktlhC7PFAJY?si=c6bbe8a6978446c0','MP3',DEFAULT,128,DEFAULT);

-- Passiamo alle tracce dei Maneskin...ops le cover--
INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTC)
VALUES('Tanzevat','00:03:22',DEFAULT,2023,TRUE,FALSE,'American After-Punk','https://open.spotify.com/track/782VcXkRqyevFaJlcoIIEz?si=5c4780b13540431f','MP3',DEFAULT,128,DEFAULT,56);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTC)
VALUES('Loose your self to dance','00:05:53',DEFAULT,2023,TRUE,FALSE,'Neomelodico','https://open.spotify.com/track/5CMjjywI0eZMixPeqNd75R?si=9c6255337e62447e','WAV',DEFAULT,256,DEFAULT,50);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTC)
VALUES('Curnutone','00:04:12',DEFAULT,2023,TRUE,FALSE,'Meeelano','https://open.spotify.com/track/5FK9QdVXh9kcxsyj6bMABU?si=847cf1ef6efb4f20','MP3',DEFAULT,128,DEFAULT,41);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA,CodTC)
VALUES('Viva La Vida','00:04:02',DEFAULT,2023,TRUE,FALSE,'Classica','https://open.spotify.com/track/3Fcfwhm8oRrBvBZ8KGhtea?si=8f157cfb46b2437c','FLAC',DEFAULT,512,DEFAULT,19);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Begin','00:03:31',DEFAULT,2020,FALSE,FALSE,'Rock','https://open.spotify.com/track/3Wrjm47oTz2sjIgck11l5e?si=a69bd451b8df459f','FLAC',DEFAULT,512,10);

INSERT INTO TRACCIA(Titolo,Durata,Etichetta,AnnoU,IsCover,IsRemastered,Genere,Link,Formato,Voto,Qualita,CodA)
VALUES('Holly e benji','00:03:04',DEFAULT,2020,FALSE,FALSE,'Cartoon','https://open.spotify.com/track/3Wrjm47oTz2sjIgck11l5e?si=a69bd451b8df459f','WAV',DEFAULT,512,DEFAULT);

-- UTENTI
INSERT INTO UTENTE(Nome,Cognome,Nickname,Email,Password,DataN,Sesso,Nazionalita,Descrizione,IsPremium,IsAdmin)
Values('Rami', 'MaleK', 'Rami_Malek','silvio.barra@unina.it','I@mMrR0bot','1991-01-01','Uomo',DEFAULT,'Google is the way',TRUE,TRUE);

INSERT INTO UTENTE(Nome,Cognome,Nickname,Email,Password,DataN,Sesso,Nazionalita,Descrizione,IsPremium,IsAdmin)
Values('Porfirio', 'Tramontana','King_of_Procida','porfirio.tramontata@unina.it','ForzaNapoli','1990-01-01','Uomo',DEFAULT,'Facciamo pausa dai',TRUE,TRUE);

INSERT INTO UTENTE(Nome,Cognome,Nickname,Email,Password,DataN,Sesso,Nazionalita,Descrizione,IsPremium,IsAdmin)
Values('Alfredo', 'Laino', 'Lord_Pino','al.laino@studenti.unina.it','1q2w3e4r5t','1995-08-21','Lampadina',DEFAULT,'Che bello popolare le basi di dati...Quanto mi rilassa...',TRUE,FALSE);

INSERT INTO UTENTE(Nome,Cognome,Nickname,Email,Password,DataN,Sesso,Nazionalita,Descrizione,IsPremium,IsAdmin)
Values('Francesco', 'Orlando', 'Effeo','francesco.orlando3@studenti.unina.it','y6t5r4e3w2q1','2002-01-20','Unicorno',DEFAULT,'Sono il terzo Francesco Orlando di UNINA,tutto apposto...',TRUE,FALSE);

INSERT INTO UTENTE(Nome,Cognome,Nickname,Email,Password,DataN,Sesso,Nazionalita,Descrizione,IsPremium,IsAdmin)
Values('Marco', 'Pastore', 'ElPator', 'loso@ahokok.com','Miscusi','2002-01-01','Donna',DEFAULT,'Mi scusi Posso fare una Domanda',FALSE,FALSE); --Cute--

--INCISIONI
INSERT INTO INCIDE (NomeArte,CodA)
Values('ColdPlay',1);

INSERT INTO INCIDE (NomeArte,CodA)
Values('USA for Africa',2);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Boney M.',3);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Squallor',4);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Daft Punk',5);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Molchat Doma',6);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Paul Kalkbrenner',7);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Randy Newman',8);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Camille',8);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Cristina Davena',9);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Giorgio Vanni',9);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Odeon Boys',9);

INSERT INTO INCIDE (NomeArte,CodA)
Values('Maneskin',10);

--PRODUZIONI
INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',1);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',2);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',3);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',4);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',5);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',6);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',7);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',8);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',9);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',10);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',11);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',12);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',13);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',14);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',15);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',16);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',17);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',18);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',19);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',20);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',21);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',22);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',23);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',24);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',25);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',26);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',27);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',28);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',29);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('ColdPlay',30);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('USA for Africa',31);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',32);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',33);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',34);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',35);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',36);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',37);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',38);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',39);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Boney M.',40);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Squallor',41);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Squallor',42);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Squallor',43);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',44);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',45);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',46);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',47);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',48);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',49);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',50);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',51);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Daft Punk',52);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Molchat Doma',53);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Molchat Doma',54);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Molchat Doma',55);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Molchat Doma',56);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Molchat Doma',57);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Molchat Doma',58);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Paul Kalkbrenner',59);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Paul Kalkbrenner',60);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Paul Kalkbrenner',61);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Randy Newman',62);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Camille',63);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Odeon Boys',64);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Cristina Davena',65);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Giorgio Vanni',66);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Silvio Barra',67);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Silvio Barra',68);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Artisti Vari',69); --Nice --

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Artisti Vari',70);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Imagine Dragons',71);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Yasuha',72);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('1-800 GIRLS',73);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Lo straqen',74);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('OEL',75);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Artisti Vari',76);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Maneskin',77);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Maneskin',78);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Maneskin',79);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Maneskin',80);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Maneskin',81);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Cristina Davena',82);

INSERT INTO PRODUCE(NomeArte,CodT)
VALUES('Giorgio Vanni',82);
