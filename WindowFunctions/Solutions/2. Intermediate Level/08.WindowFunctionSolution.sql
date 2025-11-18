SELECT 
	OrderDate,
	TotalDue,
	LAG(TotalDue) OVER (ORDER BY OrderDate) AS PrevTotalDue
FROM Sales.SalesOrderHeader