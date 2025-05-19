-- Transaction Frequency Analysis

WITH transactions_per_user AS (
    SELECT
        s.owner_id,
        COUNT(*) AS total_transactions,  -- Total number of transactions per customer
        TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1 AS tenure_months,  -- Account tenure in months (+1 to avoid division by zero)
        COUNT(*) / (TIMESTAMPDIFF(MONTH, MIN(s.transaction_date), MAX(s.transaction_date)) + 1) AS avg_txn_per_month  -- Average transactions per month
    FROM savings_savingsaccount s
    GROUP BY s.owner_id
),

-- Categorize users based on their average monthly transaction frequency
categorized_users AS (
    SELECT
        u.id AS customer_id,
        COALESCE(t.total_transactions, 0) AS total_transactions,  -- Handle users with no transactions as zero
        COALESCE(t.tenure_months, 1) AS tenure_months,  -- Avoid division by zero, default tenure to 1 month
        COALESCE(t.avg_txn_per_month, 0) AS avg_txn_per_month,  -- Default average transactions to zero for users without transactions
        CASE
            WHEN COALESCE(t.avg_txn_per_month, 0) >= 10 THEN 'High Frequency'  -- 10 or more transactions per month
            WHEN COALESCE(t.avg_txn_per_month, 0) BETWEEN 3 AND 9 THEN 'Medium Frequency'  -- Between 3 and 9 transactions per month
            ELSE 'Low Frequency'  -- 2 or fewer transactions per month
        END AS frequency_category
    FROM users_customuser u
    LEFT JOIN transactions_per_user t ON u.id = t.owner_id
)

-- Aggregate categorized users to show frequency category counts and average transactions per category
SELECT 
    frequency_category,  -- Frequency classification
    COUNT(*) AS customer_count,  -- Number of customers in each category
    ROUND(AVG(avg_txn_per_month), 1) AS avg_transactions_per_month  -- Average transactions per month rounded to 1 decimal place
FROM categorized_users
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');  -- Ensures logical ordering of categories
