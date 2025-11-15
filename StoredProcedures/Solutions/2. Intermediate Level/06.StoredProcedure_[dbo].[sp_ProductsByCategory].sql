USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_ProductsByCategory]    Script Date: 11/15/2025 11:39:24 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_ProductsByCategory]
	@ProductCategoryID INT
AS 
BEGIN
	SELECT 
		* 
	FROM Production.Product PP
	INNER JOIN Production.ProductSubcategory PPS
	ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
	INNER JOIN Production.ProductCategory PPC
	ON PPS.ProductCategoryID = @ProductCategoryID;
END;

GO


--EXEC [sp_ProductsByCategory] 1