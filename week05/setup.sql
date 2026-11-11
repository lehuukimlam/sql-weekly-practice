DROP TABLE IF EXISTS lesson_completions, enrollments, courses CASCADE;
CREATE TABLE courses (course_id int PRIMARY KEY, title text, category text);
INSERT INTO courses VALUES (1,'SQL Basics','Data'),(2,'Python for Analysts','Data'),(3,'Excel Pro','Business'),(4,'Storytelling','Business'),(5,'Power BI','Data');
CREATE TABLE enrollments (enrollment_id int PRIMARY KEY, course_id int REFERENCES courses, student_id int, enrolled_at date, status text);
INSERT INTO enrollments VALUES
(1,1,1,'2026-09-02','active'),(2,1,2,'2026-09-05','active'),(3,1,1,'2026-09-20','active'),(4,1,3,'2026-08-28','active'),
(5,2,4,'2026-09-10','active'),(6,2,5,'2026-09-12','refunded'),(7,2,2,'2026-09-15','active'),
(8,3,6,'2026-09-03','active'),(9,3,7,'2026-09-30','active'),(10,4,8,'2026-09-18','refunded'),
(11,5,1,'2026-10-01','active'),(12,3,8,'2026-09-22','active');
CREATE TABLE lesson_completions (completion_id int PRIMARY KEY, enrollment_id int REFERENCES enrollments, lesson_no int, completed_at date);
INSERT INTO lesson_completions VALUES
(1,1,1,'2026-09-03'),(2,1,2,'2026-09-06'),(3,1,3,'2026-09-10'),(4,2,1,'2026-09-07'),
(5,4,1,'2026-08-30'),(6,4,2,'2026-09-02'),(7,5,1,'2026-09-11'),(8,5,2,'2026-09-14'),
(9,6,1,'2026-09-13'),(10,7,1,'2026-09-16'),(11,7,2,'2026-09-18'),(12,7,3,'2026-09-21'),(13,7,4,'2026-09-25'),
(14,8,1,'2026-09-05'),(15,12,1,'2026-09-23'),(16,12,2,'2026-09-28');
