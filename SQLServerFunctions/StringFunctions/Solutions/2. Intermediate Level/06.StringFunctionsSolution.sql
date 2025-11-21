SELECT 
	CONCAT(UPPER(LEFT(FirstName,1)), LOWER(RIGHT(FirstName, LEN(FirstName)-1))) AS FirstNameFormatted,
	CONCAT(UPPER(LEFT(LastName,1)), LOWER(RIGHT(LastName,LEN(LastName)-1))) AS LastNameFormatted
FROM 
Person.Person;