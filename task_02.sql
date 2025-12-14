/* ============================================================
Task 02

Metrics: GPV and Transaction Volume (cumulative by month)
Data range: up to 2022-11-30
============================================================ */

WITH monthly AS (
    SELECT
        DATE_TRUNC('month', date) AS month_date,
        SUM(amount) AS monthly_gpv,
        COUNT(DISTINCT transaction_id) AS monthly_txn_volume,
        ROUND(SUM(amount) / NULLIF(COUNT(DISTINCT transaction_id), 0), 2) AS monthly_avg_ticket_value
    FROM transactions
    WHERE type = 'PURCHASE'
        AND status = 'APPROVED'
        AND date < DATE '2022-12-01'
    GROUP BY DATE_TRUNC('month', date)
)
SELECT
    TO_CHAR(month_date, 'YYYY-MM') AS month,
    monthly_gpv,
    monthly_txn_volume,
    monthly_avg_ticket_value,
    -- cumulative sums
    SUM(monthly_gpv) OVER (ORDER BY month_date) AS cumulative_gpv,
    SUM(monthly_txn_volume) OVER (ORDER BY month_date) AS cumulative_txn_volume
FROM monthly
ORDER BY month_date;
