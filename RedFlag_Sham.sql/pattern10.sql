-- =====================================================================
-- PATTERN 10 - DORMANT-THEN-ACTIVE
-- Objective:
-- Detect users who were inactive for 90 or more days and then
-- performed 15 or more transactions after becoming active again.
-- Expected Suspects: 25–27 users
-- =====================================================================

USE redflag;

WITH transaction_gaps AS (
    SELECT
        user_id,
        txn_time,
        LAG(txn_time) OVER (
            PARTITION BY user_id
            ORDER BY txn_time
        ) AS previous_txn_time
    FROM transactions
),
dormant_users AS (
    SELECT
        user_id,
        txn_time AS restart_time
    FROM transaction_gaps
    WHERE previous_txn_time IS NOT NULL
      AND TIMESTAMPDIFF(DAY, previous_txn_time, txn_time) >= 90
)

SELECT
    d.user_id,
    COUNT(*) AS transactions_after_gap
FROM dormant_users d
JOIN transactions t
    ON d.user_id = t.user_id
   AND t.txn_time >= d.restart_time
GROUP BY d.user_id
HAVING COUNT(*) >= 15
ORDER BY transactions_after_gap DESC;

-- Findings:
-- Users who remained inactive for at least 90 days and then
-- completed 15 or more transactions are flagged as possible
-- account takeover cases.