MODEL (
  name @schema_staging.era__drug_exposure_ends,
  kind FULL,
  cron '@monthly'
);

SELECT
  dt.person_id,
  dt.ingredient_concept_id AS drug_concept_id,
  dt.drug_exposure_start_date,
  min(e.end_date) AS drug_sub_exposure_end_date
FROM @schema_staging.era__drug_pre_target AS dt
INNER JOIN @schema_staging.era__drug_sub_exposure_end_dates AS e
  ON dt.person_id = e.person_id
  AND dt.ingredient_concept_id = e.ingredient_concept_id
  AND e.end_date >= dt.drug_exposure_start_date
GROUP BY
  dt.drug_exposure_id,
  dt.person_id,
  dt.ingredient_concept_id,
  dt.drug_exposure_start_date
