WITH EmployeeHierarchy AS (
    SELECT
        HRE.BusinessEntityID,
        DBO.ufnFullNameFormatter(PP.FirstName, PP.MiddleName, PP.LastName) AS FullName,
        HRE.OrganizationLevel,
        0 AS Depth  
    FROM HumanResources.Employee HRE
    INNER JOIN Person.Person PP
        ON HRE.BusinessEntityID = PP.BusinessEntityID
    WHERE HRE.OrganizationLevel IS NULL

    UNION ALL

    SELECT
        HRE.BusinessEntityID,
        DBO.ufnFullNameFormatter(PP.FirstName, PP.MiddleName, PP.LastName) AS FullName,
        HRE.OrganizationLevel,
        EH.Depth + 1 AS Depth
    FROM HumanResources.Employee HRE
    INNER JOIN EmployeeHierarchy EH
        ON HRE.OrganizationLevel = EH.BusinessEntityID
    INNER JOIN Person.Person PP
        ON HRE.BusinessEntityID = PP.BusinessEntityID
)
SELECT *
FROM EmployeeHierarchy
ORDER BY Depth, FullName;
