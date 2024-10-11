MODEL (
  name @schema_temp.temp__measurement_dates,
  kind VIEW,
  cron '@monthly',
  grain person_id
);

SELECT
  person_id,
  observation_period_start_date,
  observation_period_end_date
FROM (
  @get_observation_period(@schema_dest.measurement, measurement_date, measurement_date)
)
