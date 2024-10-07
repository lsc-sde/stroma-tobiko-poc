MODEL (
  name gold.condition_era,
  kind FULL,
  cron '@monthly',
  grain condition_era_id
);

SELECT
  ce.condition_era_id,
  ce.person_id,
  ce.condition_concept_id,
  ce.condition_era_start_date,
  ce.condition_era_end_date,
  ce.condition_occurrence_count
FROM @schema_staging.stg__condition_era AS ce
