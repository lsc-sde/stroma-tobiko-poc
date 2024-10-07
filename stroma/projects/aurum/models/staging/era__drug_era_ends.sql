MODEL (
  name @schema_staging.era__drug_era_ends,
  kind FULL,
  cron '@monthly'
);

SELECT
  ft.person_id,
  ft.ingredient_concept_id AS drug_concept_id,
  ft.drug_sub_exposure_start_date,
  min(e.end_date) AS drug_era_end_date,
  drug_exposure_count,
  days_exposed
FROM @schema_staging.era__drug_final_target AS ft
INNER JOIN @schema_staging.era__drug_end_dates AS e
  ON ft.person_id = e.person_id
  AND ft.ingredient_concept_id = e.ingredient_concept_id
  AND e.end_date >= ft.drug_sub_exposure_start_date
GROUP BY
  ft.person_id,
  ft.ingredient_concept_id,
  ft.drug_sub_exposure_start_date,
  drug_exposure_count,
  days_exposed
