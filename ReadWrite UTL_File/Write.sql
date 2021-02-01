--Rameder Carol IIA2
DECLARE
  v_fisier UTL_FILE.FILE_TYPE;
  cursor C1 is SELECT * FROM note;
  J C1%rowtype;

BEGIN
  v_fisier:=UTL_FILE.FOPEN('MYDIR','note.csv','W');
   FOR J IN (SELECT * FROM note)
   --pentru fiecare linie din tabel
  LOOP
  --pun datele pe o linie din fisierul csv
  UTL_FILE.PUT_LINE(v_fisier, J.id||','||J.id_student||','||J.id_curs||','||J.valoare||','||J.data_notare||','||J.created_at||','||J.updated_at);

  END LOOP;
