SELECT 
	FirstName,
	LastName,
	BusinessEntityID,
	CONCAT(FirstName,LastName,BusinessEntityID) AS CustID,
	HASHBYTES('SHA2_256',CONCAT(FirstName,' ', LastName, ' ',BusinessEntityID)) as HashedCustID
FROM Person.Person