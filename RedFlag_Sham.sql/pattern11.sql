-- =====================================================================
-- PATTERN 11 - VELOCITY SPIKE
-- Objective:
-- Detect users whose highest daily transaction count is at least
-- three times their average daily transaction count.
-- Expected Suspects: 20–22 users
-- =====================================================================

USE redflag;

WITH daily_transactions AS (
    SELECT
        user_id,
        DATE(txn_time) AS txn_date,
        COUNT(*) AS daily_count
    FROM transactions
    GROUP BY user_id, DATE(txn_time)
),
user_statistics AS (
    SELECT
        user_id,
        AVG(daily_count) AS average_daily_transactions,
        MAX(daily_count) AS maximum_daily_transactions
    FROM daily_transactions
    GROUP BY user_id
)

SELECT
    user_id,
    ROUND(average_daily_transactions, 2) AS average_daily_transactions,
    maximum_daily_transactions
FROM user_statistics
WHERE maximum_daily_transactions >= (average_daily_transactions * 3)
ORDER BY maximum_daily_transactions DESC;

-- Findings:
-- Users whose maximum daily transaction count is at least
-- three times their average daily transaction count are
-- flagged for possible account takeover or automated fraud.