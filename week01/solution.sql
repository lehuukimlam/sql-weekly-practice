-- Lam's FINAL query, submitted 2026-09-22.
-- Original line breaks from the chat archive were not preserved;
-- the SQL text is otherwise unchanged.

WITH orders_full_info AS (SELECT o.order_id, o.order_date, o.status, c.city, SUM(i.qty * i.unit_price) total_amount FROM orders o LEFT JOIN customers c ON o.customer_id = c.customer_id LEFT JOIN order_items i ON o.order_id = i.order_id GROUP BY o.order_id, o.order_date, o.status, c.city) SELECT city, COUNT(DISTINCT order_id) completed_orders, AVG(total_amount) avg_order_value FROM orders_full_info WHERE status = 'completed' AND order_date >= CURRENT_DATE - INTERVAL '90 days' GROUP BY city HAVING COUNT(DISTINCT order_id) >= 10 ORDER BY avg_order_value DESC;
