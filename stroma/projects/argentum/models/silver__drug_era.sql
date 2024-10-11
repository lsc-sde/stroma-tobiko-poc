MODEL (
  name @schema_dest.drug_era,
  kind VIEW,
  cron '@monthly',
  grain drug_era_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

@calculate_drug_era(@schema_dest)
