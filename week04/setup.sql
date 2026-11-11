DROP TABLE IF EXISTS tickets, agents, teams CASCADE;
CREATE TABLE teams (team_id int PRIMARY KEY, team_name text);
INSERT INTO teams VALUES (1,'Billing'),(2,'Technical'),(3,'Onboarding'),(4,'Retention');
CREATE TABLE agents (agent_id int PRIMARY KEY, agent_name text, team_id int REFERENCES teams);
INSERT INTO agents VALUES (1,'Mai',1),(2,'Tom',1),(3,'Linh',2),(4,'Sam',2),(5,'Ken',3),(6,'Zoe',4);
CREATE TABLE tickets (ticket_id int PRIMARY KEY, agent_id int REFERENCES agents, created_at date, resolved_at date, status text, rating int);
INSERT INTO tickets VALUES
(1,1,'2026-09-01','2026-09-02','resolved',5),
(2,1,'2026-09-03','2026-09-07','resolved',3),
(3,2,'2026-09-05','2026-09-06','resolved',NULL),
(4,2,'2026-09-10',NULL,'open',NULL),
(5,3,'2026-09-02','2026-09-09','resolved',4),
(6,3,'2026-09-15','2026-09-16','resolved',5),
(7,3,'2026-09-20','2026-09-25','resolved',2),
(8,4,'2026-09-08','2026-09-10','resolved',4),
(9,4,'2026-08-31','2026-09-03','resolved',1),
(10,5,'2026-09-12',NULL,'open',NULL),
(11,5,'2026-09-18','2026-09-19','resolved',5),
(12,1,'2026-10-01','2026-10-02','resolved',4);
