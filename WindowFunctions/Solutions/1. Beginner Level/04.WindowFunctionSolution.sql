SELECT
	ProductID,
	Name AS ProductName,
	ProductNumber,
	ListPrice,
	NTILE(4) OVER (ORDER BY ListPrice) AS QUARTILES
FROM Production.Product