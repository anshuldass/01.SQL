USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[GetReportingHierarchy]    Script Date: 11/18/2025 12:10:42 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[GetReportingHierarchy](@ManagerID INT)
RETURNS @ReportingHierarchy TABLE(
	OrganizationLevel INT,
	EmployeeID INT,
	FullName NVARCHAR(100)
)
AS
BEGIN
	DECLARE @ManagerNode hierarchyid;
	SELECT @ManagerNode = OrganizationNode FROM HumanResources.Employee WHERE BusinessEntityID = @ManagerID;
	WITH CTE AS(
		SELECT  
			OrganizationLevel,
			HRE.BusinessEntityID AS EmployeeID,
			dbo.ufnFullNameFormatter(PP.FirstName,PP.MiddleName,PP.LastName) AS FullName
		FROM HumanResources.Employee HRE
		INNER JOIN Person.Person PP
		ON HRE.BusinessEntityID = PP.BusinessEntityID
		WHERE HRE.OrganizationNode.IsDescendantOf(@ManagerNode) = 1
		AND HRE.BusinessEntityID <> @ManagerID
	)
	INSERT INTO @ReportingHierarchy
	SELECT * FROM CTE
	ORDER BY OrganizationLevel;
	RETURN;
END;
GO

--SELECT *FROM dbo.GetReportingHierarchy(2);