SELECT 
    ProductNumber,
    CASE 
        WHEN CHARINDEX('-', ProductNumber) > 0 
        THEN LEFT(ProductNumber, CHARINDEX('-', ProductNumber) - 1)
        ELSE ProductNumber
    END AS Part1,
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
    END AS Part2,
    CASE 
        WHEN CHARINDEX('-', ProductNumber, CHARINDEX('-', ProductNumber) + 1) > 0
        THEN SUBSTRING(
                ProductNumber,
                CHARINDEX('-', ProductNumber, CHARINDEX('-', ProductNumber) + 1) + 1,
                LEN(ProductNumber)
             )
        ELSE NULL
    END AS Part3
FROM Production.Product;
