MODEL (
  name @schema_stg.stg__observation_period,
  kind FULL,
  cron '@monthly'
);

WITH spans AS (
  SELECT
    *
  FROM @schema_temp.temp__condition_dates
  UNION
  SELECT
    *
  FROM @schema_temp.temp__visit_dates
  UNION
  SELECT
    *
  FROM @schema_temp.temp__measurement_dates
  UNION
  SELECT
    *
  FROM @schema_temp.temp__procedure_dates
  UNION
  SELECT
    *
  FROM @schema_temp.temp__observation_dates
  UNION
  SELECT
    *
  FROM @schema_temp.temp__device_dates
  UNION
  SELECT
    *
  FROM @schema_temp.temp__drug_dates
  UNION
  SELECT
    *
  FROM @schema_temp.temp__specimen_dates
), observation_period AS (
  SELECT
    person_id,
    observation_period_start_date,
    observation_period_end_date,
    row_number() OVER (PARTITION BY person_id ORDER BY observation_period_start_date) AS row_num,
    date_diff(
      'DAY',
      lag(observation_period_end_date) OVER (PARTITION BY person_id ORDER BY observation_period_start_date)::TIMESTAMP,
      observation_period_start_date::TIMESTAMP
    ) AS time_difference
  FROM spans
  WHERE
    observation_period_start_date >= '2005-01-01'
), grouped_data AS (
  SELECT
    *,
    sum(CASE WHEN time_difference > 548 OR time_difference IS NULL THEN 1 ELSE 0 END) OVER (PARTITION BY person_id ORDER BY row_num) AS group_id
  FROM observation_period
)
SELECT DISTINCT
  person_id,
  first_value(observation_period_start_date) OVER (PARTITION BY person_id, group_id ORDER BY observation_period_start_date) AS observation_period_start_date,
  first_value(observation_period_end_date) OVER (PARTITION BY person_id, group_id ORDER BY observation_period_start_date DESC) AS observation_period_end_date
FROM grouped_data
