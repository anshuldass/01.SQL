WITH CTE1 AS(
	SELECT * FROM Production.ProductListPriceHistory
),
CTE2 AS (
	SELECT 
		*,
		LAG(ListPrice) OVER(PARTITION BY ProductID ORDER BY StartDate) AS PrevPrice,
		CASE WHEN (LAG(ListPrice) OVER(PARTITION BY ProductID ORDER BY ListPrice) <> ListPrice) THEN 1 ELSE 0
		END AS IsChange
	FROM CTE1
),
CTE3 AS (
	SELECT 
		*,
		((ListPrice - PrevPrice)/PrevPrice) * 100 AS PercentChange,
		ROW_NUMBER() OVER(PARTITION BY ProductID ORDER BY IsChange) AS RN
	FROM CTE2
	WHERE IsChange = 1
)

SELECT * FROM CTE3
WHERE PercentChange >=20;