WITH Blocks AS (
    SELECT
        LogId,
        ROW_NUMBER() OVER (ORDER BY (SELECT NULL))
        - ROW_NUMBER() OVER (PARTITION BY LogId ORDER BY (SELECT NULL)) AS block_id
    FROM Logs
)
SELECT
    LogId
FROM Blocks
GROUP BY LogId
HAVING COUNT(DISTINCT block_id) = 1;