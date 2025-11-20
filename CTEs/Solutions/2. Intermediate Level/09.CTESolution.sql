WITH CTE1 AS (
	SELECT 
		PPS.ProductSubcategoryID,
		PPS.Name AS ProductSubcategoryName,
		MIN(PP.ListPrice) OVER(PARTITION BY PPS.Name) AS MinPricePerProductSubCat
	FROM Production.ProductSubcategory PPS
	INNER JOIN Production.Product PP
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
),
CTE2 AS (
	SELECT 
		PPS.ProductSubcategoryID,
		MAX(PP.ListPrice) OVER(PARTITION BY PPS.Name) AS MaxPricePerProductSubCat
	FROM Production.ProductSubcategory PPS
	INNER JOIN Production.Product PP
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
)
SELECT 
DISTINCT
	C1.ProductSubcategoryID,
	C1.ProductSubcategoryName,
	C1.MinPricePerProductSubCat,
	C2.MaxPricePerProductSubCat
FROM CTE1 C1
INNER JOIN CTE2 C2
ON C1.ProductSubcategoryID = C2.ProductSubcategoryID;