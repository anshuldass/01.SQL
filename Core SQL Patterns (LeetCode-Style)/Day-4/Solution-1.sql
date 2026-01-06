WITH CTE AS(
SELECT 
	D.DeptName,
	E.Salary,
	ROW_NUMBER() OVER(PARTITION BY D.DeptName ORDER BY SALARY DESC) AS RN
FROM Departments D
LEFT JOIN Employees E
ON D.DeptId = E.DeptId
)
SELECT 
	DeptName,
	Salary as ThirdHighestSalary
FROM CTE 
WHERE RN = 3;