SELECT
	CustomerID,
	SalesOrderID,
	OrderDate,
	SUM(TotalDue) OVER (PARTITION BY CustomerID) AS LifetimeSpend,
	ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RN
FROM Sales.SalesOrderHeader;