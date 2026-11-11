# Week 2 review

**Date:** 2026-09-28 (Australia/Sydney).

**Level:** 35/100 (first numeric rating; based on weeks 1–2 together). Logic was described as closer to 45; syntax slips and missed requirements pulled the score down to 35.

**Result:** Part 1 numbers matched the expected output on every row. Part 2 was also correct: order 103 gets `2`, and adding `PARTITION BY customer_id` is the fix.

## What went well

- `ROW_NUMBER()` and `LAG()` both used `PARTITION BY customer_id ORDER BY order_date`.
- Date subtraction gave 14, 21, and 22.
- The order-grain CTE (`customer_info_basic`) was the right place to hang the windows.
- Part 2: without a partition, `ROW_NUMBER()` counts every completed order across all customers in date order, so 103 (customer 2's first order) is numbered 2 and looks like a repeat purchase.

## Logic misses

- `order_id` is missing from the final `SELECT`. The brief asked for it.
- There is no `ORDER BY`. The rows happened to come out in the right order; SQL does not guarantee that without `ORDER BY customer_id, order_date`.
- Early drafts mixed aggregation and windows, put `GROUP BY` inside `OVER` instead of `PARTITION BY`, used `COUNT` / `FIRST_VALUE` where `ROW_NUMBER` / `LAG` were needed, and tried `DATE_DIFF` (BigQuery). Those were fixed before FINAL.

## Cleanups (result unchanged)

- The `fact` CTE is redundant: it groups by every item column, so `SUM(qty * unit_price)` is just the line total. `customer_info_basic` could read straight from the join and `SUM` at order grain.
- `COALESCE(x, NULL)` is a no-op.
- `DATE(...)` is unnecessary because `order_date` is already a date.
- `LEFT JOIN` plus `WHERE o.status = 'completed'` behaves like an inner join.

## Syntax slips (not tallied)

Most errors this session were comma rules in a `WITH` chain:

- A comma goes between CTEs, and there is no comma before the final `SELECT`.
- An extra `SELECT` in the middle of a `WITH` chain ends the statement early.
- Selecting the same column twice makes the next CTE ambiguous.

## Lessons

- Window functions were solid once the grain was right.
- The thing to tidy is CTE comma / structure rules, plus reading the brief as a checklist (required columns and the outer `ORDER BY`).

## Tóm tắt

Số liệu Part 1 khớp, window `PARTITION BY customer_id` đúng. Thiếu `order_id` và `ORDER BY` cuối. Part 2: order 103 ra số 2 nếu không partition. Level 35/100 sau hai tuần; logic mạnh hơn syntax (dấu phẩy trong `WITH`).
