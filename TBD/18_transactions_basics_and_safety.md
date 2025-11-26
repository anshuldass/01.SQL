# 18. Transactions — Basics and Safety

Transactions are the atomic units of change in SQL Server. They ensure that multiple operations succeed or fail together, maintaining data integrity and consistency.

---

## What is a transaction?

A transaction is a sequence of one or more DML operations treated as a single unit:
- **COMMIT** → all changes are saved permanently
- **ROLLBACK** → all changes are undone if something goes wrong

### Simple transaction
```sql
BEGIN TRANSACTION;

UPDATE Accounts
SET Balance = Balance - 100
WHERE AccountID = 1;

UPDATE Accounts
SET Balance = Balance + 100
WHERE AccountID = 2;

COMMIT TRANSACTION;
```

If any step fails, you can ROLLBACK to avoid partial updates.

---

## Transaction control statements

- `BEGIN TRANSACTION` – start a new transaction
- `COMMIT TRANSACTION` – save all changes
- `ROLLBACK TRANSACTION` – undo all changes
- `SAVE TRANSACTION name` – set a savepoint to roll back to a partial point

### Example with SAVEPOINT
```sql
BEGIN TRANSACTION;

UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 1;
SAVE TRANSACTION deductStep;

UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID = 2;

-- Something goes wrong
ROLLBACK TRANSACTION deductStep;  -- undoes only the first update

COMMIT TRANSACTION;
```

---

## ACID properties

Transactions guarantee ACID:
1. **Atomicity** — all or nothing
2. **Consistency** — database moves from one valid state to another
3. **Isolation** — concurrent transactions don’t interfere (read phenomena controlled by isolation level)
4. **Durability** — once committed, changes persist even after crash

---

## Isolation levels — controlling concurrency

SQL Server supports:
- **READ UNCOMMITTED** — dirty reads allowed
- **READ COMMITTED** (default) — no dirty reads
- **REPEATABLE READ** — locks prevent others from changing data read during the transaction
- **SERIALIZABLE** — full range locks to prevent phantom reads
- **SNAPSHOT** — reads a consistent version without blocking writers

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
BEGIN TRANSACTION;
-- your operations
COMMIT;
```

Choose wisely: higher isolation increases safety but can reduce concurrency.

---

## Error handling with transactions

Use `TRY...CATCH` for robust ETL and production pipelines.

```sql
BEGIN TRY
    BEGIN TRANSACTION;

    UPDATE Accounts SET Balance = Balance - 100 WHERE AccountID = 1;
    UPDATE Accounts SET Balance = Balance + 100 WHERE AccountID = 2;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    PRINT ERROR_MESSAGE();
END CATCH;
```

This ensures your ETL or batch job does not leave the database in a half-baked state.

---

## Best practices for data engineering

1. Keep transactions as short as possible to reduce locking.
2. Avoid user interaction inside transactions.
3. Use proper isolation levels for your workload.
4. Always handle errors and roll back on failure.
5. Prefer explicit transactions in ETL pipelines for predictable data states.

Transactions are your safety net. When used correctly, they preserve data integrity while your pipelines do heavy lifting.