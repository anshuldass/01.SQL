SELECT
	ProductID,
	Name AS ProductName,
	Color,
	LEFT(Color,3) AS ColorCode
FROM Production.Product
WHERE Color IS NOT NULL;