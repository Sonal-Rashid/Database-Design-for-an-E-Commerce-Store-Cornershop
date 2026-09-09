-- ============================================================
-- Database design for an E-commerce Store - Business Analysis
-- ============================================================

-- ============================================================
-- 1. unique products and categories

SELECT DISTINCT(product_name)
FROM products;

SELECT COUNT(DISTINCT(product_name)) AS total_products
FROM products;

SELECT DISTINCT(category)
FROM products;

SELECT count(DISTINCT(category)) AS total_categories
FROM products;

-- ============================================================
-- 2. total revenue generated

SELECT SUM(p.amount) AS total_revenue
FROM payments p
JOIN orders o
USING (order_id)
WHERE o.order_status = 'Delivered';

-- ============================================================
-- 3. revenue by product and by category

SELECT p.product_name, SUM(oi.quantity * p.price) AS revenue_per_product
FROM order_items oi
LEFT JOIN products p
USING (product_id)
LEFT JOIN orders o
USING (order_id)
WHERE o.order_status = 'Delivered'
GROUP BY p.product_name
ORDER BY revenue DESC;

SELECT p.category, SUM(oi.quantity * p.price) AS revenue_per_category
FROM order_items oi
LEFT JOIN products p
USING (product_id)
LEFT JOIN orders o
USING (order_id)
WHERE o.order_status = 'Delivered'
GROUP BY p.category
ORDER BY revenue DESC;

-- ============================================================
-- 4. top customers by spend

SELECT c.customer_name, SUM(p.amount) AS total_spent
FROM customers c
JOIN orders o
USING (customer_id)
JOIN payments p
USING (order_id)
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_name
ORDER BY total_spent DESC;

-- ============================================================
-- 5. best selling products

SELECT p.product_name, SUM(oi.quantity) AS total_quantity
FROM products p
JOIN order_items oi
USING (product_id)
GROUP BY p.product_name
ORDER BY total_quantity DESC;

-- ============================================================
-- 6. cancelled orders count

SELECT COUNT(*) AS cancelled_orders
FROM orders
WHERE order_status = 'Cancelled';

-- ============================================================
-- 7. monthly revenue

SELECT DATE_FORMAT(payment_date, '%Y-%m') AS `month`, SUM(amount) AS monthly_revenue
FROM payments
GROUP BY `month`;

-- ============================================================
-- 8. no of orders by status

SELECT order_status, COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- ============================================================
-- 9. Average Order Value

SELECT AVG(p.amount) AS average_order_value
FROM payments p
JOIN orders o
USING (order_id)
WHERE o.order_status = 'Delivered';

-- ============================================================
-- 10. Customers with no orders

SELECT c.customer_id, c.customer_name
FROM orders o
JOIN customers c
USING (customer_id)
WHERE o.order_id IS NULL;

-- ============================================================
-- 11. repeat customers

SELECT c.customer_id, c.customer_name, COUNT(order_id) AS total_orders
FROM orders o
JOIN customers c
USING (customer_id)
WHERE o.order_status = 'Delivered'
GROUP BY c.customer_name, c.customer_id
HAVING COUNT(order_id) > 1;