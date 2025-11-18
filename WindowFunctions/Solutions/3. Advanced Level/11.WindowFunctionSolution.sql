WITH CTE AS(
SELECT 
	ProductID,
	PP.Name AS ProductName,
	PPS.Name AS ProductSubcategory,
	ListPrice,
	ROW_NUMBER() OVER (PARTITION BY PPS.Name ORDER BY ListPrice DESC) AS RN
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
)
SELECT 
	ProductID,
	ProductName,
	ProductSubcategory,
	ListPrice
FROM CTE
WHERE RN = 1
ORDER BY ProductSubcategory