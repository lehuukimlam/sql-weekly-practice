# Week 6 — Gym plan × month revenue scorecard

**Date:** brief sent 2026-10-26; completed 2026-10-27 (Australia/Sydney).

Load the tables with `psql -d practice -f week06/setup.sql`.

A “fix the broken query” part was sent with the brief, then withdrawn the next morning. Week 6 is only the scorecard below.

## Scenario

A gym chain wants a monthly revenue scorecard for each membership plan.

## Schema

```text
plans         (plan_id, plan_name)
members       (member_id, member_name, plan_id)
payments      (payment_id, member_id, paid_at timestamp, amount, status)
              -- status: 'paid' 'refunded' 'failed'
report_months (month_start date)  -- 2026-08-01, 2026-09-01, 2026-10-01
```

## Sample data

`plans`

| plan_id | plan_name |
| ---: | --- |
| 1 | Basic |
| 2 | Premium |
| 3 | Student |

`members`

| member_id | member_name | plan_id |
| ---: | --- | ---: |
| 1 | Ana | 1 |
| 2 | Ben | 1 |
| 3 | Chloe | 2 |
| 4 | Dev | 2 |
| 5 | Emma | 3 |
| 6 | Finn | 3 |

`payments`

| payment_id | member_id | paid_at | amount | status |
| ---: | ---: | --- | ---: | --- |
| 100 | 3 | 2026-07-02 09:00 | 60 | paid |
| 101 | 1 | 2026-08-03 08:00 | 30 | paid |
| 102 | 2 | 2026-08-05 12:00 | 30 | paid |
| 103 | 3 | 2026-08-02 09:00 | 60 | paid |
| 104 | 4 | 2026-08-10 10:00 | 60 | failed |
| 105 | 5 | 2026-08-15 18:00 | 20 | paid |
| 106 | 1 | 2026-09-03 08:00 | 30 | paid |
| 107 | 1 | 2026-09-20 19:00 | 30 | paid |
| 108 | 2 | 2026-09-05 12:00 | 30 | refunded |
| 109 | 3 | 2026-09-02 09:00 | 60 | paid |
| 110 | 4 | 2026-09-10 10:00 | 60 | paid |
| 111 | 5 | 2026-09-15 18:00 | 20 | failed |
| 112 | 1 | 2026-10-03 08:00 | 30 | paid |
| 113 | 2 | 2026-10-05 12:00 | 30 | paid |
| 114 | 3 | 2026-10-02 09:00 | 60 | paid |
| 115 | 4 | 2026-10-31 21:30 | 60 | paid |
| 116 | 5 | 2026-10-15 18:00 | 20 | paid |
| 117 | 6 | 2026-10-18 11:00 | 20 | paid |

`report_months`: `2026-08-01`, `2026-09-01`, `2026-10-01`.

## Brief

For every plan and every month in `report_months`, return:

- `plan_name` and `month_start`
- `paying_members` — distinct members with at least one `'paid'` payment that month
- `revenue` — the sum of `'paid'` amounts that month, showing 0 when there's nothing. Every plan must appear in every month.
- `prev_month_revenue` — that plan's revenue in the previous report month, `NULL` for August
- `revenue_change` — `revenue` minus `prev_month_revenue`
- `revenue_rank` — `DENSE_RANK` of the plans within each month by `revenue`, highest first

Sort by `month_start`, then `revenue_rank`, then `plan_name`.

Look at the grain before writing: Ana pays twice in September, and payment 115 comes in late on 31 Oct.

### Expected output

Blank `prev_month_revenue` / `revenue_change` cells are `NULL`. Values are shown as in the brief.

| plan_name | month_start | paying_members | revenue | prev_month_revenue | revenue_change | revenue_rank |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Basic | 2026-08-01 | 2 | 60.00 | NULL | NULL | 1 |
| Premium | 2026-08-01 | 1 | 60.00 | NULL | NULL | 1 |
| Student | 2026-08-01 | 1 | 20.00 | NULL | NULL | 2 |
| Premium | 2026-09-01 | 2 | 120.00 | 60.00 | 60.00 | 1 |
| Basic | 2026-09-01 | 1 | 60.00 | 60.00 | 0.00 | 2 |
| Student | 2026-09-01 | 0 | 0 | 20.00 | -20.00 | 3 |
| Premium | 2026-10-01 | 2 | 120.00 | 120.00 | 0.00 | 1 |
| Basic | 2026-10-01 | 2 | 60.00 | 60.00 | 0.00 | 2 |
| Student | 2026-10-01 | 2 | 40.00 | 0 | 40.00 | 3 |
