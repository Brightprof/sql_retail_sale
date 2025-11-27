---CREATING DATABASE
CREATE DATABASE sql_project_p1;

--- CREATING  TABLE
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- 2. DATA EXPLORATION AND CLEANING
-- Correct Quantity column header from "quantiy" to "quantity"
EXEC sp_rename 'retail_sales.quantiy', 'quantity', 'COLUMN';

-- Checking all available data
SELECT * FROM [retail_sales ]

-- **Record Count**: Determine the total number of records in the dataset.
SELECT COUNT(*) FROM [retail_sales ]

-- **Customer Count**: Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT (customer_id)) FROM [retail_sales ]

-- **Category Count**: Identify all unique product categories in the dataset.
SELECT category FROM [retail_sales ] GROUP BY category
SELECT DISTINCT category FROM [retail_sales ]

-- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
SELECT * FROM [retail_sales ] 
WHERE transactions_id IS NULL 
OR sale_date IS NULL 
OR customer_id IS NULL 
OR gender IS NULL 
OR age IS NULL 
OR category IS NULL
OR quantiy IS NULL 
OR price_per_unit IS NULL 
OR cogs IS NULL 
OR total_sale IS NULL;

 DELETE FROM [retail_sales ] 
 WHERE   transactions_id IS NULL 
OR sale_date IS NULL 
OR customer_id IS NULL 
OR gender IS NULL 
OR age IS NULL 
OR category IS NULL
OR quantiy IS NULL 
OR price_per_unit IS NULL 
OR cogs IS NULL 
OR total_sale IS NULL;



-- 3. Data Analysis & Findings
---The following SQL queries were developed to answer specific business questions:

--1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
SELECT *
FROM [retail_sales ]
WHERE sale_date = '2022-11-05';

--2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' 
and the quantity sold is greater or equals 4 in the month of Nov-2022**:


SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND YEAR(sale_date) = 2022
  AND MONTH(sale_date) = 11
  AND quantity >= 4;



--3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
SELECT category,
	SUM(total_sale) AS Total_sale
FROM retail_sales
GROUP BY category



---4. **Write a SQL query to find the average age of customers 
--who purchased items from the 'Beauty' category.**:
SELECT 
	AVG(age) AS Average_age
FROM retail_sales
WHERE category = 'Beauty';


--5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
SELECT *
	FROM retail_sales
WHERE total_sale > 1000


--6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
SELECT 
	category,
	gender,
	COUNT(*) AS Total_Transaction
FROM retail_sales
GROUP BY category, gender


---7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:

SELECT *
FROM (
	SELECT
		YEAR(sale_date) AS YEAR,
		Month(sale_date) AS MONTH,
		AVG(total_sale) AVERAGE_SALE,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC ) AS RANK
	FROM retail_sales
	GROUP BY  YEAR(sale_date), Month(sale_date)
)t  WHERE RANK = 1


---8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
 
SELECT TOP 5
	customer_id AS CUSTOMER,
	SUM(total_sale) AS TOTAL_SALE
FROM retail_sales
GROUP BY customer_id
ORDER BY SUM(total_sale) DESC

--9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:

SELECT 
category,
COUNT(DISTINCT customer_id) AS Unique_customers
FROM retail_sales
GROUP BY category



--10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
WITH Hourly_shift
AS
(
 SELECT  *,
	CASE
		WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
		WHEN DATEPART(HOUR, sale_time) >= 12 AND DATEPART(HOUR, sale_time) < 17 THEN 'Afternoon'
		ELSE 'Evening'
	END  Shift
 FROM retail_sales
)

SELECT
Shift,
COUNT(*) As Total_orders
FROM Hourly_shift
GROUP BY Shift
