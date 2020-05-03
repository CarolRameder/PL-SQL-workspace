set serveroutput on;
--functie decodificare tip
CREATE OR REPLACE FUNCTION getType(v_rec_tab DBMS_SQL.DESC_TAB, v_nr_col int) RETURN VARCHAR2 AS
  v_tip_coloana VARCHAR2(200);
  v_precizie VARCHAR2(40);
BEGIN
     CASE (v_rec_tab(v_nr_col).col_type)
        WHEN 1 THEN v_tip_coloana := 'VARCHAR2'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        WHEN 2 THEN v_tip_coloana := 'NUMBER'; v_precizie := '(' || v_rec_tab(v_nr_col).col_precision || ',' || v_rec_tab(v_nr_col).col_scale || ')';
        WHEN 12 THEN v_tip_coloana := 'DATE'; v_precizie := '';
        WHEN 96 THEN v_tip_coloana := 'CHAR'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        WHEN 112 THEN v_tip_coloana := 'CLOB'; v_precizie := '';
        WHEN 113 THEN v_tip_coloana := 'BLOB'; v_precizie := '';
        WHEN 109 THEN v_tip_coloana := 'XMLTYPE'; v_precizie := '';
        WHEN 101 THEN v_tip_coloana := 'BINARY_DOUBLE'; v_precizie := '';
        WHEN 100 THEN v_tip_coloana := 'BINARY_FLOAT'; v_precizie := '';
        WHEN 8 THEN v_tip_coloana := 'LONG'; v_precizie := '';
        WHEN 180 THEN v_tip_coloana := 'TIMESTAMP'; v_precizie :='(' || v_rec_tab(v_nr_col).col_scale || ')';
        WHEN 181 THEN v_tip_coloana := 'TIMESTAMP' || '(' || v_rec_tab(v_nr_col).col_scale || ') ' || 'WITH TIME ZONE'; v_precizie := '';
        WHEN 231 THEN v_tip_coloana := 'TIMESTAMP' || '(' || v_rec_tab(v_nr_col).col_scale || ') ' || 'WITH LOCAL TIME ZONE'; v_precizie := '';
        WHEN 114 THEN v_tip_coloana := 'BFILE'; v_precizie := '';
        WHEN 23 THEN v_tip_coloana := 'RAW'; v_precizie := '(' || v_rec_tab(v_nr_col).col_max_len || ')';
        WHEN 11 THEN v_tip_coloana := 'ROWID'; v_precizie := '';
        WHEN 109 THEN v_tip_coloana := 'URITYPE'; v_precizie := '';
      END CASE;
      RETURN v_tip_coloana||v_precizie;
END;
/


create or replace procedure creaza_catalog (id_materie IN int) as
   v_cursor_id INTEGER;
   v_cursor2 INTEGER;
   v_cursor3 INTEGER;
   v_cursor INTEGER;
   
   v_ok INTEGER;
   v_rec_tab  DBMS_SQL.DESC_TAB;
   v_nr_col   NUMBER;
   v_total_coloane   NUMBER; 
   
   nr integer;
   v_titluCurs varchar2(30);
   
   val note.valoare%type;
   dataNot date;
   nume studenti.nume%type;
   prenume studenti.nume%type;
   matr studenti.nr_matricol%type;
   
   tip varchar2(20);
   tipValoare varchar2(20);
   tipData varchar2(20);
   tipNume varchar2(20);
   tipPrenume varchar2(20);
   tipMatricol varchar2(20);
   
begin
  select trim(titlu_curs) into v_titluCurs from cursuri where id=id_materie;
  
  --aflu tipurile coloanelor
  v_cursor3  := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cursor3 , 'select valoare, data_notare, nume, prenume, nr_matricol 
                             from studenti   JOIN note on studenti.id=note.ID_STUDENT 
                             where id_curs = '||id_materie, DBMS_SQL.NATIVE);
  v_ok := DBMS_SQL.EXECUTE(v_cursor3 );
  DBMS_SQL.DESCRIBE_COLUMNS(v_cursor3, v_total_coloane, v_rec_tab);
  v_nr_col := v_rec_tab.first;
  nr:=1;
  IF (v_nr_col IS NOT NULL) THEN
    LOOP
      
      nr:=nr+1;
      tip:=gettype(v_rec_tab,v_nr_col);
      if(nr=1)then tipValoare:=tip; END IF;
      if(nr=2)then tipData:=tip; END IF;
      if(nr=3)then tipNume:=tip; END IF;
      if(nr=4)then tipPrenume:=tip; END IF;
      if(nr=5)then tipMatricol:=tip; END IF;
      v_nr_col := v_rec_tab.next(v_nr_col);
      nr:=nr+1;
      EXIT WHEN (v_nr_col IS NULL);
    END LOOP;
  END IF;
  DBMS_SQL.CLOSE_CURSOR(v_cursor3);
  
  --creez tabelul 
  v_cursor_id := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cursor_id, 'CREATE TABLE '|| v_titluCurs ||' ( nota ' || tipValoare ||' , data_notare' || tipData ||' , nume ' || tipNume ||' NOT NULL, prenume '|| tipPrenume || ' NOT NULL, nr_matricol '|| tipMatricol ||' NOT NULL)', DBMS_SQL.NATIVE);
  v_ok := DBMS_SQL.EXECUTE(v_cursor_id);
  DBMS_SQL.CLOSE_CURSOR(v_cursor_id);
  
  
  
  ---------------------------------- il umplu cu date
  --pregatesc datele din tabelele initiale
  v_cursor2 := DBMS_SQL.OPEN_CURSOR;
  DBMS_SQL.PARSE(v_cursor2, 
                            'select valoare, data_notare, nume, prenume, nr_matricol 
                             from studenti   JOIN note on studenti.id=note.ID_STUDENT 
                             where id_curs = '||id_materie, 
                DBMS_SQL.NATIVE);
  DBMS_SQL.DEFINE_COLUMN(v_cursor2, 1, val); 
  DBMS_SQL.DEFINE_COLUMN(v_cursor2, 2, dataNot,20); 
  DBMS_SQL.DEFINE_COLUMN(v_cursor2, 3, nume,15);   
  DBMS_SQL.DEFINE_COLUMN(v_cursor2, 4, prenume,30);   
  DBMS_SQL.DEFINE_COLUMN(v_cursor2, 5, matr,6);   
   v_ok := DBMS_SQL.EXECUTE(v_cursor2); 
  
   LOOP 
     IF DBMS_SQL.FETCH_ROWS(v_cursor2)>0 THEN 
         DBMS_SQL.COLUMN_VALUE(v_cursor2, 1, val); 
         DBMS_SQL.COLUMN_VALUE(v_cursor2, 2, dataNot); 
         DBMS_SQL.COLUMN_VALUE(v_cursor2, 3, nume); 
         DBMS_SQL.COLUMN_VALUE(v_cursor2, 4, prenume); 
         DBMS_SQL.COLUMN_VALUE(v_cursor2, 5, matr);    
 
         --inserez 
          v_cursor := DBMS_SQL.OPEN_CURSOR;
          DBMS_SQL.PARSE(v_cursor, 'insert into '||v_titluCurs||' (nota,data_notare,nume,prenume,nr_matricol) values ( ' || val ||' , '|| dataNot ||' , '|| nume || ' , ' || prenume ||' ,'|| matr ||' )', DBMS_SQL.NATIVE);
          v_ok := DBMS_SQL.EXECUTE(v_cursor);
          DBMS_SQL.CLOSE_CURSOR(v_cursor);
      ELSE 
        EXIT; 
      END IF; 
  END LOOP;   
  
end; 



--bloc anonim testare
begin
  creaza_catalog(3);
end; 


