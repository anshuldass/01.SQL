SELECT E1.EmpName FROM Employees E1
INNER JOIN Employees E2
ON E1.ManagerId = E2.EmpId
WHERE E1.Salary > E2.Salary;