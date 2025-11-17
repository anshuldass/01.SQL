USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[GetEmployeesByDepartment]    Script Date: 11/17/2025 8:48:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[GetEmployeesByDepartment](@DepartmentName NVARCHAR(20))
RETURNS TABLE
AS
RETURN(
	SELECT
	PP.BusinessEntityID EmployeeID,
	dbo.ufnFullNameFormatter(FirstName, MiddleName, LastName) AS FullName,
	HRD.Name AS Department,
	HREDH.StartDate
 FROM Person.Person PP
 INNER JOIN HumanResources.EmployeeDepartmentHistory HREDH
 ON PP.BusinessEntityID = HREDH.BusinessEntityID
 INNER JOIN HumanResources.Department HRD
 ON HREDH.DepartmentID = HRD.DepartmentID
 WHERE HRD.Name = @DepartmentName
);
GO

--SELECT * FROM dbo.GetEmployeesByDepartment('Engineering');