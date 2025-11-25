WITH SalesStats AS (
    SELECT 
        AVG(TotalDue) AS AvgTotal,
        STDEV(TotalDue) AS StdTotal
    FROM Sales.SalesOrderHeader
)
SELECT 
    SOH.SalesOrderID,
    SOH.OrderDate,
    SOH.TotalDue
FROM 
    Sales.SalesOrderHeader AS SOH
CROSS JOIN 
    SalesStats AS stats
WHERE 
    SOH.TotalDue > stats.AvgTotal + 2 * stats.StdTotal
ORDER BY 
    SOH.TotalDue DESC;
