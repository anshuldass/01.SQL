WITH OrderClassification AS (
    SELECT *,
        NTILE(4) OVER(ORDER BY TotalDue) AS Quant,
        CASE 
            WHEN NTILE(4) OVER(ORDER BY TotalDue) = 1 THEN 'Low'
            WHEN NTILE(4) OVER(ORDER BY TotalDue) = 2 THEN 'Medium'
            ELSE 'High'
        END AS OrderClass
    FROM Sales.SalesOrderHeader
),
CustomerSpend AS (
    SELECT *,
        SUM(TotalDue) OVER(PARTITION BY CustomerID) AS TotalSpend
    FROM OrderClassification
),
CustomerTier AS (
    SELECT *,
        NTILE(4) OVER(ORDER BY TotalSpend) AS Tier
    FROM CustomerSpend
),
MostRecent AS (
    SELECT *
    FROM (
        SELECT *,
            ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY OrderDate DESC) AS RN
        FROM CustomerTier
    ) t
    WHERE RN = 1
)
SELECT CustomerID, SalesOrderID, OrderDate, OrderClass, TotalSpend, Tier
FROM MostRecent
WHERE 
    (Tier = 1 AND OrderClass <> 'Low')
    OR (Tier = 2 AND OrderClass <> 'Medium')
    OR (Tier IN (3,4) AND OrderClass <> 'High')
ORDER BY CustomerID;
