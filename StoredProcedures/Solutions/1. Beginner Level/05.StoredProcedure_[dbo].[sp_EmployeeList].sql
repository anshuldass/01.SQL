USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_EmployeeList]    Script Date: 11/15/2025 11:37:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_EmployeeList]
AS
BEGIN
	SELECT BusinessEntityID, JobTitle FROM HumanResources.Employee;
END;

GO

--EXEC [sp_EmployeeList]
