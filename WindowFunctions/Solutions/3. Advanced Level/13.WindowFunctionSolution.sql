WITH CTE AS(
SELECT 
	SalesOrderID,
	OrderDate,
	TotalDue,
	LAG(TotalDue) OVER (ORDER BY OrderDate) AS PrevDayTotalDue,
	AVG(TotalDue) OVER (ORDER BY OrderDate ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS SevenOrderMovingAvg
FROM Sales.SalesOrderHeader 
)
SELECT 
	*,
	CASE WHEN PrevDayTotalDue IS NOT NULL THEN ((TotalDue - SevenOrderMovingAvg)/SevenOrderMovingAvg) * 100
	ELSE NULL END AS PercentIncrease
FROM CTE
WHERE TotalDue > 1.5 * SevenOrderMovingAvg