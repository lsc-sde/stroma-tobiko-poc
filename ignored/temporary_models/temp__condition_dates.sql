MODEL (
  name temp_gold.temp__condition_dates,
  kind VIEW,
  cron '@monthly',
  grain person_id
);

SELECT
  person_id,
  observation_period_start_date,
  observation_period_end_date
FROM (
  @get_observation_period(gold.condition_era, condition_era_start_date, condition_era_end_date)
)
