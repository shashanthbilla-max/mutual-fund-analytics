create DATABASE mutual_funtd_analysis;
USE mutual_funtd_analysis;


//1.Top 5 Funds by AUM
select * from fact_performance;
SELECT
    scheme_name,
    aum_crore
FROM fact_performance
ORDER BY aum_crore DESC
LIMIT 5;

//2.Average NAV Per Month
SELECT
    DATE_FORMAT(date, '%Y-%m') AS month,
    AVG(nav) AS average_nav
FROM fact_nav
GROUP BY month
ORDER BY month;

//3.SIP Year-over-Year Growth
SELECT
    YEAR(transaction_date) AS year,
    SUM(amount_inr) AS total_sip_amount
FROM fact_transactions
WHERE transaction_type = 'SIP'
GROUP BY year
ORDER BY year;

//4.Total Transactions by State
SELECT
    state,
    COUNT(*) AS total_transactions,
    SUM(amount_inr) AS total_transaction_amount
FROM fact_transactions
GROUP BY state
ORDER BY total_transaction_amount DESC;

//5.Expense Ratio Analysis
SELECT
    scheme_name,
    expense_ratio_pct
FROM fact_performance
WHERE expense_ratio_pct < 1
ORDER BY expense_ratio_pct;

//6. Top 10 Funds by 5-Year Return
SELECT
    scheme_name,
    return_5yr_pct
FROM fact_performance
ORDER BY return_5yr_pct DESC
LIMIT 10;

//7. Top 10 Funds by Sharpe Ratio
SELECT
    scheme_name,
    sharpe_ratio
FROM fact_performance
ORDER BY sharpe_ratio DESC
LIMIT 10;

//8. Average Investment Amount by City Tier
SELECT
    city_tier,
    AVG(amount_inr) AS avg_investment
FROM fact_transactions
GROUP BY city_tier;

//9. Total Transactions by Transaction Type
SELECT
    transaction_type,
    COUNT(*) AS total_transactions,
    SUM(amount_inr) AS total_amount
FROM fact_transactions
GROUP BY transaction_type;


//10. Average 3-Year Return by Fund House
SELECT
    risk_grade,
    COUNT(*) AS total_funds
FROM fact_performance
GROUP BY risk_grade
ORDER BY total_funds DESC;

//11.Fund Houses with Highest Average Returns
SELECT
    fund_house,
    AVG(return_3yr_pct) AS avg_3yr_return
FROM fact_performance
GROUP BY fund_house
ORDER BY avg_3yr_return DESC;

//12.Redemption Amount by State
SELECT
    state,
    SUM(amount_inr) AS redemption_amount
FROM fact_transactions
WHERE transaction_type = 'Redemption'
GROUP BY state
ORDER BY redemption_amount DESC;

//13.Average Expense Ratio by Category
SELECT
    category,
    AVG(expense_ratio_pct) AS avg_expense_ratio
FROM fact_performance
GROUP BY category;

//14.Monthly NAV Trend
SELECT
    date,
    AVG(nav) AS avg_nav
FROM fact_nav
GROUP BY date
ORDER BY date;

//15.Top 10 Cities by SIP Investment
SELECT
    state,
    SUM(amount_inr) AS total_sip
FROM fact_transactions
WHERE transaction_type = 'SIP'
GROUP BY state
ORDER BY total_sip DESC
LIMIT 10;