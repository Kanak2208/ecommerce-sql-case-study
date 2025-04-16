/* ===========================================================
   analysis_queries.sql  –  Business insights for the case study
   =========================================================== */

/* 1. Customer Lifetime Value (CLV) */
SELECT
    c.customer_id,
    c.name,
    ROUND(SUM(o.order_amount), 2) AS lifetime_value
FROM customers c
JOIN orders   o ON c.customer_id = o.customer_id
WHERE o.status = 'Completed'
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC
LIMIT 10;

/* 2. Customers at Risk of Churn (no orders in 90+ days) */
SELECT
    c.customer_id,
    c.name,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
HAVING MAX(o.order_date) < CURDATE() - INTERVAL 90 DAY
ORDER BY days_since_last_order DESC;

/* 3. Product Sales Ranking by Month */
SELECT
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    p.product_name,
    SUM(oi.quantity) AS total_sold,
    RANK() OVER (
        PARTITION BY DATE_FORMAT(o.order_date, '%Y-%m')
        ORDER BY SUM(oi.quantity) DESC
    ) AS rank
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products    p  ON oi.product_id = p.product_id
WHERE o.status = 'Completed'
GROUP BY month, p.product_name;

/* 4. Monthly Retention Cohort Analysis */
WITH cohort AS (
    SELECT
        customer_id,
        DATE_FORMAT(signup_date, '%Y-%m') AS cohort_month
    FROM customers
),
activity AS (
    SELECT
        customer_id,
        DATE_FORMAT(order_date, '%Y-%m') AS active_month
    FROM orders
    WHERE status = 'Completed'
)
SELECT
    c.cohort_month,
    a.active_month,
    COUNT(DISTINCT a.customer_id) AS active_users
FROM cohort   c
JOIN activity a USING (customer_id)
GROUP BY c.cohort_month, a.active_month
ORDER BY c.cohort_month, a.active_month;
