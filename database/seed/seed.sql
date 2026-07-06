INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)

SELECT
    gen_random_uuid(),
    gen_random_uuid(),
    'HOTEL-' || g,

    CASE
        WHEN g % 4 = 0 THEN 'delhi'
        WHEN g % 4 = 1 THEN 'mumbai'
        WHEN g % 4 = 2 THEN 'pune'
        ELSE 'bangalore'
    END,

    CURRENT_DATE + (g % 10),

    CURRENT_DATE + (g % 10) + 2,

    ROUND((random() * 9000 + 1000)::numeric, 2),

    CASE
        WHEN g % 3 = 0 THEN 'CONFIRMED'
        WHEN g % 3 = 1 THEN 'PENDING'
        ELSE 'CANCELLED'
    END,

    NOW() - ((random() * 30)::int || ' days')::interval

FROM generate_series(1,100) g;


INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)

SELECT
    id,

    'BOOKED',

    jsonb_build_object(
        'message','Booking Created'
    ),

    NOW()

FROM hotel_bookings

LIMIT 50;