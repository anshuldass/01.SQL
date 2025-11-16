USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_MonthlySalesReport]    Script Date: 11/16/2025 7:19:46 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_MonthlySalesReport]
	@YR INT,
	@MN INT
AS 
BEGIN
	SELECT 
		CustomerID, 
		SUM(TotalDue) AS TotalSales, 
		COUNT(SalesOrderID) AS NumOfOrders
	FROM Sales.SalesOrderHeader
	WHERE 
		YEAR(OrderDate) = @YR AND
		MONTH(OrderDate) = @MN
	GROUP BY CustomerID
	ORDER BY NumOfOrders DESC;
END;

GO

--EXEC sp_MonthlySalesReport 2014, 02