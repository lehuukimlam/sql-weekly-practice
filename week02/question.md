# Week 2 — Customer order patterns (window functions)

**Date:** 2026-09-28 (Australia/Sydney). About 25 minutes.

Load the tables with `psql -d practice -f week02/setup.sql`.

## Scenario

The retention team wants to see each customer's buying pattern.

## Schema

`orders`

| order_id | customer_id | order_date | status |
| ---: | ---: | --- | --- |
| 101 | 1 | 2026-08-01 | completed |
| 102 | 1 | 2026-08-15 | completed |
| 103 | 2 | 2026-08-10 | completed |
| 104 | 1 | 2026-08-20 | cancelled |
| 105 | 2 | 2026-09-01 | completed |
| 106 | 1 | 2026-09-05 | completed |
| 107 | 3 | 2026-09-10 | completed |

`order_items`

| order_id | product_id | qty | unit_price |
| ---: | --- | ---: | ---: |
| 101 | A | 2 | 10 |
| 101 | B | 1 | 30 |
| 102 | A | 1 | 20 |
| 103 | C | 4 | 25 |
| 104 | A | 1 | 10 |
| 105 | A | 2 | 40 |
| 105 | B | 1 | 20 |
| 106 | C | 1 | 25 |
| 107 | B | 3 | 30 |

## Part 1 — write from scratch

For each completed order, return:

- `customer_id`, `order_id`, `order_date`
- `order_total` — `SUM` of `qty * unit_price` for that order
- `order_number` — 1 for the customer's first completed order, 2 for their second, and so on
- `days_since_prev_order` — days since that customer's previous completed order, `NULL` for their first

Sort by `customer_id`, then `order_date`.

Hint given with the brief: get to order grain first, then add the window functions on top.

### Expected output

| customer_id | order_id | order_date | order_total | order_number | days_since_prev_order |
| ---: | ---: | --- | ---: | ---: | ---: |
| 1 | 101 | 2026-08-01 | 50 | 1 | NULL |
| 1 | 102 | 2026-08-15 | 20 | 2 | 14 |
| 1 | 106 | 2026-09-05 | 25 | 3 | 21 |
| 2 | 103 | 2026-08-10 | 100 | 1 | NULL |
| 2 | 105 | 2026-09-01 | 100 | 2 | 22 |
| 3 | 107 | 2026-09-10 | 90 | 1 | NULL |

## Part 2 — what's wrong with this query?

```sql
SELECT customer_id, order_id, order_date,
       ROW_NUMBER() OVER (ORDER BY order_date) AS order_number
FROM orders
WHERE status = 'completed';
```

What `order_number` does order 103 get, and why is that wrong for the retention team?
