-- =====================================================================
-- PATTERN 5 - HIGH-VALUE TRANSACTIONS
-- Objective:
-- Detect transactions greater than ₹90,000.
-- High-value transactions are considered high risk and require
-- additional fraud investigation.
-- Expected Suspects: Approximately 30 users
-- =====================================================================

USE redflag;

SELECT
    txn_id,
    user_id,
    merchant_id,
    amount,
    txn_time,
    payment_mode,
    city
FROM transactions
WHERE amount > 90000
ORDER BY amount DESC;

-- Findings:
-- Transactions above ₹90,000 have been identified.
-- These transactions should be reviewed for possible money laundering,
-- unauthorized transfers, or other high-risk financial activity.