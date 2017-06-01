spool d:/test1.txt;

--------------------arrange matches using their type exam:group,super,..------------------------
select match_typ,count(match_typ) from match_details group by match_typ;

---------------------------------------how many game plays a team ----------------------------------------
select team_name1 as team_name,count(team_name1) as played_game from match_details group by team_name1;
select team_name2 as team_name,count(team_name2) as played_game from match_details group by team_name2;

---------------------- Show the information about buyer into a particular match type --------------------------------
select bd.buyer_id,bd.ticket_id,bd.no_of_seat_needed as ticket_buy from buyer_details bd 
where bd.ticket_id in(select ti.ticket_id from ticket_info ti,match_details md 
where ti.match_no=md.match_no and md.match_typ='&MATCH_TYP');

---------------------- Show the information about buyer into a particular match value --------------------------------
select bd.buyer_id,bd.ticket_id from buyer_details bd where bd.ticket_id in
(select ti.ticket_id from ticket_info ti,match_details md where ti.match_no=md.match_no
 and md.match_vanue='&match_vanue');

---------------------- Show the information about buyer into a particular team --------------------------------
select bd.buyer_id,bd.ticket_id from buyer_details bd where bd.ticket_id in
(select ti.ticket_id from ticket_info ti,match_details md
where ti.match_no=md.match_no and (md.team_name1='BAN' or md.team_name2 = 'BAN'));

---------------------- Show the information about the ticket  --------------------------------
select tp.match_typ,tp.ti_price from ticket_price tp where tp.ticket_category in 
(select md.ticket_category from match_details md,ticket_info ti,buyer_details bd where
md.match_no=ti.match_no and bd.ticket_id=ti.ticket_id and bd.ticket_id='&ticket_id');


------------------------------INTERSECT and UNINO ----------------------------

------------------------ Show the information about where a particular match no and a particular ticket category -----------------------
select ticket_id,seat_no,seat_typ from ticket_info where match_no = &match_no 
INTERSECT select ti.ticket_id,ti.seat_no,ti.seat_typ from ticket_info ti where ti.match_no in
(select md.match_no from match_details md where md.ticket_category = &ticket_category);

------------------------ Show the information about where a particular match no or a particular ticket category -----------------------
select ticket_id,seat_no,seat_typ from ticket_info where match_no = &match_no
union select ti.ticket_id,ti.seat_no,ti.seat_typ from ticket_info ti where ti.match_no in
(select md.match_no from match_details md where md.ticket_category = &ticket_category);
------------------------------------ END ------------------------------------


---------------------------------- GROUP BY ---------------------------------

---------------------- show all the ticket information that are already sold ----------------------------
select  ti.match_no,ti.ticket_id,ti.seat_no,ti.seat_typ from ticket_info ti where ti.match_no in 
(select md.match_no from match_details md,ticket_info ti1 where md.match_no=ti1.match_no
group by md.match_no);

 ---------------------- show all the match information that ticket are sold ----------------------------
select md.match_no,md.match_vanue,md.match_time,md.match_typ,md.team_name1,md.team_name2 from match_details md where md.match_no in 
(select ti1.match_no from match_details md1,ticket_info ti1 where md1.match_no=ti1.match_no
group by ti1.match_no);
------------------------------------ END -------------------------------------


-----------------------------------------  JOIN  -----------------------------------------

------------------------- Show all the buyer information who cut a ticket -------------------------
select bd.buyer_id,ti.seat_no,ti.seat_typ from buyer_details bd join ticket_info ti
USING (ticket_id);

------------------------- Show the ticket information with the match details -----------------------
select match_no,ticket_info.ticket_id,ticket_info.seat_no,ticket_info.seat_typ,match_details.match_vanue,
match_details.match_time,match_details.match_typ,match_details.team_name1,match_details.team_name2
from ticket_info natural join match_details;

------------------------- Show the available seat for each match --------------------------
select m.match_no,m.match_vanue,m.match_time,m.team_name1,m.team_name2,s.seat_available_in_total from match_details m 
inner join seat_available s on m.match_no=s.match_no;

------------------------ Show all the match with the ticket buyer details ----------------------------
select m.match_no,m.match_vanue,m.match_time,m.team_name1,m.team_name2,t.ticket_id,t.seat_no,t.seat_typ from match_details m 
left outer join ticket_info t on m.match_no=t.match_no;
-----------------------------------------   END -----------------------------------------------------
 

--------------------------------------- PL/SQL --------------------------------------------

-------------------- Show the maximum and minimum ticket price and show all the ticket price ------------------
SET SERVEROUTPUT ON
DECLARE
   counter    NUMBER(2);
   typ     TICKET_PRICE.MATCH_TYP%TYPE;
   price   TICKET_PRICE.TI_PRICE%TYPE;
   max_ti_price ticket_price.ti_price%TYPE;
   min_ti_price ticket_price.ti_price%TYPE;
  
BEGIN
   
   SELECT MAX(ti_price),MIN(ti_price) INTO max_ti_price,min_ti_price FROM ticket_price;
   DBMS_OUTPUT.PUT_LINE('The maximum price is : ' || max_ti_price);
   DBMS_OUTPUT.PUT_LINE('The minimum price is : ' || min_ti_price);

   FOR counter IN 1..4
   LOOP
      SELECT match_typ,ti_price 
      INTO typ,price
      FROM ticket_price where ticket_category = counter;

      DBMS_OUTPUT.PUT_LINE ('Match type : ' || typ);
      DBMS_OUTPUT.PUT_LINE ('Ticket Price : ' || price);
   END LOOP;

   EXCEPTION
      WHEN others THEN
         DBMS_OUTPUT.PUT_LINE (SQLERRM);
END;
/
--------------------------------- END --------------------------------------------


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
        select match_no,match_vanue,match_time,match_typ,team_name1,team_name2 from match_details;
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
                                || ' Match Type : ' || match_t.match_typ || ' Team Name : ' || match_t.team_name1 || ' and Team Name : ' || match_t.team_name2);
      END LOOP;
      CLOSE match_cur;
end;
/
------------------------------------------------------- END ----------------------------------------------------


------------------------------------- ADD MATCH using prodedure and user input ----------------------------------------
CREATE OR REPLACE PROCEDURE add_match(
  mno match_details.match_no%TYPE,
  mvl match_details.match_vanue%TYPE,
  mti match_details.match_time%TYPE,
  mty match_details.match_typ%TYPE,
  tn1 match_details.team_name1%TYPE,
  tn2 match_details.team_name2%TYPE,
  tca match_details.ticket_category%TYPE) IS
BEGIN
  INSERT INTO match_details
  VALUES (mno,mvl,mti,mty,tn1,tn2,tca);
END add_match;
/
SHOW ERRORS
BEGIN
   add_ticket(&match_no,'&match_vanue','&match_time','&match_typ','&team_name1','&team_name2',&ticket_category);
END;
/
select * from match_details;

 ------------------------------------- ADD TICKET using prodedure and user input ----------------------------------------
CREATE OR REPLACE PROCEDURE add_ticket (
  tid ticket_info.ticket_id%TYPE,
  sno ticket_info.seat_no%TYPE,
  sty ticket_info.seat_typ%TYPE,
  mno ticket_info.match_no%TYPE) IS
BEGIN
  INSERT INTO ticket_info
  VALUES (tid,sno,sty,mno);
  EXCEPTION
  WHEN no_data_found THEN 
    RAISE_APPLICATION_ERROR(-20203, 'No ticket found.');
END add_ticket;
/
SHOW ERRORS
BEGIN
   add_ticket('&ticket_id','&seat_no','&seat_typ',&match_no);
END;
/
SHOW ERRor;
select * from ticket_info;

 ------------------------------------- ADD BUYER using prodedure and user input ----------------------------------------
CREATE OR REPLACE PROCEDURE add_buyer (
  bid buyer_details.buyer_id%TYPE,
  tid buyer_details.ticket_id%TYPE,
  nos buyer_details.no_of_seat_needed%TYPE) IS
BEGIN
  INSERT INTO buyer_details (buyer_id,ticket_id,no_of_seat_needed)
  VALUES (bid,tid,nos);
  EXCEPTION
  WHEN no_data_found THEN 
    RAISE_APPLICATION_ERROR(-20203, 'No ticket found.');
END add_buyer;
/
SHOW ERRORS
BEGIN
   add_buyer('&buyer_id','&ticket_id',&no_of_seat_needed);
END;
/
SHOW ERRor;
select * from buyer_details;

--------------------------------- Delete any buyer using buyer id ----------------------------------------
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

--------------------- Show ticket available and time left for every match ------------------------
CREATE OR REPLACE PROCEDURE total_tic IS
    timn  ticket_info.match_no%TYPE;
    savl  seat_available.seat_available_in_total%TYPE;
    dtim  match_details.match_time%type;
    dtim  match_details.match_time%type;
    diff  NUMBER(10);
BEGIN
  FOR counter IN 1..5
  LOOP
  	SELECT count(match_no) into timn
  	FROM ticket_info where match_no=counter;
  	SELECT min(seat_available_in_total - timn) into savl 
  	FROM seat_available where match_no=counter;
  	select 	min(EXTRACT(DAY FROM match_time)-EXTRACT(DAY FROM systimestamp)) into diff from match_details
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
   dbms_output.put_line('total ticket sold : ' || total_ticket);
END;
/

----------------- Using Function how the number of ticket sold in a particular buyer ---------------
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


spool off;