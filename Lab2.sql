set SERVEROUTPUT ON;

CREATE OR REPLACE PROCEDURE my_proc (p_value1 IN INTEGER, p_value2 IN INTEGER, p_cmmdc OUT INTEGER, p_cmmmc OUT INTEGER) AS


   v_produs integer := p_value1*p_value2;
   v_cv1 integer := p_value1;
   v_cv2 integer := p_value2;
BEGIN
   while ( v_cv1 != v_cv2 ) loop
        if( v_cv1 > v_cv2 ) then
            v_cv1 := v_cv1 - v_cv2;
        else
            v_cv2 := v_cv2 - v_cv1 ;
            end if;
    end loop;
    p_cmmdc := v_cv1;
    p_cmmmc := v_produs/v_cv1 ;
END my_proc;

CREATE OR REPLACE FUNCTION CMMDC(p_value1 INTEGER, p_value2  INTEGER)
RETURN INtEGER AS
   v_produs integer := p_value1*p_value2;
   v_cv1 integer := p_value1;
   v_cv2 integer := p_value2;
   v_cmmdc integer;
   v_cmmmc integer;
BEGIN
   while ( v_cv1 != v_cv2 ) loop
        if( v_cv1 > v_cv2 ) then
            v_cv1 := v_cv1 - v_cv2;
        else
            v_cv2 := v_cv2 - v_cv1 ;
            end if;
    end loop;
    v_cmmdc := v_cv1;
    v_cmmmc := v_produs/v_cv1 ;
    return v_cmmdc;
END;

CREATE OR REPLACE FUNCTION CMMMC(p_value1 INTEGER, p_value2  INTEGER)
RETURN INtEGER AS
   v_produs integer := p_value1*p_value2;
   v_cv1 integer := p_value1;
   v_cv2 integer := p_value2;
   v_cmmdc integer;
   v_cmmmc integer;
BEGIN
   while ( v_cv1 != v_cv2 ) loop
        if( v_cv1 > v_cv2 ) then
            v_cv1 := v_cv1 - v_cv2;
        else
            v_cv2 := v_cv2 - v_cv1 ;
            end if;
    end loop;
    v_cmmdc := v_cv1;
    v_cmmmc := v_produs/v_cv1 ;
    return v_cmmmc;
END;

CREATE OR REPLACE PACKAGE BODY myPack IS

    nume_grupa1 VARCHAR2(2) := 'A1';
    nume_grupa2 VARCHAR2(2) := 'A2';
    FUNCTION CMMMC(p_value1 INTEGER, p_value2  INTEGER)
RETURN INtEGER AS
   v_produs integer := p_value1*p_value2;
   v_cv1 integer := p_value1;
   v_cv2 integer := p_value2;
   v_cmmdc integer;
   v_cmmmc integer;
BEGIN
   while ( v_cv1 != v_cv2 ) loop
        if( v_cv1 > v_cv2 ) then
            v_cv1 := v_cv1 - v_cv2;
        else
            v_cv2 := v_cv2 - v_cv1 ;
            end if;
    end loop;
    v_cmmdc := v_cv1;
    v_cmmmc := v_produs/v_cv1 ;
    return v_cmmmc;
END;
       FUNCTION CMMDC(p_value1 INTEGER, p_value2  INTEGER)
RETURN INtEGER AS
   v_produs integer := p_value1*p_value2;
   v_cv1 integer := p_value1;
   v_cv2 integer := p_value2;
   v_cmmdc integer;
   v_cmmmc integer;
BEGIN
   while ( v_cv1 != v_cv2 ) loop
        if( v_cv1 > v_cv2 ) then
            v_cv1 := v_cv1 - v_cv2;
        else
            v_cv2 := v_cv2 - v_cv1 ;
            end if;
    end loop;
    v_cmmdc := v_cv1;
    v_cmmmc := v_produs/v_cv1 ;
    return v_cmmdc;
END;

    PROCEDURE my_proc (p_value1 IN INTEGER, p_value2 IN INTEGER, p_cmmdc OUT INTEGER, p_cmmmc OUT INTEGER) AS

   v_produs integer := p_value1*p_value2;
   v_cv1 integer := p_value1;
   v_cv2 integer := p_value2;
BEGIN
   while ( v_cv1 != v_cv2 ) loop
        if( v_cv1 > v_cv2 ) then
            v_cv1 := v_cv1 - v_cv2;
        else
            v_cv2 := v_cv2 - v_cv1 ;
            end if;
    end loop;
    p_cmmdc := v_cv1;
    p_cmmmc := v_produs/v_cv1 ;
END my_proc;


END myPack;

/

declare
   v_value1 integer := &i_value1;
   v_value2 integer := &i_value2;
   v_cmmdc integer;
   v_cmmmc integer;
Begin
my_proc(v_value1,v_value2,v_cmmdc,v_cmmmc);
DBMS_OUTPUT.PUT_LINE( v_cmmdc||' '||v_cmmmc );
v_cmmmc := CMMMC(v_value1,v_value2);
v_cmmdc := CMMDC(v_value1,v_value2);
DBMS_OUTPUT.PUT_LINE( v_cmmdc||' '||v_cmmmc );
end;
/