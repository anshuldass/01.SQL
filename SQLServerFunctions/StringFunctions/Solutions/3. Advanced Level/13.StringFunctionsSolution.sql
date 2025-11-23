SELECT
	(LEFT(City,1)) AS CityInitials,
	COUNT(*) AS Counts
	FROM Person.Address
GROUP BY (LEFT(City,1))
ORDER BY CityInitials;