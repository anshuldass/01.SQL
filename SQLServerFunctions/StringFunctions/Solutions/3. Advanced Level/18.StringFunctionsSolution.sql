SELECT 
    Name AS ProductName
FROM Production.Product
WHERE LOWER(Name) LIKE '%red%'
   OR LOWER(Name) LIKE '%black%'
   OR LOWER(Name) LIKE '%silver%'
   OR LOWER(Name) LIKE '%blue%'
   OR LOWER(Name) LIKE '%green%';