WITH streaks AS (
    SELECT
        LogId,
        ROW_NUMBER() OVER (ORDER BY LogId)
      - ROW_NUMBER() OVER (PARTITION BY LogId ORDER BY LogId) AS grp
    FROM Logs
)
SELECT DISTINCT LogId
FROM streaks
GROUP BY LogId, grp
HAVING COUNT(*) >= 3;