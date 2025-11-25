SELECT 
DISTINCT
	OrderDate,
	ShipDate,
	DATEDIFF(HOUR,OrderDate,ShipDate) AS TimeToShip
FROM Sales.SalesOrderHeader
ORDER BY OrderDate;