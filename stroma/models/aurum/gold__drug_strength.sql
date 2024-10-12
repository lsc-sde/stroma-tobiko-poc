MODEL (
  name gold.drug_strength,
  kind FULL,
  cron '@monthly',
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  ds.drug_concept_id,
  ds.ingredient_concept_id,
  ds.amount_value,
  ds.amount_unit_concept_id,
  ds.numerator_value,
  ds.numerator_unit_concept_id,
  ds.denominator_value,
  ds.denominator_unit_concept_id,
  ds.box_size,
  ds.valid_start_date,
  ds.valid_end_date,
  ds.invalid_reason
FROM silver.drug_strength AS ds
