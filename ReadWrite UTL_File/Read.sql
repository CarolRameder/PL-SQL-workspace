--Rameder Carol IIA2
drop table note;

CREATE TABLE noteFinal2 (
  id INT NOT NULL PRIMARY KEY,
  id_student INT NOT NULL,
  id_curs INT NOT NULL,
  valoare NUMBER(2),
  data_notare DATE,
  created_at DATE,
  updated_at DATE,
  CONSTRAINT x FOREIGN KEY (id_student) REFERENCES studenti(id),
  CONSTRAINT y FOREIGN KEY (id_curs) REFERENCES cursuri(id)
)



set serveroutput on;
DECLARE

  v_fisier UTL_FILE.FILE_TYPE;
  v_linie VARCHAR2(200);
  v_idNota number;
  v_idStudent number;
  v_idCurs number;
  valoareNota number;
  v_dataNotare date;
  v_created_at date;
  v_updated_at date;
  
BEGIN
  v_fisier:=UTL_FILE.FOPEN('MYDIR','note.csv','R');
  
  LOOP
  BEGIN
  
  --procesul se repeta pentru fiecare linie din fisier
  UTL_FILE.GET_LINE(v_fisier, v_linie);
  
  --separ linia cu caractere in datele specifice din tabelul note
  v_idNota:=TO_NUMBER(REGEXP_SUBSTR(v_linie, '[^,]+',1,1));
  v_idStudent:=TO_NUMBER(REGEXP_SUBSTR(v_linie, '[^,]+',1,2));
 v_idCurs:=TO_NUMBER(REGEXP_SUBSTR(v_linie, '[^,]+',1,3));
  valoareNota:=TO_NUMBER(REGEXP_SUBSTR(v_linie, '[^,]+',1,4));
  v_dataNotare:=TO_DATE(REGEXP_SUBSTR(v_linie, '[^,]+',1,5), 'DD-MM-YYYY');
  v_created_at:=TO_DATE(REGEXP_SUBSTR(v_linie, '[^,]+',1,6), 'DD-MM-YYYY');
  v_updated_at:=TO_DATE(REGEXP_SUBSTR(v_linie, '[^,]+',1,7), 'DD-MM-YYYY');
  
  --DBMS_OUTPUT.PUT_LINE(v_idNota||' ' || v_idStudent||' ' ||v_idCurs||' ' ||valoareNota||' ' ||v_dataNotare||' ' || v_created_at||' ' || v_updated_at);
  
  --inserez pe linia curenta valorile preluate din fisierul csv
  INSERT INTO noteFinal2
(id, id_student, id_curs,valoare, data_notare, created_at, updated_at)
VALUES
(v_idNota , v_idStudent, v_idCurs,valoareNota,v_dataNotare,v_created_at,v_updated_at);
  EXCEPTION WHEN NO_DATA_FOUND THEN EXIT ; 
  
  END;
  END LOOP;
  
  COMMIT;
  UTL_FILE.FCLOSE(v_fisier);
END;
/
--test
select * from noteFinal2;

