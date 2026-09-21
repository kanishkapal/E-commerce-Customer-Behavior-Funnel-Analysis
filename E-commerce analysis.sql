CREATE DATABASE ecommerce_analysis;
use ecommerce_analysis;
CREATE TABLE ecommerce_customer_behavior (
    customer_id INT,
    session_id INT,
    visit_date DATE,
    device_type INT,
    user_type INT,
    marketing_channel INT,
    product_id INT,
    product_category INT,
    unit_price DECIMAL(10,2),
    quantity INT,
    discount_percent INT,
    discount_amount DECIMAL(10,2),
    revenue DECIMAL(10,2),
    pages_viewed INT,
    time_on_site_sec INT,
    added_to_cart INT,
    purchased INT,
    cart_abandoned INT,
    rating INT,
    review_text INT,
    review_helpful_votes INT,
    payment_method INT,
    visit_day INT,
    visit_month INT,
    visit_weekday INT,
    visit_season INT,
    session_duration_bucket VARCHAR(50),
    revenue_normalized DECIMAL(10,2),
    location INT
);
SHOW TABLES;
SELECT COUNT(*) 
FROM ecommerce_customer_behavior;



SELECT *
FROM ecommerce_customer_behavior
LIMIT 5;

#E-COMMERCE FUNNEL ANALYSIS
#ques1: TOTAL SESSIONS
SELECT 
    COUNT(DISTINCT session_id) AS total_sessions
FROM ecommerce_customer_behavior;

#ques2: Total sessions where product added to cart
SELECT 
    COUNT(*) AS added_to_cart_sessions
FROM ecommerce_customer_behavior
WHERE added_to_cart = 1;

#ques3: Purchase sessions
SELECT 
    COUNT(*) AS purchase_sessions
FROM ecommerce_customer_behavior
WHERE purchased = 1;

#USER TYPE PERFORMANCE
SELECT 
    user_type,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS total_purchases,
    ROUND((SUM(purchased) / COUNT(*)) * 100, 2) AS conversion_rate
FROM ecommerce_customer_behavior
GROUP BY user_type;

#ques2: device type analysis
SELECT 
    device_type,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS total_purchases,
    ROUND((SUM(purchased) / COUNT(*)) * 100, 2) AS conversion_rate
FROM ecommerce_customer_behavior
GROUP BY device_type
ORDER BY conversion_rate DESC;

#marketing channel analysis
SELECT 
    marketing_channel,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS total_purchases,
    ROUND((SUM(purchased) / COUNT(*)) * 100, 2) AS conversion_rate,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_customer_behavior
GROUP BY marketing_channel
ORDER BY conversion_rate DESC;

#Product Category Analysis
SELECT 
    product_category,
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS add_to_cart_sessions,
    SUM(purchased) AS total_purchases,
    ROUND((SUM(purchased) / COUNT(*)) * 100, 2) AS conversion_rate,
    ROUND(SUM(revenue), 2) AS total_revenue
FROM ecommerce_customer_behavior
GROUP BY product_category
ORDER BY total_revenue DESC;

#Cart Abandonment
select SUM(added_to_cart) as added_to_cart_sessions,
SUM(purchased) as purchase_sessions,
SUM(cart_abandoned) as abandoned_sessions,
ROUND(SUM(cart_abandoned)/SUM(added_to_cart) * 100,2) as cart_abandonment_rate
from ecommerce_customer_behavior;

#Cart Abandonment by User
select user_type,
sum(added_to_cart) as added_to_cart_sessions,
sum(purchased) as purchase_sessions,
sum(cart_abandoned) as abandoned_sessions,
round(sum(cart_abandoned) / sum(added_to_cart)*100,2) as cart_abandonment_rate
from ecommerce_customer_behavior
group by user_type
order by cart_abandonment_rate DESC;

#Revenue & Sales performance analysis

#ques1: Overall Revenue
select sum(Revenue) as total_revenue,
count(*) as total_orders,
round(sum(revenue)/count(*),2) as average_order_value
from ecommerce_customer_behavior
where purchased = 1;

#Revenue by User Type 
select user_type,
COUNT(*) as total_orders,
ROUND(SUM(revenue),2) as total_revenue,
ROUND(SUM(revenue)/COUNT(*),2) as average_order_value
from ecommerce_customer_behavior
where purchased = 1
group by user_type;

#Revenue by Marketing Channel
select marketing_channel,
COUNT(*) as total_orders,
ROUND(SUM(revenue),2) as total_revenue,
ROUND(SUM(revenue)/COUNT(*),2) as average_order_value
from ecommerce_customer_behavior
where purchased = 1
group by marketing_channel
order by total_revenue DESC;

#Revenue by Product Category
select product_category,
count(*) as total_orders,
round(sum(revenue),2) as total_revenue,
round(sum(revenue)/count(*),2) as average_order_value
from ecommerce_customer_behavior
where purchased = 1
group by product_category
order by total_revenue DESC;

#Product Category Performance
SELECT 
    product_category,
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS add_to_cart_sessions,
    SUM(purchased) AS purchase_sessions,
    ROUND((SUM(purchased) * 100.0 / COUNT(*)),2) AS conversion_rate
FROM ecommerce_customer_behavior
GROUP BY product_category
ORDER BY conversion_rate DESC;

#product category cart abandonment
SELECT 
    product_category,
    SUM(added_to_cart) AS added_to_cart_sessions,
    SUM(purchased) AS purchase_sessions,
    SUM(cart_abandoned) AS abandoned_sessions,
    ROUND((SUM(cart_abandoned) * 100.0 / SUM(added_to_cart)),2) AS cart_abandonment_rate
FROM ecommerce_customer_behavior
GROUP BY product_category
ORDER BY cart_abandonment_rate DESC;

#Pages Viewed vs Purchase Conversion
SELECT 
    CASE
        WHEN pages_viewed <= 5 THEN 'Low'
        WHEN pages_viewed <= 10 THEN 'Medium'
        ELSE 'High'
    END AS engagement_level,
    COUNT(*) AS total_sessions,
    SUM(purchased) AS purchase_sessions,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS conversion_rate
FROM ecommerce_customer_behavior
GROUP BY engagement_level
ORDER BY conversion_rate DESC;

#High Interest but Low Conversion Categories 
SELECT 
    product_category,
    COUNT(*) AS total_sessions,
    SUM(added_to_cart) AS cart_sessions,
    SUM(purchased) AS purchase_sessions,
    ROUND(SUM(added_to_cart) * 100.0 / COUNT(*), 2) AS cart_rate,
    ROUND(SUM(purchased) * 100.0 / COUNT(*), 2) AS purchase_rate
FROM ecommerce_customer_behavior
GROUP BY product_category
ORDER BY cart_rate DESC;

#Payment Method Performance
SELECT 
    payment_method,
    COUNT(*) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(SUM(revenue) / COUNT(*), 2) AS average_order_value
FROM ecommerce_customer_behavior
WHERE purchased = 1
GROUP BY payment_method
ORDER BY total_revenue DESC;

