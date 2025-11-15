USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_OrdersByCustomer]    Script Date: 11/15/2025 11:35:51 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_OrdersByCustomer]
	@CustomerID INT
AS
BEGIN
	SELECT 
		SalesOrderID,
		OrderDate 
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID;
END;

GO

--EXEC [sp_OrdersByCustomer] 30106