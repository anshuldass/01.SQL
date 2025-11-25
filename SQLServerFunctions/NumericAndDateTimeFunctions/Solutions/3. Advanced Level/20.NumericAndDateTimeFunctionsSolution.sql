SELECT 
	SalesOrderID,
	OrderDate,
	DATEPART(QUARTER,OrderDate) AS SalesOrderQuarter
FROM Sales.SalesOrderHeader
ORDER BY OrderDate,SalesOrderQuarter;