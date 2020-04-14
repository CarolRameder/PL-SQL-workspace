CREATE OR REPLACE TYPE autom AS OBJECT
(marca varchar2(12),
 model_car varchar2(10),
 cai_putere number(3),
 pret number(5),
 data_fabricatie date,
 NOT FINAL member procedure afiseaza_detalii,
 map member FUNCTION age RETURN integer, 
 CONSTRUCTOR FUNCTION autom(marca varchar2,model_car varchar2,cai_putere number)
    RETURN SELF AS RESULT
) NOT FINAL;

/ 

CREATE OR REPLACE TYPE BODY autom AS
   NOT FINAL MEMBER PROCEDURE afiseaza_detalii IS
   BEGIN
       DBMS_OUTPUT.PUT_LINE('Masina '||self.marca||' '||self.model_car||' are '||self.cai_putere||' cai putere si a costat '||self.pret||' euro.');
   END afiseaza_detalii;
   
   map member FUNCTION age RETURN integer IS
   BEGIN
        return sysdate - SELF.data_fabricatie;
   END age;
   
   CONSTRUCTOR FUNCTION autom (marca varchar2, model_car varchar2,cai_putere number)
    RETURN SELF AS RESULT
  AS
  BEGIN
    SELF.marca := marca;
    SELF.model_car :=model_car ;
    SELF.cai_putere := cai_putere;
    SELF.pret := 10000;
    SELF.data_fabricatie := sysdate;
    RETURN;
  END;
END;

/

drop type electric_autom;

CREATE OR REPLACE TYPE electric_autom UNDER autom
(    
   autonomy number(3),
   OVERRIDING member procedure afiseaza_detalii
)
/
CREATE OR REPLACE TYPE BODY electric_autom AS
    OVERRIDING MEMBER PROCEDURE afiseaza_detalii IS
    BEGIN
       dbms_output.put_line('Masina electrica '||self.marca||' '||self.model_car||' are autonomia de '||self.autonomy||' km.');
    END afiseaza_detalii;
END;

/

DROP TABLE myTable;
/
CREATE TABLE myTable (id number(1), obiect autom);
/

set serveroutput on;

DECLARE

   v_car1 autom;
   v_car2 autom;
   v_car3 autom;
   v_car4 electric_autom;
   
BEGIN

   v_car1 := autom('Skoda', 'Octavia', 120,21000 , TO_DATE('11/04/1994', 'dd/mm/yyyy'));
   v_car2 := autom('Volkswagen', 'Golf', 150,25000 , TO_DATE('11/04/1994', 'dd/mm/yyyy'));
   v_car3 := autom('Audi','A7',250);
   v_car1 := electric_autom('Tesla', 'ModelS', 400,60000, TO_DATE('11/04/1994', 'dd/mm/yyyy'),600 );
   v_car3.afiseaza_detalii();
   v_car1.afiseaza_detalii();
   dbms_output.put_line(v_car1.age);
   insert into myTable values (1, v_car1);
   insert into myTable values (2, v_car2);
   insert into myTable values (3 , v_car3);

END;
/
select * from myTable order by obiect;