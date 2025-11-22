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
