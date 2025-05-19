-- High-Value Customers with Multiple Products

SELECT 
    s.owner_id,  -- Unique identifier for each customer/account holder
    CONCAT(u.first_name, ' ', u.last_name) AS name,  -- Full name of the customer
    
    -- Count of distinct savings plans per customer where plan is a regular savings
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,

    -- Count of distinct investment plans per customer where plan is a fund
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,

    -- Total confirmed deposits summed, converted to millions and rounded to 2 decimals
    ROUND(SUM(s.confirmed_amount) / 100000000, 2) AS total_deposits_in_millions
    
FROM plans_plan p
LEFT JOIN savings_savingsaccount s 
    ON p.id = s.id  -- Join plans with savings accounts on plan ID
LEFT JOIN users_customuser u 
    ON u.id = s.owner_id  -- Join users with savings accounts on owner ID

GROUP BY 
    s.owner_id, 
    CONCAT(u.first_name, ' ', u.last_name)  -- Group results by owner ID and full name

HAVING 
    savings_count > 0  -- Ensure customer has at least one savings plan
    AND investment_count > 0  -- Ensure customer has at least one investment plan

ORDER BY 
    total_deposits_in_millions DESC;  -- Sort customers by total deposits, highest first
