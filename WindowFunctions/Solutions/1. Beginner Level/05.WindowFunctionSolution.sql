SELECT
	CustomerID,
	OrderDate,
	ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RN
FROM Sales.SalesOrderHeader