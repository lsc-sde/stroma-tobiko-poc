MODEL (
  name @schema_staging.era__drug_final_target,
  kind FULL,
  cron '@monthly'
);

SELECT
  row_number,
  person_id,
  drug_concept_id AS ingredient_concept_id,
  drug_sub_exposure_start_date,
  drug_sub_exposure_end_date,
  drug_exposure_count,
  date_diff(
    'DAY',
    drug_sub_exposure_start_date::TIMESTAMP,
    drug_sub_exposure_end_date::TIMESTAMP
  ) AS days_exposed
FROM @schema_staging.era__drug_sub_exposures
