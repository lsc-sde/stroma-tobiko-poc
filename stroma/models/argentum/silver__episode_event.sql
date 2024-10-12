MODEL (
  name silver.episode_event,
  kind FULL,
  cron '@monthly',
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  ee.episode_id,
  ee.event_id,
  ee.episode_event_field_concept_id
FROM bronze.episode_event AS ee
