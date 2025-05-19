
# Data Analytics Assessment

## Overview

This repository contains SQL solutions for four key business questions designed to analyze customer data and transactional patterns. Each query is crafted to provide actionable insights for different departments such as Sales, Finance, Operations, and Marketing. The solutions leverage multiple tables including user data, account plans, and transaction histories to deliver precise and efficient results.

 1. High-Value Customers with Multiple Products

**Scenario**:
The business aims to identify customers who hold both savings and investment plans to explore cross-selling opportunities.

**Approach:**

* Joined `plans_plan` with `savings_savingsaccount` to link account plans to transactions and owners.
* Filtered plans based on `is_regular_savings = 1` (savings plans) and `is_a_fund = 1` (investment plans).
* Counted distinct plans of each type per customer to avoid duplicate counting of plans.
* Calculated total deposits per customer by summing confirmed amounts.
* Sorted results by total deposits descending to prioritize customers with the highest engagement.

**Expected Outcome:**
A list of customers with their counts of savings and investment plans alongside total deposit amounts, enabling targeted marketing efforts.

---

### 2. Transaction Frequency Analysis

**Scenario:**
Finance needs to categorize customers based on how frequently they transact to tailor financial products and services.

**Approach:**

* Computed the total transactions per customer from `savings_savingsaccount`.
* Calculated account tenure in months using transaction date ranges for accurate average transactions per month.
* Categorized customers into "High Frequency," "Medium Frequency," and "Low Frequency" groups based on average monthly transactions.
* Grouped results to show counts of customers per category and their average transaction frequency.

**Expected Outcome:**
A clear segmentation of customers by transaction frequency, assisting in personalized product offerings and resource allocation.

---

### 3. Account Inactivity Alert

**Scenario:**
Operations want to identify accounts that have had no inflow (positive) transactions for over a year to enable re-engagement campaigns or account reviews.

**Approach:**

* Defined "no inflow" as accounts with confirmed transaction amounts less than or equal to zero.
* Used a subquery to find the most recent transaction date per plan where inflow was absent.
* Joined this with `plans_plan` to identify plan types and owners.
* Filtered for accounts with no inflows for more than 365 days or no transactions at all.
* Calculated inactivity in days to prioritize the most inactive accounts.

**Expected Outcome:**
A prioritized list of inactive accounts including plan details and inactivity duration to inform operational decisions on account management.

---

### 4. Customer Lifetime Value (CLV) Estimation

**Scenario:**
Marketing seeks to estimate customer lifetime value based on transaction volume and account tenure for improved customer valuation and targeting.

**Approach:**

* Calculated customer tenure in months from signup date (`users_customuser.date_joined`).
* Counted total transactions per customer.
* Estimated CLV

  where profit per transaction is assumed to be 0.1% of the transaction value.
* Rounded the CLV value to two decimal places and presented results sorted from highest to lowest CLV.

**Expected Outcome:**
A ranked list of customers by estimated lifetime value to prioritize high-value relationships and marketing investments.

---

## Challenges and Resolutions

* **Data Duplication in Counts:**
  Initially, counts for savings and investment plans returned identical numbers due to improper joins. This was resolved by counting distinct plan IDs within conditional aggregation to ensure accurate plan counts per customer.

* **Handling Nulls and Missing Transactions:**
  Some customers had no transactions leading to division by zero errors when calculating averages. The use of `COALESCE` and `NULLIF` functions helped handle null or zero tenure safely, avoiding runtime errors.

* **Date Calculations for Tenure and Inactivity:**
  Calculating tenure and inactivity involved precise date functions. Ensuring inclusive month counts and handling accounts with single transactions required careful use of `TIMESTAMPDIFF` and date formatting functions.

* **Performance Optimization:**
  To optimize queries, filters were applied before joins where possible, and subqueries (CTEs) were used for reusable calculations like last transaction date or transaction counts, improving readability and performance.

---

## Repository Structure

```
DataAnalytics-Assessment/
│
├── Assessment_Q1.sql      # High-Value Customers with Multiple Products
├── Assessment_Q2.sql      # Transaction Frequency Analysis
├── Assessment_Q3.sql      # Account Inactivity Alert
├── Assessment_Q4.sql      # Customer Lifetime Value (CLV) Estimation
│
└── README.md              # This documentation
