-- Task 05: sales vs non-sales merchant performance

SELECT
    CASE 
        WHEN sales_merchant THEN 'Sales_Acquired'
        ELSE 'Non_Sales'
    END AS acquisition_channel,
    COUNT(DISTINCT m.merchant_id) AS merchant_count,
    SUM(t.amount) AS total_gpv,
    COUNT(DISTINCT t.transaction_id) AS total_transactions,
    ROUND(SUM(t.amount) / NULLIF(COUNT(DISTINCT m.merchant_id), 0), 2) AS gpv_per_merchant,
    ROUND(SUM(t.amount) / NULLIF(COUNT(DISTINCT t.transaction_id), 0), 2) AS avg_ticket_value,
    ROUND(COUNT(DISTINCT t.transaction_id)::NUMERIC / NULLIF(COUNT(DISTINCT m.merchant_id), 0), 2) AS avg_txn_per_merchant
FROM transactions t
INNER JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE t.type = 'PURCHASE'
    AND t.status = 'APPROVED'
GROUP BY m.sales_merchant;

/* ==========================================================================================
Insights:
- Sales-acquired merchants represent 58% of merchant base, contributing over 60% of total GPV
- Sales-acquired merchants generate 15% higher GPV per merchant compared to non-sales channel
- Sales-acquired merchants complete more transactions per merchant on average
========================================================================================== */
