use Supermarket;
-- =============================================
--  What is the total revenue generated?
-- =============================================

SELECT ROUND(SUM(Total),2)Total_Revenue 
FROM supermarket_sales;

-- =============================================
--  Which branch generated the highest revenue?
-- =============================================

SELECT
    branch,
    ROUND(SUM(total),2) AS revenue
FROM supermarket_sales
GROUP BY branch
ORDER BY revenue DESC;

-- =============================================
--  Which city contributes the most sales?
-- =============================================

WITH revenue_by_city AS (
    SELECT 
        city, 
        SUM(total) AS revenue 
    FROM supermarket_sales 
    GROUP BY city
)
SELECT 
    city,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        SUM(revenue) OVER (ORDER BY revenue DESC) * 100.0 / 
        SUM(revenue) OVER (), 
        2
    ) AS cumulative_percentage
FROM revenue_by_city
ORDER BY revenue DESC;


-- =============================================
-- -- Which product lines contribute most of the revenue?
-- =============================================

WITH revenue_cte AS (
    SELECT
        product_line,
        SUM(total) revenue
    FROM supermarket_sales
    GROUP BY product_line
)

SELECT
    product_line,
    revenue,
    SUM(revenue) OVER(ORDER BY revenue DESC) * 100 /
    SUM(revenue) OVER() cumulative_percentage
FROM revenue_cte;

-- =============================================
-- Which product line generates the highest revenue?
-- =============================================

SELECT
    product_line,
    ROUND(SUM(total),2) AS revenue
FROM supermarket_sales
GROUP BY product_line
ORDER BY revenue DESC;

-- =============================================
-- Customer Lifetime Value Proxy
-- =============================================

SELECT
    customer_type,
    COUNT(*) transactions,
    ROUND(AVG(total),2) avg_order_value,
    ROUND(SUM(total),2) total_revenue
FROM supermarket_sales
GROUP BY customer_type;


-- =============================================
--  What is the revenue contribution by customer type?
-- =============================================

SELECT
    customer_type,
    ROUND(SUM(total),2) AS revenue
FROM supermarket_sales
GROUP BY customer_type
ORDER BY revenue DESC;

-- =============================================
--  Which hour of the day generates maximum sales?
-- =============================================

SELECT
    HOUR(Time) AS sales_hour,
    ROUND(SUM(total),2) AS revenue
FROM supermarket_sales
GROUP BY sales_hour
ORDER BY revenue DESC;

-- =============================================
-- Product Line Profitability Ranking
-- =============================================

SELECT
    product_line,
    ROUND(SUM(gross_income),2) AS profit,
    RANK() OVER(
        ORDER BY SUM(gross_income) DESC
    ) profit_rank
FROM supermarket_sales
GROUP BY product_line;

-- =============================================
--  Which day of the week generates the highest sales?
-- =============================================

SELECT
    DAYNAME(date) AS weekday,
    ROUND(SUM(total),2) AS revenue
FROM supermarket_sales
GROUP BY weekday
ORDER BY revenue DESC;

-- =============================================
-- Revenue Trend Analysis 
-- =============================================

SELECT
    date,
    ROUND(SUM(total),2) daily_revenue,
    ROUND(
        SUM(total) -
        LAG(SUM(total))
        OVER(ORDER BY date),2
    ) revenue_change
FROM supermarket_sales
GROUP BY date
ORDER BY date;

