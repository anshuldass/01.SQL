WITH CTE1 AS (
	SELECT * FROM Sales.SalesOrderDetail
),
CTE2 AS(
	SELECT * FROM CTE1
	WHERE NOT (LineTotal <=0)
),
CTE3 AS(
	SELECT 
		ProductID,
		CAST(SUM(LineTotal) AS decimal(10,2)) AS RevenuePerProduct
	FROM CTE2
	GROUP BY ProductID
),
CTE4 AS(
	SELECT 
		*,
		CAST(PERCENT_RANK() OVER (ORDER BY RevenuePerProduct DESC)AS decimal(10,2)) AS PerRankProduct
	FROM CTE3
)

SELECT * FROM CTE4 WHERE PerRankProduct >= 0.9