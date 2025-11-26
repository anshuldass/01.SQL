# 14. Aggregates, GROUP BY, HAVING, and Advanced Grouping

Aggregation is SQL’s way of zooming out. Instead of row-by-row detail, you compress data into meaningful summaries. GROUP BY is the lens that decides what gets grouped together, and HAVING is your quality-control gate.

---

## Aggregate functions — the usual crew

These eat many rows and return one value.
- `COUNT(*)` counts rows.
- `COUNT(column)` counts non-NULL values.
- `SUM(column)` adds numbers.
- `AVG(column)` computes averages.
- `MIN(column)` and `MAX(column)` find extremes.

Aggregates ignore NULLs unless you force them into the picture.

---

## GROUP BY — the bucket maker

GROUP BY partitions your input rows into categories. Each category produces one output row.

### Example: Total sales per customer
```sql
SELECT CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Sales.Orders
GROUP BY CustomerID;
```
Each `CustomerID` becomes a grouping bucket.

### Multi-column grouping
```sql
SELECT StoreID, ProductID, SUM(Quantity) AS UnitsSold
FROM Sales.OrderItems
GROUP BY StoreID, ProductID;
```
Now each pair (StoreID, ProductID) becomes its own bucket.

---

## HAVING — the bouncer at the group-level door

WHERE filters raw rows *before* grouping.
HAVING filters *after* grouping.

### Example: Customers who spent more than 10,000
```sql
SELECT CustomerID, SUM(TotalAmount) AS TotalSpent
FROM Sales.Orders
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 10000;
```
Without HAVING, you’d need nested queries.

---

## Subtle rules you eventually memorize

**1. Columns in SELECT must be either:**
- grouped, or
- aggregated.

**2. HAVING can reference aggregates**, WHERE cannot.

**3. GROUP BY happens before SELECT** in SQL’s logical execution order.

---

## GROUPING SETS — customizable grouping patterns

`GROUPING SETS` lets you specify multiple group-by configurations in a single query.

### Example: Sales summary by product, by store, and overall
```sql
SELECT StoreID, ProductID, SUM(Quantity) AS Qty
FROM Sales.OrderItems
GROUP BY GROUPING SETS (
    (StoreID, ProductID),
    (StoreID),
    ()   -- grand total
);
```
Producing:
- store/product level
- store-only level
- grand total

---

## ROLLUP — hierarchical grouping

`ROLLUP` walks down a hierarchy from detailed to coarse.

### Example: Year → Month totals
```sql
SELECT YEAR(OrderDate) AS Yr, MONTH(OrderDate) AS Mo, SUM(TotalAmount) AS Total
FROM Sales.Orders
GROUP BY ROLLUP (YEAR(OrderDate), MONTH(OrderDate));
```
Output includes:
- year/month
- year subtotal
- grand total

This is excellent for time-series summarization.

---

## CUBE — all combinations

`CUBE` produces every possible grouping combination among columns.

### Example
```sql
SELECT Region, Channel, SUM(Revenue) AS Total
FROM Finance.Sales
GROUP BY CUBE (Region, Channel);
```
You get:
- Region + Channel
- Region only
- Channel only
- Grand total

CUBE grows exponentially with number of columns — powerful but heavy.

---

## GROUPING() — detecting subtotal rows

`GROUPING(column)` returns 1 on aggregated (subtotal) rows and 0 on normal rows.

### Example
```sql
SELECT
    StoreID,
    ProductID,
    SUM(Quantity) AS Qty,
    GROUPING(StoreID) AS IsStoreSubtotal,
    GROUPING(ProductID) AS IsProductSubtotal
FROM Sales.OrderItems
GROUP BY ROLLUP (StoreID, ProductID);
```
Great for formatting subtotals in reports.

---

## Practical data engineering scenarios

### Quality checks during ingestion
```sql
SELECT OrderDate, COUNT(*) AS Cnt
FROM Staging.Orders
GROUP BY OrderDate
HAVING COUNT(*) = 0;
```
Spot missing partitions.

### Computing aggregates for fact tables
```sql
SELECT CustomerID, SUM(Amount) AS TotalSpent
FROM Raw.Payments
GROUP BY CustomerID;
```
Useful when building dimensions and facts.

### Rollups for reporting APIs
```sql
SELECT Region, MONTH(SaleDate) AS Mo, SUM(Revenue) AS R
FROM Analytics.Sales
GROUP BY ROLLUP (Region, MONTH(SaleDate));
```
One query gives granular and summarized data.

---

You now have the tools to bend groups and aggregates to your will. The next chapter dives into window functions, where the fun becomes delightfully mathematical.