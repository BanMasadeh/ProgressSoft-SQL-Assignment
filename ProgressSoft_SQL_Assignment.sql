
CREATE TABLE MyDepartment (
    Dept_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL
);


CREATE TABLE Gender (
    Gender_ID NUMBER PRIMARY KEY,
    Name VARCHAR2(20) NOT NULL
);


CREATE TABLE University (
    ID NUMBER PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL
);


CREATE TABLE MyEmployee (
    USERID NUMBER PRIMARY KEY,
    LAST_NAME VARCHAR2(50) NOT NULL,
    FIRST_NAME VARCHAR2(50) NOT NULL,
    HIRE_DATE DATE,
    SALARY NUMBER CHECK (SALARY >= 0),
    DEPT_ID NUMBER,
    Gender_ID NUMBER,
    University_ID NUMBER,
    EMP_IMAGE BLOB,

    CONSTRAINT FK_EMP_DEPT
        FOREIGN KEY (DEPT_ID)
        REFERENCES MyDepartment(Dept_ID),

    CONSTRAINT FK_EMP_GENDER
        FOREIGN KEY (Gender_ID)
        REFERENCES Gender(Gender_ID),

    CONSTRAINT FK_EMP_UNIVERSITY
        FOREIGN KEY (University_ID)
        REFERENCES University(ID)
);


INSERT INTO MyDepartment (Dept_ID, Name)
VALUES (1, 'IT');

INSERT INTO MyDepartment (Dept_ID, Name)
VALUES (2, 'HR');


INSERT INTO Gender (Gender_ID, Name)
VALUES (1, 'Male');

INSERT INTO Gender (Gender_ID, Name)
VALUES (2, 'Female');

INSERT INTO University (ID, Name)
VALUES (1, 'University of Jordan');

INSERT INTO University (ID, Name)
VALUES (2, 'Yarmouk University');


INSERT INTO MyEmployee
    (USERID, LAST_NAME, FIRST_NAME, HIRE_DATE,
     SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES
    (101, 'Ahmad', 'Ahmad', DATE '2020-01-15',
     900, 1, 1, 1);

INSERT INTO MyEmployee
    (USERID, LAST_NAME, FIRST_NAME, HIRE_DATE,
     SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES
    (102, 'Khaled', 'Sara', DATE '2022-06-10',
     1200, 2, 2, 2);

INSERT INTO MyEmployee
    (USERID, LAST_NAME, FIRST_NAME, HIRE_DATE,
     SALARY, DEPT_ID, Gender_ID, University_ID)
VALUES
    (103, 'Omar', 'Omar', DATE '2021-03-20',
     1000, 1, 1, 2);





INSERT INTO MyEmployee
    (USERID, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES
    (201, 'SCOTT', 'KING', DATE '1987-09-09');

INSERT INTO MyEmployee
    (USERID, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES
    (202, 'Ahmad', 'Ali', DATE '1987-10-10');

INSERT INTO MyEmployee
    (USERID, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES
    (203, 'Rami', 'Omar', DATE '1988-05-24');





CREATE OR REPLACE FUNCTION F_HR_QUERY
RETURN SYS_REFCURSOR
IS
    emp_result SYS_REFCURSOR;
    scott_date DATE;
BEGIN
    SELECT HIRE_DATE
    INTO scott_date
    FROM MyEmployee
    WHERE UPPER(FIRST_NAME) = 'SCOTT';

    OPEN emp_result FOR
        SELECT FIRST_NAME || ' ' || LAST_NAME AS EMPLOYEE_NAME,
               HIRE_DATE
        FROM MyEmployee
        WHERE HIRE_DATE > scott_date;

    RETURN emp_result;
END;
/


CREATE TABLE MyEmployee_update AS
SELECT *
FROM MyEmployee
WHERE 1 = 0;


CREATE OR REPLACE PROCEDURE P_COPY_EMPLOYEE
IS
BEGIN
    INSERT INTO MyEmployee_update
    SELECT *
    FROM MyEmployee;

    COMMIT;
END;
/


BEGIN
    P_COPY_EMPLOYEE;
END;
/



SELECT *
FROM MyEmployee_update;







DECLARE
    result_cursor SYS_REFCURSOR;
    emp_name VARCHAR2(100);
    emp_date DATE;
BEGIN
    result_cursor := F_HR_QUERY;

    LOOP
        FETCH result_cursor INTO emp_name, emp_date;
        EXIT WHEN result_cursor%NOTFOUND;

        DBMS_OUTPUT.PUT_LINE(
            emp_name || ' - ' || TO_CHAR(emp_date, 'DD-MM-YYYY')
        );
    END LOOP;

    CLOSE result_cursor;
END;
/


DELETE FROM MyEmployee;

SELECT * FROM MyEmployee;


INSERT INTO MyEmployee (USERID, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES (201, 'SCOTT', 'KING', DATE '1987-09-09');

INSERT INTO MyEmployee (USERID, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES (202, 'Ahmad', 'Ahmad', DATE '1980-10-10');

INSERT INTO MyEmployee (USERID, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES (203, 'Rami', 'Rami', DATE '1986-05-24');

INSERT INTO MyEmployee (USERID, FIRST_NAME, LAST_NAME, HIRE_DATE)
VALUES (204, 'Lina', 'Hassan', DATE '1988-03-15');



SELECT table_name
FROM user_tables
WHERE table_name IN (
    'MYEMPLOYEE',
    'MYDEPARTMENT',
    'GENDER',
    'UNIVERSITY',
    'MYEMPLOYEE_UPDATE'
);