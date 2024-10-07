MODEL (
  name @schema_staging.stg__drug_era,
  kind FULL,
  cron '@monthly'
);

/* ToDo: Drug era needs to be recalculated in gold */
SELECT
  de.drug_era_id,
  de.person_id,
  de.drug_concept_id,
  de.drug_era_start_date,
  de.drug_era_end_date,
  de.drug_exposure_count,
  de.gap_days
FROM silverdrug_era AS de
INNER JOIN @schema_staging.stg__person AS p
  ON de.person_id = p.person_id
WHERE
  de.drug_era_start_date::DATE >= p.birth_datetime::DATE
  AND de.drug_era_start_date::DATE >= @minimum_observation_period_start_date
