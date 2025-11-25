WITH CTE AS(
SELECT
	YEAR(OrderDate) AS YR,
	SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
)
SELECT
	YR AS [YEAR],
	TotalSales,
	PrevYearTotalSales,
	((TotalSales-PrevYearTotalSales)/PrevYearTotalSales) *100 AS [Growth%]
FROM (
		SELECT 
			*,
			LAG(TotalSales) OVER (ORDER BY YR) AS PrevYearTotalSales
		FROM CTE
		) AS T;
