SELECT 
    ProductNumber,
    CASE 
        WHEN CHARINDEX('-', ProductNumber) > 0 
             AND CHARINDEX('-', ProductNumber, CHARINDEX('-', ProductNumber) + 1) > 0
        THEN SUBSTRING(
                ProductNumber,
                CHARINDEX('-', ProductNumber) + 1,
                CHARINDEX('-', ProductNumber, CHARINDEX('-', ProductNumber) + 1) 
                    - CHARINDEX('-', ProductNumber) - 1
             )
        ELSE NULL
    END AS MiddleSection
FROM Production.Product;
