WITH CTE AS (
	SELECT *
	FROM Production.Product
	WHERE ListPrice > 1000
)
SELECT * FROM CTE