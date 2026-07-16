-- =====================================================================
-- PATTERN 9 - JUST-UNDER-THRESHOLD (STRUCTURING)
-- Objective:
-- Detect users who repeatedly make transactions of exactly ₹9,999.00.
-- This pattern may indicate structuring (smurfing), where fraudsters
-- intentionally stay below regulatory reporting thresholds.
-- Expected Suspects: 20 Users
-- =====================================================================

USE redflag;

SELECT
    user_id,
    COUNT(*) AS suspicious_transaction_count
FROM transactions
WHERE amount = 9999.00
GROUP BY user_id
HAVING COUNT(*) >= 10
ORDER BY suspicious_transaction_count DESC;

-- Findings:
-- Users with 10 or more transactions of exactly ₹9,999.00
-- are flagged for possible structuring (smurfing) activity.
-- These users should be investigated for potential
-- anti-money laundering (AML) violations.