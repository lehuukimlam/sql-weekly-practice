# Week 3 review

**Date:** 2026-10-06 (Australia/Sydney).

**Level:** 35 → 38/100 (both parts included).

**Result:** Part 1 matched the expected output exactly and covered the whole brief (all 6 columns in order, `HAVING`, rounding to 1 decimal, final `ORDER BY`). Part 2 counts were correct, including Sushi Go at 0, but the result was not the expected output: the rows were not sorted, because `ORDER BY` sat inside the CTE.

## Part 1 — what went well

- Fan-out was avoided by summing items per order and refunds per order in separate CTEs, then joining at one row per order. Joining both child tables straight onto orders would have counted order 201's refunds twice and order 205's three times.
- `COALESCE(refunds, 0)` after the `LEFT JOIN` so orders without refunds count as 0 and don't disappear.
- Debugging on a small slice (`order_id = 205`) to see duplicates.

## Part 1 — cleanups

- In `order_info_2`, a `LEFT JOIN` to `orders_info_1` plus `WHERE o.cuisine IS NOT NULL` is an inner join with extra steps. Start from `orders_info_1` and use a plain `JOIN` to `order_items`. This is the same `LEFT JOIN` + `WHERE` habit as week 2.
- `HAVING COUNT(*) > 1` matches the result, but `>= 2` reads like the brief.
- `BETWEEN '2026-09-01' AND '2026-09-30'` works on a date column. On a timestamp it would miss anything after midnight on the 30th. Safer: `>= '2026-09-01' AND < '2026-10-01'`.
- `order_date` in `orders_info_1` is unused later. The `1` suffix on names like `refunds1` is unnecessary.

## Part 2

- Sushi Go disappears because after the `LEFT JOIN` its row has `NULL` in every `o.` column. `WHERE o.status = 'completed'` is not true for that row, so the `LEFT JOIN` acts like an inner join.
- The intended fix is a single query: move status and date into `ON`, and use `COUNT(o.order_id)` (not `COUNT(*)`). Once the filters move to `ON`, `COUNT(*)` would give Sushi Go 1, because it counts the NULL-padded row.
- The submitted workaround never moved the filters into `ON`. It pre-filtered a CTE, then `LEFT JOIN`ed restaurants back, which got the zeros but left the sort inside the CTE.
- Cleanups: `DISTINCT` is not needed; `COALESCE(COUNT(*), 0)` does nothing because `COUNT` never returns `NULL`; joining on `name` works here, but `restaurant_id` is the safer key.
- Part 2 needed several hints.

## Syntax slips (not tallied)

Listed across the session:

- A join key compared with itself (`o.restaurant_id = o.restaurant_id`).
- `AND` between two `JOIN`s (same slip as week 1).
- A missing comma, later an extra comma.
- A dropped closing quote.
- `SELECT *` without `FROM`.
- Non-aggregated columns left out of `GROUP BY`.
- Forgot to alias a `COALESCE`.
- CTE named `full` (reserved word).
- `DISTINCT(r1.restaurants)` — table name used as a column, and `DISTINCT` treated like a function.
- A stray `(` before `COUNT(*)`.
- `ORDER BY` inside a CTE has no guaranteed effect on the final result.

## Lessons

- Check the grain before aggregating; collapse each child table first.
- `LEFT JOIN` + `WHERE` on the right table is an inner join.
- After a `LEFT JOIN`, `COUNT(*)` counts the NULL row as 1; use `COUNT(right_table.id)`.
- The final `ORDER BY` belongs in the outer query.
- Read the brief as a checklist (this week’s Part 1 covered it; week 2 had missed columns).

## Tóm tắt

Part 1 khớp expected output, đã gộp items và refunds theo order nên không bị fan-out. Part 2 đếm đúng (Sushi Go = 0) nhưng `ORDER BY` nằm trong CTE, và filter vẫn để ở `WHERE` rồi join lại. Level 35 → 38. Cần bỏ thói quen `LEFT JOIN` + `WHERE`.
