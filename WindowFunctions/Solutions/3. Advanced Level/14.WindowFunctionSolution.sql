SELECT
	PPC.Name AS ProductCategory,
	PPS.Name AS ProductSubCategory,
	ProductID,
	PP.NAME AS ProductName,
	COUNT(ProductID) OVER (PARTITION BY PPS.ProductSubcategoryID) AS TotalNumberOfProducts,
	MIN(ListPrice) OVER (PARTITION BY PPS.ProductSubcategoryID ) AS LowestProductPrice,
	MAX(ListPrice) OVER (PARTITION BY PPS.ProductSubcategoryID ) AS HighestProductPrice
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PPC
ON PPS.ProductCategoryID = PPC.ProductCategoryID
ORDER BY PPC.Name, PPS.Name, PP.ProductID