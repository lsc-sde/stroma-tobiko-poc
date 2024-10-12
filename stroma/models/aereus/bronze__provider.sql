MODEL (
  name bronze.provider,
  kind FULL,
  cron '@monthly',
  grain provider_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  p.provider_id,
  p.provider_name,
  p.npi,
  p.dea,
  p.specialty_concept_id,
  p.care_site_id,
  p.year_of_birth,
  p.gender_concept_id,
  p.provider_source_value,
  p.specialty_source_value,
  p.specialty_source_concept_id,
  p.gender_source_value,
  p.gender_source_concept_id
FROM @catalog_src.@base.provider AS p
