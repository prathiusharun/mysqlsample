SELECT * FROM learning.customer;
DROP TABLE learning.customer;

CREATE TABLE customer
(custID INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(255) NOT NULL,
last_name  VARCHAR(255) NOT NULL,
age INT NOT NULL
);
INSERT INTO customer (custID,first_name,last_name,age)
VALUES('2','Rahul','Dravid','40');

-- UPDATE
UPDATE customer
SET
first_name = 'Sijo',
last_name = 'David',
age = '22'
WHERE custID = '2';

-- DELETE 
DELETE FROM customer WHERE last_name = 'David' AND custID ='2';


INSERT INTO customer (custID,first_name,last_name,age)
VALUES('2','Rahul','Dravid','40');

-- ALTER 
ALTER TABLE customer MODIFY COLUMN last_name VARCHAR(100);

-- TRUNCATE
TRUNCATE TABLE customer;

-- DROP
DROP TABLE customer;

-- TRANSACTIONS
-- Begin a transaction
START TRANSACTION;

-- Delete operation within the transaction
DELETE FROM customer WHERE customerid = 1;

-- Rollback the transaction (to undo the changes)
ROLLBACK;

-- OR

-- Commit the transaction (to apply the changes)
COMMIT;

-- Select statement to view the data
SELECT * FROM customer;

--  Datatype: Integer


ALTER TABLE customer
ADD COLUMN num INT DEFAULT 0;

 INSERT INTO customer (custID,first_name,last_name,age,num)
 VALUES(3,'Rahul','Dravid',40,'0');
 
 SHOW tables from learning;
 DESCRIBE customer;
 INSERT INTO customer (custID,first_name,last_name,age,num)
 VALUES(4,'Rahul','Dravid',40,10.12);
 
SELECT CAST(ROUND(10.12) AS SIGNED) AS smallint_value;
SELECT CAST(ROUND(10.12) AS SIGNED) AS int_value;
SELECT ROUND(10.12966666, 1) AS float_value;
SELECT ROUND(10.12966666666666666666666666666, 25) AS float_value;
SELECT CAST(100.129 AS DECIMAL(5,2)) AS decimal_value;
SELECT CAST(100.129 AS DECIMAL(6,3)) AS decimal_value;

-- Character Datatype
SELECT 'Ian Bishop' AS char_value, LENGTH('Ian Bishop') AS octet_length_value;
SELECT OCTET_LENGTH(first_name) from customer;
SELECT 'Ian Bishop' AS varchar_value, CHAR_LENGTH('Ian Bishop') AS octet_length_value;
SELECT 'Ian Bishop' AS text_value, CHAR_LENGTH('Ian Bishop') AS char_length_value;

-- Date/Time Datatype

SELECT DATE('2024-01-15 22:30:03.904') AS date_value;
SELECT '2024-01-15 22:30:03.904' AS timestamp_value;
SELECT TIME(STR_TO_DATE('2024-01-15 22:30:03.904', '%Y-%m-%d %H:%i:%s.%f')) AS time_value; -- timestamp
SELECT STR_TO_DATE('2024-01-15 22:30:03.904', '%Y-%m-%d %H:%i:%s.%f') AS timestamp_value; -- timestampz
SELECT CAST('22:30:03.904' AS TIME) AS interval_value; -- interval

-- Money DataType
SET lc_monetary = 'en_US';
SELECT FORMAT(10, 2) AS monetary_value;
SELECT CAST(10 AS DECIMAL(10,2)) AS money_value;

-- BOOLEAN
SELECT CAST(1 AS SIGNED) AS boolean_value;

-- ENUM

CREATE TABLE new (
    Fri ENUM('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun')
);

-- UUID
CREATE TABLE customerorder (
    orderid INT AUTO_INCREMENT PRIMARY KEY,
    orderIdentifier CHAR(36),
    customerid INT,
    orderdate TIMESTAMP NULL,
    orderday ENUM('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun') NULL
);

-- Create a trigger to set orderIdentifier with UUID()
DELIMITER //
CREATE TRIGGER before_insert_customerorder
BEFORE INSERT ON customerorder
FOR EACH ROW
SET NEW.orderIdentifier = IFNULL(NEW.orderIdentifier, REPLACE(UUID(), '-', ''));
//
DELIMITER ;
SELECT * from customerorder

-- Assuming the customerorder table is already created with the appropriate structure

ALTER TABLE customerorder
MODIFY COLUMN orderdate DATE;


ALTER TABLE customerorder
MODIFY COLUMN orderday ENUM('Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun');


INSERT INTO customerorder (customerid, orderdate, orderday) VALUES (1, NOW(), 'Mon');
INSERT INTO customerorder (customerid, orderdate, orderday) VALUES (2, NOW(), 'Tue');

SELECT * FROM customerorder;

-- Json Datatype

-- Create a stored procedure to conditionally add the column
DELIMITER //

CREATE PROCEDURE AddOrderDetailsColumn()
BEGIN
  -- Check if the column exists
  IF NOT EXISTS (
      SELECT COLUMN_NAME
      FROM INFORMATION_SCHEMA.COLUMNS
      WHERE TABLE_NAME = 'customerorder' AND COLUMN_NAME = 'orderdetails'
  ) THEN
    -- Add the column
    ALTER TABLE customerorder
    ADD COLUMN orderdetails JSON NULL;
  END IF;
END //

DELIMITER ;

-- Call the stored procedure to add the column
CALL AddOrderDetailsColumn();

-- Update JSON column for orderid = 1
UPDATE customerorder 
SET orderdetails = JSON_ARRAY(
    JSON_OBJECT(
        'Item', '12112',
        'Name', 'Pen',
        'Rate', '10',
        'Quantity', '2'
    ),
    JSON_OBJECT(
        'Item', '12133',
        'Name', 'Pencil',
        'Rate', '5',
        'Quantity', '2'
    )
)
WHERE orderid = 1;







-- XML Data Type
-- XML Data Type in MySQL
SELECT ExtractValue('<dataset>
    <record><Item>12112</Item><Name>Pen</Name><Rate>10</Rate><Quantity>2</Quantity></record>
    <record><Item>12133</Item><Name>Pencil</Name><Rate>5</Rate><Quantity>2</Quantity></record>
</dataset>', '/dataset') AS xml_data;


-- Array Data Type
-- Create tables
CREATE TABLE monthly_savings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name TEXT
);

CREATE TABLE saving_per_quarter (
    monthly_savings_id INT,
    quarter_number INT,
    saving INT,
    FOREIGN KEY (monthly_savings_id) REFERENCES monthly_savings(id)
);

CREATE TABLE scheme (
    monthly_savings_id INT,
    scheme_type TEXT,
    scheme_name TEXT,
    FOREIGN KEY (monthly_savings_id) REFERENCES monthly_savings(id)
);

-- Insert data
INSERT INTO monthly_savings (name) VALUES ('Manisha');
INSERT INTO saving_per_quarter VALUES (1, 1, 20000), (1, 2, 14600), (1, 3, 23500), (1, 4, 13250);
INSERT INTO scheme VALUES (1, 'FD', 'MF'), (1, 'FD', 'Property');

-- Select data
SELECT * FROM monthly_savings;
SELECT * FROM saving_per_quarter;
SELECT * FROM scheme;


-- Composite Types
-- Create tables
CREATE TABLE inventory_item (
    name TEXT,
    supplier_id INT,
    price NUMERIC
);

CREATE TABLE on_hand (
    item_name TEXT,
    supplier_id INT,
    item_price NUMERIC,
    item_count INT
);

-- Insert data
INSERT INTO on_hand VALUES ('fuzzy dice', 42, 1.99, 1000);

-- Select data
SELECT item_name FROM on_hand WHERE item_price > 9.99;
SELECT * FROM on_hand WHERE item_price > 0.99;
SELECT item_name FROM on_hand WHERE item_price > 0.99;


-- Foreign Key
CREATE TABLE customerorder2 (
    orderid INT AUTO_INCREMENT PRIMARY KEY,
    customerid INT,
    orderdate TIMESTAMP,
    orderday VARCHAR(3),
    CONSTRAINT fk_customerorder2_customer FOREIGN KEY (customerid) REFERENCES customer(custID)
);

-- Insert data
INSERT INTO customerorder2 (customerid, orderdate, orderday) VALUES (1, NOW(), 'Mon');


-- NOT NULL
ALTER TABLE customerorder MODIFY COLUMN orderdate TIMESTAMP NOT NULL;

-- Insert data with NOT NULL constraint
-- This should result in an error because orderdate cannot be NULL
INSERT INTO customerorder (customerid, orderday) VALUES (1, 'Tue');



-- Unique

ALTER TABLE customer
ADD COLUMN emailid VARCHAR(100) ;
ALTER TABLE customer
ADD COLUMN firstname VARCHAR(100) ;

ALTER TABLE customer ADD CONSTRAINT customer_un UNIQUE (emailid);

INSERT INTO customer (firstname, middlename, lastname, emailid, customerpassword, phoneno, isactive) VALUES ('Peter', '', 'May', 'Peter@gmail.com', '', '', true);

-- Check
ALTER TABLE customer ADD COLUMN customerage INT;

ALTER TABLE customer ADD CONSTRAINT customerage_check CHECK (customerage > 0);
ALTER TABLE customer
ADD COLUMN middlename VARCHAR(100) ;
INSERT INTO customer (firstname, middlename, lastname, emailid, customerpassword, phoneno, isactive, customerage) VALUES ('Wilfred', '', 'Barber', 'Wilfred@gmail.com', '', '', true, 0);

-- Exclusion 

-- Insert, Update, Delete, Truncate, SELECT 


DROP TABLE IF EXISTS customerorder;
CREATE TABLE customerorder (
    orderid INT AUTO_INCREMENT PRIMARY KEY,
    customerid INT,
    orderdatetime TIMESTAMP NULL
);

INSERT INTO customerorder (orderid, customerid, orderdatetime) VALUES
    (1, 1, '2024-01-01 14:38:26.75'),
    (2, 2, '2024-01-03 14:38:26.75'),
    (3, 3, '2024-01-05 14:38:26.75'),
    (4, 4, '2024-01-10 14:38:26.75');



CREATE TABLE orderdetails (
	orderid  int not null,
    productid int not null,
    productdetails VARCHAR(255),
    productname VARCHAR(255),
    productprice DECIMAL(10, 2)
);
INSERT INTO orderdetails (orderid, productid, productname, productprice) VALUES
     (1, 1, 'Smart LED TV', 100000.00),
     (2, 1, 'Smart LED TV', 100000.00),
     (3, 1, 'Smart LED TV', 100000.00),
     (4, 1, 'Smart LED TV', 100000.00),
     (1, 2, 'OnePlus Nord CE 3 5G', 25000.00),
     (1, 3, 'Fire-Boltt Ninja Call Pro Plus', 2000.00),
     (2, 2, 'OnePlus Nord CE 3 5G', 25000.00),
     (2, 3, 'Fire-Boltt Ninja Call Pro Plus', 2000.00),
     (4, 2, 'OnePlus Nord CE 3 5G', 25000.00),
     (4, 3, 'Fire-Boltt Ninja Call Pro Plus', 2000.00),
     (3, 2, 'OnePlus Nord CE 3 5G', 25000.00),
     (3, 3, 'Fire-Boltt Ninja Call Pro Plus', 2000.00),
     (3, 4, 'Lakme Eyeconic Insta Cool Kajal', 1000.00);
     
     
CREATE TABLE product (
    productid INT AUTO_INCREMENT PRIMARY KEY,
    productname VARCHAR(100) NULL,
    productprice DECIMAL(10, 2) NULL
);


INSERT INTO product (productid,productname,productprice) VALUES
	 (1,'Smart LED TV',100000.00),
	 (2,'OnePlus Nord CE 3 5G',25000.00),
	 (3,'Fire-Boltt Ninja Call Pro Plus',2000.00),
	 (4,'Lakme Eyeconic Insta Cool Kajal',1000.00),
	 (5,'12-Watt LED Bulb',300.00),
	 (6,'SOFTSPUN Microfiber Cloth',200.00);
     
     
     -- Distinct


SELECT productname FROM orderdetails;
SELECT DISTINCT productname FROM orderdetails;

-- WHERE
SELECT * FROM orderdetails WHERE productid = 1;

-- ORDER BY
SELECT * FROM orderdetails ORDER BY productname ASC;
SELECT * FROM orderdetails ORDER BY productname DESC;
SELECT * FROM orderdetails ORDER BY productprice ASC;
SELECT * FROM orderdetails ORDER BY productprice DESC;

-- GROUP BY
SELECT productname, COUNT(1) AS noofsales FROM orderdetails GROUP BY productname;
SELECT productname, SUM(productprice) AS salesamount FROM orderdetails GROUP BY productname;



-- LIKE
SELECT * FROM orderdetails WHERE productname LIKE 'Smart LED TV';
SELECT * FROM orderdetails WHERE productname LIKE 'Smart LED%';
SELECT * FROM orderdetails WHERE productname LIKE '%LED%';

-- IN
SELECT * FROM orderdetails WHERE productname IN ('Smart LED TV', 'OnePlus Nord CE 3 5G');
SELECT * FROM orderdetails WHERE productid IN (1, 2);

-- add a new column orderdatetime
ALTER TABLE orderdetails
ADD COLUMN orderdatetime TIMESTAMP;
-- drop column
ALTER TABLE orderdetails
DROP COLUMN orderdatetime;


-- BETWEEN
SELECT * FROM orderdetails WHERE productprice BETWEEN 2000 AND 10000;
SELECT * FROM customerorder WHERE orderdatetime BETWEEN '2024-01-03' AND '2024-01-10';

-- AND, OR
SELECT * FROM customerorder WHERE customerid = 3 AND orderdatetime > '2024-01-03';
SELECT * FROM customerorder WHERE customerid = 3 OR orderdatetime > '2024-01-03';

-- LIMIT
SELECT * FROM customerorder LIMIT 2;

-- OFFSET
SELECT * FROM customerorder LIMIT 2 OFFSET 1;

-- HAVING
SELECT productname FROM orderdetails GROUP BY productname HAVING COUNT(productname) > 2;
SELECT productname AS product_name FROM orderdetails GROUP BY productname HAVING COUNT(productname) > 2;

-- NULL
SELECT * FROM customer WHERE middlename IS NULL;

-- CAST
SELECT productprice, CAST(productprice AS DECIMAL(10, 3)) AS product_price FROM orderdetails;
SELECT productprice, CAST(productprice AS DECIMAL(10, 3)) AS product_price FROM orderdetails;
SELECT productprice, CAST(productprice AS DECIMAL (10, 3)) AS product_price FROM orderdetails;

-- CONCAT
ALTER TABLE customer
ADD COLUMN middlename varchar(100);
SELECT CONCAT(first_name, ' ', middlename, ' ', last_name) FROM customer;
SELECT CONCAT_WS(' ', first_name, middlename, last_name) FROM customer;

SELECT * FROM CUSTOMER;

-- String AGG
SELECT GROUP_CONCAT(first_name ORDER BY first_name SEPARATOR ',') FROM customer;
SELECT CAST(CONVERT(GROUP_CONCAT(first_name ORDER BY first_name) USING UTF8) AS CHAR) AS first_names FROM customer;

-- JOIN
SELECT * FROM customer LEFT JOIN customerorder1 ON customer.custID = customerorder1.customerid;
SELECT * FROM customer RIGHT JOIN customerorder1 ON customer.custID = customerorder1.customerid;
SELECT * FROM customer INNER JOIN customerorder1 ON customer.custID = customerorder1.customerid;

-- full outer join
SELECT *
FROM customer
LEFT JOIN customerorder1 ON customer.custID = customerorder1.customerid

UNION

SELECT *
FROM customer
RIGHT JOIN customerorder1 ON customer.custID = customerorder1.customerid;


-- Recursive CTE 

DELIMITER //

CREATE PROCEDURE GenerateDates(IN start_date DATE, IN end_date DATE)
BEGIN
    CREATE TEMPORARY TABLE date_range (
        date_value DATE
    );

    SET @current_date = start_date;

    WHILE @current_date <= end_date DO
        INSERT INTO date_range (date_value) VALUES (@current_date);
        SET @current_date = @current_date + INTERVAL 1 DAY;
    END WHILE;

    SELECT * FROM date_range;

    DROP TEMPORARY TABLE IF EXISTS date_range;
END //

DELIMITER ;


CALL GenerateDates('2023-01-01', '2023-12-31');


-- UNION
CREATE TABLE productarchive (
    productid INT AUTO_INCREMENT PRIMARY KEY,
    productname VARCHAR(255) NULL,
    productprice DECIMAL(18, 2) NULL
);

INSERT INTO productarchive (productname, productprice) VALUES ('Smart LED TV', 1000.00), ('SOFTSPUN Microfiber Cloth', 100.00);

SELECT * FROM productarchive;

-- List a combination of product from productarchive and product table with not duplicate product name.
SELECT productname FROM productarchive UNION SELECT productname FROM product;

-- List a combination of product from productarchive and product table.
SELECT productname FROM productarchive UNION ALL SELECT productname FROM product;

-- Subquery
SELECT * FROM orderdetails WHERE productid IN (SELECT productid FROM product WHERE productprice = 2000.00);
SELECT * FROM orderdetails WHERE productid AND(SELECT productid FROM product WHERE productprice = 1000.00);
SELECT * FROM orderdetails WHERE productid OR(SELECT productid FROM product WHERE productprice = 3000.00);


-- Coorelated Subquery
SELECT *, (SELECT firstname FROM customer t1 WHERE t1.custID = t2.customerid) AS customername FROM customerorder t2;

-- Case
ALTER TABLE customer
ADD COLUMN isactive bool;
SELECT
    firstname,
    last_name,
    middlename,
    CASE
        WHEN isactive = 1 THEN 'Active'
        WHEN isactive = 0 THEN 'Not Active'
        ELSE ''
    END AS ActiveOrNot
FROM customer;


-- NULLIF, COALESCE
ALTER TABLE customer
ADD COLUMN customerpassword varchar(100) not null;

SELECT
    firstname,
    last_name,
    middlename,
    COALESCE(NULLIF(customerpassword, ''), 'Not Entered') AS password_status
FROM customer;



















