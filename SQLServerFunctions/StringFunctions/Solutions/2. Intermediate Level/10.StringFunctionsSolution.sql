WITH CTE AS(
SELECT
	BusinessEntityID,
	PhoneNumber,
	REPLACE(REPLACE(REPLACE(REPLACE(PhoneNumber,'(',''),')',''),' ',''),'-','') AS PhoneNumberCleansed
FROM Person.PersonPhone
WHERE PhoneNumber  LIKE '%[^0-9]%'
)
SELECT 
	*,
	LEN(PhoneNumberCleansed) AS ExactPhoneNumbers
FROM CTE
WHERE LEN(PhoneNumberCleansed) = 10;