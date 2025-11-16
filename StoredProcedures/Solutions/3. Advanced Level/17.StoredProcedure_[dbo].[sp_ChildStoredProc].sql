USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_ChildStoredProc]    Script Date: 11/16/2025 9:54:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_ChildStoredProc]
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL = 'SELECT ProductID, SUM(QUANTITY) AS TotalInventory FROM Production.ProductInventory GROUP BY ProductID'
	EXEC SP_EXECUTESQL @SQL;
END;
GO

--EXEC [dbo].[sp_NestedStoredProc]