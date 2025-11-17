USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[MaskEmail]    Script Date: 11/17/2025 11:34:34 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[MaskEmail](@EmailAddress NVARCHAR(100))
RETURNS	NVARCHAR(100)
AS
BEGIN
	RETURN (SELECT	
	CONCAT(
	LEFT(EMAILADDRESS,2),'***',
	SUBSTRING(EmailAddress,CHARINDEX('@adventure-works.com',EmailAddress) ,LEN(EmailAddress) ))
	FROM Person.EmailAddress
	WHERE EmailAddress = @EmailAddress)
END;
GO

--SELECT *, dbo.MaskEmail(EmailAddress) AS MaskedEmail FROM Person.EmailAddress