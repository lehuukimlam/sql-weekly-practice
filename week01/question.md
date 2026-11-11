# Week 1 — City completed-order AOV

**Date:** 2026-09-16 (brief sent); completed 2026-09-22 (Australia/Sydney).

This was the first session. The brief was not yet in the later LeetCode style: there was no sample database, no expected-output table, and no `setup.sql`. The problem is included here as it was given.

## Scenario

Joins + aggregation, about 25 minutes, written from scratch.

## Schema (Postgres-style)

```text
customers (customer_id, name, city, signup_date)
orders    (order_id, customer_id, order_date, status)  -- status: 'completed' 'cancelled' 'pending'
order_items (order_id, product_id, qty, unit_price)
```

No sample rows were provided.

## Brief

For each city, return:

- `city`
- `completed_orders` — count of completed orders
- `avg_order_value` — average order total (`SUM` of `qty * unit_price` per order)

Rules:

- only `status = 'completed'`
- only orders in the last 90 days (use `CURRENT_DATE`)
- only cities with at least 10 completed orders
- order by `avg_order_value` descending

## Expected output

n/a — no sample data or expected table was given with this brief.
