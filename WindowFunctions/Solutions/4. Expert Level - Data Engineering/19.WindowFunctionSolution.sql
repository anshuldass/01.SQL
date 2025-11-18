SELECT 
	PP.ProductID,
	PERCENT_RANK() OVER (PARTITION BY PPC.ProductCategoryID ORDER BY ListPrice) AS PercentileWithinCategory
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
INNER JOIN Production.ProductCategory PPC
ON PPS.ProductCategoryID = PPC.ProductCategoryID