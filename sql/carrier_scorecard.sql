-- Carrier scorecard: on-time %, average delay, and cancellation rate per airline
-- "On-time" here follows BTS convention: arrival delay under 15 minutes

SELECT
    c.carrier_code,
    COUNT(*) AS total_flights,
    ROUND(AVG(f.arr_delay), 1) AS avg_arr_delay_minutes,
    ROUND(
        100.0 * SUM(CASE WHEN f.arr_del15 = 0 THEN 1 ELSE 0 END) 
        / NULLIF(SUM(CASE WHEN f.cancelled = 0 THEN 1 ELSE 0 END), 0),
        1
    ) AS on_time_pct,
    ROUND(100.0 * SUM(f.cancelled) / COUNT(*), 2) AS cancellation_pct
    FROM fact_flights f
    JOIN dim_carrier c ON f.carrier_id = c.carrier_id
    GROUP BY c.carrier_code
    ORDER BY on_time_pct DESC;
