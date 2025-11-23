SELECT 
	Name AS ProductName,
	LEFT(Name, CHARINDEX(' ', Name)) AS ExtractedProductName
FROM Production.Product;