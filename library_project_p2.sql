create table branch (
branch_id VARCHAR(10) PRIMARY KEY,	
manager_id VARCHAR(10),
branch_address VARCHAR(55),
contact_no VARCHAR(10)
);

CREATE TABLE employee (
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(20),
position VARCHAR(10),
salary INT,
branch_id VARCHAR(10)
);

CREATE TABLE book (
isbn VARCHAR(20),	
book_title VARCHAR(75),
category VARCHAR(20),
rental_price FLOAT,
status VARCHAR(10),
author VARCHAR(35),
publisher VARCHAR(55)
);

CREATE TABLE members (
member_id VARCHAR(10) PRIMARY KEY,
member_name	VARCHAR(20),
member_address VARCHAR(20),
reg_date DATE
);

CREATE TABLE issued_status(
issued_id VARCHAR(10) PRIMARY KEY,
issued_member_id VARCHAR(10),
issued_book_name VARCHAR(75),
issued_date	DATE,
issued_book_isbn VARCHAR(20),
issued_emp_id VARCHAR(10)
);

CREATE TABLE return_status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(10),
return_book_name VARCHAR(75),	
return_date	DATE,
return_book_isbn VARCHAR(20)
);

-- foreign key
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members(member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_book
FOREIGN KEY (issued_book_isbn)
REFERENCES book(isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employee
FOREIGN KEY (issued_emp_id)
REFERENCES employee(emp_id);

ALTER TABLE employee
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch(branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status(issued_id);

select * from branch

-- project task

-- Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

INSERT INTO book(isbn, book_title, category, rental_price, status, author, publisher)
VALUES ('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM book;

-- Update an Existing Member's Address

UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;

-- Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS121'

-- Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101'

-- List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT 
issued_emp_id,
COUNT(issued_id) as total_book_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1

-- Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**

CREATE TABLE book_cnts
AS
SELECT 
b.isbn,
b.book_title,
COUNT(ist.issued_id) as no_issued
FROM book as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1, 2;
SELECT * FROM book_cnts;

-- Retrieve All Books in a Specific Category:

SELECT * FROM book
WHERE category = 'Classic';

-- Find Total Rental Income by Category:

SELECT
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM book as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1

-- List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 day; 

INSERT INTO members(member_id, member_name, member_address, reg_date)
VALUES
('C120', 'sam', '145 Main St', '2025-09-28'),
('C121', 'john', '133 Main St', '2025-09-30');

-- List Employees with Their Branch Manager's Name and their branch details:

SELECT  
	e1.*,
    b.manager_id,
    e2.emp_name as manager
FROM employee as e1
JOIN branch as b 
ON b.branch_id = e1.branch_id
JOIN
employee as e2
ON b.manager_id = e2.emp_id

-- Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Book
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven

-- Retrieve the List of Books Not Yet Returned

SELECT 
    DISTINCT ist.issued_book_name
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL

SELECT * FROM return_status