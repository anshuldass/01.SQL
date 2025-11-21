SELECT 
	EmailAddress,
	SUBSTRING(EmailAddress,CHARINDEX('@',EmailAddress),LEN(EmailAddress)) AS DomainName
FROM Person.EmailAddress;