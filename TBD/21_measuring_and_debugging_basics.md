# 21. Measuring & Debugging Basics

When building SQL Server queries and ETL pipelines, measuring performance and debugging are essential. This chapter covers the basics for data engineers.

---

## 1. Measuring query performance

### Execution time
```sql
SET STATISTICS TIME ON;
SELECT * FROM Sales.SalesOrderHeader;
SET STATISTICS TIME OFF;
```
- Shows CPU time and elapsed time.

### IO usage
```sql
SET STATISTICS IO ON;
SELECT * FROM Sales.SalesOrderHeader;
SET STATISTICS IO OFF;
```
- Displays logical reads, physical reads, and read-ahead reads.

### Actual Execution Plan
- Use **Ctrl+M** in SSMS or `Include Actual Execution Plan` to see operators, row estimates, and cost.
- Helps identify scans, seeks, expensive joins.

### Estimated Execution Plan
- Provides plan before execution; useful for quick checks without affecting data.

---

## 2. Debugging techniques

### PRINT statements
- Simple and useful in SPs, procedures, and scripts.
```sql
DECLARE @CustomerID INT = 123;
PRINT 'Processing CustomerID: ' + CAST(@CustomerID AS NVARCHAR(10));
```

### RAISERROR / THROW
- Report custom errors or stop execution.
```sql
IF @Balance < 0
    THROW 50001, 'Balance cannot be negative', 1;
```

### TRY...CATCH blocks
- Capture runtime errors and roll back transactions if needed.
```sql
BEGIN TRY
    BEGIN TRANSACTION;
    UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 1;
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH;
```

### Querying DMVs (Dynamic Management Views)
- Useful for performance insight.
```sql
-- Check currently running queries
SELECT * FROM sys.dm_exec_requests;

-- Query plan stats
SELECT * FROM sys.dm_exec_query_stats;
```

---

## 3. Common performance traps

1. **SELECT *** — fetches unnecessary columns.
2. **Non-SARGable predicates** — functions on columns prevent index usage.
3. **Implicit conversions** — mismatched types can force scans.
4. **Nested loops on large datasets** — can explode runtime.
5. **Missing indexes** — often the biggest culprit.

---

## 4. Profiling tools

- **SQL Server Profiler** — event-based tracing, deprecated in favor of Extended Events.
- **Extended Events** — lightweight, captures query activity and errors.
- **Query Store** — historical query plans and performance tracking.

---

## 5. Practical data engineering patterns

1. **Measure staging load performance**
```sql
SET STATISTICS TIME, IO ON;
INSERT INTO Fact.Sales SELECT * FROM Staging.Sales;
SET STATISTICS TIME, IO OFF;
```

2. **Debug ETL transformations**
```sql
SELECT TOP 10 * FROM #TempTransform;
PRINT 'Check completed rows: ' + CAST(@RowCount AS NVARCHAR(10));
```

3. **Catch and log errors in production SPs**
- Log messages to an audit table with timestamp, error message, and context.

Debugging and measuring form the backbone of reliable and performant ETL pipelines. Always test, monitor, and log.

