WITH CTE1 AS (
	SELECT * FROM Production.Product
	WHERE Weight IS NOT NULL
),
CTE2 AS (
	SELECT
		ListPrice,
		Weight,
		CAST(ListPrice/Weight AS decimal(10,2)) AS	PriceToWeightRatio
	FROM CTE1
)
SELECT * FROM CTE2;