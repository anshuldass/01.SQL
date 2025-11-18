SELECT 
    SSOD.SalesOrderID,
    ROW_NUMBER() OVER (PARTITION BY SSOD.SalesOrderID ORDER BY SSOD.SalesOrderDetailID) AS RN,
    UnitPrice,
    LineTotal,
    UnitPrice - LAG(UnitPrice) OVER (PARTITION BY SSOD.SalesOrderID ORDER BY SSOD.SalesOrderDetailID) AS UnitPriceDiff,
    AVG(LineTotal) OVER (PARTITION BY SSOD.SalesOrderID ORDER BY SSOD.SalesOrderDetailID ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS FiveRowMovingAvg,
    STDEV(LineTotal) OVER (PARTITION BY SSOD.SalesOrderID ORDER BY SSOD.SalesOrderDetailID ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS FiveRowStdDev,
    CASE 
        WHEN ROW_NUMBER() OVER (PARTITION BY SSOD.SalesOrderID ORDER BY SSOD.SalesOrderDetailID) = 
             COUNT(*) OVER (PARTITION BY SSOD.SalesOrderID)
             AND ABS(LineTotal - AVG(LineTotal) OVER (PARTITION BY SSOD.SalesOrderID ORDER BY SSOD.SalesOrderDetailID ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)) > 
                 2 * STDEV(LineTotal) OVER (PARTITION BY SSOD.SalesOrderID ORDER BY SSOD.SalesOrderDetailID ROWS BETWEEN 4 PRECEDING AND CURRENT ROW)
        THEN 1
        ELSE 0
    END AS IsLastLineAnomaly
FROM Sales.SalesOrderDetail SSOD
INNER JOIN Sales.SalesOrderHeader SSOH
    ON SSOD.SalesOrderID = SSOH.SalesOrderID
ORDER BY SSOD.SalesOrderID, SSOD.SalesOrderDetailID;
