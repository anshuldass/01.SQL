SELECT 
    ProductNumber,
	RIGHT(ProductNumber, PATINDEX('%[^0-9]%', REVERSE(ProductNumber))-1) AS NumberSuffix
FROM Production.Product
WHERE ProductNumber LIKE '%[0-9]';
