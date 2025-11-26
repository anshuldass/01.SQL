# 13. Set Operations: UNION, INTERSECT, EXCEPT

Set operations let tables behave like mathematical sets. Instead of joining rows horizontally, you stack or compare them vertically. SQL Server’s three big ones — `UNION`, `INTERSECT`, and `EXCEPT` — all operate on result sets that must be shape‑compatible: same number of columns, in the same order, with implicitly convertible types.

---

## UNION and UNION ALL

`UNION` combines rows from two queries.
- `UNION ALL` keeps duplicates.
- `UNION` removes duplicates (and sorts internally), which is slower.

### Example: Customers across regions
```sql
SELECT CustomerID, Email
FROM Sales.Customers_US
UNION
SELECT CustomerID, Email
FROM Sales.Customers_EU;
```
This gives distinct rows across both datasets.

### When you *want* duplicates
```sql
SELECT ProductID FROM dbo.Sales_2023
UNION ALL
SELECT ProductID FROM dbo.Sales_2024;
```
Great for stacking yearly partitions during ingestion.

---

## INTERSECT

`INTERSECT` gives rows that appear in *both* result sets.

### Example: Users active in both years
```sql
SELECT UserID
FROM Engagement.Activity_2023
INTERSECT
SELECT UserID
FROM Engagement.Activity_2024;
```
This becomes very handy when you’re identifying stable cohorts.

---

## EXCEPT

`EXCEPT` returns rows from the first query that *do not* appear in the second.

### Example: Users who churned
```sql
SELECT UserID
FROM Engagement.Activity_2023
EXCEPT
SELECT UserID
FROM Engagement.Activity_2024;
```
The output is your lost users.

### Reverse the order, reverse the meaning
```sql
-- Users newly active in 2024
SELECT UserID FROM Engagement.Activity_2024
EXCEPT
SELECT UserID FROM Engagement.Activity_2023;
```

---

## Notes that matter for performance and correctness

**Ordering:** Set operations apply after the individual SELECTs. To order the final output:
```sql
SELECT ...
UNION
SELECT ...
ORDER BY 1;
```
Don’t sneak an `ORDER BY` into each SELECT unless you’re also using `TOP`.

**Duplicates:** `UNION` and `INTERSECT` both perform deduplication. In large data engineering workloads, this can spill to tempdb.

**Column names:** The column names come from the first SELECT.

**NULL equality:** For the purpose of these operations, SQL treats `NULL = NULL` as true.

---

## Practical data engineering scenarios

**De‑duplicating incremental loads**
```sql
SELECT * FROM staging.NewBatch
EXCEPT
SELECT * FROM warehouse.FactSales;
```
Useful when the upstream system sometimes redelivers old rows.

**Comparing schema migrations**
```sql
SELECT ColumnName FROM SysA.Columns
EXCEPT
SELECT ColumnName FROM SysB.Columns;
```
Finds columns that differ between environments.

**Cross-region reconciliation**
```sql
SELECT OrderID FROM Orders.RegionA
INTERSECT
SELECT OrderID FROM Orders.RegionB;
```
Checks whether replicated systems agree.

---

These operations are deceptively simple but incredibly powerful when cleaning, reconciling, or validating data flows. The next chapter will move toward window functions — the Swiss army knife of analytical SQL.

