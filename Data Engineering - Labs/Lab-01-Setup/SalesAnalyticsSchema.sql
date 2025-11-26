-- ==========================================
-- SalesAnalytics Database Table Creation
-- Platform: MS SQL Server
-- ==========================================

-- 1. Create Database
IF DB_ID('SalesAnalytics') IS NOT NULL
    DROP DATABASE SalesAnalytics;
GO

CREATE DATABASE SalesAnalytics;
GO

USE SalesAnalytics;
GO

-- ==========================================
-- 2. Create Tables
-- ==========================================

-- 2.1 Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    Email NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    City NVARCHAR(50),
    State NVARCHAR(50),
    Country NVARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 2.2 Products
CREATE TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100),
    Category NVARCHAR(50),
    SubCategory NVARCHAR(50),
    Price DECIMAL(10,2),
    Cost DECIMAL(10,2),
    QuantityInStock INT,
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 2.3 Suppliers
CREATE TABLE Suppliers (
    SupplierID INT IDENTITY(1,1) PRIMARY KEY,
    SupplierName NVARCHAR(100),
    ContactName NVARCHAR(50),
    ContactEmail NVARCHAR(100),
    Phone NVARCHAR(20),
    City NVARCHAR(50),
    Country NVARCHAR(50),
    CreatedDate DATETIME DEFAULT GETDATE()
);

-- 2.4 Employees
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    JobTitle NVARCHAR(50),
    ManagerID INT NULL,
    HireDate DATE,
    Salary DECIMAL(10,2),
    Department NVARCHAR(50),
    CONSTRAINT FK_Manager FOREIGN KEY (ManagerID) REFERENCES Employees(EmployeeID)
);

-- 2.5 Orders
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    ShipDate DATETIME,
    TotalAmount DECIMAL(10,2),
    Status NVARCHAR(20),
    CONSTRAINT FK_Orders_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 2.6 OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT IDENTITY(1,1) PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10,2),
    Discount DECIMAL(5,2),
    CONSTRAINT FK_OrderDetails_Order FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    CONSTRAINT FK_OrderDetails_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 2.7 InventoryTransactions
CREATE TABLE InventoryTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    TransactionType NVARCHAR(20),
    Quantity INT,
    TransactionDate DATETIME,
    CONSTRAINT FK_Inventory_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- 2.8 Reviews
CREATE TABLE Reviews (
    ReviewID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    CustomerID INT,
    Rating INT CHECK (Rating BETWEEN 1 AND 5),
    Comment NVARCHAR(500),
    ReviewDate DATETIME,
    CONSTRAINT FK_Reviews_Product FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    CONSTRAINT FK_Reviews_Customer FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

PRINT 'SalesAnalytics tables created successfully!';
