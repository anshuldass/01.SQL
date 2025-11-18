SELECT 
	VendorID,
	OrderDate,
	SUM(TotalDue) OVER (PARTITION BY VendorID ORDER BY OrderDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS VendorCumulativeSpend
FROM Purchasing.PurchaseOrderHeader
ORDER BY VendorID