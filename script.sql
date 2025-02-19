-- ===================================================
-- SQL Script for Transaction Analysis and Fraud Detection
-- ===================================================

-- 1. Understand trends in transaction volume and revenue
SELECT 
    DATE_TRUNC('month', transaction_date) AS transaction_month,
    COUNT(transaction_id) AS total_transactions,
    SUM(transaction_amount) AS total_revenue
FROM transactions
WHERE status = 'successful'
GROUP BY transaction_month
ORDER BY transaction_month;

-- 2. Identify top-performing merchants
SELECT 
    m.merchant_name,
    COUNT(t.transaction_id) AS transaction_count,
    SUM(t.transaction_amount) AS total_revenue
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE t.status = 'successful'
GROUP BY m.merchant_name
ORDER BY total_revenue DESC
LIMIT 10;

-- 3. Detect potential fraudulent activities

-- Chargeback Rate by Merchant
SELECT 
    m.merchant_name,
    COUNT(c.chargeback_id) AS chargeback_count,
    COUNT(t.transaction_id) AS total_transactions,
    ROUND((COUNT(c.chargeback_id) * 100.0 / NULLIF(COUNT(t.transaction_id), 0)), 2) AS chargeback_rate
FROM transactions t
LEFT JOIN chargebacks c ON t.transaction_id = c.transaction_id
JOIN merchants m ON t.merchant_id = m.merchant_id
GROUP BY m.merchant_name
ORDER BY chargeback_rate DESC
LIMIT 10;

-- Chargeback Trends Over Time
SELECT 
    DATE_TRUNC('month', chargeback_date) AS chargeback_month,
    COUNT(*) AS chargeback_count
FROM chargebacks
GROUP BY chargeback_month
ORDER BY chargeback_month;

-- Most common chargeback reasons
SELECT reason, COUNT(*) AS occurrences
FROM chargebacks
GROUP BY reason
ORDER BY occurrences DESC
LIMIT 10;

-- 4. Assess the impact of failed transactions on revenue

-- Distribution of Transactions by Status
SELECT status, COUNT(*) 
FROM transactions 
GROUP BY status 
ORDER BY COUNT(*) DESC;

-- Assess lost revenue due to failed transactions
SELECT 
    COUNT(transaction_id) AS failed_transactions,
    SUM(transaction_amount) AS lost_revenue
FROM transactions
WHERE status = 'failed';

-- Top failure reasons affecting revenue
SELECT 
    failure_reason,
    COUNT(transaction_id) AS failure_count,
    SUM(transaction_amount) AS lost_revenue
FROM transactions
WHERE status = 'failed'
GROUP BY failure_reason
ORDER BY lost_revenue DESC
LIMIT 10;

-- 5. Recommend strategies to improve transaction success rates

-- Identify merchants with high failure rates
SELECT 
    m.merchant_name,
    COUNT(t.transaction_id) AS total_transactions,
    COUNT(t.transaction_id) FILTER (WHERE t.status = 'failed') AS failed_transactions,
    ROUND((COUNT(t.transaction_id) FILTER (WHERE t.status = 'failed') * 100.0) / COUNT(t.transaction_id), 2) AS failure_rate
FROM transactions t
JOIN merchants m ON t.merchant_id = m.merchant_id
GROUP BY m.merchant_name
HAVING COUNT(t.transaction_id) > 50 -- Only merchants with significant transactions
ORDER BY failure_rate DESC
LIMIT 10;