USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[GetProductProfit_iTVF]    Script Date: 11/18/2025 12:26:52 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[GetProductProfit_iTVF](@ProductID INT)
RETURNS TABLE
AS
RETURN
(
    SELECT 
        ProductID,
        Profit = CAST(ListPrice - StandardCost AS DECIMAL(10,2))
    FROM Production.Product
    WHERE ProductID = @ProductID
);
GO

--SELECT P.ProductID, X.Profit
--FROM Production.Product AS P
--CROSS APPLY dbo.GetProductProfit_iTVF(P.ProductID) AS X;