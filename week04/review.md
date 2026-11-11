# Week 4 review

**Date:** 2026-10-12 (Australia/Sydney).

**Level:** 38 → 41/100.

**Result:** The output matched the expected table on every number, including Retention at 0, 0, `NULL`, `NULL`, and the sort order for this data. The logic is right; several details do not match the brief.

## What went well

- Agents were joined to teams first, then tickets, with one clear grain per step. The three-step CTE chain was well organised.
- `COALESCE` in the outer query for teams with no tickets, and the sort used the coalesced value so Retention lands last.
- The date column used was `created_at`, not `resolved_at`.
- `AVG` ignoring `NULL` ratings worked as expected.

## Where it misses the brief

- The column is named `resolved_ticket`, but the brief asked for `resolved_tickets`.
- The brief said sort ties by `team_name` A to Z; the query uses `team_name DESC`. No two teams tie here, so it got away with it.
- `COUNT(DISTINCT resolved_at)` counts distinct dates, not tickets. It was right only because no two tickets in a team were resolved on the same day. Use `COUNT(ticket_id)`.
- For agents, `COUNT(DISTINCT agent_id)` is safer than names, since two agents can share a name.

## Cleanups

- `BETWEEN '2026-09-01' AND '2026-09-30'` works because `created_at` is a date. Safer habit: `>= '2026-09-01' AND < '2026-10-01'`.
- `LEFT JOIN` from teams to a metrics CTE works, but it is the same workaround as week 3 Part 2. The one-query version would join teams, agents, and tickets with the status and date filters in the last `ON` clause, then use `COUNT(tk.ticket_id)` and `COUNT(DISTINCT tk.agent_id)`.

## Syntax slips (listed, not an official scorecard total)

- A missing comma.
- Typo `agent_nam e`.
- An unclosed quote.
- Double quotes around dates.
- A `DD-MM-YYYY` date format.
- A missing table alias.
- An alias written inside `ROUND()` (`ROUND(AVG(duration) avg_days_to_resolve, 1)`).

New this week: single quotes for values, double quotes for names, and `'YYYY-MM-DD'` for dates.

## Lessons

- Re-read the query against the brief before sending (names, sort direction, the exact count).
- The `LEFT JOIN` + pre-filter workaround still avoids putting filters in `ON`.

## Tóm tắt

Số liệu khớp, kể cả Retention = 0. Sai tên cột (`resolved_ticket`), sort `team_name DESC`, và `COUNT(DISTINCT resolved_at)` thay vì đếm ticket. Level 38 → 41. Grain đã vững hơn.
