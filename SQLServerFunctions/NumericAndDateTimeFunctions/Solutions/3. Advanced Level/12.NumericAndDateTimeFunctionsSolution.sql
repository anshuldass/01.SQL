WITH CTE AS(
	SELECT
		DISTINCT
		CustomerID,
		MAX(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate DESC) AS MaxOrderDatePerCustomer
	FROM Sales.SalesOrderHeader
)
SELECT 
	*,
	DATEDIFF(DAY,MaxOrderDatePerCustomer,GETDATE()) AS NumDaysSinceLastOrder
FROM CTE
ORDER BY CustomerID;