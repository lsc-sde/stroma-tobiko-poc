MODEL (
  name bronze.dose_era,
  kind FULL,
  cron '@monthly',
  grain dose_era_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  de.dose_era_id,
  de.person_id,
  de.drug_concept_id,
  de.unit_concept_id,
  de.dose_value,
  de.dose_era_start_date,
  de.dose_era_end_date
FROM @catalog_src.@base.dose_era AS de
