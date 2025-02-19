-- Creating and cleaning tables in PostgreSQL

--  Create transactions table
CREATE TABLE transactions (
    transaction_id VARCHAR PRIMARY KEY,
    merchant_id VARCHAR,
    transaction_date DATE,
    transaction_amount NUMERIC(10,2),
    currency VARCHAR(10),
    payment_method VARCHAR(50),
    status VARCHAR(20),
    failure_reason TEXT,
    country VARCHAR(50),
    customer_id VARCHAR
);

--  Insert data into transactions and clean it
INSERT INTO transactions
SELECT 
    transaction_id, 
    merchant_id, 
    TO_DATE(transaction_date, 'YYYY-MM-DD') AS transaction_date, 
    transaction_amount, 
    currency, 
    payment_method, 
    status, 
    COALESCE(failure_reason, 'N/A') AS failure_reason, 
    country, 
    customer_id
FROM raw_transactions;

--  Create merchants table
CREATE TABLE merchants (
    merchant_id VARCHAR PRIMARY KEY,
    merchant_name VARCHAR(100),
    merchant_category VARCHAR(100),
    country VARCHAR(50)
);

--  Insert data into merchants
INSERT INTO merchants
SELECT DISTINCT * FROM raw_merchants;

--  Create chargebacks table
CREATE TABLE chargebacks (
    chargeback_id VARCHAR PRIMARY KEY,
    transaction_id VARCHAR,
    merchant_id VARCHAR,
    chargeback_date DATE,
    chargeback_amount NUMERIC(10,2),
    reason TEXT,
    FOREIGN KEY (transaction_id) REFERENCES transactions(transaction_id),
    FOREIGN KEY (merchant_id) REFERENCES merchants(merchant_id)
);

--  Insert data into chargebacks and clean it
INSERT INTO chargebacks
SELECT 
    chargeback_id, 
    transaction_id, 
    merchant_id, 
    TO_DATE(chargeback_date, 'YYYY-MM-DD') AS chargeback_date, 
    chargeback_amount, 
    reason
FROM raw_chargebacks;

-- Drow the raw(staging) tables
DROP TABLE raw_chargebacks;
DROP TABLE raw_transactions;
DROP TABLE raw_merchants;
