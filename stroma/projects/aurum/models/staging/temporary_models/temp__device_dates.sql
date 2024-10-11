MODEL (
  name @schema_temp.temp__device_dates,
  kind VIEW,
  cron '@monthly',
  grain person_id
);

SELECT
  person_id,
  observation_period_start_date,
  observation_period_end_date
FROM (
  @get_observation_period(@schema_dest.device_exposure, device_exposure_start_date, device_exposure_start_date)
)
