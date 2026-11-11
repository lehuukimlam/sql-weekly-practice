# Week 4 — Support-desk team scorecard

**Date:** 2026-10-12 (Australia/Sydney). One problem, about 30 minutes.

Load the tables with `psql -d practice -f week04/setup.sql`.

## Scenario

The support manager wants a September 2026 scorecard for every team.

## Schema and sample data

`teams`

| team_id | team_name |
| ---: | --- |
| 1 | Billing |
| 2 | Technical |
| 3 | Onboarding |
| 4 | Retention |

`agents` (one row per agent, each agent belongs to one team)

| agent_id | agent_name | team_id |
| ---: | --- | ---: |
| 1 | Mai | 1 |
| 2 | Tom | 1 |
| 3 | Linh | 2 |
| 4 | Sam | 2 |
| 5 | Ken | 3 |
| 6 | Zoe | 4 |

`tickets` (one row per ticket, many tickets per agent)

| ticket_id | agent_id | created_at | resolved_at | status | rating |
| ---: | ---: | --- | --- | --- | ---: |
| 1 | 1 | 2026-09-01 | 2026-09-02 | resolved | 5 |
| 2 | 1 | 2026-09-03 | 2026-09-07 | resolved | 3 |
| 3 | 2 | 2026-09-05 | 2026-09-06 | resolved | NULL |
| 4 | 2 | 2026-09-10 | NULL | open | NULL |
| 5 | 3 | 2026-09-02 | 2026-09-09 | resolved | 4 |
| 6 | 3 | 2026-09-15 | 2026-09-16 | resolved | 5 |
| 7 | 3 | 2026-09-20 | 2026-09-25 | resolved | 2 |
| 8 | 4 | 2026-09-08 | 2026-09-10 | resolved | 4 |
| 9 | 4 | 2026-08-31 | 2026-09-03 | resolved | 1 |
| 10 | 5 | 2026-09-12 | NULL | open | NULL |
| 11 | 5 | 2026-09-18 | 2026-09-19 | resolved | 5 |
| 12 | 1 | 2026-10-01 | 2026-10-02 | resolved | 4 |

## Brief

Count only tickets with status `resolved` that were **created** in September 2026. Every team must appear, even one with no such tickets.

Return exactly these columns, in this order:

- `team_name`
- `resolved_tickets` — the number of those tickets (0 if none)
- `agents_with_resolved` — the number of distinct agents on the team who have at least one of those tickets
- `avg_days_to_resolve` — the average of `resolved_at - created_at`, rounded to 1 decimal place
- `avg_rating` — the average rating, rounded to 2 decimal places. Tickets with no rating are ignored, and a team with no tickets shows `NULL`.

Sort by `resolved_tickets` from highest to lowest, then by `team_name` A to Z.

### Expected output

| team_name | resolved_tickets | agents_with_resolved | avg_days_to_resolve | avg_rating |
| --- | ---: | ---: | ---: | ---: |
| Technical | 4 | 2 | 3.8 | 3.75 |
| Billing | 3 | 2 | 2.0 | 4.00 |
| Onboarding | 1 | 1 | 1.0 | 5.00 |
| Retention | 0 | 0 | NULL | NULL |
