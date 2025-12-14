-- Task 04(a): top 5 performing merchants in December 2022 by total GPV

SELECT
    m.name AS merchant_name,
    m.category,
    m.sales_merchant,
    SUM(t.amount) AS total_gpv,
    COUNT(DISTINCT t.transaction_id) AS txn_volume,
    ROUND(SUM(t.amount) / NULLIF(COUNT(DISTINCT t.transaction_id), 0), 2) AS avg_ticket_value
FROM transactions t
INNER JOIN merchants m ON t.merchant_id = m.merchant_id
WHERE t.type = 'PURCHASE'
    AND t.status = 'APPROVED'
    AND t.date >= DATE '2022-12-01'
    AND t.date < DATE '2023-12-15'
GROUP BY m.merchant_id, m.name, m.category, m.sales_merchant
ORDER BY total_gpv DESC
LIMIT 5;

/* ===================================================================================================================
Top 5 performing merchants in December 2022 (from highest GPV):

| Merchant     | Total GPV | Category    | Sales obtained |
|--------------|-----------|-------------|----------------|
| Young-Mcgee  | $6609.49  | Retail      | Yes            |
| Simpson-York | $6510.55  | Retail      | Yes            |
| Walker Inc   | $6401.57  | Retail      | No             |
| Black Llc    | $6127.39  | Restaurants | Yes            |
| Freeman Plc  | $5828.42  | Services    | No             |

Insights:
- Retail leads top performance: 3 of 5 merchants are in Retail, strong December performance driven by seasonal demand
- Sales-led acquisition is effective: 60% of top performers were acquired through the Sales channel
- Success factors are consistent across industries: top merchants span Retail and Restaurants, 
  share similar characteristics of high average transaction value and consistent transaction activity
=================================================================================================================== */



-- Task 04(b): potentially churned merchants

WITH last_transaction AS (
    SELECT
        merchant_id,
        MAX(date) AS last_transaction_date
    FROM transactions
    WHERE type = 'PURCHASE'
        AND status = 'APPROVED'
    GROUP BY merchant_id
)
SELECT
    m.name AS merchant_name,
    m.category AS industry,
    m.sales_merchant,
    lt.last_transaction_date,
    DATE '2022-12-15' - lt.last_transaction_date AS days_since_last_transaction,
    ROUND((DATE '2022-12-15' - lt.last_transaction_date) / 30.0, 1) AS months_since_last_transaction
FROM merchants m
INNER JOIN last_transaction lt ON m.merchant_id = lt.merchant_id
WHERE lt.last_transaction_date < DATE '2022-06-15'
ORDER BY lt.last_transaction_date ASC;

/* ===================================================================================================================================
Number of merchants who have not made transaction for over 6 months: 20

Insights:
- Churned merchants span Retail, Restaurants amd Services
- Both sales-acquired and marketing-acquired merchants churn at similar rates. Problem occurs after onboarding, not during acquisition
- Best chance for re-engagement. (6–9 Months Inactive)
- Likely permanently gone. (12+ Months Inactive)
==================================================================================================================================== */
