SELECT 
	Name,
	'TERR-'+UPPER(LEFT(NAME,3)) AS TerritoryCodes
FROM Sales.SalesTerritory;