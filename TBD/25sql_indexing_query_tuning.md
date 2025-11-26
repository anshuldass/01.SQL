---
# 25. Indexing & Physical Design, Query Tuning, and Advanced Patterns

**Objective:** Optimize your MS SQL databases for performance, understand physical storage considerations, and adopt best practices for querying large datasets.

---

## 25.1 Basics of Indexing

Indexes improve data retrieval performance but add write overhead. Think of them as a book’s table of contents.

- **Clustered Index:** Physically orders the table rows based on key values. Only one clustered index per table.
  - Example: Primary key is often a clustered index.
- **Non-Clustered Index:** A separate structure from the data that points to table rows. Multiple non-clustered indexes allowed.
- **Unique Index:** Ensures values in the indexed column(s) are unique.
- **Filtered Index:** Index only a subset of rows, improving performance for queries with specific conditions.
- **Covering Index:** Includes all columns a query needs, reducing table lookups.

**Example:**
```sql
-- Create a clustered index
CREATE CLUSTERED INDEX idx_CustomerID ON Sales.Customer(CustomerID);

-- Create a non-clustered index
CREATE NONCLUSTERED INDEX idx_CustomerLastName ON Sales.Customer(LastName);

-- Create a filtered index
CREATE NONCLUSTERED INDEX idx_ActiveCustomers ON Sales.Customer(LastName) WHERE IsActive = 1;
```

---

## 25.2 Physical Design Considerations

**Storage & Partitioning:**
- **Data Types:** Use smallest type sufficient (e.g., `INT` instead of `BIGINT`) to reduce storage.
- **Row vs Columnstore:** Columnstore indexes are better for analytical queries on large datasets.
- **Partitioning:** Split large tables into partitions based on range or list (e.g., by year or region) to improve query and maintenance performance.
- **Fill Factor:** Controls page fullness to reduce page splits for write-heavy tables.

**Example:**
```sql
-- Partitioned table by year
CREATE PARTITION FUNCTION pf_SalesYear(int) AS RANGE LEFT FOR VALUES (2018, 2019, 2020, 2021);
CREATE PARTITION SCHEME ps_SalesYear AS PARTITION pf_SalesYear TO (fg2018, fg2019, fg2020, fg2021, fg2022);
```

---

## 25.3 Query Tuning Fundamentals

**Execution Plans:**
- Use `SET STATISTICS IO ON` and `SET STATISTICS TIME ON` to analyze query performance.
- Review the **Actual Execution Plan** to identify bottlenecks (table scans, index scans, nested loops, hash joins).

**Common Tuning Techniques:**
- **Avoid SELECT *:** Only fetch needed columns.
- **Sargable Conditions:** Write WHERE clauses that allow index usage.
- **Joins:** Prefer inner joins with proper indexing.
- **Temp Tables vs CTEs:** Use wisely; temp tables can help if reused multiple times.

**Example:**
```sql
-- Check execution plan
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT FirstName, LastName FROM Sales.Customer WHERE LastName LIKE 'A%';
```

---

## 25.4 Advanced Indexing Patterns

- **Composite Indexes:** Index multiple columns; order matters.
- **Included Columns:** Add non-key columns to cover queries without affecting key order.
- **Index Hints:** Force index usage in specific scenarios (use sparingly).
- **Index Maintenance:** Rebuild or reorganize indexes regularly to avoid fragmentation.

**Example:**
```sql
-- Composite index with included columns
CREATE NONCLUSTERED INDEX idx_Orders_CustomerDate
ON Sales.SalesOrderHeader(CustomerID, OrderDate)
INCLUDE (TotalDue);

-- Rebuild fragmented index
ALTER INDEX idx_Orders_CustomerDate ON Sales.SalesOrderHeader REBUILD;
```

---

## 25.5 Query Patterns & Anti-Patterns

**Good Patterns:**
- **Set-based operations:** Use joins, set operations instead of cursors or loops.
- **Batch Updates:** For large tables, update in batches to reduce locks.
- **Parameterization:** Avoid dynamic SQL when possible to reuse execution plans.

**Anti-Patterns:**
- **Functions on Indexed Columns:** Can disable index usage.
- **SELECT * in joins:** Causes unnecessary data load.
- **Over-indexing:** Too many indexes slow inserts/updates.
- **Nested Cursors:** Expensive row-by-row operations.

**Example of Set-based vs Cursor:**
```sql
-- Set-based update
UPDATE Sales.SalesOrderHeader
SET TotalDue = TotalDue * 1.05
WHERE OrderDate < '2023-01-01';

-- Cursor (anti-pattern)
declare @OrderID int
DECLARE order_cursor CURSOR FOR SELECT SalesOrderID FROM Sales.SalesOrderHeader;
OPEN order_cursor
FETCH NEXT FROM order_cursor INTO @OrderID
WHILE @@FETCH_STATUS = 0
BEGIN
   -- row-by-row processing
   FETCH NEXT FROM order_cursor INTO @OrderID
END
CLOSE order_cursor
DEALLOCATE order_cursor
```

---

## 25.6 Monitoring and Best Practices

- **DMVs (Dynamic Management Views):** Monitor indexes and query performance.
  - `sys.dm_db_index_usage_stats`
  - `sys.dm_exec_query_stats`
  - `sys.dm_db_index_physical_stats`
- **Regular Maintenance:** Rebuild/reorganize indexes, update statistics.
- **Avoid Over-Fragmentation:** Check fragmentation > 30% for rebuild, 5-30% for reorganize.

**Example:**
```sql
-- Check index usage
SELECT * FROM sys.dm_db_index_usage_stats WHERE database_id = DB_ID('AdventureWorks2022');

-- Check fragmentation
SELECT index_id, avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(DB_ID('AdventureWorks2022'), OBJECT_ID('Sales.SalesOrderHeader'), NULL, NULL, 'LIMITED');
```

---

**Summary:**
- Indexing and physical design are foundational for performance.
- Query tuning relies on execution plans and set-based patterns.
- Advanced indexing strategies include composite, included, and filtered indexes.
- Monitor, maintain, and avoid anti-patterns for long-term efficiency.

---

