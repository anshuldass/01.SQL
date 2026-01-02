WITH CTE AS(
SELECT 
	D.DeptName,
	E.EmpName,
	E.Salary
FROM Employees E
LEFT JOIN Departments D
ON E.DeptId = D.DeptId
WHERE E.DeptId IS NOT NULL
) 
SELECT * FROM (
	SELECT 
		*,
		ROW_NUMBER() OVER(PARTITION BY DeptName ORDER BY Salary DESC) AS RN
	FROM CTE
)AS T
WHERE RN = 1;
