SELECT 
	YEAR(OrderDate) AS Yr,
	MONTH(OrderDate) AS Mnth,
	CAST(SUM(TotalDue) AS decimal(10,2)) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate),MONTH(OrderDate)
ORDER BY Yr,Mnth;