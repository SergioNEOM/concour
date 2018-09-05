ALTER TABLE "git" RENAME TO git_old;

/*---*/

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
 "gittime1" REAL DEFAULT '0.0', 
 "foul1_time" REAL DEFAULT '0.0', 
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
 "gittime2" REAL DEFAULT '0.0', 
 "foul2_time" REAL DEFAULT '0.0',
 "totalfouls2" REAL DEFAULT 0.0, 
 place  INTEGER DEFAULT 0,
 place2 INTEGER DEFAULT 0,
 overlap INTEGER DEFAULT 0,  /* если >0 то участник перепрыжки */
 "sumfouls" REAL DEFAULT '0.0'   /* временно: вычисляемое поле глючит */
);

/*----*/

INSERT INTO "git" SELECT * FROM git_old;
