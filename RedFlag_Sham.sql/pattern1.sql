
-- =====================================================================
-- PATTERN 1 - VELOCITY FRAUD
-- Objective:
-- Detect users who perform 30 or more transactions on the same day.
-- Such unusually high transaction volume may indicate automated bots,
-- account takeover, or fraudulent transaction scripts.
-- =====================================================================

USE redflag;

SELECT
    user_id,
    DATE(txn_time) AS attack_date,
    COUNT(*) AS daily_transaction_count
FROM transactions
GROUP BY
    user_id,
    DATE(txn_time)
HAVING COUNT(*) >= 30
ORDER BY daily_transaction_count DESC;

-- Findings:
-- 50 suspicious user-days were detected.
-- The highest transaction count observed was 60 transactions in a single day.