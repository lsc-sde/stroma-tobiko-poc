MODEL (
  name bronze.observation_period,
  kind FULL,
  cron '@monthly',
  grain observation_period_id,
  physical_properties ('delta.tuneFileSizesForRewrites' = FALSE, 'delta.targetFileSize' = '256mb')
);

SELECT
  row_number() OVER (ORDER BY person_id) AS observation_period_id,
  person_id,
  observation_period_start_date,
  observation_period_end_date,
  32817 AS period_type_concept_id
FROM @catalog_src.@base.observation_period
