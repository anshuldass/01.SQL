SELECT 
	OrderDate,
	DATEADD(DAY,30,OrderDate) AS FollowUpDate
FROM Sales.SalesOrderHeader
ORDER BY OrderDate;