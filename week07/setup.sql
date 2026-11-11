DROP TABLE IF EXISTS delivery_tips, deliveries, riders, cities, report_weeks CASCADE;
CREATE TABLE cities (city_id int PRIMARY KEY, city_name text);
CREATE TABLE riders (rider_id int PRIMARY KEY, rider_name text, city_id int REFERENCES cities);
CREATE TABLE deliveries (delivery_id int PRIMARY KEY, rider_id int REFERENCES riders, delivered_at timestamp, status text);
CREATE TABLE delivery_tips (tip_id int PRIMARY KEY, delivery_id int REFERENCES deliveries, tip_amount numeric(6,2));
CREATE TABLE report_weeks (week_start date PRIMARY KEY);
INSERT INTO cities VALUES (1,'Sydney'),(2,'Melbourne'),(3,'Perth');
INSERT INTO riders VALUES (1,'Ava',1),(2,'Ben',1),(3,'Cal',2),(4,'Dee',2),(5,'Eli',3);
INSERT INTO deliveries VALUES
(201,1,'2026-10-05 12:00','completed'),
(202,2,'2026-10-07 19:00','completed'),
(203,3,'2026-10-06 18:30','completed'),
(204,4,'2026-10-08 20:00','cancelled'),
(205,5,'2026-10-09 13:00','completed'),
(206,1,'2026-10-13 12:00','completed'),
(207,1,'2026-10-18 23:40','completed'),
(208,3,'2026-10-14 19:00','completed'),
(209,4,'2026-10-16 18:00','completed'),
(210,2,'2026-10-20 12:00','completed'),
(211,3,'2026-10-21 19:00','cancelled'),
(212,4,'2026-10-22 18:00','completed'),
(213,5,'2026-10-23 12:00','completed'),
(214,5,'2026-10-25 22:15','completed'),
(215,1,'2026-10-26 09:00','completed'),
(216,3,'2026-10-04 20:00','completed');
INSERT INTO delivery_tips VALUES
(1,201,3),(2,201,2),(3,202,5),(4,203,4),(5,203,1),(6,204,5),(7,205,2),
(8,206,4),(9,207,3),(10,207,3),(11,208,6),(12,209,2),(13,209,2),
(14,210,5),(15,211,4),(16,212,3),(17,212,2),(18,213,1),(19,215,9);
INSERT INTO report_weeks VALUES ('2026-10-05'),('2026-10-12'),('2026-10-19');
