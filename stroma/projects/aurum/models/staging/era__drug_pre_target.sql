MODEL (
  name @schema_staging.era__drug_pre_target,
  kind FULL,
  cron '@monthly',
  dialect 'databricks'
);

SELECT
  d.drug_exposure_id,
  d.person_id,
  c.concept_id AS ingredient_concept_id,
  d.drug_exposure_start_date AS drug_exposure_start_date,
  d.days_supply AS days_supply,
  coalesce(
    nullif(drug_exposure_end_date, NULL),
    nullif(dateadd(DAY, days_supply, drug_exposure_start_date), drug_exposure_start_date),
    dateadd(DAY, 1, drug_exposure_start_date)
  ) AS drug_exposure_end_date
FROM gold.drug_exposure AS d
INNER JOIN gold.concept_ancestor AS ca
  ON ca.descendant_concept_id = d.drug_concept_id
INNER JOIN gold.concept AS c
  ON ca.ancestor_concept_id = c.concept_id
WHERE
  c.vocabulary_id = 'rxnorm'
  AND c.concept_class_id = 'ingredient'
  AND d.drug_concept_id <> 0
  AND coalesce(d.days_supply, 0) >= 0
