MODEL (
  name @schema_staging.stg__condition_era,
  kind FULL,
  cron '@monthly'
);

SELECT
  row_number() OVER (ORDER BY person_id)::BIGINT AS condition_era_id,
  person_id::BIGINT AS person_id,
  condition_concept_id::BIGINT AS condition_concept_id,
  min(condition_start_date) AS condition_era_start_date,
  era_end_date AS condition_era_end_date,
  count(*) AS condition_occurrence_count
FROM @schema_temp.temp__condition_era_ends
GROUP BY
  person_id,
  condition_concept_id,
  era_end_date
