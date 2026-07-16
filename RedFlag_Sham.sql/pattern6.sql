-- =====================================================================
-- PATTERN 6 - MERCHANT CONCENTRATION
-- Objective:
-- Detect users who repeatedly transact with the same merchant.
-- Excessive transactions to one merchant may indicate merchant
-- collusion or suspicious fund transfers.
-- Expected Suspects: Approximately 40 users
-- =====================================================================

USE redflag;

SELECT
    user_id,
    merchant_id,
    COUNT(*) AS transaction_count
FROM transactions
GROUP BY
    user_id,
    merchant_id
HAVING COUNT(*) >= 20
ORDER BY transaction_count DESC;

-- Findings:
-- Users with 20 or more transactions to the same merchant are
-- flagged for further investigation due to possible merchant
-- collusion or fraudulent fund movement.