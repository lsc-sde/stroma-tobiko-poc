MODEL (
  name @schema_dest.visit_detail,
  kind FULL,
  cron '@monthly',
  grain visit_detail_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  vd.visit_detail_id,
  vd.person_id,
  vd.visit_detail_concept_id,
  vd.visit_detail_start_date,
  vd.visit_detail_start_datetime,
  vd.visit_detail_end_date,
  vd.visit_detail_end_datetime,
  vd.visit_detail_type_concept_id,
  vd.provider_id,
  vd.care_site_id,
  vd.visit_detail_source_value,
  vd.visit_detail_source_concept_id,
  vd.admitted_from_source_value,
  vd.discharged_to_source_value,
  vd.discharged_to_concept_id,
  vd.preceding_visit_detail_id,
  vd.parent_visit_detail_id,
  vd.visit_occurrence_id
FROM @schema_stg.stg__visit_detail AS vd
