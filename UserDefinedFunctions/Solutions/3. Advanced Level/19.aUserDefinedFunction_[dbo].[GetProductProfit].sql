USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[GetProductProfit]    Script Date: 11/18/2025 12:25:51 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[GetProductProfit](@ProductID INT)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Profit DECIMAL(10,2);

    SELECT @Profit = (ListPrice - StandardCost)
    FROM Production.Product
    WHERE ProductID = @ProductID;

    RETURN @Profit;
END;
GO

--SELECT ProductID, dbo.GetProductProfit(ProductID)
--FROM Production.Product;