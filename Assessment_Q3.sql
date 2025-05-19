-- CTE to identify the last transaction date with no inflow (i.e., transactions with zero or negative confirmed_amount)
WITH last_inflows AS (
    SELECT 
        s.plan_id,
        MAX(DATE(s.transaction_date)) AS last_transaction_date
    FROM savings_savingsaccount s
    WHERE s.confirmed_amount <= 0  -- Consider only transactions that are NOT inflows (zero or outflows)
    GROUP BY s.plan_id
)

-- Main query to find accounts of type Savings or Investment with no inflow transactions for over one year
SELECT 
    p.id AS plan_id,                      -- Unique identifier for the plan
    p.owner_id,                          -- Owner (customer) of the plan
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'      -- Classify plan as Savings
        WHEN p.is_a_fund = 1 THEN 'Investment'            -- Classify plan as Investment
        ELSE 'Other'                                       -- Catch-all for unexpected cases
    END AS type,
    li.last_transaction_date,             -- Most recent date of a non-inflow transaction (or NULL if none)
    DATEDIFF(CURDATE(), li.last_transaction_date) AS inactivity_days  -- Days since last non-inflow transaction
FROM plans_plan p
LEFT JOIN last_inflows li ON p.id = li.plan_id
WHERE 
    (p.is_regular_savings = 1 OR p.is_a_fund = 1)     -- Only Savings or Investment plans considered
    AND 
    (li.last_transaction_date IS NULL                 -- Include plans with no recorded non-inflow transactions
     OR DATEDIFF(CURDATE(), li.last_transaction_date) > 365)  -- Or plans inactive for more than 365 days
ORDER BY inactivity_days DESC;   -- Sort by inactivity duration, longest inactive first
