MODEL (
  name gold.death,
  kind FULL,
  cron '@monthly',
  grain person_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  d.person_id,
  d.death_date,
  d.death_datetime,
  d.death_type_concept_id,
  d.cause_concept_id,
  d.cause_source_value,
  d.cause_source_concept_id
FROM stg_gold.stg__death AS d
