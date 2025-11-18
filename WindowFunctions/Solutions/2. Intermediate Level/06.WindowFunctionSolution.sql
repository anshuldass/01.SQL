SELECT 
	CustomerID,
	OrderDate,
	SUM(TotalDue) OVER (PARTITION BY CustomerID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS CustomerRunningTotal
FROM Sales.SalesOrderHeader