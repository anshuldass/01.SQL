SELECT
	DeptName,
	EmpName,
	Salary,
	DENSE_RANK() OVER(PARTITION BY DeptName ORDER BY SALARY DESC) AS DeptSalaryRank
FROM Departments D
INNER JOIN Employees E
ON E.DeptId = D.DeptId;