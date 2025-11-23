# AdventureWorks (2022) — Numeric & Date/Time Functions Practice Problems

This set covers beginner → advanced numeric and date/time function challenges using the **AdventureWorks2022** database. No solutions are included unless you request them.

---

## 🟢 Beginner Level

### **1. Absolute Values**
Return the absolute values of the `ListPrice` from `Production.Product` minus the `StandardCost`.

### **2. Rounding Prices**
Round the `ListPrice` of all products to the nearest integer using `ROUND()`.

### **3. Ceiling & Floor**
Show both the `CEILING` and `FLOOR` of `ListPrice` for all products.

### **4. Square Root of StandardCost**
Compute the square root of `StandardCost` for all products.

### **5. Random Sampling**
Select 5 random products using `NEWID()` or `RAND()`.

---

## 🟡 Intermediate Level

### **6. Discount Calculations**
From `Sales.SpecialOffer`, calculate a discounted price of 100 for each product applying the `DiscountPct`.

### **7. Price Bucketing**
Divide `ListPrice` into buckets of $50 using `CEILING()` or `FLOOR()` to find the price range category.

### **8. Date Extraction**
From `Sales.SalesOrderHeader`, extract the **year**, **month**, and **day** from `OrderDate`.

### **9. Date Difference**
Calculate the number of days between `OrderDate` and `DueDate` for all orders.

### **10. Add Days to Date**
From `Sales.SalesOrderHeader`, calculate a follow-up date 30 days after `OrderDate`.

---

## 🔵 Advanced Level

### **11. Customer Age Calculation**
From `Person.Person`, calculate each customer's age based on `BirthDate`.

### **12. Days Since Last Purchase**
From `Sales.SalesOrderHeader`, compute the number of days since the last `OrderDate` for each customer.

### **13. Monthly Sales Aggregation**
Sum `TotalDue` grouped by month and year of `OrderDate`.

### **14. Moving Average of Sales**
Compute a 7-day moving average of `TotalDue` using window functions over `OrderDate`.

### **15. Identify Expensive Orders**
Return orders where `TotalDue` is more than **2 standard deviations above the mean**.

### **16. Age Group Classification**
Group customers into age categories: `<20`, `20-35`, `36-50`, `>50`.

### **17. Time Until Ship**
For all orders, compute hours between `OrderDate` and `ShipDate`.

### **18. Random Discount Assignment**
Assign a pseudo-random discount between 5% and 20% to all products.

### **19. Yearly Growth Rate**
Calculate year-over-year growth in `TotalDue` for each year.

### **20. Calculate Quarter of Order**
From `OrderDate`, calculate which **quarter** each order belongs to.

---

Next, we can move on to **practice problems for conversion, NULL handling, and conditional functions** if you want to continue the series.