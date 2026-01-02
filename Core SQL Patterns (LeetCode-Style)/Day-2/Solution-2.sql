WITH CTE AS(
SELECT 
	C.CustomerName,
	O.Quantity * P.Price AS TotalSpend
FROM Customers C
LEFT JOIN Orders O
ON C.CustomerId = O.CustomerId
INNER JOIN Products P
ON O.ProductId = P.ProductId
WHERE OrderId IS NOT NULL
) 
SELECT  
	DISTINCT CustomerName,
	TotalSpend
	FROM (
		SELECT 
			*,
			DENSE_RANK() OVER(ORDER BY TOTALSPEND DESC) AS RN
		FROM CTE
		) AS T
	WHERE RN = 1;