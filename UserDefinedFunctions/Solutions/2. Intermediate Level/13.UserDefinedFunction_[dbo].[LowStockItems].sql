USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[LowStockItems]    Script Date: 11/17/2025 10:15:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[LowStockItems]()
RETURNS @LowStockItems TABLE(
	ProductID INT,
	TotalStock INT
)
AS
BEGIN
	INSERT INTO @LowStockItems
	SELECT 
		ProductID, 
		SUM(Quantity) AS TotalStock
	FROM Production.ProductInventory
	WHERE Quantity < 100
	GROUP BY ProductID;
	RETURN;
END;
GO

--SELECT * FROM dbo.LowStockItems();