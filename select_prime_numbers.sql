-- Write a SELECT query which will return all prime numbers smaller than 100 in ascending order.
--
-- Your query should return one column named prime.

WITH numbers AS (
  SELECT * FROM generate_series(2, 100) num
)
SELECT n1.num AS prime
FROM numbers n1
WHERE NOT EXISTS (
  SELECT *
  FROM numbers n2
  WHERE n1.num > n2.num AND n1.num % n2.num = 0
);

-- using a prime numbers table

SELECT regexp_split_to_table('2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97', E',')::int
AS prime;