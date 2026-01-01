# Day 2 — Aggregation & Anti-Join Traps

**Context shift**
Day 1 punished sloppy joins and ranking shortcuts.
Day 2 punishes incorrect *counting*, silent row multiplication, and false assumptions about completeness.

Same rules apply:
- SQL Server only
- Use only the provided dataset
- No solutions unless explicitly requested

---

## Question 1 — Department Highest Salary
For each department, find the employee(s) who earn the **highest salary**.

Constraints:
- Multiple employees may share the same highest salary.
- Employees without a department must be excluded.

Expected columns:
- `DeptName`, `EmpName`, `Salary`

---

## Question 2 — Top Customer by Total Spend
Using `Customers`, `Orders`, and `Products`, find the customer who has spent the **most money in total**.

Notes:
- Total spend = `Quantity * Price`
- Customers with no orders should not appear.
- Ties must be handled correctly.

Expected columns:
- `CustomerName`, `TotalSpend`

---

## Question 3 — Customers Who Bought All Products
Find customers who have purchased **every product** listed in the `Products` table.

Constraints:
- Quantity does not matter.
- Missing one product disqualifies the customer.

Expected columns:
- `CustomerName`

---

## Question 4 — Cancellation Rate by Day
Using `Trips` and `Users`, calculate the **daily cancellation rate**.

Rules:
- Exclude trips where either the client or the driver is banned.
- A trip is cancelled if its status is NOT `completed`.
- Cancellation rate = cancelled trips / total trips per day.

Expected columns:
- `RequestDate`, `CancellationRate`

---

## Question 5 — Average Salary by Department (Including Empty Departments)
Compute the **average salary per department**.

Constraints:
- Departments with no employees must still appear.
- Employees without a department must not affect averages.

Expected columns:
- `DeptName`, `AverageSalary`

---

### Silent Failure Warnings
If your query:
- inflates totals because of joins
- filters rows in the wrong phase (`WHERE` vs `HAVING`)
- assumes counts imply completeness

then the answer is lying to you.

Precision over cleverness. Always.