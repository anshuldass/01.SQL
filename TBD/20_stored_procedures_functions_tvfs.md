# 20. Stored Procedures, Functions, and TVFs — When to Use Which

In SQL Server, encapsulating logic is key for reusability, modularity, and maintainability. You have several options: **Stored Procedures (SPs), Scalar Functions, and Table-Valued Functions (TVFs)**. Each has strengths and trade-offs.

---

## 1. Stored Procedures (SPs)

SPs are precompiled routines that can perform multiple DML operations, control flow, and even return result sets.

### Example
```sql
CREATE PROCEDURE dbo.GetCustomerOrders
    @CustomerID INT
AS
BEGIN
    SELECT o.OrderID, o.OrderDate, SUM(oi.Quantity*oi.UnitPrice) AS TotalAmount
    FROM Sales.Orders AS o
    JOIN Sales.OrderItems AS oi ON o.OrderID = oi.OrderID
    WHERE o.CustomerID = @CustomerID
    GROUP BY o.OrderID, o.OrderDate;
END
```

### Features
- Can return multiple result sets.
- Can perform DML operations (INSERT, UPDATE, DELETE).
- Supports transactions and error handling.
- Parameters can have defaults.
- Cannot be used directly in a `SELECT` statement.

### When to use
- Complex ETL steps or batch processing.
- Multi-step operations with error handling.
- Encapsulating repeated business logic.

---

## 2. Scalar Functions

Return a single value. Can be inline (expression) or multi-statement.

### Inline scalar function example
```sql
CREATE FUNCTION dbo.GetFullName(@FirstName NVARCHAR(50), @LastName NVARCHAR(50))
RETURNS NVARCHAR(101)
AS
BEGIN
    RETURN @FirstName + ' ' + @LastName;
END
```

### Multi-statement scalar function
```sql
CREATE FUNCTION dbo.GetDiscount(@CustomerID INT)
RETURNS DECIMAL(5,2)
AS
BEGIN
    DECLARE @Discount DECIMAL(5,2);
    SELECT @Discount = CASE WHEN SUM(TotalAmount) > 1000 THEN 0.1 ELSE 0 END
    FROM Sales.Orders
    WHERE CustomerID = @CustomerID;
    RETURN @Discount;
END
```

### Caveats
- Can be used in `SELECT`, `WHERE`, `JOIN` clauses.
- Multi-statement functions can be performance killers on large datasets (row-by-row execution).

### When to use
- Small computations needed in queries.
- Deterministic calculations that are reused often.

---

## 3. Table-Valued Functions (TVFs)

Return a table. Can be **inline** (single `SELECT`) or **multi-statement** (declare table variable, populate, return).

### Inline TVF example
```sql
CREATE FUNCTION dbo.GetOrdersByCustomer(@CustomerID INT)
RETURNS TABLE
AS
RETURN (
    SELECT OrderID, OrderDate, TotalAmount
    FROM Sales.Orders
    WHERE CustomerID = @CustomerID
);
```

Usage:
```sql
SELECT * FROM dbo.GetOrdersByCustomer(123);
```

### Multi-statement TVF example
```sql
CREATE FUNCTION dbo.GetHighValueOrders(@MinAmount DECIMAL(10,2))
RETURNS @Orders TABLE (
    OrderID INT, OrderDate DATETIME, TotalAmount DECIMAL(10,2)
)
AS
BEGIN
    INSERT INTO @Orders
    SELECT OrderID, OrderDate, SUM(Quantity*UnitPrice)
    FROM Sales.OrderItems
    GROUP BY OrderID, OrderDate
    HAVING SUM(Quantity*UnitPrice) >= @MinAmount;
    RETURN;
END
```

### Caveats
- Inline TVFs generally perform well; multi-statement TVFs can be slow.
- Good for encapsulating reusable query logic.

### When to use
- Modular query logic returning sets.
- Filtering, joining, or wrapping complex SELECTs.
- Inline TVFs for performance-critical operations.

---

## Comparison Table

| Feature | Stored Procedure | Scalar Function | Table-Valued Function |
|---------|----------------|----------------|---------------------|
| Returns | Nothing or result set(s) | Single value | Table (rows) |
| Can perform DML | Yes | No | Limited in inline; Yes in multi-statement |
| Can be used in SELECT | No | Yes | Yes |
| Performance | High for batch work | Can be slow if multi-statement | Inline: fast, Multi-statement: slower |
| Transactions | Supported | Not recommended | Supported in multi-statement |
| When to use | ETL, batch jobs, procedural logic | Small reusable calculations | Encapsulate query logic, reusable datasets |

---

## Practical Data Engineering Patterns

1. **SP for ETL**: orchestrate staging → transform → load, with error handling.
2. **Scalar function**: compute discount, age, or flag within SELECT statements.
3. **Inline TVF**: reusable filter logic for multiple queries or joins.
4. **Multi-statement TVF**: more complex derived tables where procedural logic is needed.

Encapsulation helps maintainable pipelines and prevents repetitive SQL.

