# CTE Practice Questions (AdventureWorks2022)

This set builds skill with Common Table Expressions from simple refactoring to advanced recursive and multi-stage data engineering patterns. No solutions unless requested.

---

## **1. Beginner Level**

### **Q1. Simple filtering CTE**

Create a CTE returning all products with ListPrice > 1000, then select all rows from it.

### **Q2. Selecting recent orders**

Build a CTE that returns all sales orders after `2014-01-01` and then query only CustomerID and OrderDate from the CTE.

### **Q3. Multiple chained CTEs**

Write two chained CTEs:

1. First returns all products with non‑NULL weight.
2. Second returns the same products with a computed price-to-weight ratio.
   Query the second CTE.

### **Q4. Join inside a CTE**

Create a CTE that joins SalesOrderHeader and Customer to produce CustomerID, SalesOrderID, and TotalDue.

### **Q5. Using CTE instead of subquery**

Rewrite a query that finds the top 10 highest TotalDue orders using a CTE with `ROW_NUMBER()` and filter on the outer query.

---

## **2. Intermediate Level**

### **Q6. Combine CTE + Window Functions**

Create a CTE that assigns a row number per customer based on TotalDue DESC. Query only each customer’s highest order.

### **Q7. Using CTE for aggregation**

Build a CTE that sums LineTotal for each ProductID from SalesOrderDetail. Use it to return products with total revenue > 50,000.

### **Q8. Two-stage transformation**

Use two CTEs:

1. First cleans SalesOrderDetail by removing rows with LineTotal <= 0.
2. Second aggregates total revenue per ProductID.
   Query the aggregated CTE.

### **Q9. Combine two CTE aggregates**

Create one CTE calculating max ListPrice per Subcategory, and another calculating min ListPrice per Subcategory. Join them in the final query.

### **Q10. CTE for percent ranking**

Use a CTE to compute `PERCENT_RANK()` of ListPrice across all products and return rows above 90th percentile.

---

## **3. Advanced Level (Recursive CTEs)**

### **Q11. Generate a sequence**

Write a recursive CTE generating numbers 1 through 50.

### **Q12. Organizational hierarchy exploration**

Use a recursive CTE on `HumanResources.Employee` to list employees along with hierarchy level starting from those with NULL ManagerID.

### **Q13. Bill of Materials expansion**

Using Production.BillOfMaterials, expand the hierarchy for a product of your choice, returning all components at all levels.

### **Q14. Find reporting depth**

Using a recursive CTE, compute how many levels deep each employee is within the hierarchy.

### **Q15. Recursive date generator**

Generate all dates between `2013-01-01` and `2013-12-31` using a recursive CTE.

---

## **4. Expert Level (Data Engineering Scenarios)**

### **Q16. Sessionization using CTE + row-number gaps**

Using SalesOrderHeader, break orders into sessions per CustomerID where the gap between OrderDates is > 7 days.
A CTE should identify partitions with the ROW_NUMBER difference trick.

### **Q17. Multi-stage cleaning pipeline**

Use chained CTEs to:

1. Pull SalesOrderDetail.
2. Clean invalid or zero LineTotal rows.
3. Compute revenue per product.
4. Compute percent rank of each product’s revenue.
   Final result should return only the top 10% products.

### **Q18. Detect BOM cycles**

Construct a recursive CTE over BillOfMaterials. Use `OPTION (MAXRECURSION 50)` to ensure safe execution. Identify any components that appear more than once in the same recursive path.

### **Q19. Product lifecycle enrichment**

Create a multi-CTE flow:

- Extract product pricing history from ProductListPriceHistory.
- Rank price changes per product.
- Compute difference from previous price.
- Identify products with sudden jumps (> 20%).

### **Q20. Sales pipeline with segmentation**

Build a 4‑CTE process that:

1. Classifies orders as High/Medium/Low based on TotalDue quantiles.
2. Computes customer-level total spend.
3. Assigns customers into tiers based on spend.
4. Returns all customers whose tier does not match their most recent order classification.

---