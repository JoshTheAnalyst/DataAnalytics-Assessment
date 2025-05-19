-- Customer Lifetime Value (CLV) Estimation
SELECT 
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Calculate account tenure in months since signup
    TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()) AS tenure_months,
    
    -- Count total transactions per customer
    COUNT(s.id) AS total_transactions,
    
    -- Estimate Customer Lifetime Value (CLV) in millions
    -- Formula: (transactions per month * 12) * avg profit per transaction
    -- avg profit per transaction = 0.1% (0.001) of average transaction amount
    ROUND(
        (COUNT(s.id) / NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 0)) -- Avoid divide by zero
        * 12 
        * (AVG(s.confirmed_amount) * 0.001)  -- 0.1% profit per transaction
        / 1000000,  -- Convert to millions
        2
    ) AS estimated_clv_in_millions

FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON u.id = s.owner_id

GROUP BY u.id, u.first_name, u.last_name, u.date_joined

ORDER BY estimated_clv_in_millions DESC;
