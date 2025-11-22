# **Data Engineering Lab 1: Data Cleaning & Transformation**

**Database:** AdventureWorks2022  
**Objective:** Learn how to clean, transform, and derive new columns from raw data for analysis.

---

## **Exercise 1: Explore Missing Values**

**Scenario:** Your manager noticed that some orders are missing shipping dates or total amounts. You need to identify these rows.

```sql
-- Step 1: Check for missing shipping dates or total amounts 
SELECT 
    SalesOrderID, 
    CustomerID,
    OrderDate, 
    ShipDate, 
    TotalDue 
FROM 
    Sales.SalesOrderHeader 
WHERE 
    ShipDate IS NULL OR 
    TotalDue IS NULL;
```

**Task:**

1. Count how many rows have missing `ShipDate`.

2. Count how many rows have missing `TotalDue`.

**Optional Challenge:** Use `COUNT` with `CASE` to get both counts in a single query.

---

## **Exercise 2: Handle Duplicates**

**Scenario:** Some customers may have duplicate orders accidentally entered on the same date.

```sql
-- Step 2: Identify potential duplicate orders 
SELECT 
    CustomerID, 
    OrderDate, 
    COUNT(*) AS DuplicateCount 
FROM 
    Sales.SalesOrderHeader 
GROUP BY 
    CustomerID, 
    OrderDate 
    HAVING COUNT(*) > 1;
```

**Task:**

1. List all duplicate orders.

2. Decide whether to keep the first entry or remove duplicates.

3. (Optional) Write a query to remove duplicates while keeping the earliest `SalesOrderID`.

---

## **Exercise 3: Standardize Product Names**

**Scenario:** Product names have inconsistent capitalization which can cause issues in reporting.

```sql
-- Step 3: Standardize product names to upper case 
SELECT 
    ProductID, 
    Name, 
    UPPER(Name) AS StandardProductName 
FROM 
    Production.Product;
```

``

**Task:**

1. Create a view `vw_ProductsStandardized` with standardized names.

2. Ensure all future reports use this view for consistency.

**Optional Challenge:** Use `INITCAP`/`PROPER` function if your SQL supports it, for proper title case formatting.

---

## **Exercise 4: Derive New Columns (Profit Calculation)**

**Scenario:** Management wants to know the profit per line item.

```sql
-- Step 4: Calculate profit per line item 
SELECT 
    SOD.SalesOrderID, 
    SOD.ProductID, 
    SOD.OrderQty, 
    SOD.LineTotal, 
    P.StandardCost, 
    SOD.LineTotal - (P.StandardCost * SOD.OrderQty) AS Profit 
FROM 
    Sales.SalesOrderDetail SOD 
    JOIN Production.Product P 
    ON SOD.ProductID = P.ProductID;
```

**Task:**

1. Create a `Profit` column for all line items.

2. Aggregate total profit per order.

3. Optional: Aggregate profit by customer.

---

## **Exercise 5: Fill Missing Values**

**Scenario:** Reports cannot handle NULL `TotalDue` values. You must replace them with a default value.

```sql
-- Step 5: Replace NULL TotalDue with 0 
SELECT 
    SalesOrderID, 
    ISNULL(TotalDue, 0) AS TotalDue_Cleaned 
FROM Sales.SalesOrderHeader;
```

``

**Task:**

1. Update the `SalesOrderHeader` table (if allowed) to replace NULLs with 0.

2. Write a query to check that no NULL values remain.

**Optional Challenge:** Fill missing `ShipDate` using a default, such as `OrderDate + 5 days`.

---

## **Exercise 6: Combine Transformations into a Cleaned Table**

**Scenario:** You want a single table ready for reporting, with cleaned data and derived columns.

```sql
-- Step 6: Create a clean reporting table 
SELECT 
    SOH.SalesOrderID, 
    SOH.CustomerID, 
    SOH.OrderDate, 
    ISNULL(SOH.ShipDate, DATEADD(day, 5, SOH.OrderDate)) AS ShipDate_Cleaned, 
    ISNULL(SOH.TotalDue, 0) AS TotalDue_Cleaned, 
    SOD.ProductID, 
    P.Name AS ProductName, 
    UPPER(P.Name) AS StandardProductName, 
    SOD.OrderQty,    
    SOD.LineTotal, 
    P.StandardCost, 
    SOD.LineTotal - (P.StandardCost * SOD.OrderQty) AS Profit 
INTO 
    SalesOrder_Cleaned 
FROM 
    Sales.SalesOrderHeader SOH 
    JOIN Sales.SalesOrderDetail SOD 
    ON SOH.SalesOrderID = SOD.SalesOrderID 
    JOIN Production.Product P 
    ON SOD.ProductID = P.ProductID;
```

**Task:**

1. Verify the `SalesOrder_Cleaned` table.

2. Run aggregations for total revenue and total profit by customer.

3. Use this cleaned table as the basis for reporting or analytics.

---

### **Lab Notes:**

- These steps replicate **ETL pipeline logic** in SQL.

- Exercises 1–5 are **incremental** cleaning tasks.

- Exercise 6 shows how to **combine transformations** into a reporting-ready dataset.

- Optional challenges simulate **real-life scenarios** like missing data imputation and duplicate removal strategies.

---



---

# **Data Engineering Lab 1 – Practice Questions**

**Database:** AdventureWorks2022  
**Focus:** Data Cleaning & Transformation

---

## **Question 1: Identify Missing or Invalid Data**

**Scenario:** Some orders have missing shipping dates or `TotalDue` values.

**Task:**

1. Write a query to count the number of orders with `NULL` `ShipDate`.

2. Count the number of orders where `TotalDue` is `NULL` **or 0**.

3. Bonus: Find the `CustomerID`s that have both issues in the same order.

---

## **Question 2: Detect Duplicates**

**Scenario:** Duplicate orders can distort reporting.

**Task:**

1. Write a query to identify all duplicate orders based on the combination of `CustomerID` and `OrderDate`.

2. Show the `SalesOrderID`s of these duplicates.

3. Bonus: Keep only the **earliest** `SalesOrderID` per duplicate set.

---

## **Question 3: Standardize Product Names**

**Scenario:** Product names are inconsistent in capitalization.

**Task:**

1. Write a query to return all product names in **upper case**.

2. Create a temporary view `vw_ProductStandardized` that always shows standardized names.

3. Bonus: Modify your view to use **title case** (first letter capitalized) if your SQL supports it.

---

## **Question 4: Derive Profit per Order Line**

**Scenario:** Management wants to analyze profit per line item.

**Task:**

1. Write a query to calculate `Profit = LineTotal - (StandardCost × OrderQty)` for each `SalesOrderDetail`.

2. Show the top 10 orders with the highest profit.

3. Bonus: Aggregate profit per customer.

---

## **Question 5: Combine Cleaned Data into Reporting Table**

**Scenario:** You want a reporting-ready table that handles missing values and standardized product names.

**Task:**

1. Write a query that selects:
   
   - SalesOrderID, CustomerID, OrderDate
   
   - `ShipDate` (fill missing with `OrderDate + 5 days`)
   
   - `TotalDue` (fill missing with 0)
   
   - ProductID, standardized ProductName
   
   - OrderQty, LineTotal, StandardCost, Profit

2. Save this as a **new table** or **CTE** for reporting.

3. Bonus: Aggregate total revenue and total profit by customer using this table.

---

### **Lab Notes:**

- These questions mirror **real-world tasks** that data engineers perform in ETL pipelines.

- Optional challenges add **complexity** similar to what you’d encounter in production pipelines.

- Once solved, you’ll have a **cleaned, transformed dataset** ready for analysis or dashboards.
