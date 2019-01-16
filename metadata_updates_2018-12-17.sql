/*
 updates from 2018-12-17
  ( sqlite3 concour.db  ->  .read <this file> )
*/

ALTER TABLE "routes" ADD COLUMN tournament INTEGER;
/*-*/
DROP VIEW "v_routes";
/*-*/
CREATE VIEW "v_routes" AS  
  SELECT _rowid_ as id, 
 cast(routename as char(30)) as routename,
 tournament,
 route_type, 
 barriers1, 
 distance1,  
 velocity1, 
 barriers2, 
 distance2, 
 velocity2, 
 result_type,
 cast(colnames as char(360)) as colnames
 FROM "routes";

/****/
/*----*/
UPDATE vers SET lastupdate='2018-12-17';
