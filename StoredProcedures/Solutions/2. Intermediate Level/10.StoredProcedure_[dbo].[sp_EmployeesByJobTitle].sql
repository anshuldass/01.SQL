USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_EmployeesByJobTitle]    Script Date: 11/15/2025 11:45:12 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_EmployeesByJobTitle]
	@JobTitle VARCHAR(50)
AS 
BEGIN
	SELECT 
		* 
	FROM HumanResources.Employee
	WHERE JobTitle = @JobTitle;
END;

GO

--EXEC [sp_EmployeesByJobTitle] 'Design Engineer'