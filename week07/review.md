# Week 7 review

**Date:** 2026-11-02 (Australia/Sydney).

**Level:** 46 → 49/100.

**Result:** Every number and rank matches the expected output. The grid this time was on purpose, not luck.

## What went well

- The city × week grid was built on purpose, so Perth 2026-10-12 shows up with zeros. Week 6’s biggest miss is fixed.
- Tips were added up per delivery before joining, so there is no fan-out from the double tip rows.
- `COUNT(DISTINCT)` for riders, cancelled deliveries dropped before the join, and the late-night deliveries on 10-18 and 10-25 landed in the right weeks.
- The rank was fixed in session: partition by week, `DESC`, and then `COALESCE` so the NULLs-first trap didn’t put Perth at rank 1.

## Logic misses

- **Column order:** the brief wants `city_name`, `week_start`, but the output is `week_start`, `city_name`. Exact output shape matters, and this is the second week in a row.
- **Rank trap needed a run to spot:** `COALESCE` went in only after `DESC` showed Perth at rank 1. Ask “can this value be `NULL`?” before writing any `ORDER BY … DESC` inside a window.
- **Risky division:** `tips_per_delivery` has no `NULLIF(…, 0)` and no `::numeric`. It only works because tip is already numeric. Habit: `ROUND(x::numeric / NULLIF(y, 0), 1)`.

## Mistake scorecard (6 slips)

1. `r.report_weeks` — table name used as a column.
2. `ON d.rider_id = d.rider_id` — a column compared with itself, which blew up to 95 rows.
3. `d.month_start` — a column name left over from week 6.
4. Missing `GROUP BY` after editing a CTE (third week running).
5. `LAG()` with no argument.
6. `LAG` ordered by `completed_deliveries` instead of `week_start`.

No `ORDER BY … AND`, no double quotes, and no `COUNTIF` this week.

## Focus going into week 8

The `GROUP BY` check after every CTE edit, matching output column order exactly, and `LAG` / `RANK` settings (argument, time order, NULLs).

## Tóm tắt

Số liệu và rank khớp; lần này đã chủ động `CROSS JOIN` grid và gộp tip trước khi join. Level 46 → 49. Sai thứ tự cột (`week_start` trước `city_name`). Scorecard 6 lỗi: tên bảng dùng như cột, join `d.rider_id = d.rider_id`, thiếu `GROUP BY`, `LAG()` không đối số / sort sai cột.
