-- =====================================================================
-- PATTERN 2 - ROUND-AMOUNT CLUSTERING
-- Objective:
-- Detect users who repeatedly perform transactions with exact round
-- amounts such as ₹100, ₹200, ₹500, ₹1000, ₹2000, ₹5000, and ₹10000.
-- Such behaviour may indicate money laundering or suspicious fund
-- transfers because genuine shopping transactions usually have
-- irregular amounts due to taxes, discounts, and delivery charges.
-- Expected Suspects: 25 users
-- =====================================================================

USE redflag;

SELECT
    user_id,
    COUNT(*) AS round_amount_transaction_count
FROM transactions
WHERE amount IN (100, 200, 500, 1000, 2000, 5000, 10000)
GROUP BY user_id
HAVING COUNT(*) >= 15
ORDER BY round_amount_transaction_count DESC;

-- Findings:
-- Users with 15 or more transactions of exact round amounts are flagged
-- as suspicious. These users may require further investigation for
-- potential money laundering or fraudulent fund movement.