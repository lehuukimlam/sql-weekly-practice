DROP TABLE IF EXISTS order_items; DROP TABLE IF EXISTS orders; DROP TABLE IF EXISTS customers;
CREATE TABLE orders (order_id int PRIMARY KEY, customer_id int, order_date date, status text);
CREATE TABLE order_items (order_id int, product_id text, qty int, unit_price numeric);
INSERT INTO orders VALUES
(101,1,'2026-08-01','completed'),(102,1,'2026-08-15','completed'),(103,2,'2026-08-10','completed'),
(104,1,'2026-08-20','cancelled'),(105,2,'2026-09-01','completed'),(106,1,'2026-09-05','completed'),
(107,3,'2026-09-10','completed');
INSERT INTO order_items VALUES
(101,'A',2,10),(101,'B',1,30),(102,'A',1,20),(103,'C',4,25),(104,'A',1,10),
(105,'A',2,40),(105,'B',1,20),(106,'C',1,25),(107,'B',3,30);
