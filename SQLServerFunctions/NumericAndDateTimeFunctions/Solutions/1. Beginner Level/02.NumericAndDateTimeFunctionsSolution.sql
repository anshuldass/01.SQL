SELECT 
	ProductID,
	ListPrice,
	ROUND(ListPrice,1) AS Rounded_ListPrice
FROM Production.Product
ORDER BY Rounded_ListPrice DESC;