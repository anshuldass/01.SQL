SELECT CustomerName FROM Customers C
LEFT JOIN Orders O
ON C.CustomerId = O.CustomerId
WHERE O.CustomerId IS NULL;