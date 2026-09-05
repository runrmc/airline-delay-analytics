-- Monthly trends: flight volume, on-time %, and avg delay across 2025
-- Reveals seasonal patterns (e.g. summer travel, winter weather)

SELECT
    d.month,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.arr_delay), 1) AS avg_arr_delay_minutes,
    ROUND(
        100.0 * SUM(CASE WHEN f.arr_del15 = 0 THEN 1 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN f.cancelled = 0 THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_pct,
    ROUND(100.0 * SUM(f.cancelled) / COUNT(*), 2) AS cancellation_pct
FROM fact_flights f
JOIN dim_date d ON f.date_id = d.date_id
GROUP BY d.month
ORDER BY d.month;
