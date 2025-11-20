WITH CTE1 AS (
	SELECT * FROM Sales.SalesOrderDetail
	WHERE NOT( LineTotal <= 0)
),
CTE2 AS (
	SELECT DISTINCT
		ProductID,
		CAST(SUM(LineTotal) OVER(PARTITION BY ProductID)AS decimal(10,2)) AS TotalRevenue
	FROM CTE1
)
SELECT * FROM CTE2
ORDER BY TotalRevenue DESC;
