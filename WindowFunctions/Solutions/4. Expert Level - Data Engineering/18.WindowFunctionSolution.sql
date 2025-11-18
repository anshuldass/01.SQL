SELECT 
	OrderDate,
	CAST(SUM(TotalDue) OVER (ORDER BY OrderDate ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS decimal(10,2)) AS ThirtyDayRollingSum
FROM Sales.SalesOrderHeader