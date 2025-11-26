# 25. Indexing & Physical Design, Query Tuning, and Advanced Patterns

> **Objective:** Optimize your MS SQL databases for performance, understand physical storage considerations, and adopt best practices for querying large datasets.

---

## 25.1 Basics of Indexing

**Indexes** improve data retrieval performance but add write overhead. Think of them as a book’s table of contents.

- **Clustered Index:** physically orders the table rows; one per table. Typically on the PK.
- **Non-Clustered Index:** separate structure storing key values and row locators; multiple per table.
- **Covering Index:** includes all columns needed for a query to avoid lookups.

**Example:**
```sql
CREATE CLUSTERED INDEX IX_Orders_OrderDate ON dbo.Orders(OrderDate);
CREATE NONCLUSTERED INDEX IX_OrderItems_ProductID ON dbo.OrderItems(ProductID);
```

**Best practices:**
- Clustered index on narrow, unique, and immutable columns.
- Use included columns for non-clustered indexes to cover queries.
- Avoid over-indexing — write-heavy tables suffer.

---

## 25.2 Indexing Strategies for Data Engineering

- **Fact tables (large):** Clustered index on natural key or surrogate key; non-clustered indexes on foreign keys frequently used in joins.
- **Dimension tables:** Clustered index on PK, non-clustered on columns used for filters.
- **Partitioning:** For very large tables, split data logically to improve maintenance and query performance.

**Example of including columns:**
```sql
CREATE NONCLUSTERED INDEX IX_Orders_CustomerDate
ON dbo.Orders(CustomerID, OrderDate)
INCLUDE (TotalDue);
```

---

## 25.3 Physical Design Considerations

- **Fill factor:** Controls how full pages are; lower fill factor reduces page splits for write-heavy tables.
- **Data types:** Narrower types = smaller indexes = better cache efficiency.
- **Partitioning and filegroups:** Helps manage large tables and backups.
- **Compression:** Row or page compression reduces I/O but can increase CPU usage.

---

## 25.4 Query Tuning Basics

**Steps to tune a query:**
1. Identify slow queries (use `sys.dm_exec_query_stats` or Query Store).
2. Examine execution plan.
3. Check for scans vs seeks.
4. Consider rewriting queries to be set-based.
5. Check statistics freshness (`UPDATE STATISTICS`).

**Example:** Using `SET STATISTICS IO, TIME ON` to diagnose a query
```sql
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
SELECT * FROM dbo.OrderItems WHERE ProductID = 42;
SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
```

---

## 25.5 Common Query Tuning Patterns

- **Avoid SELECT *:** project only required columns.
- **SARGable predicates:** avoid functions on indexed columns.
- **JOIN order matters in complex queries:** optimizer usually handles this, but understanding logic helps.
- **Temporary tables vs CTEs:** CTEs are inline and often better for readability, temp tables allow indexing and statistics.

**Example using temp table for optimization:**
```sql
SELECT CustomerID, SUM(TotalDue) AS TotalDue
INTO #CustomerTotals
FROM dbo.Orders
GROUP BY CustomerID;

CREATE INDEX IX_CustomerTotals_TotalDue ON #CustomerTotals(TotalDue);
SELECT * FROM #CustomerTotals WHERE TotalDue > 1000;
```

---

## 25.6 Advanced T-SQL Patterns

- **Top-N per group using ROW_NUMBER()**
- **Running totals / moving averages with window functions**
- **Pivot / Unpivot for analytical transformations**
- **Dynamic SQL for flexible queries**

**Top-3 orders per customer example:**
```sql
SELECT CustomerID, OrderID, OrderDate
FROM (
  SELECT o.CustomerID, o.OrderID, o.OrderDate,
         ROW_NUMBER() OVER (PARTITION BY o.CustomerID ORDER BY o.OrderDate DESC) AS rn
  FROM dbo.Orders o
) t
WHERE rn <= 3;
```

**Pivot example:**
```sql
SELECT * FROM (
  SELECT ProductID, OrderMonth, Quantity
  FROM dbo.SalesSummary
) src
PIVOT (
  SUM(Quantity) FOR OrderMonth IN ([Jan],[Feb],[Mar])
) pvt;
```

---

## 25.7 Monitoring & Maintaining Performance

- **Execution plans:** actual vs estimated.
- **Index usage DMVs:** `sys.dm_db_index_usage_stats`.
- **Statistics:** `sys.stats` and `UPDATE STATISTICS`.
- **Query Store:** analyze query performance over time.
- **Deadlocks:** monitor with extended events.

---

## 25.8 Key Takeaways

- Proper indexing and physical design are essential for large datasets.
- Set-based thinking + SARGable predicates = most important for performance.
- Always measure, test, and verify improvements.
- Temporary tables, APPLY, and window functions are your friends for complex analytics.

---

*This section prepares you to write fast, scalable queries and design schemas optimized for data engineering workloads.*

