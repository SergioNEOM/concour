/********************/
CREATE TABLE IF NOT EXISTS tournaments ( 
 tourdate CHAR(10),
 tourname VARCHAR(100),
 tourplace VARCHAR(100),
 referee VARCHAR(30),
 assistant VARCHAR(30),
 tourdate2 CHAR(10))
);

/*-
--- hook DBGrid MEMO displaying ---
-*/
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
/*------------------*/
/* route type:
  0 = КЛАССИКА
  1 = КЛАССИКА С ПЕРЕПРЫЖКОЙ
  2 = 2 ФАЗЫ
  3 = ПО ВОЗРАСТАЮЩЕЙ СЛОЖНОСТИ
  4 = ПО ТАБЛИЦЕ
  5 = НА МАКСИМУМ БАЛЛОВ
  6 = 2 ГИТА
*/
/*-
-*/
CREATE TABLE IF NOT EXISTS "routes" ( 
 routename VARCHAR(30), 
 tournament INTEGER,
 route_type INTEGER, 
 barriers1 INTEGER DEFAULT 1,
 distance1 INTEGER,
 velocity1 INTEGER,
 barriers2 INTEGER,
 distance2 INTEGER,
 velocity2 INTEGER,
 "result_type" INTEGER,
 colnames varchar(360),
 tournament INTEGER);


CREATE VIEW IF NOT EXISTS "v_routes" AS  
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
/*-
----------------
-*/

CREATE TABLE IF NOT EXISTS "groups" ( 
 groupname CHAR(30)
);

CREATE VIEW IF NOT EXISTS "v_groups" AS  
  SELECT _rowid_ as id, groupname 
 FROM "groups";

/*-
----------------
-*/

CREATE TABLE IF NOT EXISTS "riders" ( 
 "lastname" VARCHAR(30) NOT NULL,
 "firstname" VARCHAR(25),
 "birthdate" INTEGER,
 "regnum" VARCHAR(10),
 "category" VARCHAR(10),
 "trainer" VARCHAR(25),
 "region" VARCHAR(50)
 );
/*-
--- ---
-*/
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

/*-
------------------
-*/
CREATE TABLE IF NOT EXISTS "horses" ( 
 "nickname" VARCHAR(25) NOT NULL, 
 "birthdate" INT, 
 "color" VARCHAR(25), 
 "sex" VARCHAR(25), 
 "breed" VARCHAR(25), 
 "parent" VARCHAR(25), 
 "birthplace" VARCHAR(25), 
 "register" VARCHAR(25), 
 "owner"  VARCHAR(25) 
); 

/*---- hook DBGrid MEMO displaying ----*/
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

/*-
------------------
-*/


CREATE TABLE IF NOT EXISTS "git" (
 tournament INTEGER, 
 route INTEGER,
 "group" INTEGER,
 "queue" INTEGER,
 "rider" INTEGER,
 "horse" INTEGER,
 "foul1_b1" INTEGER DEFAULT 0, 
 "foul1_b2" INTEGER DEFAULT 0, 
 "foul1_b3" INTEGER DEFAULT 0, 
 "foul1_b4" INTEGER DEFAULT 0, 
 "foul1_b5" INTEGER DEFAULT 0, 
 "foul1_b6" INTEGER DEFAULT 0, 
 "foul1_b7" INTEGER DEFAULT 0, 
 "foul1_b8" INTEGER DEFAULT 0, 
 "foul1_b9" INTEGER DEFAULT 0, 
 "foul1_b10" INTEGER DEFAULT 0, 
 "foul1_b11" INTEGER DEFAULT 0, 
 "foul1_b12" INTEGER DEFAULT 0, 
 "foul1_b13" INTEGER DEFAULT 0, 
 "foul1_b14" INTEGER DEFAULT 0, 
 "foul1_b15" INTEGER DEFAULT 0, 
 "sumfouls1" INTEGER DEFAULT 0, 
 "gittime1" REAL DEFAULT 0.0, 
 "foul1_time" REAL DEFAULT 0.0, 
 "totalfouls1" REAL DEFAULT 0.0, 
 "foul2_b1" INTEGER DEFAULT 0, 
 "foul2_b2" INTEGER DEFAULT 0, 
 "foul2_b3" INTEGER DEFAULT 0, 
 "foul2_b4" INTEGER DEFAULT 0, 
 "foul2_b5" INTEGER DEFAULT 0, 
 "foul2_b6" INTEGER DEFAULT 0, 
 "foul2_b7" INTEGER DEFAULT 0, 
 "foul2_b8" INTEGER DEFAULT 0, 
 "foul2_b9" INTEGER DEFAULT 0, 
 "foul2_b10" INTEGER DEFAULT 0, 
 "foul2_b11" INTEGER DEFAULT 0, 
 "foul2_b12" INTEGER DEFAULT 0, 
 "foul2_b13" INTEGER DEFAULT 0, 
 "foul2_b14" INTEGER DEFAULT 0, 
 "foul2_b15" INTEGER DEFAULT 0, 
 "sumfouls2" INTEGER DEFAULT 0,
 "gittime2" REAL DEFAULT 0.0, 
 "foul2_time" REAL DEFAULT 0.0,
 "totalfouls2" REAL DEFAULT 0.0, 
 place  INTEGER DEFAULT 0,
 place2 INTEGER DEFAULT 0,
 overlap INTEGER DEFAULT 0,  /* если >0 то участник перепрыжки */
 fired  INTEGER DEFAULT 0,	/* снят с гита ?*/
 firedover INTEGER DEFAULT 0,
 "sumfouls" REAL DEFAULT 0.0   /* временно: вычисляемое поле глючит */
);

/*-
---------------
-*/
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
/* WHERE git.tournament=:partour and git.route=:parroute; - в коде  */

/*-
-------
-*/

CREATE INDEX "horses_nick_idx" ON "horses"( "nickname" );



/*-
-------------------------------
-*/

CREATE TABLE vers ( 
 appdate CHAR(10),
 lastupdate CHAR(10)
);
/*-
---
-*/

CREATE VIEW "v_vers" AS
  SELECT "_rowid_" as id,
  strftime('%d-%m-%Y',appdate) as appdate,
  strftime('%d-%m-%Y',lastupdate) as lastupdate
 FROM vers;

