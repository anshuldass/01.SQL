SELECT	
	ListPrice,
	StandardCost,
	ABS(ListPrice) AS ABS_ListPrice,
	ABS(StandardCost) AS ABS_StandardCost,
	ABS(ListPrice) - ABS(StandardCost) AS ABS_Differnce
FROM Production.Product
ORDER BY ABS_Differnce DESC;