USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[ufnProductWeightClass]    Script Date: 11/17/2025 2:44:44 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[ufnProductWeightClass](@Weight INT)
RETURNS NVARCHAR(10)
AS
BEGIN
	DECLARE @Result NVARCHAR(10);
	IF @Weight < 2.0
		SET @Result = 'Light'
	IF @Weight BETWEEN 2.0 AND 10.0
		SET @Result = 'Medium'
	IF @Weight > 10.0
		SET @Result = 'Heavy'
	IF @Weight IS NULL
		SET @Result = 'UNKNOWN'
RETURN @Result
END;
GO

--SELECT 
--	*,
--	dbo.ufnProductWeightClass(Weight) as WeightCategory
--FROM Production.Product
--ORDER BY WeightCategory DESC