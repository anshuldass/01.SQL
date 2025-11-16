USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_DynamicTable]    Script Date: 11/16/2025 7:43:54 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_DynamicTable]
	@TableName NVARCHAR(100)
AS
BEGIN
	DECLARE @SQL NVARCHAR(MAX);
    DECLARE @Schema SYSNAME, @Table SYSNAME;
    -- Pull apart the name if a schema exists
    SET @Schema = PARSENAME(@TableName, 2);
    SET @Table  = PARSENAME(@TableName, 1);

    IF @Schema IS NULL
    BEGIN
        -- No schema provided; assume dbo
        SET @Schema = 'dbo';
    END

    SET @SQL =
        'SELECT * FROM ' 
        + QUOTENAME(@Schema) + '.' + QUOTENAME(@Table);

    EXEC sp_executesql @SQL;
END;

GO

--EXEC sp_DynamicTable @TableName='Sales.SalesOrderHeader'