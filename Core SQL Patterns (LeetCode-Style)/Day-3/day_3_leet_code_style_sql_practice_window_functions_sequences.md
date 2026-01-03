# Day 3 — Window Functions, Sequences, and Temporal Logic

**Mental shift**
Up to Day 2, aggregation collapsed rows.
Day 3 keeps rows alive and overlays *context* on top of them.

This is where SQL stops being about tables and starts being about **relationships across time and order**.

Rules remain unchanged:
- SQL Server or Spark SQL (either is fine)
- Same dataset
- No solutions unless requested

---

## Question 1 — Rank Salaries Within Departments
For each employee, compute their **salary rank within their department**, ordered from highest to lowest salary.

Constraints:
- Employees without a department must be excluded.
- Equal salaries must share the same rank.
- Ranking must not skip numbers incorrectly.

Expected columns:
- `DeptName`, `EmpName`, `Salary`, `DeptSalaryRank`

---

## Question 2 — Running Total of Customer Spend
For each customer and each order date, compute the **running total spend** up to that date.

Rules:
- Spend = `Quantity * Price`
- Running total must be ordered by `OrderDate`
- Each row must show cumulative spend so far

Expected columns:
- `CustomerName`, `OrderDate`, `RunningTotalSpend`

---

## Question 3 — Consecutive Login Detection (Generalized)
Using the `Logs` table, identify all values that appear **at least three times consecutively**.

Constraints:
- Do NOT rely on self-joins with fixed offsets.
- The solution must generalize beyond exactly three rows.

Expected columns:
- `LogId`

---

## Question 4 — Gaps and Islands (High Attendance Streaks)
From the `Stadium` table, identify **all streaks** of consecutive days where `People >= 100`.

Rules:
- Each streak must be identified with a unique group identifier.
- Return only streaks of length >= 3.
- All rows in qualifying streaks must be returned.

Expected columns:
- `VisitDate`, `People`, `StreakId`

---

## Question 5 — Most Recent Movie Rating per User
For each user, return the **most recent movie they rated**.

Constraints:
- Assume higher `MovieId` implies more recent for this dataset.
- One row per user.
- Ties must be resolved deterministically.

Expected columns:
- `UserId`, `MovieId`

---

### Structural Warnings
If your solution:
- uses GROUP BY where a window function is required
- relies on undocumented ordering
- filters rows before ranking when logic demands ranking first

then the query is structurally incorrect.

Windows reveal truth.
Use them carefully.

