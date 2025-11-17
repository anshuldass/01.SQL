USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[MonthlySalesSummary]    Script Date: 11/17/2025 10:05:09 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[MonthlySalesSummary](@Year INT)
RETURNS @MonthlySales TABLE(
	MonthNumber INT,
	TotalSalesAmount DECIMAL(10,2),
	TotalOrders INT
)
AS
BEGIN
	INSERT INTO @MonthlySales
	SELECT
		MONTH(OrderDate) AS MonthNumber,
		SUM(TotalDue) AS TotalSalesAmount,
		COUNT(SalesOrderID) AS TotalOrders
	FROM Sales.SalesOrderHeader
	WHERE YEAR(OrderDate) = @Year
	GROUP BY MONTH(OrderDate)
	ORDER BY MonthNumber
	RETURN;
END;
GO

--SELECT * FROM dbo.MonthlySalesSummary(2012);