WITH CTE AS (
	SELECT 
		* 
	FROM Sales.SalesOrderHeader
	WHERE OrderDate > '2014-01-01'
)

SELECT CustomerID,OrderDate FROM CTE
ORDER BY OrderDate