SELECT 
	Name AS ProductName,
	LOWER(REPLACE(Name,' ','-')) AS ProductNameURLSlugs
FROM Production.Product