MODEL (
  name @schema_stg.stg__measurement,
  kind VIEW,
  cron '@monthly'
);

SELECT
  m.measurement_id,
  m.person_id,
  m.measurement_concept_id,
  m.measurement_date,
  m.measurement_datetime,
  m.measurement_time,
  m.measurement_type_concept_id,
  m.operator_concept_id,
  m.value_as_number,
  m.value_as_concept_id,
  m.unit_concept_id,
  m.range_low,
  m.range_high,
  m.provider_id,
  m.visit_occurrence_id,
  m.visit_detail_id,
  m.measurement_source_value,
  m.measurement_source_concept_id,
  m.unit_source_value,
  m.unit_source_concept_id,
  m.value_source_value,
  m.meas_event_field_concept_id,
  m.measurement_event_id,
  m.unique_key,
  m.datasource,
  m.updated_at
FROM silvermeasurement AS m
INNER JOIN @schema_stg.stg__person AS p
  ON m.person_id = p.person_id
INNER JOIN @schema_stg.stg__visit_occurrence AS vo
  ON m.visit_occurrence_id = vo.visit_occurrence_id
WHERE
  m.measurement_date >= p.birth_datetime::DATE
  AND NOT m.measurement_date IS NULL
  AND m.measurement_date >= @minimum_observation_period_start_date
