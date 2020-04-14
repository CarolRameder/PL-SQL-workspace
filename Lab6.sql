set serveroutput on;

ALTER TABLE note ADD constraint c1 UNIQUE(id_student,id_curs) ; 

/

CREATE OR REPLACE FUNCTION methodCount(p_id_student INT) 
RETURN VARCHAR2
AS
      v_mesaj VARCHAR2(20); 
      v_nr_note int := 0; 
      v int :=1; 
      v_idLogica int; 
BEGIN

      SELECT id INTO v_idLogica FROM cursuri WHERE cursuri.titlu_curs LIKE 'Logic%';
      FOR v IN 1..100000 LOOP
        SELECT COUNT(*) INTO  v_nr_note FROM note WHERE id_student=p_id_student and id_curs=v_idLogica;   
        IF (v_nr_note =0)
          THEN
          v_mesaj := 'Nota a fost inserata';
          INSERT INTO note VALUES(10,p_id_student,v_idLogica,7,SYSDATE,SYSDATE,SYSDATE);
        ELSE v_mesaj := 'Eroare'; 
        END IF;
      END LOOP;
  return v_mesaj;
END;

/

CREATE OR REPLACE FUNCTION methodException(p_id_student INT)
RETURN VARCHAR2
AS
   v_counter INT:= 1;
   v_mesaj VARCHAR2(20):='Nota a fost inserata';
   v_idLogica int;
BEGIN
SELECT id INTO v_idLogica FROM cursuri WHERE cursuri.titlu_curs LIKE 'Logic%';
  
    FOR v_counter IN 1..100 LOOP
        INSERT INTO note VALUES(10,p_id_student,v_idLogica,7,SYSDATE,SYSDATE,SYSDATE); 
        END LOOP;
EXCEPTION 
     WHEN DUP_VAL_ON_INDEX THEN v_mesaj :='Eroare';

   return v_mesaj;
END;
/

CREATE OR REPLACE FUNCTION medie(numeS IN STUDENTI.NUME%type, prenumeS  IN STUDENTI.PRENUME%type)
RETURN INTEGER AS
medie_val INTEGER;
counter      INTEGER;
Begin
Select avg(valoare)  into medie_val
 from studenti join note on studenti.id=note.id
 where numeS = studenti.nume and prenumeS = studenti.prenume ;
 
return medie_val;
EXCEPTION
WHEN no_data_found THEN
  SELECT COUNT(*) INTO counter FROM studenti where numeS = studenti.nume and prenumeS = studenti.prenume ;
  IF counter = 0 THEN
    raise_application_error (-20003,'Studentul cu numele ' || numeS ||'si prenumele'||prenumeS ||' nu exista in baza de date.');
     ELSE
    SELECT COUNT(*) INTO counter from studenti join note on studenti.id=note.id WHERE numeS = studenti.nume and prenumeS = studenti.prenume;
    IF counter = 0 THEN
      raise_application_error (-20004,'Studentul cu numele ' || numeS ||'si prenumele'||prenumeS ||' nu are nici o nota.');
    END IF;
  END IF;
END medie;

/

CREATE TABLE STUDSS (NUME varchar2(20), PRENUME varchar2(20));

declare
   
   TYPE stud1 IS RECORD(
      nume varchar2(20) := 'Nume1', 
      prenume varchar2(20) := 'prenume1'
      );
   v_stud1 stud1; 

TYPE stud2 IS RECORD(
      nume varchar2(20) := 'Nume2', 
      prenume varchar2(20) := 'prenume2'
      );
   v_stud2 stud2; 
   TYPE stud3 IS RECORD(
      nume varchar2(20) := 'Nume3', 
      prenume varchar2(20) := 'prenume3'
      );
   v_stud3 stud3; 
    TYPE stud4 IS RECORD(
      nume varchar2(20) := 'Bradea', 
      prenume varchar2(20) := 'Andreia'
      );
   v_stud4 stud4; 

TYPE stud5 IS RECORD(
      nume varchar2(20) := 'Dogaru', 
      prenume varchar2(20) := 'Ecaterina'
      );
   v_stud5 stud5; 
   TYPE stud6 IS RECORD(
      nume varchar2(20) := 'Minuti', 
      prenume varchar2(20) := 'Ecaterina'
      );
   v_stud6 stud6; 
   avrg integer;
   notaRec integer;
   v_mesaj1 VARCHAR2(32767);
   v_mesaj2 VARCHAR2(32767);
Begin
INSERT INTO STUDSS VALUES v_stud1;
INSERT INTO STUDSS VALUES v_stud2;
INSERT INTO STUDSS VALUES v_stud3;
INSERT INTO STUDSS VALUES v_stud4;
INSERT INTO STUDSS VALUES v_stud5;
INSERT INTO STUDSS VALUES v_stud6;
avrg := medie(v_stud4.nume,v_stud4.prenume);
DBMS_OUTPUT.PUT_LINE(avrg);
v_mesaj1:=methodException(33);
v_mesaj2:=methodCount(33);
DBMS_OUTPUT.PUT_LINE(v_mesaj1);
DBMS_OUTPUT.PUT_LINE(v_mesaj2);
end;
/