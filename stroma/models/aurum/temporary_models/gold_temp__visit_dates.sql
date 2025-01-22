MODEL (
  name temp_gold.temp__visit_dates,
  kind VIEW,
  cron '@monthly',
  grain person_id
);

SELECT
  person_id,
  observation_period_start_date,
  observation_period_end_date
FROM (
  @get_observation_period(gold.visit_occurrence, visit_start_date, visit_end_date)
)
