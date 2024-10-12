MODEL (
  name @schema_dest.visit_occurrence,
  kind FULL,
  cron '@monthly',
  grain visit_occurrence_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  vo.visit_occurrence_id,
  vo.person_id,
  vo.visit_concept_id,
  vo.visit_start_date,
  vo.visit_start_datetime,
  vo.visit_end_date,
  vo.visit_end_datetime,
  vo.visit_type_concept_id,
  vo.provider_id,
  vo.care_site_id,
  vo.visit_source_value,
  vo.visit_source_concept_id,
  vo.admitted_from_concept_id,
  vo.admitted_from_source_value,
  vo.discharged_to_concept_id,
  vo.discharged_to_source_value,
  vo.preceding_visit_occurrence_id
FROM @schema_stg.stg__visit_occurrence AS vo
