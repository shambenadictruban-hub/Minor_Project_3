-- =====================================================================
-- PATTERN 12 - GEOGRAPHIC IMPOSSIBILITY
-- Objective:
-- Detect users who transact in two different cities within
-- 60 minutes.
-- Expected Suspects: Exactly 15 Users
-- =====================================================================


USE redflag;

WITH previous_transactions AS (
    SELECT
        user_id,
        city,
        txn_time,
        LAG(city) OVER (
            PARTITION BY user_id
            ORDER BY txn_time
        ) AS previous_city,
        LAG(txn_time) OVER (
            PARTITION BY user_id
            ORDER BY txn_time
        ) AS previous_time
    FROM transactions
)

SELECT DISTINCT
    user_id,
    previous_city,
    city AS current_city,
    previous_time,
    txn_time AS current_txn_time,
    TIMESTAMPDIFF(MINUTE, previous_time, txn_time) AS minutes_between
FROM previous_transactions
WHERE previous_city IS NOT NULL
  AND previous_city <> city
  AND TIMESTAMPDIFF(MINUTE, previous_time, txn_time) <= 60
ORDER BY user_id;