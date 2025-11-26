# 19. Temporary Objects: Temp Tables and Table Variables

Temporary objects are essential tools in SQL Server for intermediate storage during ETL, reporting, or complex queries. They exist only for the duration of a session or batch.

---

## Types of temporary objects

1. **Local temporary tables (`#TempTable`)**
2. **Global temporary tables (`##TempTable`)**
3. **Table variables (`@TableVar`)**

### Local vs Global Temp Tables
| Feature | Local (`#`) | Global (`##`) |
|---------|------------|---------------|
| Scope | Current session | All sessions |
| Lifetime | Dropped when session ends | Dropped when last session using it ends |
| Visibility | Only current session | Visible to all sessions |

---

## Local Temporary Tables

Used for intermediate computations, batch processing, or storing large results temporarily.

```sql
CREATE TABLE #TempSales (
    ProductID INT,
    Quantity INT,
    TotalAmount DECIMAL(10,2)
);

INSERT INTO #TempSales
SELECT ProductID, SUM(Quantity), SUM(Quantity*UnitPrice)
FROM Sales.SalesOrderDetail
GROUP BY ProductID;

SELECT * FROM #TempSales;

DROP TABLE #TempSales;  -- optional, auto-dropped at session end
```

**Notes:**
- Can have indexes, constraints, and statistics.
- Useful for large datasets and intermediate transformations.

---

## Table Variables

Table variables are in-memory structures suitable for smaller datasets and procedural logic.

```sql
DECLARE @TempInventory TABLE (
    ItemID INT PRIMARY KEY,
    Stock INT,
    LastUpdate DATETIME
);

INSERT INTO @TempInventory (ItemID, Stock, LastUpdate)
SELECT ItemID, SUM(DeltaQty), MAX(TxnDate)
FROM Warehouse.InventoryMoves
GROUP BY ItemID;

SELECT * FROM @TempInventory;
```

**Notes:**
- Scope is limited to the batch, procedure, or function.
- Cannot be altered after declaration.
- Limited indexing options (primary key or unique constraints).
- Statistics may not be maintained, which can affect query plans for large datasets.

---

## Choosing between temp tables and table variables

| Aspect | Temp Table | Table Variable |
|--------|------------|----------------|
| Size of data | Large datasets | Small datasets |
| Indexes | Yes, multiple | Limited (PK/Unique) |
| Statistics | Maintained | Limited, may affect performance |
| Transaction support | Fully participates | Limited, generally not logged for rollbacks |
| Usage | Complex joins, ETL staging | Procedural logic, loops, lightweight tasks |

---

## Practical patterns in data engineering

1. **Staging for transformations**
```sql
SELECT * INTO #Staging FROM Raw.SalesData;
-- perform transformations
INSERT INTO Fact.Sales SELECT * FROM #Staging;
```

2. **Looping over sets with table variables**
```sql
DECLARE @Products TABLE (ProductID INT);
INSERT INTO @Products VALUES (101), (102), (103);

DECLARE @ProductID INT;
WHILE EXISTS(SELECT 1 FROM @Products)
BEGIN
    SELECT TOP 1 @ProductID = ProductID FROM @Products;
    -- process each product
    DELETE FROM @Products WHERE ProductID = @ProductID;
END
```

3. **Intermediate result caching for complex joins**
```sql
SELECT CustomerID, SUM(TotalAmount) AS TotalSpent
INTO #CustomerTotals
FROM Sales.SalesOrderHeader
GROUP BY CustomerID;

SELECT c.Name, ct.TotalSpent
FROM dbo.Customers AS c
JOIN #CustomerTotals AS ct ON c.CustomerID = ct.CustomerID;
```

---

## Best practices
1. Drop temp tables when done if not relying on automatic cleanup.
2. Use table variables for lightweight, procedural operations.
3. For large datasets, prefer temp tables to benefit from indexes and statistics.
4. Avoid excessive global temp tables; they can conflict across sessions.
5. Monitor tempdb usage; temp objects reside there and can impact performance.

Temporary objects are your in-session scratchpads. Use them wisely to simplify ETL logic, optimize transformations, and prevent clutter in production tables.

