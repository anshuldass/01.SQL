SELECT 
	ProductID,
	ListPrice,
	CEILING(ListPrice) AS Ceiling_ListPrice,
	FLOOR(ListPrice) AS Floor_ListPrice
FROM Production.Product
ORDER BY  Ceiling_ListPrice DESC,Floor_ListPrice DESC;