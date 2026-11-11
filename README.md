# SQL weekly practice

Weekly Postgres analytics SQL practice for Australian data analyst / BI interview prep.

Each `weekNN/` folder holds that week's question, the setup script that loads the sample tables, the FINAL query as submitted, and the review from that session (level, syntax slips, logic misses).

Queries in `solution.sql` are the submitted FINAL answers, including mistakes. They are not model solutions.

## How to run

Create a local Postgres database, then load a week's tables and run the submitted query:

```bash
createdb practice   # once
psql -d practice -f week08/setup.sql
psql -d practice -f week08/solution.sql
```

Replace `week08` with the week you want. Week 1 has no `setup.sql`: that brief had no sample database.

## Progress

Dates are in Australia/Sydney. Levels are on a 1–100 practice scale from these sessions, not a formal exam score. Syntax-slip counts are official scorecard totals from week 6 onward; earlier weeks are `n/a` when slips were listed but not tallied.

| Week | Date | Topic / scenario | Level /100 | Syntax slips | Main logic lessons |
| --- | --- | --- | --- | --- | --- |
| 1 | 2026-09-22 | City completed-order AOV (joins + aggregation) | n/a | n/a | Order grain before city averages: join to `order_items` multiplies rows; `SUM` to one row per order first |
| 2 | 2026-09-28 | Customer order patterns (`ROW_NUMBER` / `LAG`) | 35 | n/a | Window `PARTITION BY` customer; cover every required column and put `ORDER BY` in the outer query |
| 3 | 2026-10-06 | Cuisine revenue / refund scorecard + `LEFT JOIN` debug | 38 | n/a | Pre-aggregate items and refunds per order to avoid fan-out; `LEFT JOIN` + `WHERE` on the right table acts like an inner join; `COUNT(*)` vs `COUNT(col)` after a `LEFT JOIN` |
| 4 | 2026-10-12 | Support-desk team scorecard | 41 | n/a | Keep every team (including zeros); put ticket filters in `ON`; `COUNT(ticket_id)` not `COUNT(DISTINCT resolved_at)`; match column names and sort direction to the brief |
| 5 | 2026-10-19 | Course enrolments report with `RANK` | 43 | n/a | `COUNT(DISTINCT student_id)`; rank the column the brief asks for; `COALESCE` must sit inside `RANK` / `ORDER BY … DESC` (NULLs sort first); join on keys, not names |
| 6 | 2026-10-27 | Gym plan × month revenue scorecard (`LAG`, `DENSE_RANK`) | 46 | 5 | For “every X in every Y”, `CROSS JOIN` the dimensions then `LEFT JOIN` facts; don’t hardcode an open-ended date filter; match output names and types |
| 7 | 2026-11-02 | City × week rider performance (grid, tips, `DENSE_RANK`) | 49 | 6 | Build the grid on purpose; pre-aggregate tips; `LAG` ordered by time; watch NULLs under `DESC` and exact column order |
| 8 | 2026-11-11 | SaaS region × month billing scorecard | 51 | 6 | Don’t `COALESCE` a missing month’s net to 0 (it should stay `NULL`); don’t turn a real 0% into `NULL`; prefer `NULLS LAST` (or rank on the raw nullable rate) over `COALESCE` inside the rank |

Week 5’s FINAL review was 41 → 42; after post-review fixes to `COUNT(DISTINCT)` and the rank expression, the level moved to 43. The progress table uses the end-of-week level.

Week 1 had no separate numeric level. 35/100 was first given after weeks 1–2 together.
