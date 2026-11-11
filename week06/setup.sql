DROP TABLE IF EXISTS payments, members, plans, report_months CASCADE;
CREATE TABLE plans (plan_id int PRIMARY KEY, plan_name text);
CREATE TABLE members (member_id int PRIMARY KEY, member_name text, plan_id int REFERENCES plans);
CREATE TABLE payments (payment_id int PRIMARY KEY, member_id int REFERENCES members, paid_at timestamp, amount numeric(8,2), status text);
CREATE TABLE report_months (month_start date PRIMARY KEY);
INSERT INTO plans VALUES (1,'Basic'),(2,'Premium'),(3,'Student');
INSERT INTO members VALUES (1,'Ana',1),(2,'Ben',1),(3,'Chloe',2),(4,'Dev',2),(5,'Emma',3),(6,'Finn',3);
INSERT INTO payments VALUES
(100,3,'2026-07-02 09:00',60,'paid'),
(101,1,'2026-08-03 08:00',30,'paid'),
(102,2,'2026-08-05 12:00',30,'paid'),
(103,3,'2026-08-02 09:00',60,'paid'),
(104,4,'2026-08-10 10:00',60,'failed'),
(105,5,'2026-08-15 18:00',20,'paid'),
(106,1,'2026-09-03 08:00',30,'paid'),
(107,1,'2026-09-20 19:00',30,'paid'),
(108,2,'2026-09-05 12:00',30,'refunded'),
(109,3,'2026-09-02 09:00',60,'paid'),
(110,4,'2026-09-10 10:00',60,'paid'),
(111,5,'2026-09-15 18:00',20,'failed'),
(112,1,'2026-10-03 08:00',30,'paid'),
(113,2,'2026-10-05 12:00',30,'paid'),
(114,3,'2026-10-02 09:00',60,'paid'),
(115,4,'2026-10-31 21:30',60,'paid'),
(116,5,'2026-10-15 18:00',20,'paid'),
(117,6,'2026-10-18 11:00',20,'paid');
INSERT INTO report_months VALUES ('2026-08-01'),('2026-09-01'),('2026-10-01');
