WITH AvgPositions AS (
    SELECT 
        C.class,
        C.name AS car_name,
        AVG(R.position) AS average_position,
        COUNT(R.race) AS race_count
    FROM 
        Cars C
    JOIN 
        Results R ON C.name = R.car
    GROUP BY 
        C.class, C.name
), MinAvgPositions AS (
    SELECT 
        class,
        MIN(average_position) AS min_average_position
    FROM 
        AvgPositions
    GROUP BY 
        class
)
SELECT 
    AP.car_name,
    AP.class AS car_class,
    AP.average_position,
    AP.race_count
FROM 
    AvgPositions AP
JOIN 
    MinAvgPositions MAP ON AP.class = MAP.class AND AP.average_position = MAP.min_average_position
ORDER BY 
    AP.average_position;