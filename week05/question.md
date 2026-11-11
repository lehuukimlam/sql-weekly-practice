# Week 5 — Course enrolments report

**Date:** 2026-10-19 (Australia/Sydney). One problem.

Load the tables with `psql -d practice -f week05/setup.sql`.

## Scenario

For every course, report its active enrolments made in September 2026 (`enrolled_at`).

## Schema

```text
courses            (course_id PK, title, category)
enrollments        (enrollment_id PK, course_id FK, student_id, enrolled_at date, status)
lesson_completions (completion_id PK, enrollment_id FK, lesson_no, completed_at date)
```

## Sample data

`courses`

| course_id | title | category |
| ---: | --- | --- |
| 1 | SQL Basics | Data |
| 2 | Python for Analysts | Data |
| 3 | Excel Pro | Business |
| 4 | Storytelling | Business |
| 5 | Power BI | Data |

`enrollments`

| enrollment_id | course_id | student_id | enrolled_at | status |
| ---: | ---: | ---: | --- | --- |
| 1 | 1 | 1 | 2026-09-02 | active |
| 2 | 1 | 2 | 2026-09-05 | active |
| 3 | 1 | 1 | 2026-09-20 | active |
| 4 | 1 | 3 | 2026-08-28 | active |
| 5 | 2 | 4 | 2026-09-10 | active |
| 6 | 2 | 5 | 2026-09-12 | refunded |
| 7 | 2 | 2 | 2026-09-15 | active |
| 8 | 3 | 6 | 2026-09-03 | active |
| 9 | 3 | 7 | 2026-09-30 | active |
| 10 | 4 | 8 | 2026-09-18 | refunded |
| 11 | 5 | 1 | 2026-10-01 | active |
| 12 | 3 | 8 | 2026-09-22 | active |

`lesson_completions` was shown in the brief as counts per enrolment (each real row is one lesson). Enrolments 3, 9, 10, and 11 have no completions. Full rows are in `setup.sql`.

| enrollment_id | lessons completed (rows) |
| ---: | ---: |
| 1 | 3 |
| 2 | 1 |
| 4 | 2 |
| 5 | 2 |
| 6 | 1 |
| 7 | 4 |
| 8 | 1 |
| 12 | 2 |

## Brief

Return, for every course:

- `category`
- `title`
- `sept_enrollments` — the number of those enrolments
- `unique_students` — distinct students among them
- `lessons_completed` — total lesson completions belonging to those enrolments (0 if none)
- `avg_lessons_per_enrollment` — `lessons_completed` divided by `sept_enrollments`, rounded to 1 decimal place, `NULL` when there are no enrolments
- `category_rank` — `RANK()` within each category by `sept_enrollments`, highest first

Sort by `category` A–Z, then `category_rank`, then `title` A–Z.

### Expected output

| category | title | sept_enrollments | unique_students | lessons_completed | avg_lessons_per_enrollment | category_rank |
| --- | --- | ---: | ---: | ---: | ---: | ---: |
| Business | Excel Pro | 3 | 3 | 3 | 1.0 | 1 |
| Business | Storytelling | 0 | 0 | 0 | NULL | 2 |
| Data | SQL Basics | 3 | 2 | 4 | 1.3 | 1 |
| Data | Python for Analysts | 2 | 2 | 6 | 3.0 | 2 |
| Data | Power BI | 0 | 0 | 0 | NULL | 3 |
