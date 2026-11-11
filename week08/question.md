# Week 8 — SaaS billing scorecard by region × month

**Date:** brief sent 2026-11-09; completed 2026-11-11 (Australia/Sydney). About 30 minutes.

Load the tables with `psql -d practice -f week08/setup.sql`.

## Scenario

SaaS billing scorecard for every region in every report month.

## Schema and sample data

`regions(region_id, region_name)`

| region_id | region_name |
| ---: | --- |
| 1 | NSW |
| 2 | VIC |
| 3 | QLD |
| 4 | WA |

`accounts(account_id, account_name, region_id)`

| account_id | account_name | region_id |
| ---: | --- | ---: |
| 1 | Acme | 1 |
| 2 | Bolt | 1 |
| 3 | Cirrus | 2 |
| 4 | Delta | 2 |
| 5 | Echo | 3 |
| 6 | Flux | 4 |

`invoices(invoice_id, account_id, invoice_date, amount, status)`

| invoice_id | account_id | invoice_date | amount | status |
| ---: | ---: | --- | ---: | --- |
| 1 | 1 | 2026-08-05 | 1000 | paid |
| 2 | 2 | 2026-08-12 | 500 | paid |
| 3 | 3 | 2026-08-15 | 800 | paid |
| 4 | 4 | 2026-08-20 | 300 | void |
| 5 | 5 | 2026-08-25 | 400 | paid |
| 6 | 1 | 2026-09-03 | 1000 | paid |
| 7 | 2 | 2026-09-10 | 600 | paid |
| 8 | 3 | 2026-09-14 | 800 | paid |
| 9 | 4 | 2026-09-18 | 700 | paid |
| 10 | 5 | 2026-09-28 | 400 | void |
| 11 | 1 | 2026-10-02 | 1200 | paid |
| 12 | 2 | 2026-10-09 | 500 | paid |
| 13 | 3 | 2026-10-16 | 800 | paid |
| 14 | 4 | 2026-10-21 | 700 | paid |
| 15 | 5 | 2026-10-27 | 450 | paid |
| 16 | 6 | 2026-11-02 | 900 | paid |

`refunds(refund_id, invoice_id, refund_amount)`. One invoice can have several refunds.

| refund_id | invoice_id | refund_amount |
| ---: | ---: | ---: |
| 1 | 1 | 100 |
| 2 | 1 | 50 |
| 3 | 3 | 200 |
| 4 | 5 | 40 |
| 5 | 7 | 60 |
| 6 | 8 | 100 |
| 7 | 8 | 100 |
| 8 | 9 | 350 |
| 9 | 11 | 120 |
| 10 | 13 | 80 |
| 11 | 14 | 70 |
| 12 | 14 | 70 |
| 13 | 15 | 45 |
| 14 | 4 | 300 |

`report_months(month_start)`: `2026-08-01`, `2026-09-01`, `2026-10-01`.

## Brief

Return one row for each region in each report month. Every region shows up every month, even with no invoices. Count only paid invoices, and put each one in the month of its `invoice_date`. Refunds count in the same month as their invoice. A region's net is billed minus refunded, and net is `NULL` for a month with no paid invoices.

Output these columns in exactly this order:

- `month`: text, `YYYY-MM`
- `region_name`
- `invoices`: number of paid invoices
- `billed`: total of the paid amounts, 0 if none
- `refunded`: total refunds on those invoices, 0 if none
- `refund_pct`: `refunded / billed × 100`, rounded to 1 decimal, `NULL` if nothing was billed
- `prev_net`: the region's net in the previous month
- `mom_pct`: % change in net from the previous month, 1 decimal, `NULL` if either month's net is `NULL` or the previous net is 0
- `refund_rank`: `DENSE_RANK` within the month by `refund_pct`, highest first, with regions that billed nothing ranked last

Sort by `month`, then `refund_rank`, then `region_name`.

### Expected output (12 rows)

The original brief shortened some header names so the table would fit. The values below use the full column names from the brief. Blank cells are `NULL`.

| month | region_name | invoices | billed | refunded | refund_pct | prev_net | mom_pct | refund_rank |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 2026-08 | VIC | 1 | 800.00 | 200.00 | 25.0 | NULL | NULL | 1 |
| 2026-08 | NSW | 2 | 1500.00 | 150.00 | 10.0 | NULL | NULL | 2 |
| 2026-08 | QLD | 1 | 400.00 | 40.00 | 10.0 | NULL | NULL | 2 |
| 2026-08 | WA | 0 | 0 | 0 | NULL | NULL | NULL | 3 |
| 2026-09 | VIC | 2 | 1500.00 | 550.00 | 36.7 | 600.00 | 58.3 | 1 |
| 2026-09 | NSW | 2 | 1600.00 | 60.00 | 3.8 | 1350.00 | 14.1 | 2 |
| 2026-09 | QLD | 0 | 0 | 0 | NULL | 360.00 | NULL | 3 |
| 2026-09 | WA | 0 | 0 | 0 | NULL | NULL | NULL | 3 |
| 2026-10 | VIC | 2 | 1500.00 | 220.00 | 14.7 | 950.00 | 34.7 | 1 |
| 2026-10 | QLD | 1 | 450.00 | 45.00 | 10.0 | NULL | NULL | 2 |
| 2026-10 | NSW | 2 | 1700.00 | 120.00 | 7.1 | 1540.00 | 2.6 | 3 |
| 2026-10 | WA | 0 | 0 | 0 | NULL | NULL | NULL | 4 |
