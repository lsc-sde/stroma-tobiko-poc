MODEL (
  name @schema_stg.stg__condition_occurrence,
  kind FULL,
  cron '@monthly'
);

/* ToDo: Add a clause to exclude events after death */
SELECT
  co.condition_occurrence_id,
  co.person_id,
  co.condition_concept_id,
  co.condition_start_date,
  co.condition_start_datetime,
  co.condition_end_date,
  co.condition_end_datetime,
  co.condition_type_concept_id,
  co.condition_status_concept_id,
  co.stop_reason,
  co.provider_id,
  co.visit_occurrence_id,
  co.visit_detail_id,
  co.condition_source_value,
  co.condition_source_concept_id,
  co.condition_status_source_value
FROM @schema_src.condition_occurrence AS co
INNER JOIN @schema_stg.stg__person AS p
  ON co.person_id = p.person_id
INNER JOIN @schema_stg.stg__visit_occurrence AS vo
  ON co.visit_occurrence_id = vo.visit_occurrence_id
INNER JOIN @schema_src.concept AS c
  ON co.condition_concept_id = c.concept_id AND NOT c.standard_concept IS NULL
WHERE
  NOT co.condition_occurrence_id IS NULL
  AND NOT co.condition_concept_id IS NULL
  AND co.condition_start_date >= p.birth_datetime::DATE
  AND co.condition_start_date <= CURRENT_DATE
  AND co.condition_start_date >= @minimum_observation_period_start_date
