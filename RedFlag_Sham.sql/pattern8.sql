-- =====================================================================
-- PATTERN 8 - MERCHANT COLLUSION
-- Objective:
-- Detect merchants where the top 5 users contribute more than
-- 60% of the merchant's total transaction value.
-- Expected Suspects: 15 Merchants
-- =====================================================================

USE redflag;

WITH user_totals AS (
    SELECT
        merchant_id,
        user_id,
        SUM(amount) AS user_total
    FROM transactions
    GROUP BY merchant_id, user_id
),
ranked_users AS (
    SELECT
        merchant_id,
        user_id,
        user_total,
        ROW_NUMBER() OVER (
            PARTITION BY merchant_id
            ORDER BY user_total DESC
        ) AS rn
    FROM user_totals
),
top5_totals AS (
    SELECT
        merchant_id,
        SUM(user_total) AS top5_amount
    FROM ranked_users
    WHERE rn <= 5
    GROUP BY merchant_id
),
merchant_totals AS (
    SELECT
        merchant_id,
        SUM(amount) AS merchant_amount
    FROM transactions
    GROUP BY merchant_id
)

SELECT
    m.merchant_id,
    m.merchant_amount,
    t.top5_amount,
    ROUND((t.top5_amount / m.merchant_amount) * 100, 2) AS top5_percentage
FROM merchant_totals m
JOIN top5_totals t
ON m.merchant_id = t.merchant_id
WHERE (t.top5_amount / m.merchant_amount) > 0.60
ORDER BY top5_percentage DESC;