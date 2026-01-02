WITH ValidTrips AS (
    SELECT
        t.TripId,
        t.Status,
        t.RequestDate
    FROM Trips t
    JOIN Users c
        ON t.ClientId = c.UserId
    JOIN Users d
        ON t.DriverId = d.UserId
    WHERE c.Banned = 'No'
      AND d.Banned = 'No'
),
DailyCounts AS (
    SELECT
        RequestDate,
        COUNT(*) AS TotalTrips,
        SUM(CASE WHEN Status <> 'completed' THEN 1 ELSE 0 END) AS CancelledTrips
    FROM ValidTrips
    GROUP BY RequestDate
)
SELECT
    RequestDate,
    CAST(CancelledTrips * 1.0 / TotalTrips AS DECIMAL(10,2)) AS CancellationRate
FROM DailyCounts;