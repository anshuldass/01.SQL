USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[GetOrdersByDateRange]    Script Date: 11/17/2025 8:34:39 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[GetOrdersByDateRange](@StartDate DATE, @EndDate DATE)
RETURNS TABLE
AS
RETURN(SELECT * FROM Sales.SalesOrderHeader WHERE OrderDate >= @StartDate AND OrderDate <= @EndDate);
GO

--SELECT * FROM dbo.GetOrdersByDateRange('2012-06-01','2012-06-30');