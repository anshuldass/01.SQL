USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_ProductByID]    Script Date: 11/15/2025 11:32:48 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_ProductByID]
	@ProductID INT
AS 
BEGIN
	SELECT * FROM Production.Product WHERE ProductID = @ProductID;
END;

GO


--EXEC sp_ProductByID 776
