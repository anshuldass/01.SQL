USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_SummaryByTerritory]    Script Date: 11/16/2025 10:12:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_SummaryByTerritory]
	@TerritoryID INT
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL = N'SELECT
						TerritoryID,
						SUM(TotalDue) AS TotalSales,
						COUNT(SalesOrderID) AS TotalOrders,
						AVG(TotalDue) AS AvgOrderAmount
				FROM Sales.SalesOrderHeader
				WHERE TerritoryID = @TerritoryID
				GROUP BY TerritoryID'
	EXEC SP_EXECUTESQL @SQL,
	N'@TerritoryID INT',
	@TerritoryID = @TerritoryID;
END;

GO

--EXEC sp_SummaryByTerritory 1