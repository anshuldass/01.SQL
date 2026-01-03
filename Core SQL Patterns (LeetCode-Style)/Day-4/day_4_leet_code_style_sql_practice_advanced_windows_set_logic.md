# Day 4 — Advanced Window Semantics, Set Logic, and Subtle Lies

**Shift in terrain**
Day 3 taught you to *see* context.
Day 4 tests whether you understand **when context must be constructed before filtering**.

These problems fail silently if clause order is wrong.
They succeed loudly only when the mental model is clean.

Rules:
- SQL Server or Spark SQL
- Same dataset
- No solutions unless explicitly requested

---

## Question 1 — Third Highest Salary (Department-Aware)
For each department, return the **third highest distinct salary**.

Constraints:
- If a department has fewer than three distinct salaries, exclude it.
- Employees without departments must be ignored.
- Duplicate salaries must not distort ranking.

Expected columns:
- `DeptName`, `ThirdHighestSalary`

---

## Question 2 — Customers With Increasing Spend Pattern
Identify customers whose **daily total spend is strictly increasing** over time.

Rules:
- Aggregate spend per customer per day first.
- Then evaluate the trend across days.
- Customers with only one purchase day must be excluded.

Expected columns:
- `CustomerName`

---

## Question 3 — Median Salary by Department
Compute the **median salary** for each department.

Constraints:
- Departments with no employees must be excluded.
- Median definition:
  - Odd count → middle value
  - Even count → average of two middle values

Expected columns:
- `DeptName`, `MedianSalary`

---

## Question 4 — Detect Broken Sequences
Using the `Logs` table, find all values that appear in **exactly one consecutive block** and never reappear later.

Notes:
- A value appearing in multiple disjoint streaks must be excluded.
- Consecutive duplicates count as one block.

Expected columns:
- `LogId`

---

## Question 5 — Top-Rated Movie per User (Window + Filter Discipline)
For each user, return the movie they rated **highest**.

Constraints:
- If multiple movies share the same highest rating, return the one with the **lowest MovieId**.
- Do NOT aggregate away rows before ranking.

Expected columns:
- `UserId`, `MovieId`

---

### Failure Signatures
If your query:
- filters rows before window ranking when ranking defines truth
- computes medians with naive averages
- uses GROUP BY where row order matters

then the logic is flawed even if results look correct.

Clause order is not syntax.
It is meaning.