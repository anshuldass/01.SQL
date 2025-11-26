# 24. Exercises (with Answers)

This chapter provides hands-on exercises to reinforce T-SQL, relational thinking, and data engineering patterns. Answers are provided for self-checking.

---

## 1. Basic SELECT
**Exercise:** Retrieve all customer names and emails.
```sql
SELECT FirstName, LastName, Email FROM Sandbox.Customers;
```
**Answer:** Returns 3 rows with Alice, Bob, and Charlie.

---

## 2. Filtering and WHERE
**Exercise:** Get all orders placed after '2025-01-10'.
```sql
SELECT * FROM Sandbox.Orders WHERE OrderDate > '2025-01-10';
```
**Answer:** Orders 2 and 3.

---

## 3. JOINs
**Exercise:** List orders with customer names and total amount.
```sql
SELECT c.FirstName, c.LastName, o.OrderID, SUM(oi.Quantity*oi.UnitPrice) AS TotalAmount
FROM Sandbox.Customers c
JOIN Sandbox.Orders o ON c.CustomerID = o.CustomerID
JOIN Sandbox.OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY c.FirstName, c.LastName, o.OrderID;
```
**Answer:**
- Alice: Order 1 - 1251.00, Order 2 - 45.00
- Bob: Order 3 - 25.50

---

## 4. Window Function
**Exercise:** Compute running total per customer.
```sql
SELECT OrderID, CustomerID, OrderDate,
       SUM(Quantity*UnitPrice) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal
FROM Sandbox.Orders o
JOIN Sandbox.OrderItems oi ON o.OrderID = oi.OrderID;
```
**Answer:**
- Alice: Order 1 - 1251.00, Order 2 - 1296.00
- Bob: Order 3 - 25.50

---

## 5. CTE & Aggregates
**Exercise:** List total spent per customer.
```sql
WITH CustomerTotals AS (
    SELECT CustomerID, SUM(Quantity*UnitPrice) AS TotalSpent
    FROM Sandbox.Orders o
    JOIN Sandbox.OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY CustomerID
)
SELECT c.FirstName, c.LastName, ct.TotalSpent
FROM Sandbox.Customers c
JOIN CustomerTotals ct ON c.CustomerID = ct.CustomerID;
```
**Answer:**
- Alice - 1296.00
- Bob - 25.50

---

## 6. DML
**Exercise:** Increase all product prices by 5%.
```sql
UPDATE Sandbox.Products SET Price = Price * 1.05;
```
**Answer:** Prices updated to Laptop - 1260.00, Mouse - 26.78, Keyboard - 47.25

---

## 7. Subquery
**Exercise:** Get customers who have spent more than 100.
```sql
SELECT FirstName, LastName FROM Sandbox.Customers
WHERE CustomerID IN (
    SELECT CustomerID
    FROM Sandbox.Orders o
    JOIN Sandbox.OrderItems oi ON o.OrderID = oi.OrderID
    GROUP BY CustomerID
    HAVING SUM(Quantity*UnitPrice) > 100
);
```
**Answer:** Alice

---

## 8. Temporary Table
**Exercise:** Create a temp table of high-value orders (TotalAmount > 100).
```sql
SELECT o.OrderID, CustomerID, SUM(oi.Quantity*oi.UnitPrice) AS TotalAmount
INTO #HighValueOrders
FROM Sandbox.Orders o
JOIN Sandbox.OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY o.OrderID, CustomerID
HAVING SUM(oi.Quantity*oi.UnitPrice) > 100;
```
**Answer:** #HighValueOrders contains Order 1 for Alice.

---

## 9. Scalar Function
**Exercise:** Create function to return full name.
```sql
CREATE FUNCTION dbo.GetFullName(@FirstName NVARCHAR(50), @LastName NVARCHAR(50))
RETURNS NVARCHAR(101)
AS BEGIN
    RETURN @FirstName + ' ' + @LastName;
END;
```
**Answer:** `SELECT dbo.GetFullName('Alice','Smith');` returns 'Alice Smith'

---

## 10. Table-Valued Function
**Exercise:** Create inline TVF to get orders by customer.
```sql
CREATE FUNCTION dbo.GetOrdersByCustomer(@CustomerID INT)
RETURNS TABLE
AS
RETURN (
    SELECT o.OrderID, o.OrderDate, SUM(oi.Quantity*oi.UnitPrice) AS TotalAmount
    FROM Sandbox.Orders o
    JOIN Sandbox.OrderItems oi ON o.OrderID = oi.OrderID
    WHERE o.CustomerID = @CustomerID
    GROUP BY o.OrderID, o.OrderDate
);
```
**Answer:** `SELECT * FROM dbo.GetOrdersByCustomer(1);` returns Orders 1 and 2 for Alice.

