USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[CustomerOrderStats]    Script Date: 11/17/2025 10:11:41 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[CustomerOrderStats](@CustomerID INT)
RETURNS @CustomerStats TABLE(
	TotalOrders INT,
	TotalAmount DECIMAL(10,2),
	LastOrderDate Date
)
AS
BEGIN
	INSERT INTO @CustomerStats
	SELECT
		COUNT(SalesOrderID) AS TotalOrders,
		SUM(TotalDue) AS TotalAmount,
		MAX(OrderDate) AS LastOrderDate
	FROM Sales.SalesOrderHeader
	WHERE CustomerID = @CustomerID
	GROUP BY CustomerID
	RETURN;
END;
GO

--SELECT * FROM dbo.CustomerOrderStats(29847);