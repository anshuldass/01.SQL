SELECT 
	ProductID,
	ROW_NUMBER() OVER (ORDER BY ListPrice DESC) AS RN
FROM Production.Product