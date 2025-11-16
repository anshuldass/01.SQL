USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_UpdateProductPrice]    Script Date: 11/16/2025 8:10:57 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_UpdateProductPrice]
	@ProductID INT,
	@ListPrice Decimal(10,2)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL = N'
				INSERT INTO Production.ProductListPriceHistory
				(ProductID, StartDate, EndDate, ListPrice, ModifiedDate)
				VALUES
				(@ProductID, GETDATE(), GETDATE(), @ListPrice, GETDATE());';
	EXEC sp_executesql @SQL,
                   N'@ProductID INT, @ListPrice DECIMAL(10,2)',
                   @ProductID=@ProductID,
                   @ListPrice=@ListPrice;
END;


GO

--EXEC sp_UpdateProductPrice 707,35.06