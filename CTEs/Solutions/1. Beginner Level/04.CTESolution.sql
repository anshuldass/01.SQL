WITH CTE AS (
	SELECT 
		SC.CustomerID,
		SalesOrderID,
		TotalDue
	FROM Sales.SalesOrderHeader SSOH
	INNER JOIN Sales.Customer SC
	ON SSOH.CustomerID = SC.CustomerID
)

SELECT * FROM CTE
ORDER BY CustomerID;