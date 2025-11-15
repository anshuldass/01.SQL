USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_OrdersDateRange]    Script Date: 11/15/2025 11:42:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_OrdersDateRange]
	@StartDate Date,
	@EndDate Date
AS 
BEGIN
	SELECT 
		* 
	FROM Sales.SalesOrderHeader
	WHERE 
		OrderDate >= @StartDate AND
		OrderDate <= @EndDate
	ORDER BY OrderDate;
END;

GO

--EXEC [sp_OrdersDateRange] '2011-05-01','2011-06-01'