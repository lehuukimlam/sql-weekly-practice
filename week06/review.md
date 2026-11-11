# Week 6 review

**Date:** 2026-10-27 (Australia/Sydney).

**Level:** 43 → 46/100.

**Result:** All the numbers match the expected output: paying members, revenue, the 0 for Student in September, the previous-month values, the changes, and the ranks.

## What went well

- `COALESCE` was applied in the CTE, before `LAG` and `DENSE_RANK` ran, so the NULLs-first trap was fixed in the ranking, not just in the displayed column (after a nudge).
- Conditional aggregation with `COUNT(DISTINCT CASE WHEN … END)` and no `ELSE` was clean.
- `DATE_TRUNC` handled the late 31 Oct payment.

## Mistake scorecard (5 errors in 12 runs)

| # | Error | Recurring? |
| ---: | --- | --- |
| 1 | Missing `GROUP BY` in the metrics CTE | New |
| 2 | Used alias `p.` in a CTE whose `FROM` never defined `p` | New (alias scope) |
| 3 | Missing `GROUP BY` again after rewriting the CTE | New, and a repeat within this session |
| 4 | `ORDER BY month_start AND plan_name`, hit twice. The error was also misread and `::date` was removed, which was not the problem | Yes, oldest slip |
| 5 | `ORDER BY ORDER BY` | Yes |

Near miss: `COUNTIF(...)` is BigQuery syntax; it was switched before running. In Postgres: `COUNT(DISTINCT CASE WHEN … THEN col END)` with no `ELSE`.

## Logic misses

- **No plan × month grid.** The query only works because Student happens to have a failed payment in September. With payment 111 removed, Student’s September row disappeared, and October’s `prev_month_revenue` became 20 when it should be 0. Whenever the brief says “every X in every Y”, `CROSS JOIN` plans with `report_months` and `LEFT JOIN` the payments onto that.
- **Date range is hardcoded and open-ended.** `paid_at >= '2026-08-01'` has no upper bound, so November payments would leak in. Take the months from `report_months`.
- **Output doesn’t match the brief.** `month_start` came out as a timestamp, not a date, and the column is called `change` instead of `revenue_change`. `revenue_rank` was also briefly sorted `DESC`.
- `FULL JOIN` wasn’t needed. The `WHERE` on `p.paid_at` turned it back into a plain join anyway.

Hints this week included `DATE_TRUNC`, `LAG`, rank direction, `COUNTIF`, the `ORDER BY` error, and a nudge on NULLs in the ranking. Asking about concepts is fine; the `ORDER BY … AND` slip should be automatic by now.

The +3 was because the logic was right on the sample and the NULL trap was fixed. The missing grid and the two `ORDER BY` repeats held it back from 48–50.

## Tóm tắt

Số liệu khớp expected output, đã `COALESCE` trước `LAG`/`DENSE_RANK`. Level 43 → 46. Chưa làm grid plan × month (hàng Student tháng 9 chỉ có nhờ payment failed). Cột tên `change` thay vì `revenue_change`, `month_start` ra timestamp. Scorecard: 5 lỗi syntax, trong đó `ORDER BY … AND` lặp lại.
