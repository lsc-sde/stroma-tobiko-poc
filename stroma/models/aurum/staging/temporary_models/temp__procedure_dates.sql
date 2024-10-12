MODEL (
  name temp_gold.temp__procedure_dates,
  kind VIEW,
  cron '@monthly',
  grain person_id
);

SELECT
  person_id,
  observation_period_start_date,
  observation_period_end_date
FROM (
  @get_observation_period(gold.procedure_occurrence, procedure_date, procedure_date)
)
