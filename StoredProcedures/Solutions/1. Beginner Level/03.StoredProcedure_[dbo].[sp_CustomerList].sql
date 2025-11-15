USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_CustomerList]    Script Date: 11/15/2025 11:34:19 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_CustomerList]
AS
BEGIN
	SELECT * FROM Sales.Customer;
END;

GO

--EXEC [sp_CustomerList]