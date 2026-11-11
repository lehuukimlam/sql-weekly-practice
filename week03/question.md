# Week 3 — Cuisine revenue / refund scorecard

**Date:** brief sent 2026-10-05; completed 2026-10-06 (Australia/Sydney). About 30 minutes, two parts.

Load the tables with `psql -d practice -f week03/setup.sql`.

## Scenario

Food delivery app. The ops team wants a September 2026 cuisine scorecard.

## Schema and sample data

`restaurants`

| restaurant_id | name | cuisine |
| ---: | --- | --- |
| 1 | Pho Nam | Vietnamese |
| 2 | Banh Mi Bros | Vietnamese |
| 3 | Tokyo Bowl | Japanese |
| 4 | Sushi Go | Japanese |
| 5 | Pasta Vita | Italian |

`orders` (one row per order)

| order_id | restaurant_id | order_date | status |
| ---: | ---: | --- | --- |
| 201 | 1 | 2026-09-02 | completed |
| 202 | 1 | 2026-09-10 | completed |
| 203 | 2 | 2026-09-11 | cancelled |
| 204 | 2 | 2026-09-15 | completed |
| 205 | 3 | 2026-09-05 | completed |
| 206 | 3 | 2026-09-20 | completed |
| 207 | 4 | 2026-08-30 | completed |
| 208 | 4 | 2026-09-25 | cancelled |
| 209 | 5 | 2026-09-18 | completed |
| 210 | 3 | 2026-10-01 | completed |

`order_items` (many rows per order)

| order_id | item_name | qty | unit_price |
| ---: | --- | ---: | ---: |
| 201 | Pho bo | 2 | 15.00 |
| 201 | Spring rolls | 1 | 8.00 |
| 202 | Pho ga | 1 | 14.00 |
| 203 | Banh mi | 3 | 9.00 |
| 204 | Banh mi | 2 | 9.00 |
| 204 | Iced coffee | 2 | 5.00 |
| 205 | Ramen | 2 | 18.00 |
| 205 | Gyoza | 1 | 10.00 |
| 205 | Edamame | 1 | 6.00 |
| 206 | Katsu don | 1 | 20.00 |
| 207 | Sushi set | 2 | 25.00 |
| 208 | Sushi set | 1 | 25.00 |
| 209 | Carbonara | 2 | 22.00 |
| 209 | Tiramisu | 1 | 12.00 |
| 210 | Ramen | 1 | 18.00 |

`refunds` (zero, one, or many rows per order)

| refund_id | order_id | amount |
| ---: | ---: | ---: |
| 1 | 201 | 8.00 |
| 2 | 201 | 4.00 |
| 3 | 205 | 10.00 |
| 4 | 209 | 12.00 |

## Part 1 — write from scratch (about 20 min)

Use completed orders only, with an `order_date` in September 2026. Return exactly these columns, in this order:

- `cuisine`
- `completed_orders` — the number of distinct completed orders
- `gross_revenue` — the sum of `qty × unit_price`
- `refunds` — the total refunded on those orders (0 if there were none)
- `net_revenue` — `gross_revenue` minus `refunds`
- `refund_rate_pct` — `refunds / gross_revenue × 100`, rounded to 1 decimal place

Only keep cuisines with at least 2 completed orders, and sort by `net_revenue` from highest to lowest. Use a CTE chain with at least 3 steps.

Before starting, look at how many rows `order_items` and `refunds` each have for order 201.

### Expected output

| cuisine | completed_orders | gross_revenue | refunds | net_revenue | refund_rate_pct |
| --- | ---: | ---: | ---: | ---: | ---: |
| Vietnamese | 3 | 80.00 | 12.00 | 68.00 | 15.0 |
| Japanese | 2 | 72.00 | 10.00 | 62.00 | 13.9 |

## Part 2 — what's wrong with this query? (about 10 min)

A teammate wants every restaurant with its count of completed September orders, and restaurants with no such orders should show 0. They wrote:

```sql
SELECT r.name, COUNT(*) AS sept_completed_orders
FROM restaurants r
LEFT JOIN orders o ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'completed'
  AND o.order_date BETWEEN '2026-09-01' AND '2026-09-30'
GROUP BY r.name
ORDER BY sept_completed_orders DESC, r.name;
```

It returns:

| name | sept_completed_orders |
| --- | ---: |
| Pho Nam | 2 |
| Tokyo Bowl | 2 |
| Banh Mi Bros | 1 |
| Pasta Vita | 1 |

They wanted:

| name | sept_completed_orders |
| --- | ---: |
| Pho Nam | 2 |
| Tokyo Bowl | 2 |
| Banh Mi Bros | 1 |
| Pasta Vita | 1 |
| Sushi Go | 0 |

Explain why Sushi Go disappears. Fix the query. There is a second bug that only shows up once the first one is fixed, so check the output carefully.

The submitted Part 2 query is in `solution-part2.sql`.
