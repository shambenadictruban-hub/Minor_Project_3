-- =====================================================================
-- PATTERN 4 - RAPID SUCCESSIVE TRANSACTIONS
-- Objective:
-- Detect users making multiple successful transactions within a
-- very short period of time.
-- Such behaviour may indicate automated fraud or account takeover.
-- Expected Suspects: Approximately 20 users
-- =====================================================================

USE redflag;

WITH txn_gaps AS (
    SELECT
        user_id,
        txn_time,
        TIMESTAMPDIFF(
            SECOND,
            LAG(txn_time) OVER (PARTITION BY user_id ORDER BY txn_time),
            txn_time
        ) AS time_gap
    FROM transactions
    WHERE status = 'SUCCESS'
)

SELECT
    user_id,
    COUNT(*) AS rapid_transactions
FROM txn_gaps
WHERE time_gap IS NOT NULL
  AND time_gap <= 60
GROUP BY user_id
HAVING COUNT(*) >= 3
ORDER BY rapid_transactions DESC;

-- Findings:
-- Users with three or more successful transactions occurring
-- within one minute are flagged as suspicious and should be
-- investigated for possible automated or fraudulent activity.