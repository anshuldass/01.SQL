WITH CTE AS(
SELECT
	CustomerName,
	OrderDate,
	O.Quantity * P.Price AS SalesTotal
FROM Customers C
LEFT JOIN Orders O
ON C.CustomerId = O.CustomerId
INNER JOIN Products P
ON O.ProductId = P.ProductId
)
SELECT 
	*,
	SUM(SalesTotal) OVER(PARTITION BY CustomerName ORDER BY ORDERDATE ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningtotalSpend
FROM CTE;