MODEL (
  name @schema_dest.drug_era,
  kind FULL,
  cron '@monthly',
  grain drug_era_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  de.drug_era_id,
  de.person_id,
  de.drug_concept_id,
  de.drug_era_start_date,
  de.drug_era_end_date,
  de.drug_exposure_count,
  de.gap_days
FROM @catalog_src.@schema_src.drug_era AS de
