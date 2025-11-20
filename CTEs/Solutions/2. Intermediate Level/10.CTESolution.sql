WITH CTE AS (
	SELECT
		ProductID,
		Name AS ProductName,
		ListPrice,
		CAST(PERCENT_RANK() OVER (ORDER BY ListPrice)AS decimal(10,2)) AS PercentRanking
	FROM Production.Product
)
SELECT * FROM CTE WHERE PercentRanking > .90;