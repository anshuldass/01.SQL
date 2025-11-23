SELECT 
	ProductID,
	StandardCost,
	SQRT(StandardCost) AS SQRT_StandardCost
FROM Production.Product
ORDER BY SQRT_StandardCost DESC;