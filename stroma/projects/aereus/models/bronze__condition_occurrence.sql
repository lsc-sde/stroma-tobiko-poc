MODEL (
  name @schema_dest.condition_occurrence,
  kind FULL,
  cron '@monthly',
  grain condition_occurrence_id
);

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
FROM @catalog_src.@schema_src.condition_occurrence AS co
WHERE
  co.condition_start_date >= '2010-01-01'
