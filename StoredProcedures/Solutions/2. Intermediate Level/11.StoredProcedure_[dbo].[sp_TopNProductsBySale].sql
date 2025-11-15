USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_TopNProductsBySale]    Script Date: 11/15/2025 11:53:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_TopNProductsBySale]
	@N INT
AS 
BEGIN
	SELECT 
		TOP (@N)
		ProductID, 
		CAST(SUM(LineTotal) AS decimal(10,2)) AS TotalSales
	FROM Sales.SalesOrderDetail 
	GROUP BY ProductID
	ORDER BY TotalSales DESC;
END;

GO

-- EXEC sp_TopNProductsBySale 10