SELECT 
	OrderDate,
	YEAR(OrderDate) AS Yr,
	MONTH(OrderDate) AS Mnth,
	DAY(OrderDate) AS Dy
FROM Sales.SalesOrderHeader
ORDER BY OrderDate;