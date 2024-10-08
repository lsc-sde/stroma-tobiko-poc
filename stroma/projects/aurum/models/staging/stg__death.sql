MODEL (
  name @schema_stg.stg__death,
  kind FULL,
  cron '@monthly'
);

SELECT
  d.person_id,
  d.death_date,
  d.death_datetime,
  d.death_type_concept_id,
  d.cause_concept_id,
  d.cause_source_value,
  d.cause_source_concept_id
FROM silverdeath AS d
INNER JOIN @schema_stg.stg__person AS p
  ON d.person_id = p.person_id
WHERE
  d.death_date::DATE >= p.birth_datetime::DATE
  AND d.death_date::DATE <= CURRENT_DATE
