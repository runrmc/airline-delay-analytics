-- Route-level reliability: which origin-destination pairs are least reliable?
-- Filtered to routes with meaningful volume (200+ flights) to avoid noise from rare routes

SELECT
    orig.airport_code AS origin,
    dest.airport_code AS destination,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.arr_delay), 1) AS avg_arr_delay_minutes,
    ROUND(
        100.0 * SUM(CASE WHEN f.arr_del15 = 0 THEN 1 ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN f.cancelled = 0 THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_pct
FROM fact_flights f
JOIN dim_airport orig ON f.origin_airport_id = orig.airport_id
JOIN dim_airport dest ON f.dest_airport_id = dest.airport_id
GROUP BY orig.airport_code, dest.airport_code
HAVING COUNT(*) >= 200
ORDER BY on_time_pct ASC
LIMIT 20;
