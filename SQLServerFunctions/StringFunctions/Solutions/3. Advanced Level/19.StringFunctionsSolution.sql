SELECT	
	DBO.ufnFullNameFormatter(FirstName,MiddleName,LastName) AS FullName,
	REVERSE(DBO.ufnFullNameFormatter(FirstName,MiddleName,LastName)) AS ReversedFullName
FROM Person.Person;