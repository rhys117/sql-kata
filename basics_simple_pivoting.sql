-- For this challenge you need to PIVOT data. You have two tables, products and details.
-- Your task is to pivot the rows in products to produce a table of products which have rows of their detail.
-- Group and Order by the name of the Product.
--
-- Tables and relationship below:
-- http://i.imgur.com/81Ww3YH.png
--
-- You must use the CROSSTAB statement to create a table that has the schema as below:
--
-- CROSSTAB table.
-- name
-- good
-- ok
-- bad
-- Compare your table to the expected table to view the expected results.
--
-- CREATE EXTENSION tablefunc;

-- Create your CROSSTAB statement here

SELECT *
FROM CROSSTAB(
  $$
  SELECT p.name, d.detail, COUNT(d.detail)::int AS value
  FROM products p
  INNER JOIN details d ON p.id = d.product_id
  GROUP BY 1, 2
  ORDER BY 1, CASE
    WHEN d.detail = 'good' THEN 1
    WHEN d.detail = 'ok' THEN 2
    ELSE 3
  END ASC
  $$
) AS ct("name" TEXT, "good" int, "ok" int, "bad" int);

-- 2nd attempt (cleaner)

SELECT *
FROM CROSSTAB(
  $$
  SELECT p.name, detail, count(d.id)
  FROM products p
  JOIN details d ON p.id = d.product_id
  GROUP BY p.name, d.detail
  ORDER BY 1, 2
  $$
) AS CT(name TEXT, bad BIGINT, good BIGINT, ok BIGINT);