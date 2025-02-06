MODEL (
  name silver.death,
  kind FULL,
  cron '@monthly',
  grain person_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  d.person_id::BIGINT,
  d.death_date::DATE,
  d.death_datetime::DATETIME,
  d.death_type_concept_id::BIGINT,
  d.cause_concept_id,
  d.cause_source_value,
  d.cause_source_concept_id
FROM bronze.death AS d
