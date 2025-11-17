USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[CalculateAge]    Script Date: 11/18/2025 12:17:45 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[CalculateAge](@BirthDate DATE)
RETURNS INT
AS
BEGIN
	RETURN DATEDIFF(YEAR,@BirthDate,GETDATE());
END;
GO

--SELECT 
--	PP.BusinessEntityID,
--	dbo.ufnFullNameFormatter(FirstName, MiddleName, LastName) AS FullName,
--	dbo.CalculateAge(HRE.Birthdate) AS Age 
--FROM Person.Person PP
--INNER JOIN HumanResources.Employee HRE
--ON PP.BusinessEntityID = HRE.BusinessEntityID