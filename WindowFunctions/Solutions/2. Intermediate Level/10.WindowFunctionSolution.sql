SELECT 
	ProductID,
	ListPrice,
	PERCENT_RANK() OVER (ORDER BY ListPrice) AS PercentileRank
FROM Production.Product