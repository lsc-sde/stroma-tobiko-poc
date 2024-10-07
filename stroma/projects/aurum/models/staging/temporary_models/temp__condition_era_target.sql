MODEL (
  name @schema_temp.temp__condition_era_target,
  kind FULL,
  cron '@monthly'
);

/* ToDo: VC added distinct clause. QA to check. */
SELECT DISTINCT
  co.person_id,
  co.condition_concept_id,
  co.condition_start_date,
  coalesce(co.condition_end_date, co.condition_start_date + 1) AS condition_end_date
FROM @schema_staging.stg__condition_occurrence AS co
