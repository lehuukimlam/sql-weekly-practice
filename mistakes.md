# Recurring mistakes

A running list of slips that showed up in more than one week, plus a few one-offs that became later targets. Only weeks confirmed in the session reviews are listed.

## Logic

### Grain and fan-out

Joining a parent to a one-to-many child (items, refunds, tips, lesson completions) multiplies rows and inflates totals unless the child is collapsed first.

- **Week 1:** The early CTEs grouped by city (or left line totals unaveraged). The FINAL query fixed this with an order-grain `SUM`.
- **Week 2:** A leftover line-level `GROUP BY` / `SUM` in `fact` was redundant once the next CTE summed to order grain. Numbers still matched.
- **Week 3:** Part 1 FINAL pre-aggregated items and refunds per order, which was the point of the exercise (order 201 has two refunds; order 205 has three items).
- **Weeks 5, 7, 8:** Completions, tips, and refunds were pre-aggregated in the FINAL queries. Keep doing this.

### `LEFT JOIN` + `WHERE` on the right table

A filter on the right-hand table in `WHERE` drops the unmatched left rows (`NULL` is not true), so the join behaves like an inner join. Put those filters in `ON` if you need to keep the left rows, or use a plain `JOIN` if you don’t.

- **Week 2:** `LEFT JOIN` plus `WHERE o.status = 'completed'` behaved like an inner join.
- **Week 3:** Part 1 used `WHERE o.cuisine IS NOT NULL` after a `LEFT JOIN` (an inner join with extra steps). Part 2 was built to drill this: `WHERE o.status = 'completed'` hid Sushi Go.
- **Week 4:** Filters lived in a pre-filtered metrics CTE, then teams were `LEFT JOIN`ed on. The intended habit is filters in the last `ON` clause.
- **Week 6:** A `FULL JOIN` plus `WHERE p.paid_at >= …` turned back into a plain join.

### `COUNT(*)` vs `COUNT(col)` vs `COUNT(DISTINCT …)`

- **Week 3 Part 2:** After a correct `LEFT JOIN`, `COUNT(*)` would count the NULL-padded row as 1. `COUNT(o.order_id)` gives 0. `COALESCE(COUNT(*), 0)` does nothing because `COUNT` never returns `NULL`.
- **Week 4:** `COUNT(DISTINCT resolved_at)` counts distinct dates, not tickets. It only matched because no two tickets in a team shared a resolved date. Use `COUNT(ticket_id)`. `COUNT(DISTINCT agent_id)` is safer than counting names.
- **Week 5:** `COUNT(student_id)` counted enrolment rows, so SQL Basics showed 3 unique students instead of 2. Needs `COUNT(DISTINCT student_id)`.

### “Every X in every Y” needs a grid

Start from `CROSS JOIN` of the dimensions, then `LEFT JOIN` the facts.

- **Week 6:** No plan × month grid. Student’s September row only existed because of a failed payment. Removing that payment dropped the row and broke October’s `prev_month_revenue`.
- **Week 7:** The city × week grid was built on purpose (Perth 2026-10-12 showed zeros).
- **Week 8:** The region × month grid was written unprompted.

### NULLs sort first under `DESC`

`COALESCE` (or `NULLS LAST`) has to sit inside the `RANK` / `ORDER BY` expression, not only on the displayed column.

- **Week 5:** `COALESCE` was applied to the displayed metrics, then `RANK` used a column that could still be `NULL` (and, in the FINAL, the wrong column). After review, `RANK` used `COALESCE(m.sept_enrollments, 0) DESC`.
- **Week 6:** `COALESCE` went into the CTE before `LAG` and `DENSE_RANK`, so the rank was correct (after a nudge).
- **Week 7:** A first `DESC` rank put Perth (no tips that week) at 1 until `tip_total` was 0-filled before the rank.
- **Week 8:** `DENSE_RANK … ORDER BY COALESCE(refund_pct, 0) DESC` stopped empty regions from ranking 1, but a real 0% would then tie with “no billing”. Safer: `ORDER BY refund_pct DESC NULLS LAST`.

### Window function settings

- **Week 2:** Early drafts put `GROUP BY` inside `OVER`, or used `COUNT` / `FIRST_VALUE` where `ROW_NUMBER` / `LAG` belonged. The FINAL window clauses were correct. Part 2: without `PARTITION BY customer_id`, order 103 gets `order_number` 2.
- **Week 6:** `revenue_rank` was briefly sorted `DESC` in the outer `ORDER BY`.
- **Week 7:** `LAG()` with no argument; `LAG` ordered by `completed_deliveries` instead of `week_start`.
- **Week 8:** Early `mom_pct` was missing parentheses (`net - prev * 100 / prev`) and was rounded to 0 decimals; the FINAL fixed both. `LAG` / rank arguments were otherwise in place.

### Exact output shape

Column order, names, types, and the outer `ORDER BY` are part of the brief.

- **Week 2:** Final `SELECT` omitted `order_id`; no outer `ORDER BY`.
- **Week 3 Part 2:** `ORDER BY` sat inside the CTE, so the result was not guaranteed to be sorted.
- **Week 4:** `resolved_ticket` instead of `resolved_tickets`; `team_name DESC` instead of A–Z.
- **Week 5:** `title` before `category`; still swapped after the post-review numeric fixes.
- **Week 6:** Column named `change` instead of `revenue_change`; `month_start` came out as a timestamp, not a date.
- **Week 7:** `week_start` before `city_name`.
- **Week 8:** Month needed to be `YYYY-MM` text (fixed in the FINAL). Three `prev_net` cells were `0` instead of `NULL`.

### Safe division and NULL vs 0

Prefer `ROUND(x::numeric / NULLIF(y, 0), 1)`. Don’t turn a missing value into `0` if the brief wants `NULL`, and don’t turn a real `0` into `NULL`.

- **Week 5:** The average worked because `SUM` was already numeric.
- **Week 7:** `tips_per_delivery` had no `NULLIF` and no `::numeric`.
- **Week 8:** `net` used `COALESCE(SUM(amount), 0) - COALESCE(SUM(refund_all), 0)`, so months with no invoices became `0` instead of `NULL`, which put `0` in `prev_net` for WA Sep, QLD Oct, and WA Oct. `NULLIF(COALESCE(refund_pct, 0), 0)` would also hide a real 0% refund rate. A `CASE` that nulls `mom_pct` when the current `net = 0` would be wrong for a genuine 100% refund (that month should be −100%).

### Reading the brief as a checklist

- **Week 2:** Missed a required column and the sort.
- **Week 4:** Almost filtered on the wrong date column during drafts (`resolved_at` vs `created_at`); the FINAL used `created_at`.
- **Week 6:** Date filter was hardcoded and open-ended (`paid_at >= '2026-08-01'` with no upper bound) instead of coming from `report_months`.

## Syntax

Official scorecards started in week 6 (5 slips in week 6, 6 in week 7, 6 in week 8). Earlier weeks list slips from the reviews, without an official total.

### Missing or extra commas, and CTE commas

- **Week 2:** Most errors were comma rules in a `WITH` chain (commas between CTEs, none before the final `SELECT`, a stray `SELECT` mid-chain).
- **Week 3:** A missing comma between `order_id` and `SUM(amount)`, later an extra comma.
- **Week 4:** A missing comma.
- **Week 8:** A double comma (`month,,`) and a missing comma after `refund_pct`.

### `AND` between joins, or a join key compared with itself

- **Week 1:** `AND LEFT JOIN` between two joins.
- **Week 3:** The same `AND` between two `LEFT JOIN`s; also `o.restaurant_id = o.restaurant_id`.
- **Week 5:** Two `ON` clauses in one join (should be one `ON` with `AND`).
- **Week 7:** `ON d.rider_id = d.rider_id`, which blew up to 95 rows.

### `ORDER BY a AND b`, or `ORDER BY` twice

- **Week 4:** This slip was already being asked about.
- **Week 5:** `ORDER BY` with `AND`, or written twice.
- **Week 6:** `ORDER BY month_start AND plan_name` (twice), and `ORDER BY ORDER BY`. Clean in week 7.

### Missing `GROUP BY` after editing a CTE

- **Week 3:** Non-aggregated columns left out of `GROUP BY`.
- **Week 4:** `team_name` selected with aggregates but no `GROUP BY` in an early CTE (hidden behind a typo).
- **Week 6:** Missing `GROUP BY` in the metrics CTE, then again after rewriting it.
- **Week 7:** Missing `GROUP BY` after a CTE edit (third week running).
- **Week 8:** Not forgotten in the FINAL week; it had been a target going in.

### Quotes, reserved words, and names

- **Week 3:** CTE named `full` (reserved); `DISTINCT(r1.restaurants)` used the table name as a column and treated `DISTINCT` like a function.
- **Week 4:** Typo `agent_nam e`; unclosed quote; double quotes around dates; `DD-MM-YYYY` date format. Single quotes are for values, double quotes for names, dates are `'YYYY-MM-DD'`.
- **Week 5:** `"active"` (double quotes); `WITH` repeated before the second CTE.
- **Week 6:** Alias `p` used in a CTE whose `FROM` never defined `p`.
- **Week 7:** `r.report_weeks` (table name as a column); `d.month_start` left over from week 6.
- **Week 8:** `m.report_months` (table name as a column, same pattern as week 7); `month` aliased without `AS` (reserved word).

### Missing the final `SELECT`, and other structure

- **Week 5:** Forgot the final `SELECT` after the CTEs, twice.
- **Week 3 Part 2:** A stray `(` before `COUNT(*)`.
- **Week 4:** Missing table alias (`tickets_metrics` selected as `m`); alias written inside `ROUND()`: `ROUND(AVG(duration) avg_days_to_resolve, 1)`.
- **Week 8:** Extra parenthesis in `ORDER BY (COALESCE(refund_pct, 0) DESC`.

### Dialect mix-ups

- **Week 2:** `DATE_DIFF` (BigQuery). Postgres subtracts dates directly.
- **Week 6:** `COUNTIF` (BigQuery, near miss — switched before running). In Postgres: `COUNT(DISTINCT CASE WHEN … THEN col END)` or `COUNT(*) FILTER (WHERE …)`.
- **Week 7 / 8:** No `COUNTIF` or `ORDER BY … AND` in those weeks.

### Window and `ROUND` typing

- **Week 7:** `LAG()` with no argument.
- **Week 4:** Misplaced `ROUND` closing parenthesis.
- **Weeks 5, 7, 8:** `ROUND` on a float without `::numeric` can bite; it only worked when a side was already numeric.
