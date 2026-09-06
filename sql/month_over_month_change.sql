-- Month-over-month change: how do certain months perform compared to their previous month?

WITH monthly_stats AS (
    SELECT
        d.month,
        ROUND(
            100.0 * SUM(CASE WHEN f.arr_del15 = 0 THEN 1 ELSE 0 END) 
            / NULLIF(SUM(CASE WHEN f.cancelled = 0 THEN 1 ELSE 0 END), 0),
            1
        ) AS on_time_pct
    FROM fact_flights f
    JOIN dim_date d ON f.date_id = d.date_id
    GROUP BY d.month
)
SELECT
    month,
    on_time_pct,
    LAG(on_time_pct) OVER (ORDER BY month) AS prev_month_pct,
    ROUND(on_time_pct - LAG(on_time_pct) OVER (ORDER BY month), 1) AS pct_change
FROM monthly_stats
ORDER BY month;