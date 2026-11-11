# Week 7 — City × week rider performance

**Date:** 2026-11-02 (Australia/Sydney).

Load the tables with `psql -d practice -f week07/setup.sql`.

## Scenario

Food-delivery app. Ops wants a weekly scorecard of rider activity and tips for every city in every report week. Each report week runs Monday 00:00 to the next Monday 00:00.

## Schema

```text
cities         (city_id, city_name)
riders         (rider_id, rider_name, city_id)
deliveries     (delivery_id, rider_id, delivered_at timestamp, status)
delivery_tips  (tip_id, delivery_id, tip_amount)
report_weeks   (week_start date)
```

## Sample data

`cities`

| city_id | city_name |
| ---: | --- |
| 1 | Sydney |
| 2 | Melbourne |
| 3 | Perth |

`riders`

| rider_id | rider_name | city_id |
| ---: | --- | ---: |
| 1 | Ava | 1 |
| 2 | Ben | 1 |
| 3 | Cal | 2 |
| 4 | Dee | 2 |
| 5 | Eli | 3 |

`deliveries`

| delivery_id | rider_id | delivered_at | status |
| ---: | ---: | --- | --- |
| 201 | 1 | 2026-10-05 12:00:00 | completed |
| 202 | 2 | 2026-10-07 19:00:00 | completed |
| 203 | 3 | 2026-10-06 18:30:00 | completed |
| 204 | 4 | 2026-10-08 20:00:00 | cancelled |
| 205 | 5 | 2026-10-09 13:00:00 | completed |
| 206 | 1 | 2026-10-13 12:00:00 | completed |
| 207 | 1 | 2026-10-18 23:40:00 | completed |
| 208 | 3 | 2026-10-14 19:00:00 | completed |
| 209 | 4 | 2026-10-16 18:00:00 | completed |
| 210 | 2 | 2026-10-20 12:00:00 | completed |
| 211 | 3 | 2026-10-21 19:00:00 | cancelled |
| 212 | 4 | 2026-10-22 18:00:00 | completed |
| 213 | 5 | 2026-10-23 12:00:00 | completed |
| 214 | 5 | 2026-10-25 22:15:00 | completed |
| 215 | 1 | 2026-10-26 09:00:00 | completed |
| 216 | 3 | 2026-10-04 20:00:00 | completed |

`delivery_tips`

| tip_id | delivery_id | tip_amount |
| ---: | ---: | ---: |
| 1 | 201 | 3.00 |
| 2 | 201 | 2.00 |
| 3 | 202 | 5.00 |
| 4 | 203 | 4.00 |
| 5 | 203 | 1.00 |
| 6 | 204 | 5.00 |
| 7 | 205 | 2.00 |
| 8 | 206 | 4.00 |
| 9 | 207 | 3.00 |
| 10 | 207 | 3.00 |
| 11 | 208 | 6.00 |
| 12 | 209 | 2.00 |
| 13 | 209 | 2.00 |
| 14 | 210 | 5.00 |
| 15 | 211 | 4.00 |
| 16 | 212 | 3.00 |
| 17 | 212 | 2.00 |
| 18 | 213 | 1.00 |
| 19 | 215 | 9.00 |

`report_weeks`: `2026-10-05`, `2026-10-12`, `2026-10-19`.

## Brief

Return one row for every city in every report week, with exactly these columns:

- `city_name`
- `week_start`, as a date
- `active_riders` — unique riders with at least one completed delivery that week, or 0 if none
- `completed_deliveries` — completed deliveries that week, or 0 if none
- `tip_total` — sum of tips on completed deliveries that week, or 0 if none
- `tips_per_delivery` — `tip_total / completed_deliveries` rounded to 1 decimal, or `NULL` when there are no deliveries
- `deliveries_change` — `completed_deliveries` minus the same city's previous week, or `NULL` for the first week
- `tip_rank` — dense rank of cities within each week by `tip_total`, with the highest ranked 1

Sort by `week_start`, then `tip_rank`, then `city_name`.

### Expected output

Blank `tips_per_delivery` / `deliveries_change` cells are `NULL`.

| city_name | week_start | active_riders | completed_deliveries | tip_total | tips_per_delivery | deliveries_change | tip_rank |
| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| Sydney | 2026-10-05 | 2 | 2 | 10.00 | 5.0 | NULL | 1 |
| Melbourne | 2026-10-05 | 1 | 1 | 5.00 | 5.0 | NULL | 2 |
| Perth | 2026-10-05 | 1 | 1 | 2.00 | 2.0 | NULL | 3 |
| Melbourne | 2026-10-12 | 2 | 2 | 10.00 | 5.0 | 1 | 1 |
| Sydney | 2026-10-12 | 1 | 2 | 10.00 | 5.0 | 0 | 1 |
| Perth | 2026-10-12 | 0 | 0 | 0 | NULL | -1 | 2 |
| Melbourne | 2026-10-19 | 1 | 1 | 5.00 | 5.0 | -1 | 1 |
| Sydney | 2026-10-19 | 1 | 1 | 5.00 | 5.0 | -1 | 1 |
| Perth | 2026-10-19 | 1 | 2 | 1.00 | 0.5 | 2 | 2 |
