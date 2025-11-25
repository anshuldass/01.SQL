SELECT 
    ProductID,
    Name,
    ListPrice,
    FLOOR(ListPrice / 50.0) * 50 AS PriceBucketStart,
    FLOOR(ListPrice / 50.0) * 50 + 49.99 AS PriceBucketEnd,
    CONCAT(
        FLOOR(ListPrice / 50.0) * 50, ' - ', 
        FLOOR(ListPrice / 50.0) * 50 + 49.99
    ) AS PriceRange
FROM 
    Production.Product;