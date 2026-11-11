# Week 1 review

**Date:** 2026-09-22 (Australia/Sydney).

**Level:** n/a for this week alone. A numeric level was first given after weeks 1–2 together (35/100).

**Result:** The rewritten FINAL query was accepted as correct: order-grain CTE with `SUM(qty * unit_price)`, joins on the right keys, filters, `HAVING`, and `DESC`.

## What went well

- A CTE plus bringing `city` in from `customers` was the right shape.
- The successful rewrite used `GROUP BY` at order grain (`order_id`, `order_date`, `status`, `city`), then averaged those totals per city.
- `HAVING COUNT(DISTINCT order_id) >= 10` and `ORDER BY avg_order_value DESC` matched the brief.
- The 90-day filter settled on `order_date >= CURRENT_DATE - INTERVAL '90 days'`.

## Logic misses (in earlier drafts)

- **Grain:** After joining `order_items`, each row is a line, not an order. `AVG` of line amounts is not average order value. The CTE must `SUM(qty * unit_price)` and `GROUP BY` the order, not only `city`.
- Early drafts used invalid or line-level totals (`AVG(SUM(qty, unit_price))`, then `qty * unit_price` without `SUM`) and put `COUNT(...)` in `WHERE` instead of `HAVING`.
- `COUNT(order_id)` after the items join counts lines unless the grain is already one row per order (or you use `COUNT(DISTINCT order_id)`).

## Syntax slips (not tallied)

- Join syntax: `order_items` was first attached with `AND … ON …` instead of its own `JOIN`, and joined on `customer_id` (the items table has no `customer_id`). The key is `order_id`.
- Stray `AND` between two `LEFT JOIN`s (`AND LEFT JOIN`).
- `GROUP BY` was placed outside the CTE, after the closing `)`.
- Optional polish (not required for correctness): `INNER JOIN` is cleaner than `LEFT JOIN` here; in the outer query `COUNT(*)` is enough once each CTE row is one order.

## Lessons

- Join multiplies; `GROUP BY` at the parent key collapses back to one row per order. That was the whole week 1 lesson.
- Get to order grain before any city-level average.

## Tóm tắt

Bài học chính là grain: join `order_items` làm nhân số dòng, phải `SUM` về một dòng/order rồi mới `AVG` theo city. Query cuối đã đúng. Tuần này chưa có điểm level riêng; 35/100 được chấm sau tuần 1–2.
