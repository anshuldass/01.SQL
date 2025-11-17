USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[ActiveProducts]    Script Date: 11/17/2025 9:42:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[ActiveProducts]()
RETURNS TABLE
AS
RETURN(
	SELECT
	ProductID,
	PP.Name,
	Color,
	ListPrice
FROM Production.Product PP
INNER JOIN Production.ProductModel PPM
ON PP.ProductModelID = PPM.ProductModelID
WHERE ListPrice>0
);
GO

--SELECT * FROM dbo.ActiveProducts();