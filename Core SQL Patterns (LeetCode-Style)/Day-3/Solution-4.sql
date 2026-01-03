WITH Filtered AS (
    SELECT
        VisitDate,
        People,
        DATEADD(day,-ROW_NUMBER() OVER (ORDER BY VisitDate),VisitDate) AS StreakId
    FROM Stadium
    WHERE People >= 100
),
Qualified AS (
    SELECT *
    FROM Filtered
    WHERE StreakId IN (
        SELECT StreakId
        FROM Filtered
        GROUP BY StreakId
        HAVING COUNT(*) >= 3
    )
)
SELECT
    VisitDate,
    People,
    StreakId
FROM Qualified
ORDER BY VisitDate;