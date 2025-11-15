USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_GetAllProducts]    Script Date: 11/15/2025 11:30:03 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_GetAllProducts]
AS
BEGIN
	SELECT * FROM Production.Product;
END;

GO

--EXEC [sp_GetAllProducts]


