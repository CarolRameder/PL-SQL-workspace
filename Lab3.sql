set serveroutput on;

DECLARE
   v_grupa studenti.grupa%type:=&i_grupa;
   
   CURSOR students_list ( p_grupa studenti.grupa%type) IS
   SELECT nume, prenume 
   FROM studenti 
   WHERE grupa LIKE p_grupa
   AND id IN 
     (SELECT note.id_student 
      FROM note JOIN cursuri ON cursuri.id=note.id_curs 
      WHERE note.valoare=10 
      AND cursuri.titlu_curs='Baze de date');
  v_std_linie students_list%ROWTYPE;
   
BEGIN   
 
   UPDATE note set valoare = valoare + 1 
   WHERE id_student IN 
    (Select id from studenti 
     where studenti.grupa LIKE v_grupa) 
     AND valoare < 10 
     AND id_curs IN 
      (Select id from cursuri 
       where titlu_curs LIKE 'Baze de date');
   IF(SQL%FOUND) 
      THEN
         DBMS_OUTPUT.PUT_LINE('Am updatat nota la ' || SQL%ROWCOUNT || ' studenti.');
      ELSE
         DBMS_OUTPUT.PUT_LINE('Nimanui nu i s a updatat nota');
    END IF;
   
   OPEN students_list (v_grupa);
   LOOP
        FETCH students_list INTO v_std_linie;
        EXIT WHEN students_list%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_std_linie.nume||' '|| v_std_linie.prenume);
    END LOOP;
    CLOSE students_list;
   
   
END;