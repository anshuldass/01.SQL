# 22. Common Pitfalls & Best Practices (Checklist)

This chapter summarizes practical do's and don'ts for writing clean, efficient, and maintainable T-SQL, particularly relevant for data engineering pipelines.

---

## ✅ Do:

1. **Use `schema.table`**
```sql
SELECT * FROM dbo.Customers;
```
- Prevents ambiguity, ensures proper plan caching, avoids runtime errors.

2. **Select explicit columns**
```sql
SELECT CustomerID, Name, Email FROM dbo.Customers;
```
- Reduces I/O, improves readability, avoids breaking dependent objects when schema changes.

3. **Keep transactions short**
```sql
BEGIN TRANSACTION;
-- minimal work
COMMIT;
```
- Minimizes locking and blocking, avoids long-running conflicts.

4. **Use set-based operations, not cursors**
```sql
UPDATE p
SET ListPrice = ListPrice * 1.05
FROM Production.Product p
JOIN dbo.PriceUpdates u ON p.ProductID = u.ProductID;
```
- Set-based operations are faster, scalable, and easier to maintain.

5. **Source-control DDL/DML**
- Version your scripts (tables, procedures, ETL jobs) to track changes, rollback, and collaborate safely.

---

## ❌ Avoid:

1. **`SELECT *` in production**
- Pulls unnecessary data, increases memory/IO pressure, breaks dependent code on schema changes.

2. **Functions on indexed columns (non-SARGable)**
```sql
-- Avoid
WHERE YEAR(OrderDate) = 2024
-- Use
WHERE OrderDate >= '2024-01-01' AND OrderDate < '2025-01-01'
```
- Prevents index usage, forces scans.

3. **`NOT IN` with nullable subqueries**
```sql
-- Problematic
WHERE CustomerID NOT IN (SELECT CustomerID FROM dbo.Blacklist)
```
- Use `NOT EXISTS` to avoid unexpected NULL behavior.

4. **Blindly following missing-index DMVs**
- Missing-index suggestions may not consider your workload or may create redundant indexes. Analyze carefully before applying.

---

## Practical checklist for Data Engineering pipelines

- [ ] Explicitly name schemas and tables in all queries.
- [ ] Avoid `SELECT *`; list only required columns.
- [ ] Keep ETL transactions short; commit often for large batches.
- [ ] Prefer set-based transformations over row-by-row loops.
- [ ] Validate index suggestions against workload, not blindly.
- [ ] Use TRY...CATCH, logging, and monitoring for safe pipelines.
- [ ] Source-control all SQL objects and ETL scripts.
- [ ] Profile performance periodically using `SET STATISTICS`, execution plans, and DMVs.

Following these do's and don'ts ensures your SQL Server code is maintainable, efficient, and safe for production ETL pipelines.

