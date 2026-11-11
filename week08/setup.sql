DROP TABLE IF EXISTS refunds, invoices, accounts, regions, report_months CASCADE;
CREATE TABLE regions (region_id int PRIMARY KEY, region_name text);
CREATE TABLE accounts (account_id int PRIMARY KEY, account_name text, region_id int REFERENCES regions);
CREATE TABLE invoices (invoice_id int PRIMARY KEY, account_id int REFERENCES accounts, invoice_date date, amount numeric(8,2), status text);
CREATE TABLE refunds (refund_id int PRIMARY KEY, invoice_id int REFERENCES invoices, refund_amount numeric(8,2));
CREATE TABLE report_months (month_start date PRIMARY KEY);
INSERT INTO regions VALUES (1,'NSW'),(2,'VIC'),(3,'QLD'),(4,'WA');
INSERT INTO accounts VALUES (1,'Acme',1),(2,'Bolt',1),(3,'Cirrus',2),(4,'Delta',2),(5,'Echo',3),(6,'Flux',4);
INSERT INTO invoices VALUES
(1,1,'2026-08-05',1000,'paid'),
(2,2,'2026-08-12',500,'paid'),
(3,3,'2026-08-15',800,'paid'),
(4,4,'2026-08-20',300,'void'),
(5,5,'2026-08-25',400,'paid'),
(6,1,'2026-09-03',1000,'paid'),
(7,2,'2026-09-10',600,'paid'),
(8,3,'2026-09-14',800,'paid'),
(9,4,'2026-09-18',700,'paid'),
(10,5,'2026-09-28',400,'void'),
(11,1,'2026-10-02',1200,'paid'),
(12,2,'2026-10-09',500,'paid'),
(13,3,'2026-10-16',800,'paid'),
(14,4,'2026-10-21',700,'paid'),
(15,5,'2026-10-27',450,'paid'),
(16,6,'2026-11-02',900,'paid');
INSERT INTO refunds VALUES
(1,1,100),(2,1,50),(3,3,200),(4,5,40),(5,7,60),(6,8,100),(7,8,100),
(8,9,350),(9,11,120),(10,13,80),(11,14,70),(12,14,70),(13,15,45),(14,4,300);
INSERT INTO report_months VALUES ('2026-08-01'),('2026-09-01'),('2026-10-01');
