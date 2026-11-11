# Week 8 review

**Date:** 2026-11-11 (Australia/Sydney).

**Level:** 49 → 51/100.

**Result:** Almost a full match. All rows matched except three `prev_net` cells (WA Sep, QLD Oct, WA Oct), which showed `0` instead of `NULL`.

## What went well

- The region × month `CROSS JOIN` grid was written unprompted, so every region appears in every month.
- Refunds were pre-aggregated per invoice before joining, so there is no fan-out (invoices 1, 8, and 14 have more than one refund).
- `COALESCE` was added inside `DENSE_RANK` after a first run put `NULL` refund rates at rank 1.
- `mom_pct` was corrected in session: parentheses around `(net - prev) * 100`, and rounding to 1 decimal.

This week did not repeat the missing-`GROUP BY` or `ORDER BY … AND` slips.

## Logic misses

1. **`net` is 0 instead of `NULL` when there are no invoices.** The expression is `COALESCE(SUM(amount), 0) - COALESCE(SUM(refund_all), 0)`, so a month with no paid invoices becomes 0. That is the source of the three wrong `prev_net` cells. Fix: `SUM(i.amount) - COALESCE(SUM(i.refund_all), 0)`. With no invoices, `SUM` is `NULL`, so `net`, `prev_net`, and `mom_pct` stay `NULL` without a `CASE`.
2. **`CASE WHEN net = 0 THEN NULL` patches the symptom.** If a region were genuinely refunded 100%, net really is 0, and `mom_pct` should be −100%, not `NULL`. The brief only nulls `mom_pct` when the current net is `NULL` or the previous net is `NULL` or 0. Fix the `net` expression instead.
3. **`NULLIF(COALESCE(refund_pct, 0), 0)` is a hidden bug.** A region that billed something and had no refunds should show `0.0`, but this turns that real 0 into `NULL`. Leave `refund_pct` as calculated.
4. **`COALESCE(refund_pct, 0)` inside the rank** would tie a real 0% with a region that has no billing. Safer: `ORDER BY refund_pct DESC NULLS LAST`.
5. **`DATE_TRUNC` on a `date` returns `timestamptz`** (`+10` / `+11` in this session), then joined to `month_start` (`date`). It worked in this timezone, but `DATE_TRUNC('month', invoice_date)::date` is safer.

## Syntax scorecard (6 slips)

1. `m.report_months` — table name used as a column (same pattern as week 7’s `r.report_weeks`).
2. `month` is a reserved word; the alias needed `AS` (`g.month_start month` errored, `AS month` did not).
3. A double comma (`month,,`).
4. A missing comma after `refund_pct`.
5. An extra parenthesis in `ORDER BY (COALESCE(...) DESC`.
6. Early `mom_pct` was missing parentheses: `net - prev * 100 / prev` (fixed in the FINAL).

## Tóm tắt

Gần như khớp hết; chỉ sai 3 ô `prev_net` (WA 09, QLD 10, WA 10) ra 0 thay vì `NULL`, vì `net` bị `COALESCE` thành 0 khi không có hóa đơn. Level 49 → 51. Grid và gộp refund tự làm được; `mom_pct` và rank đã tự sửa trong buổi. Scorecard 6 lỗi syntax (tên bảng dùng như cột, alias `month`, dấu phẩy / ngoặc).
