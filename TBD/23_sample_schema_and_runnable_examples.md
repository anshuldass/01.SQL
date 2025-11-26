# 23. Sample Schema + Runnable Examples

This chapter provides a lightweight, fully runnable sample schema with data to practice T-SQL concepts, joins, window functions, DML, and ETL-style transformations.

---

## 1. Create sample schema
```sql
-- Create schema
CREATE SCHEMA Sandbox;
GO

-- Customers table
CREATE TABLE Sandbox.Customers (
    CustomerID INT IDENTITY PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(100),
    CreatedAt DATETIME2 DEFAULT SYSUTCDATETIME()
);

-- Products table
CREATE TABLE Sandbox.Products (
    ProductID INT IDENTITY PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(10,2) NOT NULL
);

-- Orders table
CREATE TABLE Sandbox.Orders (
    OrderID INT IDENTITY PRIMARY KEY,
    CustomerID INT NOT NULL,
    OrderDate DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
    FOREIGN KEY (CustomerID) REFERENCES Sandbox.Customers(CustomerID)
);

-- OrderItems table
CREATE TABLE Sandbox.OrderItems (
    OrderItemID INT IDENTITY PRIMARY KEY,
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES Sandbox.Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Sandbox.Products(ProductID)
);
```

---

## 2. Insert sample data
```sql
-- Customers
INSERT INTO Sandbox.Customers (FirstName, LastName, Email)
VALUES
('Alice','Smith','alice@example.com'),
('Bob','Johnson','bob@example.com'),
('Charlie','Lee','charlie@example.com');

-- Products
INSERT INTO Sandbox.Products (Name, Price)
VALUES
('Laptop', 1200.00),
('Mouse', 25.50),
('Keyboard', 45.00);

-- Orders
INSERT INTO Sandbox.Orders (CustomerID, OrderDate)
VALUES
(1, '2025-01-01'),
(1, '2025-01-15'),
(2, '2025-02-05');

-- OrderItems
INSERT INTO Sandbox.OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES
(1, 1, 1, 1200.00),
(1, 2, 2, 25.50),
(2, 3, 1, 45.00),
(3, 2, 1, 25.50);
```

---

## 3. Runnable query examples

### Simple SELECT
```sql
SELECT CustomerID, FirstName, LastName FROM Sandbox.Customers;
```

### JOIN example
```sql
SELECT c.FirstName, c.LastName, o.OrderID, SUM(oi.Quantity * oi.UnitPrice) AS TotalAmount
FROM Sandbox.Customers AS c
JOIN Sandbox.Orders AS o ON c.CustomerID = o.CustomerID
JOIN Sandbox.OrderItems AS oi ON o.OrderID = oi.OrderID
GROUP BY c.FirstName, c.LastName, o.OrderID;
```

### Window function example
```sql
SELECT OrderID, CustomerID, OrderDate,
       SUM(Quantity * UnitPrice) OVER (PARTITION BY CustomerID ORDER BY OrderDate) AS RunningTotal
FROM Sandbox.Orders AS o
JOIN Sandbox.OrderItems AS oi ON o.OrderID = oi.OrderID;
```

### DML example
```sql
-- Update
UPDATE Sandbox.Products SET Price = Price * 1.10;

-- Delete
DELETE FROM Sandbox.OrderItems WHERE Quantity = 1;
```

### CTE example
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

---

This schema provides a full playground to practice joins, aggregates, window functions, DML, CTEs, temp objects, and more in a controlled, runnable environment.

