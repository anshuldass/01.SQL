-- ==========================================
-- SalesAnalytics: FK-safe large dataset population
-- Using persistent Numbers table and modulo FK assignment
-- ==========================================

USE SalesAnalytics;
GO

-- ==========================================
-- 1. Create Persistent Numbers Table
-- ==========================================
IF OBJECT_ID('dbo.Numbers', 'U') IS NOT NULL
    DROP TABLE dbo.Numbers;
GO

CREATE TABLE dbo.Numbers (
    n INT PRIMARY KEY
);
GO

-- Populate Numbers table: 2,000,000 rows (enough for all inserts)
INSERT INTO dbo.Numbers (n)
SELECT TOP (2000000) ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n
FROM (SELECT 1 AS X UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) a
CROSS JOIN (SELECT 1 AS X UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) b
CROSS JOIN (SELECT 1 AS X UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) c
CROSS JOIN (SELECT 1 AS X UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) d
CROSS JOIN (SELECT 1 AS X UNION ALL SELECT 1 UNION ALL SELECT 1 UNION ALL SELECT 1) e;
GO

-- ==========================================
-- 2. Populate Customers (100,000)
-- ==========================================
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address, City, State, Country)
SELECT
    CONCAT('First', n),
    CONCAT('Last', n),
    CONCAT('user', n, '@example.com'),
    CONCAT('9', RIGHT('0000000000' + CAST(n AS VARCHAR(10)), 10)),
    CONCAT('Address ', n),
    CASE WHEN n % 2 = 0 THEN 'CityA' ELSE 'CityB' END,
    CASE WHEN n % 3 = 0 THEN 'StateA' ELSE 'StateB' END,
    CASE WHEN n % 2 = 0 THEN 'CountryX' ELSE 'CountryY' END
FROM dbo.Numbers
WHERE n <= 100000;

-- ==========================================
-- 3. Populate Products (10,000)
-- ==========================================
INSERT INTO Products (ProductName, Category, SubCategory, Price, Cost, QuantityInStock)
SELECT
    CONCAT('Product', n),
    CASE WHEN n % 3 = 0 THEN 'Electronics' WHEN n % 3 = 1 THEN 'Clothing' ELSE 'Home' END,
    CASE WHEN n % 2 = 0 THEN 'SubA' ELSE 'SubB' END,
    CAST((RAND(CHECKSUM(NEWID()))*1000) AS DECIMAL(10,2)),
    CAST((RAND(CHECKSUM(NEWID()))*500) AS DECIMAL(10,2)),
    FLOOR(RAND(CHECKSUM(NEWID()))*1000)
FROM dbo.Numbers
WHERE n <= 10000;

-- ==========================================
-- 4. Populate Suppliers (1,000)
-- ==========================================
INSERT INTO Suppliers (SupplierName, ContactName, ContactEmail, Phone, City, Country)
SELECT
    CONCAT('Supplier', n),
    CONCAT('Contact', n),
    CONCAT('supplier', n, '@example.com'),
    CONCAT('9', RIGHT('0000000000' + CAST(n AS VARCHAR(10)), 10)),
    CASE WHEN n % 2 = 0 THEN 'CityA' ELSE 'CityB' END,
    CASE WHEN n % 2 = 0 THEN 'CountryX' ELSE 'CountryY' END
FROM dbo.Numbers
WHERE n <= 1000;

-- ==========================================
-- 5. Populate Employees (1,000)
-- ==========================================
INSERT INTO Employees (FirstName, LastName, JobTitle, ManagerID, HireDate, Salary, Department)
SELECT
    CONCAT('EmpFirst', n),
    CONCAT('EmpLast', n),
    CASE WHEN n % 5 = 0 THEN 'Manager' ELSE 'Staff' END,
    NULL, -- Assign managers later
    DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID()))*3650), GETDATE()),
    CAST(RAND(CHECKSUM(NEWID()))*100000 AS DECIMAL(10,2)),
    CASE WHEN n % 2 = 0 THEN 'Sales' ELSE 'Support' END
FROM dbo.Numbers
WHERE n <= 1000;

-- Assign random ManagerIDs to Staff
UPDATE Employees
SET ManagerID = (SELECT TOP 1 EmployeeID FROM Employees e2 ORDER BY NEWID())
WHERE JobTitle='Staff';

-- ==========================================
-- 6. Populate Orders (500,000)
-- ==========================================
INSERT INTO Orders (CustomerID, OrderDate, ShipDate, TotalAmount, Status)
SELECT
    ((n - 1) % 100000) + 1, -- FK-safe CustomerID 1 → 100,000
    DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID()))*1095), GETDATE()),
    DATEADD(DAY, FLOOR(RAND(CHECKSUM(NEWID()))*10), GETDATE()),
    CAST(RAND(CHECKSUM(NEWID()))*5000 AS DECIMAL(10,2)),
    CASE WHEN RAND(CHECKSUM(NEWID())) < 0.7 THEN 'Shipped'
         WHEN RAND(CHECKSUM(NEWID())) < 0.85 THEN 'Pending'
         ELSE 'Cancelled' END
FROM dbo.Numbers
WHERE n <= 500000;

-- ==========================================
-- 7. Populate OrderDetails (1,500,000)
-- ==========================================
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice, Discount)
SELECT
    ((n - 1) % 500000) + 1, -- FK-safe OrderID
    ((n - 1) % 10000) + 1,  -- FK-safe ProductID
    FLOOR(RAND(CHECKSUM(NEWID()))*10)+1,
    CAST(RAND(CHECKSUM(NEWID()))*1000 AS DECIMAL(10,2)),
    CAST(RAND(CHECKSUM(NEWID()))*0.3 AS DECIMAL(5,2))
FROM dbo.Numbers
WHERE n <= 1500000;

-- ==========================================
-- 8. Populate InventoryTransactions (1,000,000)
-- ==========================================
INSERT INTO InventoryTransactions (ProductID, TransactionType, Quantity, TransactionDate)
SELECT
    ((n - 1) % 10000) + 1,  -- FK-safe ProductID
    CASE WHEN n % 3 = 0 THEN 'Sale' WHEN n % 3 = 1 THEN 'Purchase' ELSE 'Return' END,
    FLOOR(RAND(CHECKSUM(NEWID()))*50)+1,
    DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID()))*1095), GETDATE())
FROM dbo.Numbers
WHERE n <= 1000000;

-- ==========================================
-- 9. Populate Reviews (300,000)
-- ==========================================
INSERT INTO Reviews (ProductID, CustomerID, Rating, Comment, ReviewDate)
SELECT
    ((n - 1) % 10000) + 1,    -- FK-safe ProductID
    ((n - 1) % 100000) + 1,   -- FK-safe CustomerID
    FLOOR(RAND(CHECKSUM(NEWID()))*5)+1,
    'Sample review text',
    DATEADD(DAY, -FLOOR(RAND(CHECKSUM(NEWID()))*1095), GETDATE())
FROM dbo.Numbers
WHERE n <= 300000;

PRINT 'SalesAnalytics database fully populated with FK-safe data!';
