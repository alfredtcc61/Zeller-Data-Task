/* ============================================================
Task 03

Bottom 3 performing industries (all time) by GPV,
with transaction volume, merchant count,
average ticket value and portfolio contribution.
============================================================ */

WITH industry_metrics AS (
    SELECT
        m.category AS industry,
        SUM(t.amount) AS industry_gpv,
        COUNT(DISTINCT t.transaction_id) AS industry_txn,
        COUNT(DISTINCT t.merchant_id) AS merchant_count,
        ROUND(SUM(t.amount) / NULLIF(COUNT(DISTINCT t.transaction_id), 0), 2) AS avg_ticket_value
    FROM transactions t
    INNER JOIN merchants m
        ON t.merchant_id = m.merchant_id
    WHERE t.type = 'PURCHASE'
      AND t.status = 'APPROVED'
    GROUP BY m.category
)
SELECT
    industry,
    industry_gpv,
    industry_txn,
    merchant_count,
    avg_ticket_value,
    ROUND(industry_gpv / NULLIF(SUM(industry_gpv) OVER (), 0) * 100, 2) AS gpv_portfolio_share_percent,
    ROUND(industry_txn / NULLIF(SUM(industry_txn) OVER (), 0) * 100, 2) AS txn_portfolio_share_percent
FROM industry_metrics
ORDER BY industry_gpv ASC
LIMIT 3;

/* =================================================================================
Bottom 3 performing industries (from lowest GPV):

| Industry       | Total GPV     | Portfolio %|
|----------------|---------------|------------|
| Transportation | $374,620.17   | 2.26%      | 
| Entertainment  | $823,075.93   | 4.97%      |
| Health Care    | $1,774,696.69 | 10.71%     |

Insights:
- Average transaction values across three industries remain similar at around $256
- Transportation & Entertainment: significantly underrepresented merchant base
- Health Care: adequate merchant presence with suboptimal transaction velocity
================================================================================= */
