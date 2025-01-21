SELECT * FROM walmart;


SELECT COUNT(*) FROM walmart;


SELECT 
	 payment_method,
	 COUNT(*)
FROM walmart
GROUP BY payment_method


SELECT 
	COUNT(DISTINCT branch) 
FROM walmart;


SELECT MIN(quantity) FROM walmart;





 				---- SOLVING SOME PROBLEMS----
				 
--Q.1 Find different payment method and number of transactions, number of qty sold

SELECT 
	 payment_method,
	 COUNT(*) as no_payments,
	 SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method




-- Q.2 Identify the highest-rated category in each branch, displaying the branch, category
-- AVG RATING

SELECT * 
FROM
(	SELECT 
		branch,
		category,
		AVG(rating) as avg_rating,
		RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) as rank
	FROM walmart
	GROUP BY 1, 2
)
WHERE rank = 1




--Q.3 What is the busiest day of the week for each branch based on transaction volume?

SELECT * FROM
	(SELECT
		branch,
		TO_CHAR(TO_DATE(date,'DD/MM/YY'),'Day') as day_name,
		COUNT(*) as num_transactions,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as RANK
	from walmart
	GROUP BY 1,2
	)
WHERE RANK=1
--since the date column is text format, we first convert it to DATE format and then pick day from it




--Q.4 How many items were sold through each payment method?

SELECT 
	 payment_method,
	 SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method




--Q.5 What are the average, minimum, and maximum ratings for each category in each city?

SELECT
	city,
	category,
	MIN(rating) as min_rating,
	MAX(rating) as max_rating,
	AVG(rating) as avg_rating
FROM walmart
GROUP BY 1,2
ORDER BY 1,2 DESC





--Q.6 : What is the total profit for each category, ranked from highest to lowest?

SELECT
	category,
	SUM(total*profit_margin) as total_profit
FROM walmart
GROUP BY 1
ORDER BY 2 DESC




--Q.7 What is the most frequently used payment method in each branch?

SELECT * FROM
	(SELECT
		branch,
		payment_method,
		COUNT(payment_method) as cnt,
		RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) as rank
	FROM walmart
	GROUP by 1,2
	ORDER BY 1,cnt DESC
	)
WHERE rank=1





--Q.8 How many transactions occur in each shift (Morning, Afternoon, Evening) across branches?

SELECT 
	branch,
    CASE 
        WHEN EXTRACT(HOUR FROM time::time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM time::time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
	COUNT(*) AS no_of_transactions
FROM walmart
GROUP BY branch, shift
ORDER BY branch, no_of_transactions DESC

