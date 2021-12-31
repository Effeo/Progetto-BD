--primo utente: utente base, può solo ascoltare le tracce, visitare le tracce, gli album, gli artisti, gli altri utenti e le playlist.
CREATE USER UtenteBase PASSWORD 'base';
GRANT SELECT on Traccia to UtenteBase;
GRANT SELECT on Album to UtenteBase;
GRANT SELECT on Artista to UtenteBase;
GRANT SELECT on Playlist to UtenteBase;
GRANT SELECT on Contiene to UtenteBase;
GRANT SELECT on Utente to UtenteBase;
GRANT SELECT on Produce to UtenteBase;
GRANT SELECT on Incide to UtenteBase;
GRANT INSERT on Contiene to UtenteBase;
GRANT INSERT on Playlist to UtenteBase;
GRANT INSERT on Ascolta to UtenteBase;
GRANT UPDATE on Playlist to UtenteBase;
GRANT DELETE on Playlist to UtenteBase;
GRANT UPDATE on Contiene to UtenteBase;
GRANT DELETE on Contiene to UtenteBase;

--secondo utente: oltre ad avere i privilegi dell'utente normale può anche votare delle tracce.
CREATE USER UtentePremium PASSWORD 'premium';
GRANT SELECT on Traccia to UtentePremium;
GRANT SELECT on Album to UtentePremium;
GRANT SELECT on Artista to UtentePremium;
GRANT SELECT on Playlist to UtentePremium;
GRANT SELECT on Contiene to UtentePremium;
GRANT SELECT on Utente to UtentePremium;
GRANT SELECT on Produce to UtentePremium;
GRANT SELECT on Incide to UtentePremium;
GRANT INSERT on Contiene to UtentePremium;
GRANT INSERT on Playlist to UtentePremium;
GRANT INSERT on Ascolta to UtentePremium;
GRANT UPDATE on Playlist to UtentePremium;
GRANT DELETE on Playlist to UtentePremium;
GRANT UPDATE on Contiene to UtentePremium;
GRANT DELETE on Contiene to UtentePremium;
GRANT INSERT on Vota to UtentePremium;
GRANT DELETE on Vota to UtentePremium;
GRANT UPDATE on Vota to UtentePremium;

--terzo utente: utente admin, ha tutti i privilegi
CREATE USER UtenteAdmin PASSWORD 'admin';
GRANT ALL on Traccia to UtenteAdmin;
GRANT ALL on Album to UtenteAdmin;
GRANT ALL on Artista to UtenteAdmin;
GRANT ALL on Playlist to UtenteAdmin;
GRANT ALL on Contiene to UtenteAdmin;
GRANT ALL on Utente to UtenteAdmin;
GRANT ALL on Produce to UtenteAdmin;
GRANT ALL on Incide to UtenteAdmin;
GRANT ALL on Vota to UtenteAdmin;
GRANT ALL on Ascolta to UtenteAdmin;
