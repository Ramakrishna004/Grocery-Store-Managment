-- 1. Database
CREATE DATABASE IF NOT EXISTS Grocery_Store_Managment;
USE Grocery_Store_Managment;

-- 2. Supplier Table
CREATE TABLE IF NOT EXISTS supplier (
    sup_id TINYINT PRIMARY KEY,
    sup_name VARCHAR(255),
    address TEXT
);
SELECT * FROM supplier;

-- remove NULL rows if any
DELETE FROM supplier
WHERE sup_id IS NULL
  AND sup_name IS NULL
  AND address IS NULL;

-- 3. Categories Table
CREATE TABLE IF NOT EXISTS categories (
    cat_id TINYINT PRIMARY KEY,
    cat_name VARCHAR(255)
);
SELECT * FROM categories;

-- 4. Employees Table
CREATE TABLE IF NOT EXISTS Store_employees (
    emp_id TINYINT PRIMARY KEY,
    emp_name VARCHAR(255),
    hire_date VARCHAR(255)
);
SELECT * FROM Store_employees;

-- 5. Customers Table
CREATE TABLE IF NOT EXISTS customers (
    cust_id SMALLINT PRIMARY KEY,
    cust_name VARCHAR(255),
    address TEXT
);
SELECT * FROM customers;

-- 6. Products Table
CREATE TABLE IF NOT EXISTS products (
    prod_id TINYINT PRIMARY KEY,
    prod_name VARCHAR(255),
    sup_id TINYINT,
    cat_id TINYINT,
    price DECIMAL(10,2),
    FOREIGN KEY (sup_id) REFERENCES supplier(sup_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (cat_id) REFERENCES categories(cat_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT * FROM products;

-- 7. Orders Table
CREATE TABLE IF NOT EXISTS orders (
    ord_id SMALLINT PRIMARY KEY,
    cust_id SMALLINT,
    emp_id TINYINT,
    order_date VARCHAR(255),
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (emp_id) REFERENCES Store_employees(emp_id)  
        ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT * FROM orders;

-- 8. Order_Details Table
CREATE TABLE IF NOT EXISTS order_details (
    ord_ID SMALLINT AUTO_INCREMENT PRIMARY KEY,
    ord_ids SMALLINT,
    prod_id TINYINT,
    quantity TINYINT,
    each_price DECIMAL(10,2),
    total_price DECIMAL(10,2),
    FOREIGN KEY (ord_id) REFERENCES orders(ord_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (prod_id) REFERENCES products(prod_id)
        ON UPDATE CASCADE ON DELETE CASCADE
);
SELECT * FROM order_details;

-- Question 1
select count(distinct(cust_id)) as Total_count 
from customers;

-- Question 2
SELECT c.cust_id,c.cust_name,COUNT(o.cust_id) AS total_orders
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cust_name
ORDER BY total_orders DESC
LIMIT 1;

-- Question 3
SELECT c.cust_id,c.cust_name,SUM(od.total_price) AS total_purchase_value, AVG(od.total_price) AS avg_purchase_value
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN order_details od ON o.ord_id = od.ord_ids
GROUP BY c.cust_id, c.cust_name
ORDER BY total_purchase_value DESC;

-- Question 4
SELECT c.cust_id,c.cust_name,SUM(od.total_price) AS total_purchase_value
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN order_details od ON o.ord_id = od.ord_ids
GROUP BY c.cust_id, c.cust_name
ORDER BY total_purchase_value DESC
LIMIT 5;

-- Question 5
SELECT c.cat_name, COUNT(p.prod_id) AS total_products
FROM categories c
JOIN products p
  ON c.cat_id = p.cat_id
GROUP BY c.cat_name
ORDER BY total_products DESC;

-- Question 6
SELECT c.cat_name, AVG(od.total_price / od.quantity) AS avg_price
FROM categories c
JOIN products p 
  ON c.cat_id = p.cat_id
JOIN order_details od 
  ON p.prod_id = od.prod_id
GROUP BY c.cat_name
ORDER BY avg_price DESC;


-- Question 7
SELECT p.prod_name, SUM(od.quantity) AS total_quantity_sold
FROM products p
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY p.prod_name
ORDER BY total_quantity_sold DESC limit 1;

-- Question 8
SELECT p.prod_id,p.prod_name,SUM(od.total_price) AS Total_Revenue
FROM order_details od
JOIN products p ON od.prod_id = p.prod_id
GROUP BY p.prod_id, p.prod_name;

-- Question 9
SELECT c.cat_name,s.sup_name,SUM(od.total_price) AS sales
FROM categories c
JOIN products p ON c.cat_id = p.cat_id
JOIN supplier s ON p.sup_id = s.sup_id
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY c.cat_name, s.sup_name;

-- Question 10
SELECT COUNT(*) AS total_orders
FROM orders;

-- Question 11
SELECT SUM(total_price) / COUNT(DISTINCT ord_ids) AS avg_order_value
FROM order_details;

-- Question 12
select o.order_date, count(od.total_price) as total_orders
from orders o
join order_details od on o.ord_id = od.ord_id
group by o.order_date
order by total_orders desc limit 1;

-- Question 13
SELECT DATE_FORMAT(STR_TO_DATE(o.order_date, '%Y-%m-%d'), '%Y-%m') AS month, COUNT(o.ord_id) AS total_orders,SUM(od.total_price) AS total_revenue
FROM orders o
JOIN order_details od ON o.ord_id = od.ord_id
WHERE o.order_date IS NOT NULL
GROUP BY month
ORDER BY month;

-- Question 14
SELECT CASE 
WHEN DAYOFWEEK(order_date) IN (1,7) THEN 'Weekend' ELSE 'Weekday' END AS Day_Type, COUNT(ord_id) AS Total_Orders
FROM orders
GROUP BY Day_Type;

-- Question 15
select count(sup_id) as Total_suppliers
from supplier;

-- Question 16
select s.sup_name ,count(p.prod_id) as Totalproducts
from supplier s
join products p on s.sup_id = p.prod_id
group by s.sup_name
order by Totalproducts limit 1;

-- Question 17
select s.sup_name, avg(od.each_price) as Average_price
from supplier s
join products p on s.sup_id = p.sup_id
join order_details od on p.prod_id = od.ord_id
group by  s.sup_name;

-- Question 18
SELECT s.sup_name, SUM(od.quantity * od.each_price) AS total_revenue
FROM supplier s
JOIN products p ON s.sup_id = p.sup_id
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY s.sup_name
ORDER BY total_revenue DESC;

-- Question 19
SELECT COUNT(DISTINCT emp_id) AS employees_who_processed_orders
FROM orders;

-- Question 20
SELECT se.emp_name,
       COUNT(o.ord_id) AS total_orders
FROM Store_employees se
JOIN orders o 
  ON se.emp_id = o.emp_id
GROUP BY se.emp_name
ORDER BY total_orders DESC;

-- Question 21
SELECT se.emp_name,count(o.ord_id) AS total_orders
FROM Store_employees se
JOIN orders o ON se.emp_id = o.emp_id
GROUP BY se.emp_name
ORDER BY total_orders DESC;

-- Question 22
SELECT se.emp_name, AVG(od.total_price) AS avg_order_value
FROM Store_employees se
JOIN orders o ON se.emp_id = o.emp_id
JOIN order_details od ON o.ord_id = od.ord_id
GROUP BY se.emp_name
ORDER BY avg_order_value DESC;




-- Question 23
SELECT od.quantity,
       AVG(od.total_price) AS avg_total_price
FROM order_details od
GROUP BY od.quantity
ORDER BY od.quantity;

-- Question 24
select p.prod_name, avg(od.quantity) as Average_quantity
from  products p
join order_details od on p.prod_id = od.ord_id
group by p.prod_name;


-- question 25
SELECT p.prod_name,
    MIN(od.each_price) AS min_price,
    MAX(od.each_price) AS max_price,
    AVG(od.each_price) AS avg_price
FROM products p
JOIN order_details od ON p.prod_id = od.prod_id
GROUP BY p.prod_name;