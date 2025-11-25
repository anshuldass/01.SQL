SELECT 
	OrderDate,
	DueDate,
	DATEDIFF(DAY,OrderDate,DueDate) AS Date_Diff
FROM Sales.SalesOrderHeader
ORDER BY OrderDate;