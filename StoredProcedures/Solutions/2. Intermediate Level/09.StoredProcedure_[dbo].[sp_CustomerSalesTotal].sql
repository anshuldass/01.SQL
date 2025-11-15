USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_CustomerSalesTotal]    Script Date: 11/15/2025 11:44:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_CustomerSalesTotal]
	@CustomerID INT
AS
BEGIN
	SELECT 
		*
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;
END;

GO

--EXEC sp_CustomerSalesTotal 29614