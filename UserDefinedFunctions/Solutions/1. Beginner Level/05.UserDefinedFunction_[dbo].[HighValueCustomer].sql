USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[HighValueCustomer]    Script Date: 11/17/2025 7:41:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[HighValueCustomer](@CustomerID INT)
RETURNS NVARCHAR(3)
AS
BEGIN
	DECLARE @Result NVARCHAR(3), @Sale DECIMAL(10,2);
	SET @Sale =	(
		SELECT 
			COALESCE(SUM(TotalDue),0) AS TotalSales	
		FROM Sales.SalesOrderHeader
		WHERE CustomerID = @CustomerID
		)
	IF @Sale > 50000.0
		SET @Result = 'Yes'
	ELSE 
		SET @Result = 'No'
RETURN @Result
END;
GO

--SELECT
--	dbo.HighValueCustomer(30078) AS HighValueCustomer,
--	*
--FROM Sales.SalesOrderHeader;
