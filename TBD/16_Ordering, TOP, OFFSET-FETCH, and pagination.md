# ## 16. Ordering, TOP, OFFSET‑FETCH, and Pagination

### Why ordering matters

SQL doesn’t promise any natural order. Rows are quantum gremlins: they appear in whichever sequence the engine finds convenient. If you want deterministic order, you *must* ask for it explicitly with `ORDER BY`.

When stepping into pagination, ranking, or reproducible ETL, ordering becomes your compass.

### ORDER BY — the stable anchor

You can order by columns, expressions, aliases, or even window functions. AdventureWorks often demonstrates ordering by names, dates, or amounts.

```sql
SELECT p.ProductID, p.Name, p.ListPrice
FROM Production.Product AS p
ORDER BY p.ListPrice DESC, p.ProductID;
```

This ensures a consistent experience every time the query runs.

### TOP — the old-school bouncer

`TOP` limits the number of rows. It’s evaluated *after* the logical processing phase but *before* returning results.

```sql
SELECT TOP (10) 
       SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;
```

Works well for quick samples, dashboards, or checking the highest-priced orders.

You can parameterize it:

```sql
DECLARE @n INT = 5;
SELECT TOP (@n) * FROM Person.Person ORDER BY BusinessEntityID;
```

### WITH TIES — when duplicates crash the party

If two or more rows tie on the last sorted value, SQL can bring them all in.

```sql
SELECT TOP (3) WITH TIES Name, ListPrice
FROM Production.Product
ORDER BY ListPrice DESC;
```

If the 3rd and 4th most expensive products have the same price, both appear. Fair play.

### OFFSET‑FETCH — the modern pagination tool

Introduced in SQL Server 2012. Works only with `ORDER BY`.

It’s the SQL Server equivalent of page numbers.

```sql
SELECT SalesOrderID, OrderDate, TotalDue
FROM Sales.SalesOrderHeader
ORDER BY SalesOrderID
OFFSET 50 ROWS
FETCH NEXT 25 ROWS ONLY;  -- page of 25
```

OFFSET = how many to skip.  
FETCH NEXT = how many to read.

### Common pagination pattern (AdventureWorks)

```sql
DECLARE @Page INT = 3, @PageSize INT = 20;

SELECT ProductID, Name, ListPrice
FROM Production.Product
ORDER BY ProductID
OFFSET (@Page - 1) * @PageSize ROWS
FETCH NEXT @PageSize ROWS ONLY;
```

Useful for APIs, dashboards, and browsing-style apps.

### OFFSET vs TOP — philosophical musings

TOP is simple, fast, blunt. Think: “show me the first N rows.”  
OFFSET‑FETCH is precise and civilized: “show me page 13, items 241–260.”

Internally, OFFSET can be less efficient for deep pages because SQL has to walk past all skipped rows. That’s why heavy pagination often uses *seekable keys* and *keyset pagination* (a trick using `WHERE ProductID > @LastSeenId`).

### SARGability and pagination

When pairing pagination with filters, ensure the `ORDER BY` fits an index.  
Otherwise SQL does a sad little shuffle.

Example of an efficient pattern:

```sql
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '2020-01-01'
ORDER BY OrderDate, SalesOrderID
OFFSET 0 ROWS FETCH NEXT 50 ROWS ONLY;
```

The composite index `(OrderDate, SalesOrderID)` makes this fly.

### Pagination pitfalls

1. No ORDER BY → nondeterministic pages, shifting row sets.
2. ORDER BY non-unique column → ties give unstable pages.
3. Deep OFFSET → performance degradation.

### Real-world DE scenario

Power BI or a web app needs product catalog pagination.  
Your upstream API limits calls and requires deterministic slices.
You implement stable ordering using the primary key, and the ETL populates a delta table by fetching pages with OFFSET‑FETCH until the result set becomes empty. This guarantees you don’t miss or duplicate rows.

Another scenario: generating windowed extracts from fact tables for parallel processing.
Each worker grabs a chunk using OFFSET‑FETCH with guaranteed order.

This keeps the engine calm and the pipeline orderly.
