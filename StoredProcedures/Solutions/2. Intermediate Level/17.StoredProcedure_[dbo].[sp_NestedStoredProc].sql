USE [AdventureWorks2022]
GO

/****** Object:  StoredProcedure [dbo].[sp_NestedStoredProc]    Script Date: 11/16/2025 9:54:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   PROCEDURE [dbo].[sp_NestedStoredProc]
AS
BEGIN
	SET NOCOUNT ON;
	PRINT 'EXECUTING Child Stored Procedure'
	EXEC SP_EXECUTESQL sp_ChildStoredProc;
END;
GO


