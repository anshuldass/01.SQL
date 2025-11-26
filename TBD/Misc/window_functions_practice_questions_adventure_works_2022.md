# Window Functions Practice Questions (AdventureWorks2022)

This collection progresses from foundational to advanced analytical challenges using window functions. No solutions are included unless requested.

---

## **1. Beginner Level**

### **Q1. Assign row numbers**
List all products with a row number ordered by ListPrice from highest to lowest.

### **Q2. Rank products by price**
Using `RANK()`, rank all products within each ProductSubcategory based on ListPrice descending.

### **Q3. Dense rank by selling weight**
For all products, compute a dense rank ordered by Weight (ascending). Products with NULL weight should appear last.

### **Q4. Create price quartiles**
Using `NTILE(4)`, divide products into quartiles based on ListPrice.

### **Q5. Order count per customer**
Assign `ROW_NUMBER()` to each SalesOrderHeader by CustomerID sorted by OrderDate.

---

## **2. Intermediate Level**

### **Q6. Running total of customer orders**
For each customer, calculate a running total of TotalDue ordered by OrderDate.

### **Q7. Moving 3-order average**
Calculate a 3-row moving average of TotalDue across all sales orders ordered by OrderDate.

### **Q8. Compare each sale to the previous one**
Use `LAG()` to show each order’s TotalDue alongside the previous order’s TotalDue.

### **Q9. First and last price**
For each product, use `FIRST_VALUE()` and `LAST_VALUE()` to show first and last ListPrice based on ModifiedDate.

### **Q10. Percentile rank of product price**
Using `PERCENT_RANK()`, show the percentile ranking of each product’s ListPrice across the entire product catalog.

---

## **3. Advanced Level**

### **Q11. Top 1 most expensive product per subcategory**
Return the most expensive product in each ProductSubcategory using a window function (no TOP or subquery filters).

### **Q12. Gaps and islands – identify order streaks**
Identify continuous sequences of SalesOrderID values for each customer using the ROW_NUMBER difference trick.

### **Q13. Detect abnormal spikes**
Compare each order’s TotalDue with:
- its 7-order moving average
- the previous day’s TotalDue using `LAG()`
Highlight rows where TotalDue > 150% of the moving average.

### **Q14. Windowed aggregates with partitioning**
For each product category → subcategory group, calculate:
- total number of products
- highest and lowest ListPrice
using window aggregates.

### **Q15. Ranking vendors by cumulative spend**
Rank vendors based on cumulative TotalDue across Purchase Orders ordered by OrderDate.

---

## **4. Expert Level (Data Engineering Scenarios)**

### **Q16. Customer lifecycle stage**
Label each customer’s orders with purchase number (1st, 2nd, …) and compute lifetime spend using window aggregates.

### **Q17. Month-over-month trend analysis**
For each month:
- total sales amount
- LAG of last month’s total
- percent change
Use `OVER(PARTITION BY YEAR(OrderDate) ...)` as needed.

### **Q18. Rolling 30-day revenue window**
Using ROWS or RANGE, compute a 30-day rolling SUM of TotalDue.

### **Q19. Product category percentile within category**
For each product, compute percentile of its ListPrice **within its ProductCategory**.

### **Q20. Basket anomaly detection**
For SalesOrderDetail, compute:
- row number within each sales order
- difference between UnitPrice and previous line’s UnitPrice
- 5-row moving average of LineTotal
Identify orders where the last line deviates from the moving average by > 2 standard deviations.

---

## Want solutions?
A complete solutions file or a hints-only version can be created when needed.