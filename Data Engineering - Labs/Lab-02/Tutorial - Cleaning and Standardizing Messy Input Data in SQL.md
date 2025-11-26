# **Tutorial: Cleaning and Standardizing Messy Input Data in SQL**

Messy or inconsistent data is one of the most common challenges in real-world data engineering. This tutorial demonstrates how to **clean and standardize data** in SQL using practical examples from the `SalesAnalytics` database.

---

## **1. Introduction**

**Messy data** can appear as:

- Inconsistent formatting (e.g., phone numbers, emails, addresses)
- Duplicates
- Nulls or missing values
- Wrong data types
- Extra whitespace or special characters

**Goal:** Transform messy data into a **consistent, clean, and usable format** for analysis or ETL pipelines.

---

## **2. Tools and SQL Functions for Cleaning**

SQL Server provides functions that help clean and standardize data:

| **Function** | **Purpose** |
|--------------|-------------|
| `LTRIM()` / `RTRIM()` | Remove leading/trailing spaces |
| `UPPER()` / `LOWER()` | Standardize text case |
| `REPLACE()` | Replace unwanted characters |
| `TRIM()` | SQL Server 2017+: remove spaces from both ends |
| `ISNULL()` / `COALESCE()` | Handle NULLs |
| `NULLIF()` | Convert invalid values to NULL |
| `CAST()` / `CONVERT()` | Correct data types |
| `TRY_CAST()` / `TRY_CONVERT()` | Safe type conversion |
| `PATINDEX()` / `LIKE` | Identify pattern mismatches |

---

## **3. Common Cleaning Tasks**

### **3.1 Removing Leading/Trailing Spaces**

```sql
UPDATE Customers
SET
    FirstName = LTRIM(RTRIM(FirstName)),
    LastName = LTRIM(RTRIM(LastName));
```

### **3.2 Standardizing Case**

```sql
-- Standardize email
UPDATE Customers
SET Email = LOWER(Email);

-- Capitalize first letter of FirstName and LastName
UPDATE Customers
SET
    FirstName = UPPER(LEFT(FirstName, 1)) + LOWER(SUBSTRING(FirstName, 2, LEN(FirstName))),
    LastName = UPPER(LEFT(LastName, 1)) + LOWER(SUBSTRING(LastName, 2, LEN(LastName)));
```

### **3.3 Removing Special Characters**

```sql
UPDATE Customers
SET Phone = REPLACE(REPLACE(REPLACE(Phone, '-', ''), '(', ''), ')', '');
```

### **3.4 Handling NULL or Missing Values**

```sql
-- Replace missing city with 'Unknown'
UPDATE Customers
SET City = ISNULL(City, 'Unknown');

-- Replace empty strings with NULL
UPDATE Customers
SET City = NULL
WHERE LTRIM(RTRIM(City)) = '';

-- Using NULLIF()
UPDATE Customers
SET City = NULLIF(LTRIM(RTRIM(City)), '');
```

### **3.5 Standardizing Dates**

```sql
-- Convert string dates to proper datetime
UPDATE Orders
SET OrderDate = TRY_CAST(OrderDate AS DATE)
WHERE TRY_CAST(OrderDate AS DATE) IS NOT NULL;

-- Identify invalid dates
SELECT *
FROM Orders
WHERE TRY_CAST(OrderDate AS DATE) IS NULL;
```

### **3.6 Removing Duplicates**

```sql
-- Find duplicate customers by email
SELECT Email, COUNT(*) AS cnt
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

-- Remove duplicates while keeping first record
WITH CTE AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY Email ORDER BY CustomerID) AS rn
    FROM Customers
)
DELETE FROM CTE
WHERE rn > 1;
```

### **3.7 Validating and Correcting Numeric Data**

```sql
-- Correct negative prices
UPDATE Products
SET Price = ABS(Price)
WHERE Price < 0;

-- Set QuantityInStock to 0 if NULL
UPDATE Products
SET QuantityInStock = ISNULL(QuantityInStock, 0);
```

### **3.8 Standardizing Categorical Data**

```sql
UPDATE Orders
SET Status = CASE
    WHEN UPPER(Status) LIKE 'SHIPP%' THEN 'Shipped'
    WHEN UPPER(Status) LIKE 'PEND%' THEN 'Pending'
    WHEN UPPER(Status) LIKE 'CANC%' THEN 'Cancelled'
    ELSE 'Unknown'
END;
```

### **3.9 Combining Multiple Cleaning Steps**

```sql
UPDATE Customers
SET
    FirstName = UPPER(LEFT(LTRIM(RTRIM(FirstName)),1)) + LOWER(SUBSTRING(LTRIM(RTRIM(FirstName)),2,LEN(FirstName))),
    LastName = UPPER(LEFT(LTRIM(RTRIM(LastName)),1)) + LOWER(SUBSTRING(LTRIM(RTRIM(LastName)),2,LEN(LastName))),
    Email = LOWER(LTRIM(RTRIM(Email))),
    Phone = REPLACE(REPLACE(REPLACE(LTRIM(RTRIM(Phone)),'-',''),'(',''),')',''),
    City = ISNULL(NULLIF(LTRIM(RTRIM(City)),'') , 'Unknown');
```

---

## **4. Checking Data Quality After Cleaning**

```sql
-- Check for remaining NULLs
SELECT COUNT(*) AS NullEmails
FROM Customers
WHERE Email IS NULL;

-- Check for duplicates
SELECT Email, COUNT(*) AS cnt
FROM Customers
GROUP BY Email
HAVING COUNT(*) > 1;

-- Validate ranges for numeric fields
SELECT MIN(Price), MAX(Price) FROM Products;
SELECT MIN(QuantityInStock), MAX(QuantityInStock) FROM Products;

-- Validate categorical values
SELECT DISTINCT Status FROM Orders;
```

---

## **5. Best Practices**

- **Always backup** your data before mass updates.
- **Test on a sample** before running full-scale updates.
- Use **CTEs** and **ROW_NUMBER()** to safely remove duplicates.
- **Document all cleaning steps** in scripts for reproducibility.
- Consider **creating views** with standardized data for ETL pipelines.

---

## **6. Practical Exercise**

1. Clean the `Reviews` table:
    - Standardize `Comment` text to remove extra spaces.
    - Ensure `Rating` is between 1 and 5.
    - Replace any missing `ReviewDate` with `GETDATE()`.

2. Standardize `InventoryTransactions`:
    - Ensure `TransactionType` contains only 'Sale', 'Purchase', 'Return'.
    - Remove negative `Quantity` values.

---

## **7. Summary**

- **Cleaning and standardization** ensures your data is **consistent, accurate, and reliable**.  
- Use SQL functions like `LTRIM`, `RTRIM`, `REPLACE`, `ISNULL`, `UPPER`, and `CASE` to clean data.  
- Always **validate results** after cleaning.  
- Cleaned data improves **ETL pipelines, analytics, and reporting**.

---

This tutorial sets the foundation for handling messy input data. In the next module, we can cover **data transformation and enrichment** for ETL pipelines.

