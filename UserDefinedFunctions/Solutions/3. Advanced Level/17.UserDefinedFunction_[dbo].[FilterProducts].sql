USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[FilterProducts]    Script Date: 11/17/2025 11:40:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[FilterProducts](@Color NVARCHAR(50), @MinPrice DECIMAL(10,2), @MaxPrice DECIMAL(10,2))
RETURNS TABLE
AS
RETURN(
	SELECT * FROM Production.Product
	WHERE Color = @Color
	AND ListPrice BETWEEN @MinPrice AND @MaxPrice
);
GO

--SELECT *FROM dbo.FilterProducts('Red', 1.0, 100.0);