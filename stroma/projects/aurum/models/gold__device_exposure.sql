MODEL (
  name @schema_dest.device_exposure,
  kind FULL,
  cron '@monthly',
  grain device_exposure_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  de.device_exposure_id,
  de.person_id,
  de.device_concept_id,
  de.device_exposure_start_date,
  de.device_exposure_start_datetime,
  de.device_exposure_end_date,
  de.device_exposure_end_datetime,
  de.device_type_concept_id,
  de.unique_device_id,
  de.production_id,
  de.quantity,
  de.provider_id,
  de.visit_occurrence_id,
  de.visit_detail_id,
  de.device_source_value,
  de.device_source_concept_id,
  de.unit_concept_id,
  de.unit_source_value,
  de.unit_source_concept_id
FROM @schema_src.device_exposure AS de
