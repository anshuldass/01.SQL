# 📝 MS SQL Stored Procedure Practice Questions (AdventureWorks 2022)

**Goal:** Practice writing stored procedures from beginner to advanced using the AdventureWorks 2022 database.

---

## Table of Contents

1. Beginner Level
2. Intermediate Level
3. Advanced Level

---

## 1. Beginner Level

1. **Get all products:**
   - Create a stored procedure to fetch all columns from `Production.Product`.

2. **Product by ID:**
   - Create a stored procedure that accepts `ProductID` as input and returns the product details.

3. **Customer list:**
   - Create a procedure that returns all customers from `Sales.Customer`.

4. **Orders by Customer:**
   - Create a procedure that takes `CustomerID` as input and returns all orders (`SalesOrderID`, `OrderDate`) for that customer.

5. **Employee list:**
   - Create a procedure that fetches all employees from `HumanResources.Employee` including `BusinessEntityID` and `JobTitle`.

---

## 2. Intermediate Level

6. **Products by Category:**
   - Create a procedure with input `ProductCategoryID` and return all products in that category.

7. **Product Count by Category:**
   - Procedure accepts `ProductCategoryID` and returns the count of products as an output parameter.

8. **Orders in Date Range:**
   - Procedure accepts `StartDate` and `EndDate` and returns all orders in that period.

9. **Customer Sales Total:**
   - Procedure accepts `CustomerID` and returns the total `TotalDue` from `Sales.SalesOrderHeader`.

10. **Employees by Job Title:**
    - Procedure accepts `JobTitle` and returns all employees with that title.

11. **Top N Products by Sales:**
    - Procedure accepts `TopN` and returns top N products based on total sales amount.

---

## 3. Advanced Level

12. **Monthly Sales Report:**
    - Procedure accepts `Year` and `Month` and returns `CustomerID`, total sales, and number of orders.

13. **Dynamic Table Fetch:**
    - Procedure accepts `TableName` and returns top 10 rows dynamically from that table.

14. **Update Product Price:**
    - Procedure accepts `ProductID` and `NewPrice` and updates the `ListPrice` of the product.

15. **Insert New Customer:**
    - Procedure accepts `FirstName`, `LastName`, `Email` and inserts a new record into `Person.Person` and related `Sales.Customer` table.

16. **Delete Old Orders:**
    - Procedure deletes orders older than a given date, accepts `CutoffDate` as input, includes transaction and error handling.

17. **Nested Stored Procedures:**
    - Create a main procedure that calls another procedure to get products, then calculates total inventory value.

18. **Sales Summary by Territory:**
    - Procedure accepts `SalesTerritoryID` and returns total sales, total orders, and average order amount.

19. **Parameter Sniffing Prevention:**
    - Create a procedure with `OPTION (RECOMPILE)` to handle dynamic filtering on `ProductCategoryID` and `ListPrice`.

20. **ETL Style Load to Staging:**
    - Procedure truncates a staging table and loads product data from `Production.Product` with transaction and error handling.

---

These 20 questions cover beginner to advanced stored procedure scenarios and can be used as a hands-on practice set to master MS SQL stored procedures in AdventureWorks 2022.
