USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[TopNProducts]    Script Date: 11/17/2025 9:45:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[TopNProducts](@TopN INT)
RETURNS TABLE
AS
RETURN(
	SELECT TOP(@TopN) *
	FROM Production.Product 
	ORDER BY ListPrice DESC
);
GO

--SELECT * FROM dbo.TopNProducts(10);