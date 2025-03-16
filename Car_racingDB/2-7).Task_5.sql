WITH CarStats AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country,
        COUNT(*) OVER (PARTITION BY c.class) AS total_races
    FROM Cars c
    INNER JOIN Results r ON c.name = r.car
    INNER JOIN Classes cl ON c.class = cl.class
    GROUP BY c.name, c.class, cl.country
),
LowPositionCars AS (
    SELECT 
        car_class,
        COUNT(*) AS low_position_count
    FROM CarStats
    WHERE avg_position > 3.0
    GROUP BY car_class
    HAVING COUNT(*) = (
        SELECT MAX(low_count) 
        FROM (
            SELECT COUNT(*) AS low_count 
            FROM CarStats 
            WHERE avg_position > 3.0 
            GROUP BY car_class
        ) t
    )
)
SELECT 
    cs.car_name,
    cs.car_class,
    CAST(cs.avg_position AS DECIMAL(10,4)) AS average_position,
    cs.race_count,
    cs.car_country,
    cs.total_races,
    lpc.low_position_count
FROM CarStats cs
INNER JOIN LowPositionCars lpc ON cs.car_class = lpc.car_class
WHERE cs.avg_position > 3.0
ORDER BY 
    lpc.low_position_count DESC,
    cs.avg_position DESC,
    cs.car_class;