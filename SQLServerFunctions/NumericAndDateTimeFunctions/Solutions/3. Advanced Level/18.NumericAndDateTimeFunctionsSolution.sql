SELECT 
    ProductID,
    Name,
    ListPrice,
    CAST((RAND(CHECKSUM(NEWID())) * (0.20 - 0.05) + 0.05) AS DECIMAL(4,2)) AS RandomDiscountPct
FROM 
    Production.Product;
