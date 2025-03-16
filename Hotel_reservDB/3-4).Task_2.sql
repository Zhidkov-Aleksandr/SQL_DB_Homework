WITH MultiHotelClients AS (
    SELECT 
        c.ID_customer,
        c.name,
        COUNT(b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS unique_hotels,
        SUM(r.price) AS total_spent
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    JOIN Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY c.ID_customer, c.name
    HAVING 
        COUNT(b.ID_booking) > 2 
        AND COUNT(DISTINCT h.ID_hotel) > 1
),

HighSpendingClients AS (
    SELECT 
        c.ID_customer,
        c.name,
        SUM(r.price) AS total_spent,
        COUNT(b.ID_booking) AS total_bookings
    FROM Customer c
    JOIN Booking b ON c.ID_customer = b.ID_customer
    JOIN Room r ON b.ID_room = r.ID_room
    GROUP BY c.ID_customer, c.name
    HAVING SUM(r.price) > 500
)

SELECT 
    m.ID_customer,
    m.name,
    m.total_bookings,
    m.total_spent,
    m.unique_hotels
FROM MultiHotelClients m
JOIN HighSpendingClients h 
    ON m.ID_customer = h.ID_customer
ORDER BY m.total_spent ASC;