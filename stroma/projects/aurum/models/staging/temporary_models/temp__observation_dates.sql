MODEL (
  name @schema_temp.temp__observation_dates,
  kind FULL,
  cron '@monthly',
  grain person_id
);

SELECT
  person_id,
  observation_period_start_date,
  observation_period_end_date
FROM (
  @get_observation_period(gold.observation, observation_date, observation_date)
)
