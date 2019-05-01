-- For this challenge you need to create a VIEW. This VIEW is used by a sales store to give out vouches to members
-- who have spent over $1000 in departments that have brought in more than $10000 total ordered by the members id.
-- The VIEW must be called members_approved_for_voucher then you must create a SELECT query using the view.

-- Tables relationships: http://i.imgur.com/hkEkGg1.png

-- resultant table schema
-- id
-- name
-- email
-- total_spending

CREATE VIEW members_approved_for_voucher AS
  SELECT mem.id, mem.name, mem.email, SUM(prod.price) as total_spending
  FROM members mem
  JOIN sales sal ON sal.member_id = mem.id
  JOIN products prod ON sal.product_id = prod.id
  JOIN departments dep ON sal.department_id = dep.id
  WHERE dep.id IN (
    SELECT dep.id
    FROM departments dep
    JOIN sales sal ON sal.department_id = dep.id
    JOIN products prod ON sal.product_id = prod.id
    GROUP BY dep.id
    HAVING SUM(prod.price) > 10000
  )
  GROUP BY mem.id, mem.name, mem.email
  HAVING SUM(prod.price) > 1000
  ORDER BY mem.id;

SELECT * FROM members_approved_for_voucher;