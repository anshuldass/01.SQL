WITH CTE AS (
	SELECT
		HRE.BusinessEntityID,
		DBO.ufnFullNameFormatter(PP.FirstName,PP.MiddleName,PP.LastName) AS FullName,
		HRE.OrganizationNode,
		HRE.OrganizationLevel,
		HRE.JobTitle
	FROM HumanResources.Employee HRE
	INNER JOIN Person.Person PP
	ON HRE.BusinessEntityID = PP.BusinessEntityID
	WHERE OrganizationNode.GetAncestor(1) IS NULL
	UNION ALL
	SELECT 
		HRE.BusinessEntityID,
		DBO.ufnFullNameFormatter(PP.FirstName,PP.MiddleName,PP.LastName) AS FullName,
		HRE.OrganizationNode,
		HRE.OrganizationLevel,
		HRE.JobTitle
	FROM CTE C
	INNER JOIN HumanResources.Employee HRE	
	ON C.BusinessEntityID = HRE.OrganizationLevel
	INNER JOIN Person.Person PP
	ON HRE.BusinessEntityID = PP.BusinessEntityID
)
SELECT * FROM CTE;
