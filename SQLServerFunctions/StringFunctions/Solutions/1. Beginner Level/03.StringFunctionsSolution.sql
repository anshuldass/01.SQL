SELECT 
	AddressLine1,
	TRIM(AddressLine1) AS Trim_AddressLine1
FROM
Person.Address;