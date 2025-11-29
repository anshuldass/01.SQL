/*List all products with their name, color, and list price. Show only
products with a non-null color.*/

SELECT NAME, Color,ListPrice FROM Production.Product
WHERE Color IS NOT NULL;

/*Retrieve employees hired in the last 5 years using `HumanResources.Employee`.*/
SELECT * FROM HumanResources.Employee
WHERE HireDate>= DATEADD(YEAR,-5,GETDATE());

/*Show the top 10 most expensive products (`ListPrice`).*/
SELECT TOP 10 * FROM Production.Product
ORDER BY ListPrice DESC;

/*Find all customers from Canada using `Person.CountryRegion` +`Sales.SalesTerritory`.*/
SELECT * FROM Sales.Customer c
INNER JOIN Sales.SalesTerritory SST
ON C.TerritoryID = SST.TerritoryID
AND SST.Name = 'Canada';

/*Count how many products exist in each `ProductSubcategory`.*/
SELECT 
	PPS.ProductSubcategoryID,
	PPS.Name,
	COUNT(*) AS CountSubCat
FROM Production.ProductSubcategory PPS
INNER JOIN Production.Product PP
ON PPS.ProductSubcategoryID = PP.ProductSubcategoryID
GROUP BY PPS.ProductSubcategoryID,PPS.Name;

/*List customer full names from `Person.Person` combined with `Sales.Customer`.*/
SELECT
	CONCAT(ISNULL(PP.FirstName,''),' ',ISNULL(PP.MiddleName,''),' ',ISNULL(PP.LastName,'')) AS FullName
FROM Sales.Customer C
INNER JOIN Person.Person PP
ON C.PersonID = PP.BusinessEntityID;

/*Retrieve all orders placed in 2014.*/
SELECT * FROM Sales.SalesOrderHeader 
WHERE OrderDate BETWEEN '2014-01-01' AND '2014-12-31';

/*Find the average list price of products grouped by color.*/
SELECT
	Color,
	AVG(ListPrice) AVG_List_Price
FROM Production.Product
WHERE COLOR IS NOT NULL
GROUP BY Color
ORDER BY AVG_List_Price;

/*Show all products that have never been sold.*/
SELECT * FROM Production.Product PP
LEFT JOIN Sales.SalesOrderDetail SSOD
ON PP.ProductID = SSOD.ProductID
WHERE SSOD.SalesOrderID IS NULL;

/*Return order details for a specific SalesOrderID, including productname, quantity, and line total.*/
SELECT 
	SSOD.SalesOrderID,
	PP.Name AS ProductName,
	OrderQty,
	LineTotal
FROM Sales.SalesOrderDetail SSOD
INNER JOIN Production.Product PP
ON SSOD.ProductID = PP.ProductID
WHERE SalesOrderID = 43659;

/*List customers along with the salesperson assigned to them.*/
SELECT 
	DISTINCT 
	CustomerID,
	SalesPersonID 
FROM Sales.SalesOrderHeader SSOH
INNER JOIN Person.Person PP
ON SSOH.SalesPersonID = PP.BusinessEntityID;

/*Show all products along with their vendor names.*/
SELECT 
	PV.BusinessEntityID,
	PV.Name AS VendorName,
	PPV.ProductID,
	PP.Name AS ProductName
FROM Purchasing.Vendor PV
INNER JOIN Purchasing.ProductVendor PPV
ON PV.BusinessEntityID = PPV.BusinessEntityID
INNER JOIN Production.Product PP
ON PPV.ProductID = PP.ProductID;

/*Find employees and their job titles using `Employee` +`EmployeeDepartmentHistory`.*/
SELECT 
	HRE.BusinessEntityID,
	HRE.JobTitle,
	HREDH.DepartmentID
FROM HumanResources.Employee HRE
INNER JOIN HumanResources.EmployeeDepartmentHistory HREDH
ON HRE.BusinessEntityID = HREDH.BusinessEntityID;	

/*Retrieve all purchase orders with vendor details.*/
SELECT 
	*,
	PV.Name AS VendorName
FROM Purchasing.PurchaseOrderHeader PPOH
INNER JOIN Purchasing.Vendor PV
ON PPOH.VendorID = PV.BusinessEntityID;

/*Find all stores (not individuals) that made purchases.*/
SELECT * FROM Sales.SalesOrderHeader SSOH
INNER JOIN Sales.Store SS
ON SSOH.CustomerID = SS.BusinessEntityID;

/*Show each product category with total products under it.*/
SELECT 
	PPC.ProductCategoryID,
	PPC.Name AS ProductCatName,
	PP.ProductID,
	PP.Name AS ProductName
FROM Production.ProductCategory PPC
INNER JOIN Production.ProductSubcategory PPS
ON PPC.ProductCategoryID = PPS.ProductSubcategoryID
INNER JOIN Production.Product PP
ON PPS.ProductSubcategoryID = PP.ProductSubcategoryID
ORDER BY PPC.ProductCategoryID;

/*Identify sales orders handled by female salespersons.*/
SELECT 
	SSOH.SalesOrderID,
	SSOH.SalesPersonID,
	HRE.Gender
FROM Sales.SalesOrderHeader SSOH
INNER JOIN HumanResources.Employee HRE
ON SSOH.SalesPersonID = HRE.BusinessEntityID
AND HRE.Gender = 'F';

/*Show products whose vendor charges an average price higher than the product's own list price.*/
--SELECT * FROM Purchasing.ProductVendor PPV
--SELECT * FROM Production.Product PP
WITH CTE AS(
SELECT
	PPOD.ProductID,
	AVG(PPOD.UnitPrice) AS Avg_Unit_Price
FROM Purchasing.PurchaseOrderDetail PPOD
GROUP BY PPOD.ProductID
)
SELECT 
	C.ProductID,
	C.Avg_Unit_Price,
	PP.ListPrice
FROM CTE C
INNER JOIN Production.Product PP
ON C.ProductID = PP.ProductID
WHERE C.Avg_Unit_Price > PP.ListPrice;

/*Join `Sales.SalesOrderHeader` and `Sales.SalesOrderDetail` to compute total order price.*/
SELECT
	SSOH.SalesOrderID,
	CAST(SUM(TotalDue) AS decimal(10,2)) AS TotalSales,
	CAST(SUM(LineTotal) AS decimal(10,2)) AS LineItemTotal
FROM Sales.SalesOrderHeader SSOH
INNER JOIN Sales.SalesOrderDetail SSOD
ON SSOH.SalesOrderID = SSOD.SalesOrderID
GROUP BY SSOH.SalesOrderID
ORDER BY SSOH.SalesOrderID;

/*Display each sales territory with total sales amount and number of customers.*/

SELECT 
	SST.TerritoryID,
	SST.Name AS SalesTerritoryName,
	CAST(SUM(SSOH.TotalDue)AS decimal(10,2)) AS TotalSales,
	COUNT(CustomerID) AS CustomerCount
FROM Sales.SalesOrderHeader SSOH
INNER JOIN Sales.SalesTerritory SST
ON SSOH.TerritoryID = SST.TerritoryID
GROUP BY SST.TerritoryID,SST.Name
ORDER BY SST.TerritoryID;

/*For each product, compute its rank by `ListPrice` within its subcategory.*/
SELECT 
	PP.ProductID,
	PP.Name AS ProductName,
	PP.ProductSubcategoryID,
	PP.ListPrice,
	DENSE_RANK() OVER (PARTITION BY PP.ProductSubcategoryID ORDER BY ListPrice DESC) AS RN
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID;

/*Compute running total of sales by order date.*/
SELECT 
	OrderDate,
	SalesOrderID,
	CAST(TotalDue AS decimal(18,2)) AS TotalDue,
	SUM(TotalDue) OVER (ORDER BY SALESORDERID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotals
FROM Sales.SalesOrderHeader;

/*Show each salesperson's total sales and their rank within their region.*/
WITH CTE AS(
SELECT 
	SSP.BusinessEntityID AS SalesPersonID,
	SST.TerritoryID,
	SST.Name AS TerritoryName,
	CAST(SUM(TotalDue)AS decimal(10,2)) AS TotalSales	
FROM Sales.SalesOrderHeader SSOH
INNER JOIN Sales.SalesPerson SSP
ON SSOH.SalesPersonID = SSP.BusinessEntityID
INNER JOIN Sales.SalesTerritory SST
ON SSP.TerritoryID = SST.TerritoryID

GROUP BY SSP.BusinessEntityID,SST.TerritoryID,SST.Name
)
SELECT 
	SalesPersonID,
	CONCAT(PP.FirstName, PP.MiddleName, PP.LastName) AS SalesPersonName,
	TerritoryID,
	TerritoryName,
	TotalSales,
	DENSE_RANK() OVER (PARTITION BY TerritoryName ORDER BY TotalSales DESC) AS RNK
FROM CTE C
INNER JOIN Person.Person PP
ON C.SalesPersonID = PP.BusinessEntityID
ORDER BY TerritoryName;

/*For each customer, calculate the average days between orders.*/
WITH CTE AS(
SELECT 
	CustomerID,
	SalesOrderID,
	OrderDate,
	LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PREV_Order_Date
FROM Sales.SalesOrderHeader
)
SELECT	
	CustomerID,
	SalesOrderID,
	OrderDate,
	PREV_Order_Date,
	DaysBetween,
	AVG(DaysBetween) OVER (PARTITION BY CUSTOMERID) AS AVG_Days_Between
FROM (
	SELECT 
		*,
		DATEDIFF(DAY,PREV_Order_Date,OrderDate) AS DaysBetween
	FROM CTE
	) AS T;

/*Show products with their list price and the difference from the subcategory's average list price.*/
WITH CTE AS(
SELECT	
	ProductID,
	PP.Name AS ProductName,
	PP.ListPrice,
	pps.ProductSubcategoryID,
	PPS.Name AS ProductSubCatName,
	AVG(PP.ListPrice) OVER (PARTITION BY PPS.ProductSubcategoryID) AS AVG_SubCat_Price
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PPS
ON PP.ProductSubcategoryID = PPS.ProductSubcategoryID
)
SELECT 
	*,
	ListPrice - AVG_SubCat_Price AS PriceDifference
FROM CTE
ORDER BY ProductSubcategoryID,ProductSubCatName;

/*For each employee, show salary along with department-wide min, max,and average.*/

WITH SalaryDetails AS(
SELECT 
	BusinessEntityID,
	CASE WHEN PayFrequency = 2 THEN
		Rate*2
	ELSE 
		Rate
	END AS Salary,
	RateChangeDate,
	ROW_NUMBER() OVER (PARTITION BY BusinessEntityID ORDER BY RateChangeDate DESC) AS RN
FROM HumanResources.EmployeePayHistory HRE
),
EmployeeDeptHist AS(
SELECT 
	BusinessEntityID,
	DepartmentID,
	StartDate,
	EndDate,
	ROW_NUMBER() OVER (PARTITION BY BusinessEntityID ORDER BY ModifiedDate DESC) RN
FROM HumanResources.EmployeeDepartmentHistory
)
SELECT 
	T.BusinessEntityID,
	Salary,
	HRD.Name AS DepartmentName,
	MIN(Salary) OVER (PARTITION BY Hist.DepartmentID)AS MIN_SAL,
	MAX(Salary) OVER (PARTITION BY Hist.DepartmentID)AS MAX_SAL,
	AVG(Salary) OVER (PARTITION BY Hist.DepartmentID)AS AVG_SAL
		FROM ( 
		SELECT 
			BusinessEntityID,
			Salary
		FROM SalaryDetails
		WHERE RN=1
		) AS T
INNER JOIN EmployeeDeptHist Hist
ON T.BusinessEntityID=Hist.BusinessEntityID
INNER JOIN HumanResources.Department HRD
ON Hist.DepartmentID = HRD.DepartmentID
WHERE Hist.RN=1;

/*Find three most expensive products per category.*/
WITH CTE AS (
SELECT 
	ProductID,
	PP.Name AS ProductName,
	ListPrice,
	DENSE_RANK() OVER (PARTITION BY PPC.ProductCategoryID ORDER BY ListPrice DESC) AS RN
FROM Production.Product PP
INNER JOIN Production.ProductSubcategory PSB
ON PP.ProductSubcategoryID = PSB.ProductSubcategoryID
INNER JOIN Production.ProductCategory PPC
ON PSB.ProductCategoryID = PPC.ProductCategoryID
)
SELECT * FROM CTE
WHERE RN<=3;

/*Display year-over-year growth in sales amount.*/
WITH CTE AS(
SELECT 
	YEAR(OrderDate) AS YR,
	SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY YEAR(OrderDate)
)
SELECT 
	*,
	CASE WHEN PrevTotalSales IS NOT NULL THEN
	((TotalSales - PrevTotalSales)/PrevTotalSales) * 100
	END AS [Growth%]
FROM (
	SELECT 
		*,
		LAG(TotalSales) OVER(ORDER BY YR) AS PrevTotalSales
	FROM CTE
	)AS T;

/*Show each product with the percentage contribution of its sales to total product sales.*/
WITH CTE AS(
SELECT 
	PP.ProductID,
	PP.Name AS ProductName,
	SUM(SSOD.LineTotal) AS TotalSales
FROM Sales.SalesOrderHeader SSOH
INNER JOIN Sales.SalesOrderDetail SSOD
ON SSOH.SalesOrderID = SSOD.SalesOrderID
INNER JOIN Production.Product PP
ON SSOD.ProductID = PP.ProductID
GROUP BY PP.ProductID,PP.Name
),
CTE1 AS (
	SELECT 
		SUM(LineTotal) AS GrandTotal
	FROM Sales.SalesOrderDetail
)
SELECT 
	*,
	(TotalSales / GrandTotal)*100 AS SalesPercentage
FROM CTE C
CROSS JOIN CTE1 C1;

/*Identify the most recent purchase date per vendor.*/
WITH CTE AS(
SELECT 
	PPOH.VendorID,
	PV.Name AS VendorName,
	PPOH.OrderDate,
	ROW_NUMBER() OVER (PARTITION BY PPOH.VendorID ORDER BY PPOH.OrderDate DESC) AS LatestOrder
FROM Purchasing.PurchaseOrderHeader PPOH
INNER JOIN Purchasing.Vendor PV
ON PPOH.VendorID = PV.BusinessEntityID
)
SELECT 
	VendorID,
	VendorName,
	OrderDate AS LatestOrderDate
FROM CTE
WHERE LatestOrder = 1;