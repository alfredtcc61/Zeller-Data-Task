/* =================================================================
Task 04(a): top 5 performing merchants in December 2022 by total GPV
================================================================= */

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
- Retail leads top performance: 3 of 5 merchants are in Retail, strong December performance driven by seasonal demand.
- Sales-led acquisition is effective: 60% of top performers were acquired through the Sales channel.
- Success factors are consistent across industries: top merchants span Retail and Restaurants, 
  share similar characteristics of high average transaction value and consistent transaction activity
=================================================================================================================== */
