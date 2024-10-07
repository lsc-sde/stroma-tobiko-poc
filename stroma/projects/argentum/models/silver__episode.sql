MODEL (
  name @schema_dest.episode,
  kind FULL,
  cron '@monthly',
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  e.episode_id,
  e.person_id,
  e.episode_concept_id,
  e.episode_start_date,
  e.episode_start_datetime,
  e.episode_end_date,
  e.episode_end_datetime,
  e.episode_parent_id,
  e.episode_number,
  e.episode_object_concept_id,
  e.episode_type_concept_id,
  e.episode_source_value,
  e.episode_source_concept_id
FROM @schema_src.episode AS e
