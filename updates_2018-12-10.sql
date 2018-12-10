/*
 updates from 2018-12-10 
  ( sqlite3 concour.db  ->  .read <this file> )
*/
DROP VIEW "v_riders";
/*---*/
CREATE VIEW IF NOT EXISTS "v_riders" AS
  SELECT _rowid_ as id, 
 cast("lastname" as char(30)) as lastname,
 cast("firstname" as char(25)) as firstname,
 birthdate,
 cast("regnum" as char(10)) as regnum,
 cast("category" as char(10)) as category, 
 cast("trainer" as char(25)) as trainer, 
 cast("region" as char(50)) as region 
  FROM "riders"
 ORDER BY lastname,firstname,id;
/*---*/
DROP VIEW "v_horses";
/*---*/
CREATE VIEW IF NOT EXISTS "v_horses" AS 
  SELECT _rowid_ as id, 
 cast("nickname" as CHAR(25)) as nickname, 
 "birthdate" as birthdate,
 cast("color" as CHAR(25)) as color,
 cast("sex" as CHAR(25)) as sex,
 cast("breed" as CHAR(25)) as breed,
 cast("parent" as CHAR(25)) as parent,
 cast("birthplace" as CHAR(25)) as birthplace,
 cast("register" as CHAR(25)) as register,
 cast("owner" as CHAR(25)) as owner
 FROM "horses"
 ORDER BY nickname,id;


