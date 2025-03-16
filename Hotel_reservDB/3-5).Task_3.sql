WITH HotelCategory AS (
    SELECT 
        r.ID_hotel,
        h.name AS hotel_name,
        CASE 
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM Room r
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY r.ID_hotel, h.name
),
CustomerPreferences AS (
    SELECT 
        b.ID_customer,
        c.name AS customer_name,
        MAX(CASE 
            WHEN hc.hotel_category = 'Дорогой' THEN 3
            WHEN hc.hotel_category = 'Средний' THEN 2
            WHEN hc.hotel_category = 'Дешевый' THEN 1
        END) AS preference_priority,
        GROUP_CONCAT(DISTINCT h.name ORDER BY h.name ASC SEPARATOR ',') AS visited_hotels
    FROM Booking b
    JOIN Customer c ON b.ID_customer = c.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN HotelCategory hc ON r.ID_hotel = hc.ID_hotel
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY b.ID_customer, c.name
),
FinalResult AS (
    SELECT 
        cp.ID_customer,
        cp.customer_name,
        CASE 
            WHEN cp.preference_priority = 3 THEN 'Дорогой'
            WHEN cp.preference_priority = 2 THEN 'Средний'
            WHEN cp.preference_priority = 1 THEN 'Дешевый'
        END AS preferred_hotel_type,
        cp.visited_hotels
    FROM CustomerPreferences cp
)
SELECT 
    ID_customer,
    customer_name AS name,
    preferred_hotel_type,
    visited_hotels
FROM FinalResult
ORDER BY FIELD(preferred_hotel_type, 'Дешевый', 'Средний', 'Дорогой'), ID_customer;