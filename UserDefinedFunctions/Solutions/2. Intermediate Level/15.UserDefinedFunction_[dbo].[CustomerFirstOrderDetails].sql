USE [AdventureWorks2022]
GO

/****** Object:  UserDefinedFunction [dbo].[CustomerFirstOrderDetails]    Script Date: 11/17/2025 10:58:53 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER   FUNCTION [dbo].[CustomerFirstOrderDetails]()
RETURNS @FirstOrderDet TABLE(
	CustomerID INT,
	FirstOrderDate DATE,
	FirstOrderTotal DECIMAL(10,2)
)
AS
BEGIN
	INSERT INTO @FirstOrderDet
	SELECT
	CustomerID,
	OrderDate AS FirstOrderDate,
	TotalAmount AS FirstOrderTotal
	FROM (
		SELECT 
			CustomerID,
			TotalDue AS TotalAmount,
			OrderDate,
			ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY ORDERDATE,SALESORDERID) AS RN
		FROM Sales.SalesOrderHeader
		) 
	AS T
	WHERE RN = 1;
	RETURN;
END;
GO


--SELECT * FROM dbo.CustomerFirstOrderDetails();