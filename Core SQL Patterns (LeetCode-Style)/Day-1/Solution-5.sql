WITH CTE AS (
    SELECT *,
           LAG(People)  OVER (ORDER BY VisitDate) AS PrevDay,
           LEAD(People) OVER (ORDER BY VisitDate) AS NextDay
    FROM Stadium
)
SELECT VisitDate, People
FROM CTE
WHERE People >= 100
  AND (
         (PrevDay >= 100 AND NextDay >= 100)
      OR (PrevDay < 100 AND NextDay >= 100)
      OR (PrevDay >= 100 AND NextDay < 100)
  )
ORDER BY VisitDate;
