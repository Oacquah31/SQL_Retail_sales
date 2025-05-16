-- sql retail analysis project
create database my_library;
Use my_library
-- create tables
create table retail_sales (
transactions_id INT  PRIMARY KEY,
sale_date DATE,
sale_time TIME,
customer_id INT,
gender VARCHAR(15),
age INT,
category VARCHAR(15),
quantity INT,
price_per_unit FLOAT,
cogs FLOAT,
total_sale FLOAT
)

-- Data cleaning
select *
from retail_sales
where transaction_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or 
category is null
or
cogs is null
or
total_sale is null;

-- 
 
Delete from retail_sales
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or 
category is null
or
cogs is null
or
total_sale is null;

-- Data exploration 
-- How many sales we have?
select count(*) as total_sale from retail_sales 
-- How many uniques customers we have 
select count(Distinct customer_id) as total_customer from retail_sales

-- Category of sales
select Distinct category  from retail_sales

-- Data Analysis & Business key problems & Answers 
-- q.1 Write a sql query to retrieve all columns for sales made on '2022-11-05
-- q.2 write a sql query to retreive all transactions where the category is 'clothing' and the quantity sold is more than 10 in the month of nov-2022
-- q.3 write a sql query to calculate the total sales (total_sale) for each category
-- q.4 write a sql query to find the average age of customers who purchased items from the 'beauty' category.
-- q.5 write a sql query to find all transactions where the total_sale is greater than 1000
-- q.6 write a sql query to find the total umber of transactions (transcation_id) made by each gender in each category.
-- q.7 write a sql query to calculate the average sale per each month. find out best selling month in each year
-- q.8 write a sql query to find the top5 customers based on the highest total sales
-- q.9 write a sql query to find the number of unique customers who purchased items from each category
-- 10  write a sql query to create each shift and number of orders(example morning <=12,afternoon between 12&17, evening >17

-- Q.1 Write a sql query to retrieve all columns for sales made on '2022-11-05
select *
from retail_sales
where sale_date = '2022-11-05';

-- Q.2 write a sql query to retreive all transactions where the category is 'clothing' and the quantity sold is more than 10 in the month of nov-2022
SELECT *
FROM retail_sales
WHERE category = 'clothing'
  AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11'
  AND quantity >=4
  
  -- Q.3 write a sql query to calculate the total sales (total_sale) for each category
  select category,
  sum(total_sale)as net_sale
  from  retail_sales
  group by category;
  
  -- Q.4 write a sql query to find the average age  of customers who purchased items from the 'beauty' category.
  select
  Avg(age)
  from retail_sales
  where category = 'Beauty';
  
  -- Q.5 write a sql query to find all transactions where the total_sale is greater than 1000
  Select *
  from retail_sales
  where total_sale > 1000
  
-- Q.6 write a sql query to find the total umber of transactions (transcation_id) made by each gender in each category.
SELECT category, gender,
count(*) as total_transaction
from retail_sales
group by category, gender
order by category

-- Q.7 write a sql query to calculate the average sale per each month. find out best selling month in each year
SELECT 
  ms.year,
  ms.month,
  ms.avg_sale
FROM (
  SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    AVG(total_sale) AS avg_sale
  FROM retail_sales
  GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS ms
WHERE ms.avg_sale = (
  SELECT 
    MAX(sub.avg_sale)
  FROM (
    SELECT 
      YEAR(sale_date) AS year,
      MONTH(sale_date) AS month,
      AVG(total_sale) AS avg_sale
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
  ) AS sub
  WHERE sub.year = ms.year
);

-- Q8 write a sql query to find the top5 customers based on the highest total sales
SELECT customer_id,
       SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- Q9 write a sql query to find the number of unique customers who purchased items from each category
 SELECT category,
       COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;

-- Q10 write a sql query to create each shift and number of orders(example morning <=12,afternoon between 12&17, evening >17

WITH hourly_sale AS (
    SELECT *,
        CASE
            WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
            WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            ELSE 'Evening'
        END AS shift
    FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) AS total_orders    
FROM hourly_sale
GROUP BY shift;

-- END OF PROJECT
