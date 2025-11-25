SELECT
	BusinessEntityID,
	BirthDate,
	DATEDIFF(YEAR,BirthDate,GETDATE()) AS Age
FROM HumanResources.Employee
ORDER BY BusinessEntityID;