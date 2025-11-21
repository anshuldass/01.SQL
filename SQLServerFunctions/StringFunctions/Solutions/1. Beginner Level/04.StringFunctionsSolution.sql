SELECT 
	LastName,
	PATINDEX('%son%', LastName) AS SubStringLastName
FROM Person.Person
WHERE PATINDEX('%son%', LastName) > 0
ORDER BY SubStringLastName DESC;