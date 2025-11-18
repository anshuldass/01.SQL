SELECT 
	OrderDate,
	AVG(TotalDue) OVER (ORDER BY OrderDate ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingThirdOrderAvg
FROM Sales.SalesOrderHeader