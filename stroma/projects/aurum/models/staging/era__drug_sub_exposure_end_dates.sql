MODEL (
  name @schema_staging.era__drug_sub_exposure_end_dates,
  kind FULL,
  cron '@monthly'
);

SELECT
  person_id,
  ingredient_concept_id,
  event_date AS end_date
FROM (
  SELECT
    person_id,
    ingredient_concept_id,
    event_date,
    event_type,
    max(start_ordinal) OVER (PARTITION BY person_id, ingredient_concept_id ORDER BY event_date, event_type rows BETWEEN UNBOUNDED preceding AND CURRENT ROW) AS start_ordinal,
    row_number() OVER (PARTITION BY person_id, ingredient_concept_id ORDER BY event_date, event_type) AS overall_ord
  FROM (
    SELECT
      person_id,
      ingredient_concept_id,
      drug_exposure_start_date AS event_date,
      -1 AS event_type,
      row_number() OVER (PARTITION BY person_id, ingredient_concept_id ORDER BY drug_exposure_start_date) AS start_ordinal
    FROM @schema_staging.era__drug_pre_target
    UNION ALL
    SELECT
      person_id,
      ingredient_concept_id,
      drug_exposure_end_date,
      1 AS event_type,
      NULL
    FROM @schema_staging.era__drug_pre_target
  ) AS rawdata
) AS e
WHERE
  (
    2 * e.start_ordinal
  ) - e.overall_ord = 0
