# Group 6 Insurance Analytics Project
create database Insurance;
Use Insurance;
drop database Insurance;

# Ahmedabad Branch KPI

# 1-No of Invoice by Account Exec
select count(invoice_number) as number_of_invoice, Account_Executive from invoice group by Account_Executive;

# 2-Yearly Meeting Count
SELECT YEAR(meeting_date) AS meeting_year, COUNT(*) AS meeting_count FROM meeting 
GROUP BY YEAR(meeting_date) ORDER BY meeting_year;

# 3.1-Cross Sell
#Target
select sum(`Cross sell bugdet`) as Target_Cross_sell from individual_budgets;
# Achieve
SELECT 
(SELECT SUM(amount) FROM Brokerage WHERE income_class = 'cross sell')
 +
(SELECT SUM(amount) FROM Fees WHERE income_class = 'cross sell') AS Acheivement_cross_sell;

# 3.2 New Budget
#Target
select sum(New_Budget) as Target_New_Budget from individual_budgets;
#Achieve
select
(select sum(amount) from Brokerage where income_class = "New")
+
(select sum(amount) from fees where income_class = "New") as Acheivement_new_budget;

# 3.1Renewal
#Target
select sum(Renewal_Budget) as target_renewal FROM individual_budgets;
 #Achieve
 select
(select sum(amount) from Brokerage where income_class = "Renewal")
+
(select sum(amount) from fees where income_class = "Renewal") as Acheivement_renewal;

# 4-Stage by Revenue
select sum(revenue_amount) as total_revenue, stage from opportunity 
group by stage order by total_revenue desc;

# 5-No of meeting By Account Exe
select count(meeting_date) as Meetings, account_executive from meeting 
group by account_executive order by meetings desc;

#6-Top Open Opportunity
select sum(revenue_amount) as total_revenue , product_group from opportunity 
where stage ='Qualify Opportunity' or stage ='Propose Solution' group by product_group;

## INSURANCE KPI

# 1-Total Policy
select count(policy_id) as total_policy from policy_details;

# 2-Total Customers
select count(distinct(customer_id)) as Total_customers from policy_details;

# 3-Age Bucket Wise Policy Count
SELECT 
  CASE 
    WHEN ci.age BETWEEN 18 AND 20 THEN '18-20'
    WHEN ci.age BETWEEN 21 AND 30 THEN '21-30'
    WHEN ci.age BETWEEN 31 AND 40 THEN '31-40'
    WHEN ci.age BETWEEN 41 AND 50 THEN '41-50'
    WHEN ci.age BETWEEN 51 AND 60 THEN '51-60'
    WHEN ci.age BETWEEN 61 AND 70 THEN '61-70'
    WHEN ci.age BETWEEN 71 AND 80 THEN '71-80'
    ELSE '80+' 
  END AS age_bucket,
  COUNT(pd.policy_id) AS policy_count
FROM 
  customer_info ci
JOIN 
  policy_details pd ON ci.customer_id = pd.customer_id
GROUP BY age_bucket ORDER BY age_bucket;

# 4-Gender Wise Policy Count
select ci.gender, count(pd.policy_id) as Policy_count from policy_details pd
join customer_info ci on pd.Customer_id=ci.customer_id
group by ci.gender order by Policy_count asc;

# 5-Policy Type Wise Policy Count
select policy_type, count(policy_id) as policy_count from policy_details 
group by policy_type order by policy_count desc;

# 6-Policy Expire This Year
select count(policy_id) as expiring_policy_count from policy_details 
where year(policy_end_date)=year(current_date());

# 7-Premium Growth Rate
SELECT 
  year,
  premium_amount,
  ROUND(
    (premium_amount - LAG(premium_amount) OVER (ORDER BY year)) 
    / LAG(premium_amount) OVER (ORDER BY year) * 100, 
    2
  ) AS growth_rate_percent
FROM (
  SELECT 
    YEAR(Policy_start_date) AS year,
    SUM(premium_amount) AS premium_amount
  FROM 
    policy_details
  GROUP BY 
    YEAR(Policy_start_date)
) AS yearly_premiums;

# 8-Claim Status Wise Policy Count
select count(Policy_ID) as Policy_count, claim_status from claims
group by claim_status order by policy_count desc;

# 9-Payment Status Wise Policy Count
select count(policy_id) as policy_count, payment_status from payment_history 
group by payment_status order by policy_count desc;

# 10-Total Claim Amount
select sum(claim_amount) as Total_Claim_Amount from claims;

## THANK YOU ##