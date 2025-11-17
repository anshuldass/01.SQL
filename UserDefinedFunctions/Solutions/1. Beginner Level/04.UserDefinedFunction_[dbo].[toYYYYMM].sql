USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[toYYYYMM]    Script Date: 11/17/2025 7:24:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[toYYYYMM](@OrderDate Date)
RETURNS NVARCHAR(10)
AS
BEGIN
	RETURN FORMAT(@OrderDate,'yyyyMM', 'en-US')
END;
GO

--SELECT
--	dbo.toYYYYMM(OrderDate) AS DateFormat,
--	*
--FROM Sales.SalesOrderHeader;
