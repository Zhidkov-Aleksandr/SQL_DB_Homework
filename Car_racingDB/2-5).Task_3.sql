WITH CarStats AS (
    SELECT 
        car,
        AVG(position) AS avg_position,
        COUNT(race) AS race_count
    FROM Results
    GROUP BY car
),
ClassStats AS (
    SELECT 
        c.class,
        MIN(cs.avg_position) AS min_avg_position
    FROM Cars c
    JOIN CarStats cs ON c.name = cs.car
    GROUP BY c.class
),
MinClassStats AS (
    SELECT 
        class,
        min_avg_position
    FROM ClassStats
    WHERE min_avg_position = (
        SELECT MIN(min_avg_position)
        FROM ClassStats
    )
),
FinalData AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        cs.avg_position AS average_position,
        cs.race_count,
        cl.country AS car_country,
        COUNT(r.race) OVER (PARTITION BY c.class) AS total_races
    FROM Cars c
    JOIN CarStats cs ON c.name = cs.car
    JOIN Classes cl ON c.class = cl.class
    JOIN Results r ON c.name = r.car
    WHERE c.class IN (SELECT class FROM MinClassStats)
)
SELECT 
    car_name,
    car_class,
    ROUND(average_position, 4) AS average_position,
    race_count,
    car_country,
    total_races
FROM FinalData
ORDER BY car_name;