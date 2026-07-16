-- =====================================================================
-- PATTERN 7 - REFUND ABUSE
-- Objective:
-- Detect users with a refund ratio greater than 40% and at least
-- 20 total transactions. Such users may be abusing refund policies.
-- Expected Suspects: 24–25 users
-- =====================================================================

USE redflag;

SELECT
    user_id,
    COUNT(*) AS total_transactions,
    SUM(CASE
            WHEN txn_type = 'REFUND' THEN 1
            ELSE 0
        END) AS refund_transactions,
    ROUND(
        SUM(CASE
                WHEN txn_type = 'REFUND' THEN 1
                ELSE 0
            END) * 100.0 / COUNT(*),
        2
    ) AS refund_percentage
FROM transactions
GROUP BY user_id
HAVING COUNT(*) >= 20
   AND SUM(CASE
               WHEN txn_type = 'REFUND' THEN 1
               ELSE 0
           END) * 1.0 / COUNT(*) > 0.40
ORDER BY refund_percentage DESC;