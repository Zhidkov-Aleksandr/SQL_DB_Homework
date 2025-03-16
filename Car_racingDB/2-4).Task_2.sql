WITH CarStats AS (
    SELECT 
        c.name AS car_name,
        c.class,
        AVG(r.position) AS avg_position,
        COUNT(r.race) AS races_count
    FROM Cars c
    INNER JOIN Results r ON c.name = r.car
    GROUP BY c.name, c.class
)
SELECT 
    cs.car_name,
    cs.class AS car_class,
    CAST(cs.avg_position AS DECIMAL(10,4)) AS average_position,
    cs.races_count AS race_count,
    cl.country AS car_country
FROM CarStats cs
INNER JOIN Classes cl ON cs.class = cl.class
ORDER BY 
    cs.avg_position,
    cs.car_name
LIMIT 1;