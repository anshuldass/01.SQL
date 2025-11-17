USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[GetProductsBySubCategory]    Script Date: 11/17/2025 8:20:49 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[GetProductsBySubCategory](@SubcategoryID INT)
RETURNS TABLE
AS
RETURN(
	SELECT 
		 ProductID,
		 Name AS ProductName,
		 ListPrice
	FROM Production.Product
	WHERE ProductSubcategoryID = @SubcategoryID
);
GO

--SELECT * FROM dbo.GetProductsBySubCategory(1);