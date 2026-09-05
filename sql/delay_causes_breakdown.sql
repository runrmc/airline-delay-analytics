-- Delay cause breakdown: among delayed flights, what's driving the delay?
-- Only flights with arr_del15 = 1 have delay-cause data populated by BTS

SELECT 
    ROUND(100.0 * SUM(carrier_delay) / SUM(carrier_delay + weather_delay + nas_delay + security_delay + late_aircraft_delay), 1) AS pct_carrier_delay,
    ROUND(100.0 * SUM(weather_delay) / SUM(carrier_delay + weather_delay + nas_delay + security_delay + late_aircraft_delay), 1) AS pct_weather_delay,
    ROUND(100.0 * SUM(nas_delay) / SUM(carrier_delay + weather_delay + nas_delay + security_delay + late_aircraft_delay), 1) AS pct_nas_delay,
    ROUND(100.0 * SUM(security_delay) / SUM(carrier_delay + weather_delay + nas_delay + security_delay + late_aircraft_delay), 1) AS pct_security_delay,
    ROUND(100.0 * SUM(late_aircraft_delay) / SUM(carrier_delay + weather_delay + nas_delay + security_delay + late_aircraft_delay), 1) AS pct_late_aircraft_delay
FROM fact_flights
WHERE arr_del15 = 1;