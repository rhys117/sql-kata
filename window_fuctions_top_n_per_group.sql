-- Description
-- Given the schema presented below write a query, which uses a window function, that returns two most viewed posts for every category.
--
-- Order the result set by:
--
-- category name alphabetically
-- number of post views largest to lowest
-- post id lowest to largest

-- Note:
-- Some categories may have less than two or no posts at all.
-- Two or more posts within the category can be tied by (have the same) the number of views. Use post id as a tie breaker - a post with a lower id gets a higher rank.
-- Schema

-- categories
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- id          | integer                     | not null
-- category    | character varying(255)      | not null

-- posts
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- id          | integer                     | not null
-- category_id | integer                     | not null
-- title       | character varying(255)      | not null
-- views       | integer                     | not null

-- Desired Output
-- The desired output should look like this:
--
-- category_id | category | title                             | views | post_id
-- ------------+----------+-----------------------------------+-------+--------
-- 5           | art      | Most viewed post about Art        | 9234  | 234
-- 5           | art      | Second most viewed post about Art | 9234  | 712
-- 2           | business | NULL                              | NULL  | NULL
-- 7           | sport    | Most viewed post about Sport      | 10    | 126
-- ...
-- category_id - category id
-- category - category name
-- title - post title
-- views - the number of post views
-- post_id - post id

-- Attempt 2
SELECT
  cat.id AS category_id,
  cat.category,
  pos.title,
  pos.views,
  pos.post_id
FROM categories cat LEFT JOIN (
  SELECT
    category_id,
    title,
    views,
    id AS post_id,
    ROW_NUMBER() OVER (
      PARTITION BY category_id
      ORDER BY views DESC, id
    )
  FROM posts) pos ON cat.id = pos.category_id AND pos.row_number <= 2
ORDER BY category, views DESC, post_id

-- Attempt 1
SELECT
  rank_filter.category_id,
  rank_filter.category,
  rank_filter.title,
  rank_filter.views,
  rank_filter.post_id
  FROM (
    SELECT
      cat.id AS category_id,
      cat.category,
      pos.title,
      pos.views,
      pos.id AS post_id,
      ROW_NUMBER() OVER(
        PARTITION BY pos.category_id
        ORDER BY pos.views DESC
      )
    FROM categories cat
    LEFT JOIN posts pos ON cat.id = pos.category_id
  ) rank_filter
WHERE ROW_NUMBER <= 2
ORDER BY rank_filter.category, rank_filter.views DESC, rank_filter.post_id ASC;