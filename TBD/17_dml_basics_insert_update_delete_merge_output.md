# 17. DML Basics: INSERT, UPDATE, DELETE, MERGE, OUTPUT

Data Manipulation Language (DML) is the set of verbs that reshape the contents of your tables. SELECT is the quiet observer; DML is the sculptor.

---

## INSERT — adding new rows

### Direct insertion
```sql
INSERT INTO Production.ProductSubcategory (Name, ProductCategoryID)
VALUES ('Quantum Gadgets', 3);
```

### Insert-from-select
```sql
INSERT INTO Sales.SalesTerritoryHistory (BusinessEntityID, TerritoryID, StartDate)
SELECT e.BusinessEntityID, 1, GETDATE()
FROM HumanResources.Employee AS e
WHERE e.JobTitle LIKE '%Manager%';
```

### Multiple rows in one go
```sql
INSERT INTO Person.EmailAddress (BusinessEntityID, EmailAddress)
VALUES (1, 'a@b.com'), (2, 'c@d.com');
```

Useful for ETL when staging tables feed production tables.

---

## UPDATE — reshaping existing rows

```sql
UPDATE Production.Product
SET ListPrice = ListPrice * 1.05
WHERE ProductSubcategoryID = 15;
```

Updates can reference other tables:
```sql
UPDATE p
SET p.ListPrice = p.ListPrice + x.PriceIncrease
FROM Production.Product AS p
JOIN dbo.PriceUpdates AS x
    ON p.ProductID = x.ProductID;
```

---

## DELETE — removing rows (carefully)

```sql
DELETE FROM Sales.SalesOrderDetail
WHERE SalesOrderID = 43659;
```

DELETE with joins for data cleaning:
```sql
DELETE d
FROM dbo.Duplicates AS d
JOIN dbo.ToRemove AS r
  ON d.KeyCol = r.KeyCol;
```

---

## MERGE — conditional INSERT/UPDATE/DELETE

MERGE is like a Swiss Army knife. Handy for upserts but use carefully.

```sql
MERGE dbo.Customers AS tgt
USING dbo.CustomerUpdates AS src
    ON tgt.CustomerID = src.CustomerID
WHEN MATCHED THEN
    UPDATE SET tgt.Email = src.Email
WHEN NOT MATCHED BY TARGET THEN
    INSERT (CustomerID, Email)
    VALUES (src.CustomerID, src.Email)
WHEN NOT MATCHED BY SOURCE THEN
    DELETE;
```

Practical note: Older SQL Server builds had MERGE quirks, so many DE teams prefer explicit UPDATE/INSERT logic.

---

## OUTPUT — watching DML in action

Capture changes for auditing or staging:

### UPDATE with OUTPUT
```sql
UPDATE Production.Product
SET ListPrice = ListPrice * 1.10
OUTPUT deleted.ProductID AS OldID,
       deleted.ListPrice AS OldPrice,
       inserted.ListPrice AS NewPrice;
```

### INSERT with OUTPUT (capture surrogate keys)
```sql
DECLARE @NewProducts TABLE (ProductID INT, Name NVARCHAR(50));

INSERT INTO Production.Product (Name, ListPrice)
OUTPUT inserted.ProductID, inserted.Name
INTO @NewProducts
VALUES ('Antigrav Shoes', 199.99);
```

### DELETE with OUTPUT
```sql
DELETE FROM dbo.TempData
OUTPUT deleted.* INTO dbo.Archive_DeletedRows;
```

---

## Real-world DE workflow

During a nightly ETL load:
- Insert new dimension members via INSERT
- Update slowly changing attributes via UPDATE
- Clean expired rows via DELETE
- Use MERGE for Type 1/Type 2 hybrid management
- Use OUTPUT to populate audit trails or track lineage

DML forms the backbone of data engineering, refreshing marts, shaping dimensions, and enforcing business rules.