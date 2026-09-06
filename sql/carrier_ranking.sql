-- Carrier ranking: ranks each carrier's on-time % within its own delay-cause profile

SELECT
    carrier_code,
    on_time_pct,
    RANK() OVER (ORDER BY on_time_pct DESC) AS reliability_rank
FROM (
    SELECT
        c.carrier_code,
        ROUND(
        100.0 * SUM(CASE WHEN f.arr_del15 = 0 THEN 1 ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN f.cancelled = 0 THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_pct
    FROM fact_flights f
    JOIN dim_carrier c ON f.carrier_id = c.carrier_id
    GROUP BY c.carrier_code
) AS carrier_stats;