SELECT 
	CustomerId
FROM Orders O
INNER JOIN Products P
ON O.ProductId = P.ProductId
GROUP BY CustomerId
HAVING COUNT(DISTINCT O.ProductId)=(SELECT COUNT(*) FROM Products);