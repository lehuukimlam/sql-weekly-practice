-- Lam's FINAL query, submitted 2026-10-06.
-- Original line breaks from the chat archive were not preserved;
-- the SQL text is otherwise unchanged.

WITH sept_counts AS (SELECT r.name, COUNT(*) AS sept_completed_orders FROM restaurants r LEFT JOIN orders o ON o.restaurant_id = r.restaurant_id WHERE o.status = 'completed' AND o.order_date BETWEEN '2026-09-01' AND '2026-09-30' GROUP BY r.name ORDER BY sept_completed_orders DESC, r.name) SELECT DISTINCT(r1.name) name, COALESCE(r2.sept_completed_orders,0) sept_completed_orders FROM restaurants r1 LEFT JOIN sept_counts r2 ON r1.name = r2.name;
