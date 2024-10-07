MODEL (
  name gold.note,
  kind FULL,
  cron '@monthly',
  grain note_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  n.note_id,
  n.person_id,
  n.note_date,
  n.note_datetime,
  n.note_type_concept_id,
  n.note_class_concept_id,
  n.note_title,
  n.note_text,
  n.encoding_concept_id,
  n.language_concept_id,
  n.provider_id,
  n.visit_occurrence_id,
  n.visit_detail_id,
  n.note_source_value,
  n.note_event_id,
  n.note_event_field_concept_id
FROM silvernote AS n
