USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[ufnFullNameFormatter]    Script Date: 11/17/2025 2:07:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[ufnFullNameFormatter](@FirstName NVARCHAR(50), @LastName NVARCHAR(50), @MiddleName NVARCHAR(50))
RETURNS NVARCHAR(50)
AS
BEGIN
	RETURN CONCAT(ISNULL(@FirstName,''),' ',ISNULL(@LastName,''),' ',ISNULL(@MiddleName,''))
END;

GO


--SELECT 
--	dbo.ufnFullNameFormatter(FirstName, MiddleName, LastNAme) AS FullName 
--FROM Person.Person