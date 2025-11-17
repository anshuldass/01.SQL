USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[ufnCalculateDiscount]    Script Date: 11/17/2025 2:28:11 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[ufnCalculateDiscount](@ListPrice DECIMAL(10,2), @DiscountPercent DECIMAL(10,2))
RETURNS DECIMAL(10,2)
AS
BEGIN
	RETURN @ListPrice * (@DiscountPercent/100)
END;
GO

--SELECT 
--	dbo.ufnCalculateDiscount(ListPrice, 10.0) as Discount
--FROM Production.Product
--order by 1 desc