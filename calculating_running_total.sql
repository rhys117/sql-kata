-- Given a posts table that contains a created_at timestamp column write a query that returns date (without time component), a number of posts for a given date and a running (cumulative) total number of posts up until a given date. The resulting set should be ordered chronologically by date.
--
-- Desired Output
-- The resulting set should look similar to the following:
--
-- date       | count | total
-- -----------+-------+-------
-- 2017-01-26 |    20 |    20
-- 2017-01-27 |    17 |    37
-- 2017-01-28 |     7 |    44
-- 2017-01-29 |     8 |    52
-- ...
-- date - (DATE) date
-- count - (INT) number of posts for a date
-- total - (INT) a running (cumulative) number of posts up until a date


-- Attempt 2
SELECT
  created_at::DATE AS date,
  COUNT(*) AS count,
  SUM(COUNT(*)::int) OVER (ORDER BY created_at::DATE) AS total
FROM posts
GROUP BY date
ORDER BY date

-- Attempt 1
WITH converted_dates AS (
  SELECT DATE(created_at) AS date,
  COUNT(DATE(created_at) = DATE(created_at)) AS count
  FROM posts
  GROUP BY date
)

SELECT
  date,
  count,
  CAST(SUM(count) OVER (ORDER BY date ASC) AS integer) AS total
FROM converted_dates
ORDER BY date ASC;