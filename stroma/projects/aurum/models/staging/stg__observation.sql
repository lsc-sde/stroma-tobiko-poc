MODEL (
  name @schema_staging.stg__observation,
  kind FULL,
  cron '@monthly'
);

SELECT
  o.observation_id,
  o.person_id,
  o.observation_concept_id,
  o.observation_date,
  o.observation_datetime,
  o.observation_type_concept_id,
  o.value_as_number,
  o.value_as_string,
  o.value_as_concept_id,
  o.qualifier_concept_id,
  o.unit_concept_id,
  o.provider_id,
  o.visit_occurrence_id,
  o.visit_detail_id,
  o.observation_source_value,
  o.observation_source_concept_id,
  o.unit_source_value,
  o.qualifier_source_value,
  o.value_source_value,
  o.observation_event_id,
  o.obs_event_field_concept_id,
  o.unique_key,
  o.datasource,
  o.updated_at
FROM silverobservation AS o
INNER JOIN @schema_staging.stg__person AS p
  ON o.person_id = p.person_id
INNER JOIN @schema_staging.stg__visit_occurrence AS vo
  ON o.visit_occurrence_id = vo.visit_occurrence_id
INNER JOIN @catalog_source.@schema_src.concept AS c
  ON o.observation_concept_id = c.concept_id AND c.invalid_reason IS NULL
WHERE
  o.observation_date >= p.birth_datetime::DATE
  AND NOT o.observation_date IS NULL
  AND o.observation_date >= @minimum_observation_period_start_date
