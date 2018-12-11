/*
 updates from 2018-12-11
  ( sqlite3 concour.db  ->  .read <this file> )
*/

ALTER TABLE tournaments ADD COLUMN tourdate2 CHAR(10);
/*--*/
UPDATE tournaments SET tourdate2 = tourdate;
/*--*/
DROP VIEW "v_tournaments";
/*--*/
CREATE VIEW IF NOT EXISTS "v_tournaments" AS
  SELECT "_rowid_" as id,
 strftime('%d-%m-%Y',tourdate) as "Дата соревнования",
 strftime('%d-%m-%Y',tourdate2) as "Дата2",
 cast(tourname as CHAR(100)) as tourname,
 cast(tourplace as CHAR(100)) as tourplace,
 cast(referee as CHAR(30)) as referee,
 cast(assistant as CHAR(30)) as assistant 
 FROM tournaments
 ORDER BY tourdate,tourdate2;
/*---*/


CREATE TABLE IF NOT EXISTS vers ( 
 appdate CHAR(10),
 lastupdate CHAR(10)
);
/*--*/
CREATE VIEW IF NOT EXISTS "v_vers" AS
  SELECT "_rowid_" as id,
  strftime('%d-%m-%Y',appdate) as appdate,
  strftime('%d-%m-%Y',lastupdate) as lastupdate
 FROM vers;

/*---*/
INSERT INTO vers(appdate,lastupdate) VALUES('2018-12-11','2018-12-11');

/****/
