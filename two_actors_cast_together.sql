-- Given the the schema presented below find two actors who cast together the most and list titles of only those
-- movies they were casting together. Order the result set alphabetically by the movie title.
--
-- Table film_actor
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- actor_id    | smallint                    | not null
-- film_id     | smallint                    | not null
-- ...

-- Table actor
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- actor_id    | integer                     | not null
-- first_name  | character varying(45)       | not null
-- last_name   | character varying(45)       | not null
-- ...

-- Table film
--  Column     | Type                        | Modifiers
-- ------------+-----------------------------+----------
-- film_id     | integer                     | not null
-- title       | character varying(255)      | not null
-- ...

-- The desired output:
-- first_actor | second_actor | title
-- ------------+--------------+--------------------
-- John Doe    | Jane Doe     | The Best Movie Ever
-- ...

-- first_actor - Full name (First name + Last name separated by a space)
-- second_actor - Full name (First name + Last name separated by a space)
-- title - Movie title
-- Note: actor_id of the first_actor should be lower then actor_id of the second_actor

-- First attempt
WITH self_joined AS
(
  SELECT DISTINCT LEAST(a.actor_id, b.actor_id) AS first_actor_id, GREATEST(a.actor_id, b.actor_id) AS second_actor_id, a.film_id
  FROM film_actor a, film_actor b
  WHERE a.actor_id <> b.actor_id
  AND a.film_id = b.film_id
),
movies_together_count AS
(
  SELECT COUNT(*) AS appearances_together, first_actor_id, second_actor_id
  FROM self_joined
  GROUP BY 2, 3
),
most_starred_together AS
(
  SELECT DISTINCT mtc.appearances_together, mtc.first_actor_id, mtc.second_actor_id, fa.film_id
  FROM movies_together_count mtc
  INNER JOIN film_actor fa ON fa.actor_id IN (mtc.first_actor_id, mtc.second_actor_id)
  WHERE appearances_together = (SELECT MAX(appearances_together) FROM movies_together_count)
  AND EXISTS (SELECT * FROM film_actor WHERE actor_id = mtc.first_actor_id AND film_id = fa.film_id)
  AND EXISTS (SELECT * FROM film_actor WHERE actor_id = mtc.second_actor_id AND film_id = fa.film_id)
)

SELECT
  CONCAT(first_actor.first_name, ' ', first_actor.last_name) AS first_actor,
  CONCAT(second_actor.first_name, ' ', second_actor.last_name) AS second_actor,
  film.title
FROM most_starred_together mst
INNER JOIN actor first_actor ON first_actor.actor_id = mst.first_actor_id
INNER JOIN actor second_actor ON second_actor.actor_id = mst.second_actor_id
INNER JOIN film ON film.film_id = mst.film_id;

-- Second attempt
WITH top_team AS (
  SELECT fa1.actor_id AS first_actor_id, fa2.actor_id AS second_actor_id
  FROM film_actor fa1
  INNER JOIN film_actor fa2 ON fa1.film_id = fa2.film_id
  WHERE fa1.actor_id <> fa2.actor_id
  GROUP BY fa1.actor_id, fa2.actor_id
  ORDER BY COUNT(fa1.film_id) DESC
  LIMIT 1
)

SELECT
  (SELECT CONCAT(first_name, ' ', last_name) FROM actor WHERE actor_id = tt.first_actor_id) AS first_actor,
  (SELECT CONCAT(first_name, ' ', last_name) FROM actor WHERE actor_id = tt.second_actor_id) AS second_actor,
  f.title
FROM top_team tt
INNER JOIN film_actor fa1 ON tt.first_actor_id = fa1.actor_id
INNER JOIN film_actor fa2 ON tt.second_actor_id = fa2.actor_id
INNER JOIN film f ON fa1.film_id = f.film_id AND fa2.film_id = f.film_id;
