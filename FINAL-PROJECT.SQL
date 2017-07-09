spool C:/Users/AYON/Desktop/database/1407041/text.txt;

----------------------- DROP ALL THE TABLE ------------------------------
DROP TABLE MATCH_DETAILS cascade constraints;
DROP TABLE BUYER_DETAILS cascade constraints;
DROP TABLE TICKET_INFO cascade constraints;
DROP TABLE account cascade constraints;
DROP TABLE ALL_DETAILS cascade constraints;

------------------------ CREATE ALL THE TABLE ----------------------------

CREATE TABLE MATCH_DETAILS(
  MATCH_NO NUMBER(2) NOT NULL,
  MATCH_VANUE VARCHAR(9),
  MATCH_TIME DATE,
  MATCH_TYP VARCHAR(10),
  TEAM_NAME1 VARCHAR(4),
  TEAM_NAME2 VARCHAR(4),
  TOTAL_SEAT NUMBER(10),
  TIME_LEFT NUMBER(10)
);


CREATE TABLE BUYER_DETAILS(
  BUYER_ID VARCHAR(8) NOT NULL,
  TICKET_ID VARCHAR(9),
  TOTAL_PRICE NUMBER(10),
  TICKET_CATEGORY NUMBER(1) check(TICKET_CATEGORY >= 1 and TICKET_CATEGORY <= 4),
  NO_OF_SEAT_NEEDED NUMBER(10) check(NO_OF_SEAT_NEEDED >= 1 and NO_OF_SEAT_NEEDED <= 4)
);

CREATE TABLE TICKET_INFO(
  TICKET_ID VARCHAR(9) NOT NULL,
  SEAT_NO VARCHAR(6),
  SEAT_TYP VARCHAR(8),
  MATCH_NO NUMBER(2)
);

create table account(
    userid varchar(10),
    password number(10)
);

CREATE TABLE ALL_DETAILS(
  MATCH_NO NUMBER(10),
  TICKET_ID VARCHAR(10),
  BUYER_ID VARCHAR(10)
);


-------------------------------------- PRIMARY KEY ----------------------------------------------
ALTER TABLE MATCH_DETAILS ADD CONSTRAINT MDP_KEY PRIMARY KEY(MATCH_NO);
ALTER TABLE BUYER_DETAILS ADD CONSTRAINT BDP_KEY PRIMARY KEY(BUYER_ID);
ALTER TABLE TICKET_INFO ADD CONSTRAINT TIP_KEY PRIMARY KEY(TICKET_ID);

-------------------------------------- FOREIGN KEY ----------------------------------------------
ALTER TABLE TICKET_INFO ADD CONSTRAINT TIF_KEY FOREIGN KEY (MATCH_NO) REFERENCES MATCH_DETAILS(MATCH_NO) on delete cascade;
ALTER TABLE BUYER_DETAILS ADD CONSTRAINT BDF_KEY FOREIGN KEY (TICKET_ID) REFERENCES TICKET_INFO(TICKET_ID) on delete cascade;


------------------------------- LOG IN ---------------------------------------


insert into account values('AYON',41);
insert into account values('PRANTO',03);
insert into account values('ASIF',07);
insert into account values('NAHID',21);
PROMPT You need to login first..
PROMPT Enter your userid and password..


SET SERVEROUTPUT ON
DECLARE
   row NUMBER(2);
   u1 account.userid%TYPE;
   p1 account.password%TYPE;
BEGIN
    u1 := '&userid';
    p1 := &password;

    select count(*) into row from account
    where account.userid=u1 and account.password=p1;

    if row = 1 then
      dbms_output.put_line ('Log in successful');
    else
      dbms_output.put_line ('Id or password did not match');
    end if;  
END;
/

PAUSE Press ENTER to continue 1 ...
---------------------------------- TRIGGER (for match_details table) --------------------------------
DROP TRIGGER TR_GRADE1; 
CREATE or REPLACE TRIGGER TR_GRADE1 
BEFORE UPDATE OR INSERT ON MATCH_DETAILS
FOR EACH ROW 
BEGIN
      IF EXTRACT(DAY FROM(:new.MATCH_TIME - systimestamp)) > 1  THEN
        :new.TIME_LEFT := EXTRACT(DAY FROM(:new.MATCH_TIME - systimestamp));
      else
      :new.TIME_LEFT := 0;
    END IF;
END TR_GRADE1;
/
SHOW ERRORS;


-------------------------------------- INSERT DATA INTO TABLE ------------------------------------
INSERT INTO MATCH_DETAILS VALUES(1,'DHA','11-JUL-2017','GROUP','BAN','IND',10000,NULL);
INSERT INTO MATCH_DETAILS VALUES(2,'CHI','12-JUL-2017','GROUP','AUS','SAF',20000,NULL);
INSERT INTO MATCH_DETAILS VALUES(3,'KHU','13-JUL-2017','SUPER','NZ','PK',30000,NULL);
INSERT INTO MATCH_DETAILS VALUES(4,'DHA','15-JUL-2017','SUPER','SL','WI',40000,NULL);
INSERT INTO MATCH_DETAILS VALUES(5,'KHU','16-JUL-2017','SEMIFINAL','END','ZIM',50000,NULL);


INSERT INTO TICKET_INFO VALUES('A1001','N-01','NORMAL',1);
INSERT INTO TICKET_INFO VALUES('B2001','N-02','NORMAL',2);
INSERT INTO TICKET_INFO VALUES('B2002','M-01','MIDDLE',2);
INSERT INTO TICKET_INFO VALUES('A3002','N-02','MIDDLE',3);
INSERT INTO TICKET_INFO VALUES('A3001','M-01','VIP',3);
INSERT INTO TICKET_INFO VALUES('A3003','M-02','VIP',2);

COMMIT;


------------------------------- DESCRIBE ALL THE TABLE ------------------------------------
describe MATCH_DETAILS;
describe BUYER_DETAILS;
describe TICKET_INFO;


---------------------------------- TRIGGER AND ROLLBACK (for buyer_details table) --------------------------------
DROP TRIGGER TR_GRADE2; 
CREATE or REPLACE TRIGGER TR_GRADE2 
BEFORE UPDATE OR INSERT ON BUYER_DETAILS
FOR EACH ROW 
BEGIN
IF :NEW.NO_OF_SEAT_NEEDED = 1 and :NEW.TICKET_CATEGORY = 1  THEN
  :NEW.total_price := (1 * 900) ;
ELSIF :NEW.no_of_seat_needed = 2 and :NEW.ticket_category = 1  THEN
  :NEW.total_price := (2 * 900) ;
ELSIF :NEW.no_of_seat_needed = 3 and :NEW.ticket_category = 1  THEN
  :NEW.total_price := (3 * 900) ;
ELSIF :NEW.no_of_seat_needed = 4 and :NEW.ticket_category = 1  THEN
  :NEW.total_price := (4 * 900) ;
ELSIF :NEW.no_of_seat_needed = 1 and :NEW.ticket_category = 2  THEN
  :NEW.total_price := (1 * 700) ;
ELSIF :NEW.no_of_seat_needed = 2 and :NEW.ticket_category = 2  THEN
  :NEW.total_price := (2 * 700) ;
ELSIF :NEW.no_of_seat_needed = 3 and :NEW.ticket_category = 2  THEN
  :NEW.total_price := (3 * 700) ;
ELSIF :NEW.no_of_seat_needed = 4 and :NEW.ticket_category = 2  THEN
  :NEW.total_price := (4 * 700) ;
ELSIF :NEW.no_of_seat_needed = 1 and :NEW.ticket_category = 3  THEN
  :NEW.total_price := (1 * 500) ;
ELSIF :NEW.no_of_seat_needed = 2 and :NEW.ticket_category = 3  THEN
  :NEW.total_price := (2 * 500) ;
ELSIF :NEW.no_of_seat_needed = 3 and :NEW.ticket_category = 3  THEN
  :NEW.total_price := (3 * 500) ;
ELSIF :NEW.no_of_seat_needed = 4 and :NEW.ticket_category = 3  THEN
  :NEW.total_price := (4 * 500) ;
ELSIF :NEW.no_of_seat_needed = 1 and :NEW.ticket_category = 4  THEN
  :NEW.total_price := (1 * 300) ;
ELSIF :NEW.no_of_seat_needed = 2 and :NEW.ticket_category = 4  THEN
  :NEW.total_price := (2 * 300) ;
ELSIF :NEW.no_of_seat_needed = 3 and :NEW.ticket_category = 4  THEN
  :NEW.total_price := (3 * 300) ;
ELSIF :NEW.no_of_seat_needed = 4 and :NEW.ticket_category = 4  THEN
  :NEW.total_price := (4 * 300) ;
END IF;
END TR_GRADE2;
/
SHOW ERRORS;


INSERT INTO BUYER_DETAILS VALUES('A01','A1001',NULL,3,3);
savepoint sp1;
INSERT INTO BUYER_DETAILS VALUES('A02','B2001',NULL,2,4);
savepoint sp2;
INSERT INTO BUYER_DETAILS VALUES('A03','B2002',NULL,2,2);
savepoint sp3;
INSERT INTO BUYER_DETAILS VALUES('A04','A3001',NULL,1,3);
savepoint sp4;
INSERT INTO BUYER_DETAILS VALUES('B03','A3002',NULL,3,2);
savepoint sp5;
INSERT INTO BUYER_DETAILS VALUES('C04','A3003',NULL,4,1);
savepoint sp6;

ROLLBACK TO sp5;

------------------------------------- SELECT ----------------------------------- 
select * from match_details;
select * from ticket_info;
select * from BUYER_DETAILS;

PAUSE Press ENTER to continue 2 ...

select md.match_no,tI.ticket_id,bd.buyer_id from match_details md,TICKET-INFO ti, BUYER_DETAILS bd where 
ti.TICKET_ID = bd.TICKET_ID and ti.match_no = md.match_no and md.match_no and bd.buyer_id = 'A01';
--------------------------------- UPDATE -------------------------
UPDATE match_details set match_vanue = 'KHU',match_time = '23-JUL-2017' where match_no = 1;
select * from match_details;

UPDATE ticket_info set seat_no = 'A-01',seat_typ = 'VIP' where TICKET_ID = 'A1001';
select * from ticket_info;

UPDATE BUYER_DETAILS set ticket_category = 3,no_of_seat_needed = 1 where BUYER_ID = 'A01';
select * from BUYER_DETAILS;

PAUSE Press ENTER to continue 3 ...

------------------------------ ORDER BY + GROUP BY----------------------------------------

------------------------------ Show match order by the day left ---------------------------------
select * from match_details order by TIME_LEFT;

------------------------------ Show TICKET order by the Ticket Category ---------------------------------
select TICKET_CATEGORY,BUYER_ID ,TICKET_ID,TOTAL_PRICE ,NO_OF_SEAT_NEEDED from BUYER_DETAILS order by ticket_category;

------------------------------ Show TICKET order by the No of seat Needed ---------------------------------
select NO_OF_SEAT_NEEDED,BUYER_ID ,TICKET_ID,TOTAL_PRICE ,TICKET_CATEGORY from BUYER_DETAILS order by no_of_seat_needed desc;

------------------------------ Show match order by the match no ---------------------------------
select MATCH_NO,TICKET_ID,SEAT_NO,SEAT_TYP from ticket_info order by match_no;


-------------------- Arrange matches using their Vanue and type ------------------------
select match_vanue,count(match_vanue) as Total_play from match_details group by match_vanue order by total_play ;
select match_typ,count(match_typ) as Total_play from match_details group by match_typ order by total_play ;

-------------------- How many ticket sold in every match --------------------------------
select match_no,count(match_no) as total_buy from ticket_info group by match_no having count(match_no) >= 2  order by total_buy desc;

PAUSE Press ENTER to continue 4 ...

--------------------------------------- How many game plays a team  USING VIEW ----------------------------------------
DROP VIEW mat_play;
DROP VIEW mat_pl;

CREATE VIEW mat_play AS
select team_name1 as team_name,count(team_name1) as played_game from match_details group by team_name1 having count(team_name1) >= 1;

select * from mat_play;

CREATE VIEW mat_pl AS
select team_name2 as team_name,count(team_name2) as played_game from match_details group by team_name2 having count(team_name1) >= 1;

select * from mat_pl;

-------------------------------- END ----------------------------------

---------------------- show all the ticket information that are already sold USING VIEW -----------------------------
DROP VIEW tic_information;
DROP VIEW mat_information;

CREATE VIEW tic_information AS
select  ti.match_no,ti.ticket_id,ti.seat_no,ti.seat_typ from ticket_info ti where ti.match_no in 
(select md.match_no from match_details md,ticket_info ti1 where md.match_no=ti1.match_no);

SELECT * FROM tic_information;

 ---------------------- show all the match information that ticket are sold USING VIEW- ----------------------------
 CREATE VIEW mat_information AS
select md.match_no,md.match_vanue,md.match_time,md.match_typ,md.team_name1,md.team_name2 from match_details md where md.match_no in 
(select ti1.match_no from match_details md1,ticket_info ti1 where md1.match_no=ti1.match_no);

SELECT * FROM mat_information;

PAUSE Press ENTER to continue 5 ...


---------------------- Show the information about buyer into a particular match type --------------------------------

PROMPT Enter a match type to show the information about the buyer..

select bd.buyer_id,bd.ticket_id,bd.no_of_seat_needed as ticket_buy from buyer_details bd 
where bd.ticket_id in(select ti.ticket_id from ticket_info ti,match_details md 
where ti.match_no=md.match_no and md.match_typ='&MATCH_TYP');

---------------------- Show the information about buyer into a particular match value --------------------------------

PROMPT Enter a match vanue to show the information about the buyer..

select bd.buyer_id,bd.ticket_id from buyer_details bd where bd.ticket_id in
(select ti.ticket_id from ticket_info ti,match_details md where ti.match_no=md.match_no
 and md.match_vanue='&match_vanue');

---------------------- Show the information about buyer into a particular team --------------------------------
select bd.buyer_id,bd.ticket_id from buyer_details bd where bd.ticket_id in
(select ti.ticket_id from ticket_info ti,match_details md
where ti.match_no=md.match_no and (md.team_name1='BAN' or md.team_name2 = 'BAN'));

PAUSE Press ENTER to continue 6 ...

------------------------------- LIKE -----------------------------------------
select * from match_details where match_typ like '%GROUP%';
select * from match_details where MATCH_VANUE like '%DHA%';
select * from ticket_info where seat_typ like '%NORMAL%';


------------------------------MINUS,INTERSECT,UNINO ----------------------------

------------------------ Show the information about where a particular match no and a particular ticket category USING VIEW -----------------------
DROP VIEW information1;
DROP VIEW information2;
DROP VIEW information3;

CREATE VIEW information1 AS
select BUYER_ID,ticket_id,total_price,ticket_category from buyer_details where ticket_category = &ticket_category 
minus SELECT bd.BUYER_ID,bd.ticket_id,bd.total_price,bd.ticket_category from buyer_details bd where bd.ticket_id in
(select ti.ticket_id from ticket_info ti where ti.match_no = &match_no );

SELECT * FROM information1;


CREATE VIEW information2 AS
select BUYER_ID,ticket_id,total_price,ticket_category from buyer_details where ticket_category = &ticket_category 
union SELECT bd.BUYER_ID,bd.ticket_id,bd.total_price,bd.ticket_category from buyer_details bd where bd.ticket_id in
(select ti.ticket_id from ticket_info ti where ti.match_no = &match_no );

SELECT * FROM information2;


CREATE VIEW information3 AS
select ticket_id,seat_no,seat_typ from ticket_info where match_no = &match_no 
INTERSECT select ti.ticket_id,ti.seat_no,ti.seat_typ from ticket_info ti where ti.match_no in
(select md.match_no from match_details md where md.match_no = &match_no);

SELECT * FROM information3;

PAUSE Press ENTER to continue 7 ...

------------------------------------ END ------------------------------------


-----------------------------------------  JOIN  -----------------------------------------

------------------------- Show all the buyer information who cut a ticket -------------------------
select bd.buyer_id,ti.seat_no,ti.seat_typ from buyer_details bd join ticket_info ti
USING (ticket_id);

------------------------- Show the ticket information with the match details -----------------------
select match_no,ticket_info.ticket_id,ticket_info.seat_no,ticket_info.seat_typ,match_details.match_vanue,
match_details.match_time,match_details.match_typ,match_details.team_name1,match_details.team_name2
from ticket_info natural join match_details;

------------------------ Show all the match with the ticket details ----------------------------
select m.match_no,m.match_vanue,m.match_time,m.team_name1,m.team_name2,t.ticket_id,t.seat_no,t.seat_typ from match_details m 
left outer join ticket_info t on m.match_no=t.match_no;

select m.match_no,m.match_vanue,m.match_time,m.team_name1,m.team_name2,t.ticket_id,t.seat_no,t.seat_typ from match_details m 
inner join ticket_info t on m.match_no=t.match_no;

------------------------ Show all the ticket with the buyer details ----------------------------
select t.ticket_id,t.seat_no,t.seat_typ,b.buyer_id,b.ticket_category,b.no_of_seat_needed from ticket_info t 
left outer join BUYER_DETAILS b on t.ticket_id=b.ticket_id;

PAUSE Press ENTER to continue 8 ...

-----------------------------------------   END -----------------------------------------------------

---------------------- INSERT DATA INTO ALL_DETAILS TABLE USING THE DATA OF THREE TABLES ----------------------

INSERT INTO ALL_DETAILS SELECT MD.MATCH_NO,TI.TICKET_ID,BD.BUYER_ID FROM MATCH_DETAILS MD,TICKET_INFO TI,BUYER_DETAILS BD 
WHERE MD.MATCH_NO = TI.MATCH_NO AND TI.TICKET_ID = BD.TICKET_ID;


select * from ALL_DETAILS;

PAUSE Press ENTER to continue 9 ...
--------------------------------------- PL/SQL --------------------------------------------

--------------------------------- CURSOR for show all buyer details ---------------------------------------
SET SERVEROUTPUT ON;
DECLARE
      CURSOR buyer_cur IS
        select buyer_id,ticket_id from buyer_details;
        buyer_t  buyer_cur%ROWTYPE;
        counter NUMBER;
        count1  NUMBER;
  BEGIN
  counter:=0;
    select count(buyer_id) into count1 from buyer_details;
      OPEN  buyer_cur;
       LOOP
        FETCH buyer_cur INTO buyer_t;
          counter := counter + 1;
          EXIT WHEN counter > count1; 
          DBMS_OUTPUT.PUT_LINE ('Buyer name: ' || buyer_t.buyer_id ||'  Ticket ID : ' ||  buyer_t.ticket_id );
      END LOOP;
      CLOSE buyer_cur;
end;
/

--------------------------------- CURSOR for show all match details ---------------------------------------
SET SERVEROUTPUT ON;
DECLARE
      CURSOR match_cur IS
        select match_no,match_vanue,match_time,match_typ,team_name1,team_name2,time_left from match_details;
        match_t  match_cur%ROWTYPE;
        counter NUMBER;
        count1  NUMBER;
  BEGIN
  counter:=0;
    select count(match_no) into count1 from match_details;
      OPEN  match_cur;
       LOOP
        FETCH match_cur INTO match_t;
          counter := counter + 1;
          EXIT WHEN counter > count1; 
          DBMS_OUTPUT.PUT_LINE ('Match No : ' || match_t.match_no ||' Match Vanue : ' ||  match_t.match_vanue ||' Match Time : '|| match_t.match_time
                                || ' Match Type : ' || match_t.match_typ || ' Team Name : ' || match_t.team_name1 || ' and Team Name : ' || match_t.team_name2
                                || 'Time Left for the game : ' || match_t.time_left);
      END LOOP;
      CLOSE match_cur;
end;
/

PAUSE Press ENTER to continue 10 ...

------------------------------------------------------- END ----------------------------------------------------


------------------------------------- ADD MATCH using prodedure and user input ----------------------------------------

PROMPT Enter a match details information to ADD a Match..

CREATE OR REPLACE PROCEDURE add_match(
  mno match_details.match_no%TYPE,
  mvl match_details.match_vanue%TYPE,
  mti match_details.match_time%TYPE,
  mty match_details.match_typ%TYPE,
  tn1 match_details.team_name1%TYPE,
  tn2 match_details.team_name2%TYPE,
  tse match_details.total_seat%TYPE,
  tle match_details.time_left%TYPE) IS
BEGIN
  INSERT INTO match_details
  VALUES (mno,mvl,mti,mty,tn1,tn2,tse,tle);
END add_match;
/
SHOW ERRORS
BEGIN
   add_match(&match_no,'&match_vanue','&match_time','&match_typ','&team_name1','&team_name2',&total_seat,null);
END;
/
select * from match_details;

PAUSE Press ENTER to continue 11 ...

 ------------------------------------- UPDATE MATCH-DETAILS using prodedure and user input ----------------------------------------

PROMPT Enter a match details information to update..

CREATE OR REPLACE PROCEDURE upd_match (
  mva match_details.match_vanue%TYPE,
  mti match_details.match_time%TYPE,
  mno match_details.match_no%TYPE) IS
BEGIN
  UPDATE match_details set match_vanue = mva,match_time = mti where match_no = mno;
  EXCEPTION
  WHEN no_data_found THEN 
    RAISE_APPLICATION_ERROR(-20203, 'No match found.');
END upd_match;
/
SHOW ERRORS
BEGIN
  upd_match('&match_vanue','&match_time',&match_no);
END;
/
SHOW ERRORS
select * from match_details;

PAUSE Press ENTER to continue 13 ...

------------------------------------- UPDATE TICKET-INFO using prodedure and user input ----------------------------------------

PROMPT Enter a ticket details information to update..

CREATE OR REPLACE PROCEDURE upd_ticket (
  sno ticket_info.seat_no%TYPE,
  sty ticket_info.seat_typ%TYPE,
  tid ticket_info.ticket_id%TYPE) IS
BEGIN
  UPDATE ticket_info set seat_no = sno,seat_typ = sty where ticket_id = tid;
  EXCEPTION
  WHEN no_data_found THEN 
    RAISE_APPLICATION_ERROR(-20203, 'No ticket found.');
END upd_ticket;
/
SHOW ERRORS
BEGIN
  upd_ticket('&seat_no','&seat_typ','&ticket_id');
END;
/
SHOW ERRor;
select * from ticket_info;

PAUSE Press ENTER to continue 14 ...

------------------------------------- UPDATE BUYER-DETAILS using prodedure and user input ----------------------------------------

PROMPT Enter a buyer details information to update..

CREATE OR REPLACE PROCEDURE upd_BUYER(
  tca BUYER_DETAILS.ticket_category%TYPE,
  nsd BUYER_DETAILS.no_of_seat_needed%TYPE,
  bid BUYER_DETAILS.BUYER_ID%TYPE) IS
BEGIN
 UPDATE BUYER_DETAILS set ticket_category = tca,no_of_seat_needed = nsd where BUYER_ID = bid;

  EXCEPTION
  WHEN no_data_found THEN 
    RAISE_APPLICATION_ERROR(-20203, 'No BUYER found.');
END upd_BUYER;
/
SHOW ERRORS
BEGIN
  upd_BUYER('&ticket_category','&no_of_seat_needed','&BUYER_ID');
END;
/
SHOW ERRor;
select * from BUYER_DETAILS;

PAUSE Press ENTER to continue 15 ...

--------------------------------- Delete any buyer using buyer id ----------------------------------------

PROMPT Enter a buyer id to delete a buyer..

CREATE OR REPLACE PROCEDURE del_buy (
  bid buyer_details.buyer_id%TYPE) IS
BEGIN
  DELETE buyer_details 
  where buyer_id=bid;
  dbms_output.put_line('Delete Ticket Buyer : ' || bid);
END del_buy;
/
SHOW ERRORS
BEGIN
  del_buy('&buyer_id');
END;
/
select * from buyer_details;

PAUSE Press ENTER to continue 16 ...

--------------------- Show ticket available and time left for every match ------------------------
CREATE OR REPLACE PROCEDURE total_tic IS
    timn  ticket_info.match_no%TYPE;
    savl  match_details.TOTAL_SEAT%TYPE;
    dtim  match_details.match_time%type;
    dtim  match_details.match_time%type;
    diff  NUMBER(10);
BEGIN
  FOR counter IN 1..5
  LOOP
    SELECT count(match_no) into timn
    FROM ticket_info where match_no=counter;
    SELECT min(TOTAL_SEAT - timn) into savl 
    FROM match_details where match_no=counter;
    select  EXTRACT(DAY FROM(MATCH_TIME - systimestamp)) into diff from match_details
    where match_no=counter;
    dbms_output.put_line('Total ticket buy in match  : ' || counter || ' is ' || timn);
    dbms_output.put_line(' And Available is : '|| savl);
    IF diff > 0  THEN
        dbms_output.put_line(' And Time left : '|| diff);
    ELSE
        dbms_output.put_line(' Game is alredy Finished');
    END IF;
  END LOOP;
END total_tic;
/
SHOW ERRORS
SET SERVEROUTPUT ON
BEGIN
  total_tic;
END;
/

PAUSE Press ENTER to continue 17 ...

------------------------------------------------------- END ----------------------------------------------------


-------------------- Using Function Show total ticket sold in all matches -------------------------
CREATE OR REPLACE FUNCTION total_ticket RETURN NUMBER is total NUMBER(4);
BEGIN
    SELECT sum(no_of_seat_needed) into total from buyer_details;
    RETURN total;
END total_ticket;
/
SHOW ERRORS
SET SERVEROUTPUT ON
BEGIN
   dbms_output.put_line('total ticket sold in all matches: ' || total_ticket);
END;
/

PAUSE Press ENTER to continue 18 ...

----------------- Using Function how the number of ticket sold in a particular buyer ---------------

PROMPT Enter the buyer id to show how many ticket he buy..

CREATE OR REPLACE FUNCTION total_ticket1 RETURN NUMBER is total1 NUMBER(4);
BEGIN
    SELECT sum(no_of_seat_needed) into total1 from buyer_details where buyer_id='&buyer_id';
    RETURN total1;
END total_ticket1;
/
SHOW ERRORS
SET SERVEROUTPUT ON
BEGIN
   dbms_output.put_line('total ticket sold : ' || total_ticket1);
END;
/

PAUSE Press ENTER to continue 19 ...

-------------------------------------------- Transaction Management --------------------------------------


-------------------------------------------- ROLLBACK ------------------------------------------

DELETE from match_details;
ROLLBACK;
SELECT * FROM match_details;

DELETE from BUYER_DETAILS;
ROLLBACK;
SELECT * FROM BUYER_DETAILS;

DELETE from TICKET_INFO;
ROLLBACK;
SELECT * FROM TICKET_INFO;

spool off;