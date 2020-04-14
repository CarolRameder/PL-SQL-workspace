--Rameder Carol IIA2
-- am considerat cazurile posibile date in enunt ca fiind de la 1-5
set serveroutput on;

create view newView as 
select nume,prenume,valoare,titlu_curs from
studenti   JOIN note on studenti.id=note.ID_STUDENT JOIN cursuri on note.ID_CURS=cursuri.ID ;

/

--caz1
CREATE OR REPLACE TRIGGER stergere
   INSTEAD OF delete ON newView
DECLARE
newID int;
BEGIN

   select id into newID from studenti where nume like :OLD.nume and prenume LIKE :OLD.prenume;
   
  delete from note where id_student=newID;
  delete from studenti where id= newID;
END;
/
delete from newView where nume like 'Bute' and prenume like 'Paula';
select * from studenti where nume like 'Bute'and prenume like 'Paula';
/ 

CREATE OR REPLACE TRIGGER inserts
   INSTEAD OF insert ON newView
DECLARE

countS int;
countC int;
rand_bursa studenti.bursa%type;
rand_an number(2);
rand_data_nastere date;
rand_grupa char(2);
rand_matricol varchar(6);
rand_semestru number(1);
rand_credite number(2);
rand_email varchar(40);
new_id_S int;
new_id_N int;
new_id_C int;

BEGIN

  rand_credite:=TRUNC(DBMS_RANDOM.VALUE(0,6))+1;
  rand_an:=TRUNC(DBMS_RANDOM.VALUE(0,3))+1;
  rand_semestru:=TRUNC(DBMS_RANDOM.VALUE(0,2))+1;
  rand_bursa:=TRUNC(DBMS_RANDOM.VALUE(0,650));
  rand_email := ('newMember@info.uaic.ro');
  rand_data_nastere := (sysdate-TRUNC(DBMS_RANDOM.VALUE(0,6000)));
  rand_grupa := 'B9';--hardcoded
  rand_matricol := '999XX9';--hardcoded

  Select count(*) into countS from studenti where nume like :NEW.nume and prenume like :NEW.prenume;
  Select count(*) into countC from cursuri where titlu_curs like :NEW.titlu_curs;

--caz 2
  IF (countC =1 AND countS = 0) THEN
  
    select count(*) into new_id_N from note; new_id_N:=new_id_N+1;
    select count(*) into new_id_S from studenti; new_id_S:=new_id_S+1;
    Select id into new_id_C from cursuri where titlu_curs like :NEW.titlu_curs;
   
   INSERT INTO studenti(id, nr_matricol, nume, prenume, an, bursa, created_at, updated_at, data_nastere, grupa, email)
   VALUES(new_id_S, rand_matricol, :NEW.nume, :NEW.prenume ,rand_an , rand_bursa, SYSDATE, SYSDATE, rand_data_nastere, rand_grupa, rand_email);
   
   INSERT INTO note(id, id_student,id_curs,valoare,data_notare,created_at,updated_at)
   VALUES(new_id_N , new_id_S , new_id_C , :NEW.valoare , SYSDATE , SYSDATE , SYSDATE);
   
  END IF;


--caz3
  IF ( countS = 1 AND countC =0 ) THEN
  
   select count(*) into new_id_C from cursuri ;  new_id_C := new_id_C+1;
   select count(*) into new_id_N from note ; new_id_N := new_id_N+1;
   Select id into new_id_S from studenti where nume like :NEW.nume and prenume like :NEW.prenume;
  
   INSERT INTO cursuri(id , titlu_curs , an , semestru , credite , created_at , updated_at )
   VALUES( new_id_C , :NEW.titlu_curs , rand_an , rand_semestru , rand_credite , SYSDATE , SYSDATE);
   
   INSERT INTO note(id , id_student , id_curs , valoare , data_notare , created_at , updated_at)
   VALUES(new_id_N , new_id_S , new_id_C , :NEW.valoare , SYSDATE , SYSDATE , SYSDATE);

  END IF;


  --caz4
  IF (countC =0 AND countS = 0) THEN
   
   select count(*) into new_id_S from studenti; new_id_S := new_id_S+1;
    select count(*) into new_id_C from cursuri; new_id_C := new_id_C+1;
   select count(*) into new_id_N from note; new_id_N := new_id_N+1;

   INSERT INTO studenti(id, nr_matricol, nume, prenume, an, bursa, created_at, updated_at, data_nastere, grupa, email) 
   VALUES(new_id_S, rand_matricol, :NEW.nume, :NEW.prenume ,rand_an , rand_bursa, SYSDATE, SYSDATE, rand_data_nastere, rand_grupa, rand_email);
   
 INSERT INTO cursuri(id , titlu_curs , an , semestru , credite , created_at , updated_at )
 VALUES( new_id_C , :NEW.titlu_curs , rand_an , rand_semestru , rand_credite , SYSDATE , SYSDATE);
 
   INSERT INTO note(id , id_student , id_curs , valoare , data_notare , created_at , updated_at) 
   VALUES(new_id_N , new_id_S , new_id_C , :NEW.valoare , SYSDATE , SYSDATE , SYSDATE);

  END IF;

END;

/

--caz2
insert into newView values('Nume2','Prenume2',6,'Logica');
select * from studenti where nume like 'Nume2';
--caz3
insert into newView values('Bute','Paula',8,'sculptura');

--caz4 
insert into newView values('Edward2','Williams2',7,'fishing');
select * from studenti where nume like 'Edward2';

--caz5
CREATE OR REPLACE TRIGGER marire
  INSTEAD OF UPDATE ON newView
  DECLARE
newID int;
BEGIN

  
  IF (:OLD.valoare<:NEW.valoare) THEN
  
  select id into newID from studenti where nume like :NEW.nume and prenume like :NEW.prenume;
  update note set valoare=:NEW.valoare where id_student = newID;
  update note set updated_at=:SYSDATE where id_student= newID;

  end if;
END;
/

update newView set valoare=9 where nume like 'Bute' and prenume like 'Paula';
select * from studenti where nume like 'Bute'and prenume like 'Paula';
/

