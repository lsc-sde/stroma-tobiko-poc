MODEL (
  name @schema_staging.era__condition_target,
  kind FULL,
  cron '@monthly'
);

SELECT
  co.person_id,
  co.condition_concept_id,
  co.condition_start_date,
  coalesce(co.condition_end_date, co.condition_start_date + INTERVAL '1' DAY) AS condition_end_date
FROM gold.condition_occurrence AS co
