SELECT 
	ProductID,
	Name AS ProductName,
	ProductSubCategoryID,
	ListPrice,
	RANK() OVER (PARTITION BY ProductSubCategoryID ORDER BY ListPrice DESC) AS RN
FROM Production.Product