/*
 updates at 2019-02-02
  ( sqlite3 concour.db  ->  .read <this file> )
*/

DROP VIEW "v_tournaments";
/*-*/
CREATE VIEW IF NOT EXISTS "v_tournaments" AS
  SELECT "_rowid_" as id,
 strftime('%d-%m-%Y',tourdate) as tourdate,
 strftime('%d-%m-%Y',tourdate2) as tourdate2,
 cast(tourname as CHAR(100)) as tourname,
 cast(tourplace as CHAR(100)) as tourplace,
 cast(referee as CHAR(30)) as referee,
 cast(assistant as CHAR(30)) as assistant 
 FROM tournaments
 ORDER BY tournaments.tourdate,tournaments.tourdate2;

/****/
/*----*/
UPDATE vers SET lastupdate='2019-02-02';
