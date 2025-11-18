WITH CTE AS(
SELECT 
	YEAR(OrderDate) AS Year,
	MONTH(OrderDate) AS Month,
	SUM(TotalDue) AS TotalSalesAmount
FROM Sales.SalesOrderHeader
GROUP BY MONTH(OrderDate), YEAR(OrderDate)
)
SELECT 
	*, 
	CASE WHEN PrevMonthsTotal IS NULL THEN NULL ELSE ((TotalSalesAmount - PrevMonthsTotal)/PrevMonthsTotal )*100 END AS PercentChange
FROM (
			SELECT 
				*,
				LAG(TotalSalesAmount) OVER(ORDER BY YEAR,MONTH) AS PrevMonthsTotal
			FROM CTE
) AS T