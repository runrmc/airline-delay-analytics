-- Day-of-week patterns: are certain days more delay-prone than others?
-- day_of_week: 1=Monday ... 7=Sunday (ISO convention used by BTS)

SELECT
    d.day_of_week,
    CASE d.day_of_week
        WHEN 1 THEN 'Monday'
        WHEN 2 THEN 'Tuesday'
        WHEN 3 THEN 'Wednesday'
        WHEN 4 THEN 'Thursday'
        WHEN 5 THEN 'Friday'
        WHEN 6 THEN 'Saturday'
        WHEN 7 THEN 'Sunday'
    END AS day_name,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.arr_delay), 1) AS avg_arr_delay_minutes,
    ROUND(
        100.0 * SUM(CASE WHEN f.arr_del15 = 0 THEN 1 ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN f.cancelled = 0 THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_pct
FROM fact_flights f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.day_of_week
ORDER BY d.day_of_week;
