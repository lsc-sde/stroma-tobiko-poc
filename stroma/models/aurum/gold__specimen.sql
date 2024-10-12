MODEL (
  name gold.specimen,
  kind FULL,
  cron '@monthly',
  grain specimen_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  s.specimen_id,
  s.person_id,
  s.specimen_concept_id,
  s.specimen_type_concept_id,
  s.specimen_date,
  s.specimen_datetime,
  s.quantity,
  s.unit_concept_id,
  s.anatomic_site_concept_id,
  s.disease_status_concept_id,
  s.specimen_source_id,
  s.specimen_source_value,
  s.unit_source_value,
  s.anatomic_site_source_value,
  s.disease_status_source_value
FROM stg_gold.stg__specimen AS s
