USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_InsertNewCustomer]    Script Date: 11/16/2025 9:24:47 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_InsertNewCustomer]
	@FirstName NVARCHAR(50),
	@LastName NVARCHAR(50),
	@Email NVARCHAR(50)
AS
BEGIN
	SET NOCOUNT ON;
	DECLARE @SQL NVARCHAR(MAX);
	SET @SQL = N'INSERT INTO DBO.CUSTOMER (FirstName, LastName, Email)
				VALUES(@FirstName,@LastName,@Email)'
	EXEC SP_EXECUTESQL @SQL,
			N'@FirstName NVARCHAR(50),@LastName NVARCHAR(50),@Email NVARCHAR(50)',
			@FirstName = @FirstName,
			@LastName = @LastName,
			@Email = @Email
END;
GO

EXEC sp_InsertNewCustomer 'ANSHUL','DASS', 'ANSHUL.DASS@DOMAIN.COM'