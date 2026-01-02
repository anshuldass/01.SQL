SELECT 
	DeptName,
	AVG(Salary) AS AverageSalary
FROM Departments D 
LEFT JOIN Employees E
ON E.DeptId = D.DeptId
GROUP BY DeptName;