-- =====================================================
-- LeetCode-Style SQL Practice Dataset
-- Target: SQL Server
-- Purpose: Covers ~90% of LeetCode SQL problem patterns
-- =====================================================

-- Drop existing tables if rerunning
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Employees;
DROP TABLE IF EXISTS Departments;
DROP TABLE IF EXISTS Logs;
DROP TABLE IF EXISTS Stadium;
DROP TABLE IF EXISTS Trips;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS MovieRatings;
DROP TABLE IF EXISTS Movies;

-- =====================
-- Employees / Departments
-- =====================
CREATE TABLE Departments (
    DeptId INT PRIMARY KEY,
    DeptName VARCHAR(50)
);

CREATE TABLE Employees (
    EmpId INT PRIMARY KEY,
    EmpName VARCHAR(50),
    Salary INT,
    DeptId INT NULL,
    ManagerId INT NULL
);

INSERT INTO Departments VALUES
(1, 'IT'), (2, 'HR'), (3, 'Sales');

INSERT INTO Employees VALUES
(1, 'Alice', 90000, 1, NULL),
(2, 'Bob', 80000, 1, 1),
(3, 'Charlie', 80000, 1, 1),
(4, 'David', 60000, 2, NULL),
(5, 'Eva', 70000, NULL, NULL),
(6, 'Frank', 90000, 3, NULL);

-- =====================
-- Customers / Orders / Products
-- =====================
CREATE TABLE Customers (
    CustomerId INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Products (
    ProductId INT PRIMARY KEY,
    ProductName VARCHAR(50),
    Price INT
);

CREATE TABLE Orders (
    OrderId INT PRIMARY KEY,
    CustomerId INT,
    ProductId INT,
    OrderDate DATE,
    Quantity INT
);

INSERT INTO Customers VALUES
(1, 'John'), (2, 'Jane'), (3, 'Alex');

INSERT INTO Products VALUES
(1, 'Laptop', 1000),
(2, 'Phone', 500),
(3, 'Tablet', 300);

INSERT INTO Orders VALUES
(1, 1, 1, '2024-01-01', 1),
(2, 1, 2, '2024-01-02', 2),
(3, 2, 2, '2024-01-03', 1),
(4, 2, 3, '2024-01-10', 3),
(5, 3, 1, '2024-01-11', 1);

-- =====================
-- Logs (gaps, duplicates)
-- =====================
CREATE TABLE Logs (
    LogId INT
);

INSERT INTO Logs VALUES
(1),(1),(2),(3),(3),(3),(5),(6);

-- =====================
-- Stadium (consecutive days)
-- =====================
CREATE TABLE Stadium (
    VisitDate DATE,
    People INT
);

INSERT INTO Stadium VALUES
('2024-01-01', 10),
('2024-01-02', 120),
('2024-01-03', 130),
('2024-01-04', 140),
('2024-01-05', 20);

-- =====================
-- Trips / Users (cancellations)
-- =====================
CREATE TABLE Users (
    UserId INT PRIMARY KEY,
    Banned VARCHAR(3)
);

CREATE TABLE Trips (
    TripId INT PRIMARY KEY,
    ClientId INT,
    DriverId INT,
    Status VARCHAR(20),
    RequestDate DATE
);

INSERT INTO Users VALUES
(1,'No'),(2,'Yes'),(3,'No'),(4,'No');

INSERT INTO Trips VALUES
(1,1,3,'completed','2024-01-01'),
(2,2,3,'cancelled_by_driver','2024-01-01'),
(3,1,4,'cancelled_by_client','2024-01-02'),
(4,3,4,'completed','2024-01-02');

-- =====================
-- Movies / Ratings
-- =====================
CREATE TABLE Movies (
    MovieId INT PRIMARY KEY,
    Title VARCHAR(50)
);

CREATE TABLE MovieRatings (
    MovieId INT,
    UserId INT,
    Rating INT
);

INSERT INTO Movies VALUES
(1,'Inception'),(2,'Interstellar'),(3,'Dunkirk');

INSERT INTO MovieRatings VALUES
(1,1,5),(1,2,4),(2,1,5),(2,3,5),(3,2,3);
