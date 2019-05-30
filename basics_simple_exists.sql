-- For this challenge you need to create a SELECT statement, this SELECT statement will use an EXISTS to check whether
-- a department has had a sale with a price over 98.00 dollars.
--
-- departments table schema
-- id
-- name

-- sales table schema
-- id
-- department_id (department foreign key)
-- name
-- price
-- card_name
-- card_number
-- transaction_date
-- resultant table schema
-- id
-- name
-- NOTE: Your solution should use pure SQL. Ruby is used within the test cases to do the actual testing.
-- Do not: alias tables as this can cause a failure.

-- W3 Schools
-- The SQL EXISTS Operator
-- The EXISTS operator is used to test for the existence of any record in a subquery.
--
-- The EXISTS operator returns true if the subquery returns one or more records.
--
-- EXISTS Syntax
-- SELECT column_name(s)
-- FROM table_name
-- WHERE EXISTS
-- (SELECT column_name FROM table_name WHERE condition);

SELECT *
FROM departments d
WHERE EXISTS
(SELECT * FROM sales s WHERE s.price > 98 AND s.department_id = d.id);