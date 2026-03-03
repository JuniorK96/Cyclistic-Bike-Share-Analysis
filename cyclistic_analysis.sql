-- ============================================================
-- Combine 12 months of Divvy trip data (Feb 2025 – Jan 2026)
-- into a single full-year table for analysis
-- ============================================================

CREATE OR REPLACE TABLE `cyclistic_project.full_year_data` AS
SELECT * FROM `cyclistic_project.202502_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202503_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202504_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202505_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202506_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202507_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202508_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202509_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202510_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202511_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202512_divvy_tripdata`
UNION ALL
SELECT * FROM `cyclistic_project.202601_divvy_tripdata`;

-- ============================================================
-- DATA CLEANING & FEATURE ENGINEERING
-- ============================================================

CREATE OR REPLACE TABLE `cyclistic_project.cleaned_data` AS
SELECT
  ride_id,
  rideable_type,
  started_at,
  ended_at,
  member_casual,

  -- Calculate ride length in minutes
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length,

  -- Extract day of week
  FORMAT_TIMESTAMP('%A', started_at) AS day_of_week

FROM `cyclistic_project.full_year_data`
WHERE
  started_at IS NOT NULL
  AND ended_at IS NOT NULL
  AND ended_at > started_at;

-- ============================================================
-- ANALYSIS QUERIES
-- ============================================================

-- Total rides by rider type
SELECT
  member_casual,
  COUNT(*) AS total_rides
FROM `cyclistic_project.cleaned_data`
GROUP BY member_casual;

-- Average Ride Length
SELECT
  member_casual,
  ROUND(AVG(ride_length), 2) AS avg_ride_length_minutes
FROM `cyclistic_project.cleaned_data`
GROUP BY member_casual;

-- Monthly Trends
SELECT
  member_casual,
  FORMAT_TIMESTAMP('%Y-%m', started_at) AS ride_month,
  COUNT(*) AS monthly_rides
FROM `cyclistic_project.cleaned_data`
GROUP BY member_casual, ride_month
ORDER BY ride_month;

-- Rides by Day of Week
SELECT 
  day_of_week,
  member_casual,
  COUNT(*) AS total_rides
FROM `cyclistic_project.cleaned_data`
GROUP BY day_of_week, member_casual
ORDER BY 
  CASE day_of_week
    WHEN 'Monday' THEN 1
    WHEN 'Tuesday' THEN 2
    WHEN 'Wednesday' THEN 3
    WHEN 'Thursday' THEN 4
    WHEN 'Friday' THEN 5
    WHEN 'Saturday' THEN 6
    WHEN 'Sunday' THEN 7
  END,
  member_casual;


