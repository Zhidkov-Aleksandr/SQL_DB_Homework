WITH ClassStats AS (
    SELECT 
        c.class,
        AVG(r.position) AS class_avg_position,
        COUNT(DISTINCT c.name) AS cars_in_class
    FROM Cars c
    INNER JOIN Results r ON c.name = r.car
    GROUP BY c.class
    HAVING COUNT(DISTINCT c.name) >= 2
),
CarPerformance AS (
    SELECT 
        c.name AS car_name,
        c.class AS car_class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS race_count,
        cl.country AS car_country,
        cs.class_avg_position
    FROM Cars c
    INNER JOIN Results r ON c.name = r.car
    INNER JOIN Classes cl ON c.class = cl.class
    INNER JOIN ClassStats cs ON c.class = cs.class
    GROUP BY c.name, c.class, cl.country, cs.class_avg_position
)
SELECT 
    car_name,
    car_class,
    CAST(avg_position AS DECIMAL(10,4)) AS average_position,
    race_count,
    car_country
FROM CarPerformance
WHERE avg_position < class_avg_position
ORDER BY car_class, average_position;