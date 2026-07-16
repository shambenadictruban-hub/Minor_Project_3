-- =====================================================================
-- PATTERN 3 - CARD TESTING FRAUD
-- Objective:
-- Detect users with 5 or more failed transactions.
-- Multiple failed payment attempts may indicate stolen card testing.
-- Expected Suspects: Approximately 35 users
-- =====================================================================

USE redflag;

SELECT
    user_id,
    COUNT(*) AS failed_transaction_count
FROM transactions
WHERE status = 'FAILED'
GROUP BY user_id
HAVING COUNT(*) >= 5
ORDER BY failed_transaction_count DESC;

-- Findings:
-- Users with five or more failed transactions are flagged for
-- investigation, as repeated failures may indicate card testing
-- or unauthorized payment attempts.