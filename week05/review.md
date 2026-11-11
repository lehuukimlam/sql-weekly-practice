# Week 5 review

**Date:** 2026-10-19 (Australia/Sydney).

**Level:** 41 → 42/100 at FINAL; then 42 → 43 after post-review fixes to `COUNT(DISTINCT)` and the rank. The progress table uses 43.

**Result at FINAL:** Close, but not a match yet. After the two logic fixes, all numbers matched; `title` / `category` column order was still swapped.

## What went well

- Completions were counted per enrolment in their own CTE before joining, so there is no fan-out.
- The September filter (`>=` and `<`) and the `active` filter are both right.
- The query starts from `courses` and uses `COALESCE`, so Storytelling and Power BI show up with 0.
- The final `ORDER BY` has three keys with the right directions.

## What's wrong (FINAL query)

- `unique_students` for SQL Basics is 3, but it should be 2. Student 1 enrolled twice, and `COUNT(student_id)` counts rows, not people. Use `COUNT(DISTINCT student_id)`.
- The brief ranks by `sept_enrollments`, but the FINAL ranked by `unique_students` because it happened to give the right numbers. Once unique students are fixed, SQL Basics and Python would both have 2 students and tie at rank 1. Rank by `COALESCE(m.sept_enrollments, 0) DESC`.
- Column order is swapped: the brief wants `category` first, then `title`.
- The average works by luck: `SUM()` happens to return numeric, so `4/3` gave 1.3. If both sides were integers, Postgres would give 1. Habit: `x::numeric / NULLIF(y, 0)`.
- Join on keys, not names. `metrics` should keep `course_id` and join on that. Joining on `title` plus `category` breaks as soon as two courses share a name.

## Syntax slips (listed, not an official scorecard total)

- Forgot the final `SELECT` after the CTEs, twice.
- `"active"` — double quotes are for names, single quotes for values.
- `AND < '2026-10-01'` without repeating the column on each side of `AND`.
- `ORDER BY` with `AND`, or written twice (also asked about in week 4). It is one `ORDER BY` with commas.
- Two `ON`s in one join. It is one `ON` joined with `AND`.
- `WITH` repeated before the second CTE. Write `WITH` once, then separate CTEs with commas.

## New lesson

In Postgres, `ORDER BY … DESC` puts `NULL`s first. Rank on a value that is already 0-filled, or add `NULLS LAST`.

## After the review

The following query (submitted after the review) switched to `COUNT(DISTINCT student_id)` and ranked by `COALESCE(m.sept_enrollments, 0) DESC`. That earned the move from 42 to 43. Column order `title, category` was still swapped.

```sql
-- Post-review revision, 2026-10-19. Line breaks were not preserved in the chat archive.
WITH lesson_completed AS (SELECT enrollment_id, COUNT(completion_id) FROM lesson_completions GROUP BY enrollment_id), enroll_full_info AS (SELECT e.enrollment_id, c.title, c.category, e.student_id, e.enrolled_at, e.status, l.count FROM enrollments e LEFT JOIN lesson_completed l ON e.enrollment_id = l.enrollment_id LEFT JOIN courses c ON c.course_id = e.course_id WHERE e.enrolled_at >= '2026-09-01' AND e.enrolled_at < '2026-10-01' AND e.status = 'active'), metrics AS (SELECT title, category, COUNT(enrollment_id) sept_enrollments, COUNT(DISTINCT student_id) unique_students, SUM(count) lessons_completed, ROUND(SUM(count) / COUNT(enrollment_id),1) avg_lessons_per_enrollment FROM enroll_full_info GROUP BY category, title) SELECT c.title, c.category, COALESCE(m.sept_enrollments,0) sept_enrollments, COALESCE(m.unique_students,0) unique_students, COALESCE(m.lessons_completed,0) lessons_completed, m.avg_lessons_per_enrollment, RANK() OVER (PARTITION BY c.category ORDER BY COALESCE(m.sept_enrollments,0) DESC) category_rank FROM courses c LEFT JOIN metrics m ON m.title = c.title AND m.category = c.category ORDER BY c.category ASC, category_rank ASC, c.title ASC;
```

## Tóm tắt

FINAL chưa khớp: `COUNT(student_id)` (SQL Basics ra 3 thay vì 2), rank theo `unique_students` thay vì `sept_enrollments`, cột `title` đứng trước `category`. Sau khi sửa hai lỗi logic, số liệu đúng, level 41 → 42 → 43. Thứ tự cột vẫn đảo.
