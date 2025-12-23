# Day 1 — Core SQL Patterns (LeetCode-Style)

**Rules of engagement**
- Target database: **SQL Server**
- Use ONLY the tables from the provided dataset
- Do **not** look up solutions
- Write queries that survive edge cases

---

## Question 1 — Second Highest Salary (Tie-aware)
Using the `Employees` table, return the **second highest distinct salary**.

Constraints:
- If there is no second highest salary, return `NULL`.
- Duplicate salaries must not create false ranks.

Expected columns:
- `SecondHighestSalary`

---

## Question 2 — Employees Earning More Than Their Manager
From the `Employees` table, list employees who earn **strictly more** than their manager.

Notes:
- Some employees have no manager.
- Managers are also employees.

Expected columns:
- `EmpName`

---

## Question 3 — Customers Who Never Ordered
Using `Customers` and `Orders`, find customers who **never placed an order**.

Constraints:
- Do not assume referential completeness.
- Avoid false positives caused by joins.

Expected columns:
- `CustomerName`

---

## Question 4 — Duplicate Numbers
Using the `Logs` table, find all numbers that appear **at least three times consecutively**.

Notes:
- Order is determined by the natural insertion order.
- Repeated values must be adjacent to count.

Expected columns:
- `ConsecutiveNums`

---

## Question 5 — High Attendance Periods
From the `Stadium` table, report all rows that belong to a period of **at least three consecutive days** where `People >= 100`.

Notes:
- All qualifying rows in the streak must be returned.
- Single-day spikes should be excluded.

Expected columns:
- `VisitDate`, `People`

---

### Discipline Reminder
If your solution:
- breaks when rows are duplicated
- fails when NULLs appear
- relies on ordering without stating it

then it is not correct yet.

Do not optimize. Do not be clever.
Make the logic undeniable.