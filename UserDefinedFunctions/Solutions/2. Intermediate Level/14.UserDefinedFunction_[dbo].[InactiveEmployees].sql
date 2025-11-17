USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[InactiveEmployees]    Script Date: 11/17/2025 10:50:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[InactiveEmployees]()
RETURNS @InactiveEmployees TABLE(
	EmployeeID INT,
	FullName NVARCHAR(100),
	LastDeprtment NVARCHAR(50),
	LastEndDate Date
)
AS
BEGIN
	INSERT INTO @InactiveEmployees
	SELECT
		EmployeeID,
		FullName,
		DepartmentID AS LastDeprtment,
		EndDate AS LastEndDate
	FROM (
	SELECT 
		HREDH.BusinessEntityID AS EmployeeID,
		dbo.ufnFullNameFormatter(FirstName,MiddleName,LastName) AS FullName,
		DepartmentID,
		EndDate,
		ROW_NUMBER() OVER (PARTITION BY HREDH.BusinessEntityID ORDER BY EndDate DESC) AS RN
	FROM HumanResources.EmployeeDepartmentHistory HREDH
	INNER JOIN Person.Person PP
	ON HREDH.BusinessEntityID = PP.BusinessEntityID
	WHERE EndDate IS NOT NULL
	AND HREDH.BusinessEntityID NOT IN 
	(
		SELECT BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory WHERE EndDate IS NULL
	)
	AND HREDH.ModifiedDate > DATEADD(YEAR,-3,GETDATE())
	) AS T 
	WHERE RN=1;
	RETURN ;
END
GO

--SELECT * FROM dbo.InactiveEmployees();