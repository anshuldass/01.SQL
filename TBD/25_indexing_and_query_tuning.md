# 25. Indexing & Physical Design, Query Tuning, and Advanced Patterns

Indexing, query optimization, and physical design are critical for data engineering pipelines that handle large volumes of data. This chapter covers fundamental strategies, common pitfalls, and advanced patterns.

---

## 1. Indexing Fundamentals

### Types of indexes
- **Clustered index**: Defines the physical order of data in a table; one per table.
- **Non-clustered index**: Separate structure that points to rows; multiple per table.
- **Unique index**: Guarantees uniqueness.
- **Filtered index**: Indexes only a subset of rows.
- **Columnstore index**: Optimized for analytical queries on large tables.
- **Full-text index**: Specialized for text search.

### Guidelines
- Index columns used in WHERE, JOIN, ORDER BY, and GROUP BY.
- Avoid over-indexing; each index adds write overhead.
- Use narrow indexes (include only necessary columns) to reduce size.

### Example
```sql
-- Clustered PK
CREATE CLUSTERED INDEX IX_Customers_PK ON Sandbox.Customers(CustomerID);

-- Non-clustered index on email
CREATE NONCLUSTERED INDEX IX_Customers_Email ON Sandbox.Customers(Email);

-- Filtered index for active orders
CREATE NONCLUSTERED INDEX IX_Orders_Recent ON Sandbox.Orders(OrderDate)
WHERE OrderDate >= '2025-01-01';
```

---

## 2. Measuring and Analyzing Queries

- **Execution plans**: Check for scans vs seeks.
- **SET STATISTICS TIME, IO**: Evaluate CPU and logical reads.
- **Query Store / Extended Events**: Track plan regressions.

Example:
```sql
SET STATISTICS IO, TIME ON;
SELECT * FROM Sandbox.Orders WHERE OrderDate >= '2025-01-01';
SET STATISTICS IO, TIME OFF;
```

---

## 3. Query Tuning Patterns

### SARGable predicates
```sql
-- Non-SARGable
WHERE YEAR(OrderDate) = 2025
-- SARGable
WHERE OrderDate >= '2025-01-01' AND OrderDate < '2026-01-01'
```

### Covering indexes
- Include columns used in SELECT to avoid key lookups.
```sql
CREATE NONCLUSTERED INDEX IX_OrderItems_Covering
ON Sandbox.OrderItems(OrderID)
INCLUDE (Quantity, UnitPrice);
```

### Minimize nested loops on large sets
- Use hash or merge joins where appropriate.
- Ensure statistics are up-to-date.

### Batch processing
- Process large tables in batches to avoid blocking and log growth.
```sql
WHILE EXISTS (SELECT 1 FROM Sandbox.Orders WHERE Processed = 0)
BEGIN
    DELETE TOP (1000) FROM Sandbox.Orders WHERE Processed = 0;
END
```

---

## 4. Advanced Patterns

### 1. Partitioning large tables
- Use partitioned tables for high-volume fact tables.
- Switch partitions in/out for efficient ETL.
```sql
CREATE PARTITION FUNCTION pf_OrderDate(datetime2)
AS RANGE LEFT FOR VALUES ('2025-01-01','2025-02-01');
```

### 2. Columnstore indexes for analytics
- Ideal for read-heavy, aggregate-heavy queries.
```sql
CREATE CLUSTERED COLUMNSTORE INDEX CCI_OrderItems ON Sandbox.OrderItems;
```

### 3. Indexed views
- Pre-aggregated computations can improve performance.
```sql
CREATE VIEW dbo.v_TotalSales
WITH SCHEMABINDING AS
SELECT CustomerID, SUM(Quantity*UnitPrice) AS TotalSpent
FROM Sandbox.OrderItems
GROUP BY CustomerID;
CREATE UNIQUE CLUSTERED INDEX IX_v_TotalSales ON dbo.v_TotalSales(CustomerID);
```

### 4. Query Hints (use sparingly)
- `OPTION (RECOMPILE)`, `FORCESEEK`, etc., for specific tuning scenarios.

### 5. Monitoring & Continuous Tuning
- Use Query Store to monitor plan changes.
- Check index usage DMVs: `sys.dm_db_index_usage_stats`.
- Regularly update statistics: `UPDATE STATISTICS dbo.Orders`.

---

## 5. Practical DE Scenarios

1. **Fact table aggregation:** Use columnstore indexes + batch ETL.
2. **Slow join performance:** Ensure indexed FK columns; consider filtered indexes.
3. **ETL staging table:** Drop indexes during bulk load, recreate after.
4. **Reporting:** Indexed views for frequently accessed aggregates.

Indexing and query tuning are iterative. Measure, analyze, adjust, and monitor continuously to ensure scalable and perfor