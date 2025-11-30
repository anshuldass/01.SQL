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

/*Show products discontinued (SellEndDate \< GETDATE()).*/
SELECT * FROM Production.Product
WHERE SellEndDate <=GETDATE();

/*Find the longest gap (in days) between successive orders for any customer.*/
WITH CTE AS(
		SELECT
			CustomerID,
			OrderDate,
			LAG(OrderDate) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS PrevOrderDate
		FROM Sales.SalesOrderHeader
)
SELECT TOP 1
	MAX(DifferenceInDays) AS MAX_Gap
	FROM (
	SELECT 
		*,
		DATEDIFF(DAY,PrevOrderDate,OrderDate) AS DifferenceInDays
	FROM CTE) AS T
	GROUP BY CustomerID
	ORDER BY MAX_Gap DESC;

/*Identify repeat customers who placed orders in at least 3 distinct years.*/
SELECT 
    CustomerID
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
HAVING COUNT(DISTINCT YEAR(OrderDate)) >= 3
ORDER BY CustomerID;

/*Write a CTE to list all products and flag whether their sales volume is above the median.*/
WITH ProductSales AS (
    SELECT 
        ProductID,
        SUM(OrderQty) AS TotalSales
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
),

MedianValue AS (
    SELECT 
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY TotalSales) 
        OVER () AS MedianSales
    FROM ProductSales
)

SELECT 
    p.ProductID,
    p.TotalSales,
    CASE 
        WHEN p.TotalSales > m.MedianSales THEN 'Above Median'
        ELSE 'Below or Equal Median'
    END AS SalesFlag
FROM ProductSales p
CROSS JOIN (SELECT DISTINCT MedianSales FROM MedianValue) m
ORDER BY p.TotalSales DESC;

/*List employees whose vacation hours are below the company average.*/
WITH CTE1 AS (
SELECT 
	AVG(VacationHours) AS AvgVacationComp
FROM HumanResources.Employee
),
CTE2 AS (
	SELECT 
		BusinessEntityID,
		VacationHours
	FROM HumanResources.Employee
)
SELECT * 
FROM CTE2 
WHERE VacationHours < (SELECT AvgVacationComp FROM CTE1);

/*Retrieve the month with the highest total sales in each year.*/
WITH CTE AS(
SELECT 
	YEAR(OrderDate) AS YR,
	MONTH(OrderDate) AS MN,
	SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY MONTH(OrderDate),YEAR(OrderDate)
)
SELECT * FROM (
SELECT 
	YR,
	MN,
	TotalSales,
	ROW_NUMBER() OVER (PARTITION BY YR ORDER BY TOTALSALES DESC) AS RN
FROM CTE
) AS T
WHERE RN =1;

/*Find discontinued products that still have active vendors.*/
SELECT 
	PP.ProductID,
	PP.Name AS ProductName,
	PV.Name AS ProductVendor
FROM Production.Product PP
INNER JOIN Purchasing.ProductVendor PPV
ON PP.ProductID = PPV.ProductID
INNER JOIN Purchasing.Vendor PV
ON PPV.BusinessEntityID = PV.BusinessEntityID
WHERE PV.ActiveFlag = 1
AND PP.SellEndDate <=GETDATE() 
AND PP.SellEndDate IS NOT NULL;

/*Show vendors who supplied at least 5 different products.*/
SELECT 
	PV.BusinessEntityID AS ProductVendor
FROM Production.Product PP
INNER JOIN Purchasing.ProductVendor PPV
ON PP.ProductID = PPV.ProductID
INNER JOIN Purchasing.Vendor PV
ON PPV.BusinessEntityID = PV.BusinessEntityID
GROUP BY PV.BusinessEntityID
HAVING COUNT(DISTINCT PP.ProductID)>=5;

/*Identify products with mismatched weight units (WeightUnitMeasureCode not found in `UnitMeasure`).*/
SELECT * FROM Production.Product
WHERE WeightUnitMeasureCode NOT IN(SELECT DISTINCT UnitMeasureCode FROM Production.UnitMeasure);

/*Return orders where the tax amount is unusually high (greater than 2 standard deviations from mean).*/
WITH TaxStats AS (
    SELECT 
        AVG(TaxAmt) AS AvgTax,
        STDEV(TaxAmt) AS StdTax
    FROM Sales.SalesOrderHeader
)
SELECT 
    SalesOrderID,
    OrderDate,
    TaxAmt
FROM Sales.SalesOrderHeader s
CROSS JOIN TaxStats t
WHERE TaxAmt > t.AvgTax + 2 * t.StdTax
ORDER BY TaxAmt DESC;

/*Detect customers with overlapping orders (order dates too close---within 1 day).*/
WITH CTE AS(
SELECT 
	CustomerID,
	OrderDate
FROM Sales.SalesOrderHeader
)
SELECT * FROM (
SELECT 
	*,
	LAG(OrderDate) OVER (PARTITION BY CUSTOMERID ORDER BY ORDERDATE) AS PREVORDERDATE
FROM CTE C
) AS T
WHERE (PREVORDERDATE = OrderDate OR DATEDIFF(DAY,PREVORDERDATE, OrderDate)<=1);

/*Show top 10 most profitable products (LineTotal − StandardCost).*/
SELECT TOP 10 WITH TIES
	PP.ProductID,
	Name AS ProductName,
	(SSOD.LineTotal - PP.StandardCost*OrderQty) AS Profit
FROM Production.Product PP
INNER JOIN Sales.SalesOrderDetail SSOD
ON PP.ProductID = SSOD.ProductID
ORDER BY Profit DESC;

/*Identify salespeople whose sales dropped for 3 consecutive quarters.*/
WITH CTE AS(
SELECT 
	SSOH.SalesPersonID,
	YEAR(OrderDate) AS YR,
	DATEPART(QUARTER,OrderDate) AS Quarter,	
	SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader SSOH
INNER JOIN Sales.SalesPerson SSP
ON SSOH.SalesPersonID = SSP.BusinessEntityID
GROUP BY SSOH.SalesPersonID,YEAR(OrderDate),DATEPART(QUARTER,OrderDate)
)SELECT * FROM (
SELECT *,
	LAG(Prev) OVER (PARTITION BY SalesPersonID ORDER BY YR,Quarter) AS Prev3,
	CASE WHEN LAG(Prev2) OVER (PARTITION BY SalesPersonID ORDER BY YR,Quarter)  > PREV2
	AND Prev2>PREV AND PREV>TotalSales THEN 1 ELSE 0
	END AS DECLINE
FROM (
SELECT
	SalesPersonID,
	YR,
	TotalSales,
	Prev,
	QUARTER,
	LAG(Prev) OVER (PARTITION BY SalesPersonID ORDER BY YR,Quarter) AS Prev2
FROM (
SELECT *,
	LAG(TotalSales) OVER (PARTITION BY SalesPersonID ORDER BY YR,Quarter) AS Prev
FROM CTE
)AS T) AS T2) AS T3
WHERE DECLINE = 1;

/*Display all orders where shipping took more than 10 days from order date.*/
SELECT * FROM Sales.SalesOrderHeader
WHERE DATEDIFF(DAY,OrderDate,ShipDate) > 10;

/*List employees who changed departments more than twice.*/
SELECT
	HRE.BusinessEntityID
FROM HumanResources.Employee HRE
INNER JOIN HumanResources.EmployeeDepartmentHistory HREDH
ON HRE.BusinessEntityID = HREDH.BusinessEntityID
GROUP BY HRE.BusinessEntityID
HAVING COUNT(DISTINCT HREDH.DepartmentID) > 2;

/*Find slow-moving products: not sold in last 120 days.*/
SELECT P.ProductID, P.Name AS ProductName
FROM Production.Product P
WHERE NOT EXISTS (
    SELECT 1
    FROM Sales.SalesOrderDetail SSOD
    INNER JOIN Sales.SalesOrderHeader SSOH
        ON SSOD.SalesOrderID = SSOH.SalesOrderID
    WHERE SSOD.ProductID = P.ProductID
      AND SSOH.OrderDate > DATEADD(DAY, -120, GETDATE())
)
ORDER BY P.ProductID;
