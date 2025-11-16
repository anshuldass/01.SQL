USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_SnifPrevention]    Script Date: 11/16/2025 10:21:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_SnifPrevention]
	@ProductSubCategoryID INT = NULL,
	@ListPrice DECIMAL(18,3) = NULL
AS
BEGIN
	SET NOCOUNT ON;
	SELECT * FROM Production.Product
	WHERE (@ProductSubCategoryID IS NULL OR ProductSubcategoryID = @ProductSubCategoryID)
	AND (@ListPrice IS NULL OR ListPrice = @ListPrice)
	OPTION(RECOMPILE)
END;

GO

--EXEC sp_SnifPrevention NULL,87.745