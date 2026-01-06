WITH RankedSalaries AS (
    SELECT
        d.DeptName,
        e.Salary,
        ROW_NUMBER() OVER (
            PARTITION BY d.DeptName
            ORDER BY e.Salary
        ) AS rn,
        COUNT(*) OVER (
            PARTITION BY d.DeptName
        ) AS cnt
    FROM Employees e
    JOIN Departments d
        ON e.DeptId = d.DeptId
)
SELECT
    DeptName,
    AVG(1.0 * Salary) AS MedianSalary
FROM RankedSalaries
WHERE rn IN ((cnt + 1) / 2, (cnt + 2) / 2)
GROUP BY DeptName;
