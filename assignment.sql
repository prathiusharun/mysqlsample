-- 4th question, Display days as comma separated for each training.

CREATE DATABASE IF NOT EXISTS task;
USE task;

DROP TABLE IF EXISTS sessions;

CREATE TABLE sessions (
    TrainingID  INT AUTO_INCREMENT PRIMARY KEY,
    Training VARCHAR(255) NOT NULL,
    ClassRoom VARCHAR(255) NOT NULL,
    StartTime TIME NOT NULL,
    Duration TIME NOT NULL,
    Wk VARCHAR(255) NOT NULL
);

SELECT * FROM SESSIONS;


INSERT INTO sessions (Training, ClassRoom, StartTime, Duration, Wk)
VALUES ('SQL SERVER', 'Silver-Room', '10:00', '02:00', 'M'),
	   ('SQL SERVER', 'Silver-Room', '10:00', '02:00', 'W'),
	   ('SQL SERVER', 'Silver-Room', '10:00', '02:00', 'T'),
	   ('SQL SERVER', 'Silver-Room', '10:00', '02:00', 'F'),
	   ('ASP.NET', 'Cloud-Room', '11:00', '1:45', 'F'),
	   ('ASP.NET', 'Cloud-Room', '11:00', '1:45', 'M'),
	   ('ASP.NET', 'Cloud-Room', '11:00', '1:45', 'TH');

SELECT
    Training,
    ClassRoom,
    TIME_FORMAT(StartTime, '%H:%i') AS StartTime,
    TIME_FORMAT(Duration, '%H:%i') AS Duration,
    GROUP_CONCAT(Wk SEPARATOR ',') AS Weeks
FROM
    sessions
GROUP BY
    Training,
    ClassRoom,
    StartTime,
    Duration
ORDER BY
    CASE
        WHEN Training = 'ASP.NET' THEN 2
        WHEN Training = 'SQL SERVER' THEN 1
        ELSE 3
    END;


-- 8th question, Find the First and Last day of Current Month for Last Year from Current Date.

-- Sample Input - 2024-01-26
SELECT DATE_FORMAT(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL DAYOFMONTH(NOW()) - 1 DAY), '%d/%m/%Y') AS LastYearFirstDate;

SELECT DATE_FORMAT(LAST_DAY(DATE_SUB(DATE_SUB(NOW(), INTERVAL 1 YEAR), INTERVAL DAYOFMONTH(NOW()) - 1 DAY)), '%d/%m/%Y') AS LastYearLastDate;

-- 12th question, Write a query that shows employee name, manager and the manager's manager name.

CREATE DATABASE IF NOT EXISTS worker;
USE worker;

DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    EmpID INT AUTO_INCREMENT PRIMARY KEY ,
    EmpName VARCHAR(255),
    ReportsTo INT,
    Manager VARCHAR(255),
    ManagersManager VARCHAR(255)
);

INSERT INTO employee (EmpName, ReportsTo, Manager, ManagersManager)
VALUES('Jacob', NULL, '', ''),
	  ('Rui', NULL, '', ''),
	  ('Jacobson', NULL, '', ''),
	  ('Jess', 1, '', ''),
	  ('Steve', 1, '', ''),
	  ('Bob', 1, '', ''),
	  ('Smith', 2, '', ''),
	  ('Bobbey', 2, '', ''),
	  ('Steffi', 3, '', ''),
	  ('Bracha', 3, '', ''),
	  ('John', 5, '', ''),
	  ('Micheal', 6, '', ''),
	  ('Paul', 6, '', ''),
	  ('Johnson', 7, '', ''),
	  ('Mic', 8, '', ''),
	  ('Stev', 8, '', ''),
	  ('Paulson', 9, '', ''),
	  ('Jessica', 10, '', '');
SELECT * FROM EMPLOYEE;

SELECT
    e1.EmpName AS Employee,
    e2.EmpName AS Manager,
    e3.EmpName AS ManagersManager
FROM
    employee e1
LEFT JOIN
    employee e2 ON e1.ReportsTo = e2.EmpID
LEFT JOIN
    employee e3 ON e2.ReportsTo = e3.EmpID;
    
-- 16th question, Remove leading and trailing commas from a string

CREATE DATABASE IF NOT EXISTS cable;
USE cable;

DROP TABLE IF EXISTS text;

CREATE TABLE text (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Val TEXT,
    NewVal TEXT
);


INSERT INTO text(Val, NewVal)
VALUES(',,Pawan',''),
      (',Pawan,,,,,',''),
      (',',''),
      (',,Hello,',''),
      ('a,a,b,c,,,,,,,,',''),
      (NULL,''),
      ('','');

SELECT * FROM text;

SET SQL_SAFE_UPDATES = 0;


UPDATE text
SET NewVal = IF(Val IS NULL OR Val = ',', NULL, TRIM(BOTH ',' FROM Val));


SELECT * FROM text;

-- 20th question, Find out the extension of the file names present in a table.

CREATE DATABASE IF NOT EXISTS arrange;
USE arrange;

DROP TABLE IF EXISTS book;

CREATE TABLE book (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    fName TEXT,
    Extension VARCHAR(20)
);

SELECT * FROM book; 

INSERT INTO book (fName, Extension)
VALUES('f1.xlsx', ''),
       ('file2.doc', ''),
       ('fl.h', ''),
       ('testfile.abcxyz', ''),
       ('t...est..file.abcxyz', '');

-- UPDATE book
-- SET Extension = CASE
 --   WHEN POSITION('.' IN REVERSE(fName)) > 0 THEN 
   --     REVERSE(SUBSTRING(REVERSE(fName), 1, POSITION('.' IN REVERSE(fName))))
   -- ELSE ''
-- END;

-- SELECT fName, Extension FROM book;


SELECT 
    fName,
    CONCAT('.', SUBSTRING_INDEX(fName, '.', -1)) AS extension
FROM 
    (SELECT 'f1.xlsx' AS fName UNION ALL
     SELECT 'file2.doc' UNION ALL
     SELECT 'fl.h' UNION ALL
     SELECT 'testfile.abcxyz' UNION ALL
     SELECT 't...est..file.abcxyz') AS arrange_book;



