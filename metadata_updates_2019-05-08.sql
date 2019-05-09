/*
 updates at 2019-05-08
  ( sqlite3 concour.db  ->  .read <this file> )
*/

/*-*/
   ALTER TABLE git ADD COLUMN fired     int default 0;
   ALTER TABLE git ADD COLUMN firedover int default 0;
/*-*/
   UPDATE git SET place=place-9000, fired=9100 where place>9000;
   UPDATE git SET place2=place2-9000, firedover=9100 where place2>9000;
/*-*/
DROP VIEW "v_git";
/****/
CREATE VIEW IF NOT EXISTS "v_git" AS
  SELECT git._rowid_ as id, git.tournament, git.route, 
  git."queue" as queue,  git.place, git.place2,
  git."group", groups."groupname", 
  git.overlap, git."rider" as rider,  
  git.fired, git.firedover,
  cast(riders."lastname" as char(30))||' '||cast(riders."firstname" as char(25)) as lastname,
  cast(riders."firstname" as char(25)) as firstname,
  riders."birthdate" as r_year,
  cast(riders."regnum" as char(10)) as regnum,
  cast(riders."category" as char(10)) as category,
  cast(riders."trainer" as char(25)) as trainer,
  cast(riders."region" as char(50)) as region,
  git.horse as horse, horses."birthdate" as h_year, 
  cast(horses."nickname" as CHAR(25)) as nickname,
  cast(horses."register" as CHAR(25)) as register, 
  cast(horses."color" as CHAR(25)) as color, 
  cast(horses."sex" as CHAR(25)) as sex, 
  cast(horses."breed" as CHAR(25)) as breed, 
  cast(horses."parent" as CHAR(25)) as parent, 
  cast(horses."birthplace" as CHAR(25)) as birthplace, 
  cast(horses."owner" as CHAR(25)) as owner, 
  git."foul1_b1" as foul1_b1, git."foul1_b2" as foul1_b2, git."foul1_b3" as foul1_b3, 
  git."foul1_b4" as foul1_b4, git."foul1_b5" as foul1_b5, git."foul1_b6" as foul1_b6, 
  git."foul1_b7" as foul1_b7, git."foul1_b8" as foul1_b8, git."foul1_b9" as foul1_b9, 
  git."foul1_b10" as foul1_b10, git."foul1_b11" as foul1_b11, git."foul1_b12" as foul1_b12, 
  git."foul1_b13" as foul1_b13, git."foul1_b14" as foul1_b14, git."foul1_b15" as foul1_b15, 
  git."gittime1" as gittime1, git."foul1_time" as foul1_time, 
  git."foul2_b1" as foul2_b1, git."foul2_b2" as foul2_b2, git."foul2_b3" as foul2_b3, 
  git."foul2_b4" as foul2_b4, git."foul2_b5" as foul2_b5, git."foul2_b6" as foul2_b6, 
  git."foul2_b7" as foul2_b7, git."foul2_b8" as foul2_b8, git."foul2_b9" as foul2_b9, 
  git."foul2_b10" as foul2_b10, git."foul2_b11" as foul2_b11, git."foul2_b12" as foul2_b12, 
  git."foul2_b13" as foul2_b13, git."foul2_b14" as foul2_b14, git."foul2_b15" as foul2_b15, 
  git."gittime2" as gittime2, git."foul2_time" as foul2_time, 
  git."sumfouls1" as sumfouls1, git."sumfouls2" as sumfouls2,
  git.totalfouls1, git.totalfouls2, git."sumfouls" as sumfouls 
  FROM "git" left join "riders" on git."rider"=riders._rowid_  
	     left join "horses" on git."horse"=horses._rowid_ 
	     left join "groups" on git."group"=groups._rowid_;
/*----*/
UPDATE vers SET lastupdate='2019-05-08';
