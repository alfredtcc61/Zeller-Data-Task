-- Create tables
CREATE TABLE transactions (
    date DATE,
    transaction_id TEXT,
    merchant_id TEXT,
    type TEXT,
    amount NUMERIC(10, 2),
    status TEXT);

CREATE TABLE merchants (
    merchant_id TEXT,
    name TEXT,
    category TEXT,
    sales_merchant BOOLEAN);

-- Set PKs and FK
ALTER TABLE merchants
ADD CONSTRAINT pk_merchants
PRIMARY KEY (merchant_id);

ALTER TABLE transactions
ADD CONSTRAINT pk_transactions
PRIMARY KEY (transaction_id);

ALTER TABLE transactions
ADD CONSTRAINT fk_transactions_merchants
FOREIGN KEY (merchant_id)
REFERENCES merchants (merchant_id);



/* ============================================================
Task 01

Comparison:
- Previous week: 2022-12-05 to 2022-12-11 (Mon–Sun)
- Prior week:    2022-11-28 to 2022-12-04 (Mon–Sun)

GPV definition:
- TYPE = 'PURCHASE'
- STATUS = 'APPROVED'
============================================================ */

-- a) Overall performance by week
-- Set base CTE
WITH base AS (
    SELECT
        t.date,
        t.transaction_id,
        t.amount,
        m.category,
        CASE
            WHEN t.date BETWEEN DATE '2022-12-05' AND DATE '2022-12-11' THEN 'previous_week'
            WHEN t.date BETWEEN DATE '2022-11-28' AND DATE '2022-12-04' THEN 'prior_week'
        END AS sales_week
    FROM transactions t
    LEFT JOIN merchants m ON t.merchant_id = m.merchant_id
    WHERE t.type = 'PURCHASE' 
        AND t.status = 'APPROVED'
        AND t.date BETWEEN DATE '2022-11-28' AND DATE '2022-12-11'
)

SELECT
    sales_week,
    SUM(amount) AS gpv,
    COUNT(DISTINCT transaction_id) AS transaction_volume,
    ROUND(SUM(amount) / NULLIF(COUNT(DISTINCT transaction_id), 0), 2) AS avg_ticket_value
FROM base
GROUP BY sales_week
ORDER BY sales_week;

-- b) Industry performance comparison
WITH base AS (
    SELECT
        t.date,
        t.transaction_id,
        t.amount,
        m.category,
        CASE
            WHEN t.date BETWEEN DATE '2022-12-05' AND DATE '2022-12-11' THEN 'previous_week'
            WHEN t.date BETWEEN DATE '2022-11-28' AND DATE '2022-12-04' THEN 'prior_week'
        END AS sales_week
    FROM transactions t
    LEFT JOIN merchants m ON t.merchant_id = m.merchant_id
    WHERE t.type = 'PURCHASE' 
        AND t.status = 'APPROVED'
        AND t.date BETWEEN DATE '2022-11-28' AND DATE '2022-12-11'
)

SELECT
    category AS industry,
    SUM(CASE WHEN sales_week = 'previous_week' THEN amount END) AS previous_week_gpv,
    SUM(CASE WHEN sales_week = 'prior_week' THEN amount END) AS prior_week_gpv,
    SUM(CASE WHEN sales_week = 'previous_week' THEN amount END) - SUM(CASE WHEN sales_week = 'prior_week' THEN amount END) AS gpv_change,
    ROUND(
        (SUM(CASE WHEN sales_week = 'previous_week' THEN amount END) - SUM(CASE WHEN sales_week = 'prior_week' THEN amount END)) / 
         NULLIF(SUM(CASE WHEN sales_week = 'prior_week' THEN amount END), 0) * 100, 2) AS gpv_change_percent
FROM base
GROUP BY category
ORDER BY gpv_change_percent DESC;
