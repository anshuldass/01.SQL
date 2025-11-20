WITH RecursiveBOM AS (
    SELECT
        BOM.ProductAssemblyID AS ParentProductID,
        BOM.ComponentID,
        CAST(BOM.ComponentID AS VARCHAR(MAX)) AS ComponentPath,
        1 AS Level
    FROM Production.BillOfMaterials BOM
    WHERE BOM.ProductAssemblyID IS NOT NULL

    UNION ALL

    SELECT
        BOM.ProductAssemblyID AS ParentProductID,
        BOM.ComponentID,
        RB.ComponentPath + ',' + CAST(BOM.ComponentID AS VARCHAR(MAX)) AS ComponentPath,
        RB.Level + 1 AS Level
    FROM Production.BillOfMaterials BOM
    INNER JOIN RecursiveBOM RB
        ON BOM.ProductAssemblyID = RB.ComponentID
    WHERE CHARINDEX(',' + CAST(BOM.ComponentID AS VARCHAR) + ',', ',' + RB.ComponentPath + ',') = 0
)
SELECT *
FROM RecursiveBOM
WHERE CHARINDEX(',' + CAST(ComponentID AS VARCHAR) + ',', ',' + ComponentPath + ',') <>
      LEN(ComponentPath) - LEN(REPLACE(ComponentPath, CAST(ComponentID AS VARCHAR), '')) 
OPTION (MAXRECURSION 50);