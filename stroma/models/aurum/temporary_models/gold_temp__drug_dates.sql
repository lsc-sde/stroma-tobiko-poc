MODEL (
  name temp_gold.temp__drug_dates,
  kind VIEW,
  cron '@monthly',
  grain person_id
);

SELECT
  person_id,
  observation_period_start_date,
  observation_period_end_date
FROM (
  @get_observation_period(gold.drug_exposure, drug_exposure_start_date, drug_exposure_start_date)
)
