MODEL (
  name @schema_staging.era__drug_sub_exposures,
  kind FULL,
  cron '@monthly'
);

SELECT
  row_number() OVER (PARTITION BY person_id, drug_concept_id, drug_sub_exposure_end_date ORDER BY person_id) AS row_number,
  person_id,
  drug_concept_id,
  min(drug_exposure_start_date) AS drug_sub_exposure_start_date,
  drug_sub_exposure_end_date,
  count(*) AS drug_exposure_count
FROM @schema_staging.era__drug_exposure_ends
GROUP BY
  person_id,
  drug_concept_id,
  drug_sub_exposure_end_date /* order by person_id, drug_concept_id */
