WITH CTE AS(
	SELECT 
	DISTINCT
		ProductID,
		CAST(SUM(LineTotal) OVER (PARTITION BY ProductID)AS decimal(10,2)) AS TotalRevenue
	FROM Sales.SalesOrderDetail
)
SELECT * FROM CTE
WHERE TotalRevenue > 50000
ORDER BY TotalRevenue DESC;