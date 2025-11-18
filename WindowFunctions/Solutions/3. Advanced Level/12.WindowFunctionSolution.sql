WITH CTE AS(
SELECT 
	SalesOrderID,
	CustomerID,
	ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY SalesOrderID) AS RN
FROM Sales.SalesOrderHeader
)
SELECT 
	*,
	SalesOrderID - RN AS IslandGroup
FROM CTE
ORDER BY SalesOrderID,IslandGroup